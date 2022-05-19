# README

## Code of EM9D
> To run the code on EM9D, users should program the image file into the EM9D board.
The folder `EM9D` includes the code for running the program on board. EM9D is used to do classify the sensor data into six different categories of sitting pose and send the predicted category back to RPI.
```
Process
---
| -> Send Connection
        |
        |
        | Wait for response
        |
        v
| -> Get Response
|
| -> Start receiving data -
|                         |
|                         |
|          Loop           |
|                         |
∧                         v
- - - Predict result <- - -
```

## RPI code
RPI is used to collect the pressure data from the sensor and normalized the data to `-128~127` before sending to EM9D board with UART.

### Set up the environment
```
$ pip install -r requirements.txt
```

### Run the code
```
$ python RPI/sensor.py
```

## Training Process

### Dataset Collection
We collect the data by our team members with five pressure sensors, and for each category, we collect 120 data from two different person. The six categories included:
1. Normal
2. Leaning back
3. Left sitting
4. Right sitting
5. Crossed left leg
6. Crossed right leg

Our collected data is save in `res.csv`

### Training
We use jupyter notebook to training our model. Users can access to our training code in `pose.ipynb`. Our mdoel architecture is shown below: