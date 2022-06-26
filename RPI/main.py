import spidev
import serial
import time
import math
from datetime import datetime, date

import numpy as np
import Adafruit_PCA9685
import pytz

import firebase_admin
from firebase_admin import credentials
from firebase_admin import firestore

mean_v = [
    84.95833333333333,
    8.34047619047619,
    51.0797619047619,
    46.42202380952381,
    68.64583333333333,
    40.58452380952381,
    19.260119047619046,
    45.09464285714286,
]
std_v = [
    39.38892673840168,
    12.517969170524228,
    33.29535317128283,
    36.74069193038208,
    53.526207815565265,
    18.31951856593203,
    18.85381305339836,
    9.88264326826012,
]

machine_id = "01234567"

# Set up the timezone
tz = pytz.timezone("Asia/Taipei")
day_total_second = 86400

import Adafruit_PCA9685

pwm = Adafruit_PCA9685.PCA9685()
pwm.set_pwm_freq(490)


def run_pattern(id):
    """
    - Posture class
    sitting posture    |  pattern number  |
        normal         |        0         |
        lean back      |        1         |
        sit left       |        2         |
        sit right      |        3         |
        left leg lift  |        4         |
        right leg lift |        5         |

    - Motor Positino
    0    1
     2 3
    4    6
    7 5  9
    """
    l = []
    if id == 0:
        pass
    elif id == 1:
        l = [4, 5, 6, 7, 9]
    elif id == 2:
        l = [0, 2, 4, 7]
    elif id == 3:
        l = [1, 3, 6, 9]
    elif id == 4:
        l = [5, 6, 9]
    elif id == 5:
        l = [4, 5, 7]
    elif id == 6:
        for i in range(0, 8, 1):
            pwm.set_pwm(i, 4096, 0)
        time.sleep(1)
        for i in range(0, 8, 1):
            pwm.set_pwm(i, 4096, 4096)

    for i in range(0, 8, 1):
        pwm.set_pwm(i, 4096, 4096)

    time.sleep(0.1)

    for i in l:
        pwm.set_pwm(i, 4096, 0)
    time.sleep(3)


def readadc(adcnum):
    """Read SPI data from the MCP3008, 8 channels in total"""
    if adcnum > 7 or adcnum < 0:
        return -1
    r = spi.xfer2([1, 8 + adcnum << 4, 0])
    data = ((r[1] & 3) << 8) + r[2]
    return data


def normalize(x):
    """Normalize the data with mean and std"""
    max_num = np.amax(x)
    x = np.array(x) / max_num
    x = (x * 255) - 127
    return [str(int(num)) + " " for num in x]


def get_current_time():
    utc_time = datetime.utcnow()
    local_time = pytz.utc.localize(utc_time, is_dst=None).astimezone(tz)
    return local_time


def compute_duration(start, end):
    duration = datetime.combine(date.min, end) - datetime.combine(date.min, start)
    return duration.total_seconds()


def check_and_update_new_day():
    cur_time = get_current_time()
    if now_date.date() != cur_time.date():
        now_date = cur_time


def reset_new_date(firestore_client, current_user):
    global now_date, hour, past_sit, total_count

    # Update date first
    now_date = get_current_time()

    # Update list
    hour = 0
    past_sit, total_count = [0] * 6, [0] * 6

    # Update database
    firestore_client.collection("users").document(current_user).update(
        {"score": 5, "hour": hour, "past_sit": past_sit}
    )


def update_past_sit_from_total():
    global past_sit

    sum_sit_num = sum(total_count)

    if sum_sit_num == 0:
        past_sit = [0] * 6
    else:
        past_sit = [round(sit_num / sum_sit_num, 2) for sit_num in total_count]


def past_sit_to_score():
    global past_sit

    if past_sit[0] <= 0.25:
        return 0
    elif past_sit[0] <= 0.5:
        return 1
    elif past_sit[0] <= 0.75:
        return 2
    else:
        return 3


def update_user_statistics(firestore_client, current_user):
    global hour

    update_past_sit_from_total()
    hour = round(compute_duration(now_date.time(), get_current_time().time()) / 3600, 1)

    firestore_client.collection("users").document(current_user).update(
        {"score": past_sit_to_score(), "hour": hour, "past_sit": past_sit}
    )


if __name__ == "__main__":
    # Activate the firebase service
    cred = credentials.Certificate("service_account.json")
    firebase_admin.initialize_app(cred)
    firestore_client = firestore.client()
    # Obtain the current user
    current_user = (
        firestore_client.collection("machines")
        .document(machine_id)
        .get()
        .to_dict()["user"]
    )

    # User statistics
    hour = 0
    total_count = [0] * 6
    past_sit = [0] * 6

    # Set up update time
    now_date = None
    reset_new_date(firestore_client, current_user)

    try:
        ser = serial.Serial("/dev/ttyUSB1", 115200)

        # Build the connection with EM9D
        while 1:
            ser.write(str.encode("s\n"))
            status = ser.readline().decode().strip()
            if status == "s":
                break
        time.sleep(0.1)

        # Create SPI
        spi = spidev.SpiDev()
        spi.open(0, 0)
        spi.max_speed_hz = 1000000

        # Define Variables
        value_list = []

        try:
            while True:
                value_list = []
                for idx in range(8):
                    value_list.append(readadc(idx))

                # Ignore the data if no one is sitting on it
                flag = False
                for val in value_list:
                    if abs(val) > 5:
                        flag = True
                        break
                if not flag:
                    continue

                # Normalize the value first and send dato EM9D with UART
                value_list = normalize(value_list)
                for idx in range(8):
                    ser.write(str.encode(value_list[idx]))
                    time.sleep(0.01)

                # Update the database after reading the prediction from EM9D
                r = int(ser.readline().decode().strip())
                total_count[r] += 1
                run_pattern(r)
                update_user_statistics(firestore_client, current_user)
        except KeyboardInterrupt:
            pass
    except serial.serialutil.SerialException:
        print("Can't find USB port, make sure it's pluged in")


