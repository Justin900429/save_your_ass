import spidev
import time
import serial
import os

mean_v = [
    81.27430556, 60.69618056, 139.90277778, 87.78819444,
    101.45138889, 98.40972222, 60.98611111, 47.171875]
std_v = [
    29.69119596, 38.05961679, 67.94310012, 39.25168432,
    56.3846019, 39.34889579, 35.38674935, 18.1955993]


def readadc(adcnum):
    # read SPI data from the MCP3008, 8 channels in total
    if adcnum > 7 or adcnum < 0:
        return -1
    r = spi.xfer2([1, 8 + adcnum << 4, 0])
    data = ((r[1] & 3) << 8) + r[2]
    return data


def normalize(x):
    # Normalize with mean and std
    data = ((x[1] - mean_v[x[0]]) / std_v[x[0]]) * 127

    # Check the boundary
    if data > 127:
        data = 127
    if data < -128:
        data = -128
    return str(int(data)) + " "


try:
    ser = serial.Serial("/dev/ttyUSB1", 115200)

    while(1):
        ser.write(str.encode('s\n'))
        status = ser.readline().decode().strip()
        print(status)
        if(status == "s"):
            print("START")
            break

    time.sleep(1)

    #Create SPI
    spi = spidev.SpiDev()
    spi.open(0, 0)
    spi.max_speed_hz=1000000

    #Define Variables
    value_list = []

    try:
        while True:
            value_list = []
            for idx in range(8):
                value_list.append((idx, readadc(idx)))

            value_list = list(map(normalize, value_list))

            for idx in range(8):
                ser.write(str.encode(value_list[idx]))
                time.sleep(0.01)

            r = ser.readline().decode().strip()
            print(r)
    except KeyboardInterrupt:
        pass
except serial.serialutil.SerialException:
    print("Can't find USB port, make sure it's pluged in")
