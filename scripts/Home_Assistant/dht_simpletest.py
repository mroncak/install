# SPDX-FileCopyrightText: 2021 ladyada for Adafruit Industries
# SPDX-License-Identifier: MIT

import time
import board
import adafruit_dht

# Initial the dht device, with data pin connected to:
dhtDevice = adafruit_dht.DHT22(board.D14)
dht_pracovna = adafruit_dht.DHT22(board.D15)
dht_detska = adafruit_dht.DHT22(board.D18)

# you can pass DHT22 use_pulseio=False if you wouldn't like to use pulseio.
# This may be necessary on a Linux single board computer like the Raspberry Pi,
# but it will not work in CircuitPython.
# dhtDevice = adafruit_dht.DHT22(board.D18, use_pulseio=False)

while True:
    try:
        # Print the values to the serial port
        temperature_c = dhtDevice.temperature
        humidity = dhtDevice.humidity
        msg = f'{{ "temperature" : {temperature_c}, "humidity" : {humidity} }}'
        print(
            msg
        )
        temperature_c_pracovna = dht_pracovna.temperature
        humidity_pracovna = dht_pracovna.humidity
        msg_pracovna = f'{{ "temperature" : {temperature_c_pracovna}, "humidity" : {humidity_pracovna} }}'
        print(
            msg_pracovna
        )
        temperature_c_detska = dht_detska.temperature
        humidity_detska = dht_detska.humidity
        msg_detska = f'{{ "temperature" : {temperature_c_detska}, "humidity" : {humidity_detska} }}'
        print(
            msg_detska
        )

    except RuntimeError as error:
        # Errors happen fairly often, DHT's are hard to read, just keep going
        print(error.args[0])
        time.sleep(2.0)
        continue
    except Exception as error:
        dhtDevice.exit()
        raise error

    time.sleep(10.0)
