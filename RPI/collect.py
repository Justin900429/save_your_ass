import argparse
import signal
import time

import numpy as np

import spidev
import pandas as pd

# Create SPI
spi = spidev.SpiDev()
spi.open(0, 0)
spi.max_speed_hz = 1000000


def readadc(adcnum):
    # read SPI data from the MCP3008, 8 channels in total
    if adcnum > 7 or adcnum < 0:
        return -1
    r = spi.xfer2([1, 8 + adcnum << 4, 0])
    data = ((r[1] & 3) << 8) + r[2]
    return data


def normalize(x):
    # Normalize with mean and std
    max_num = np.amax(x)
    x = np.array(x) / max_num
    x = (x * 255) - 127
    return [str(int(num)) + " " for num in x]


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument("--file_name", type=str, default="test.csv")
    args = parser.parse_args()

    res = []
    running = True

    count = 0
    while count < 100:
        temp = []
        for idx in range(8):
            temp.append(readadc(idx))
        res.append(temp)
        time.sleep(0.75)
        count += 1
        print(f"Collect {count}, {temp}")

    pd.DataFrame(
        res, columns=["one", "two", "three", "four", "five", "six", "seven", "eight"]
    ).to_csv(args.file_name, index=False)
    print()

