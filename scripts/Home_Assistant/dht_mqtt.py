import time
import board
import random
import adafruit_dht
#import paho.mqtt.client as mqtt
#import paho.mqtt.publish as publish
from paho.mqtt import client as mqtt_client

# Initial the dht device, with data pin connected to:
dht_test = adafruit_dht.DHT22(board.D14)
#dht_obyvacka = adafruit_dht.DHT22(board.D16)
#dht_kuchyna = adafruit_dht.DHT22(board.D16)
#dht_kupelna = adafruit_dht.DHT22(board.D16)
#dht_spalna = adafruit_dht.DHT22(board.D16)
dht_detska = adafruit_dht.DHT22(board.D18)
dht_pracovna = adafruit_dht.DHT22(board.D15)

# you can pass DHT22 use_pulseio=False if you wouldn't like to use pulseio.
# This may be necessary on a Linux single board computer like the Raspberry Pi,
# but it will not work in CircuitPython.
# dhtDevice = adafruit_dht.DHT22(board.D18, use_pulseio=False)

broker = '192.168.10.101'
port = 1883
pub_topic_test = 'test/sensor1'       # send messages to this topic
# pub_topic_obyvacka = 'obyvacka/sensor1'
# pub_topic_kuchyna = 'kuchyna/sensor1'
# pub_topic_kupelna = 'kupelna/sensor1'
# pub_topic_spalna = 'spalna/sensor1'
pub_topic_detska = 'detska/sensor1'
pub_topic_pracovna = 'pracovna/sensor1'
client_id = f'python-mqtt-{random.randint(0, 1000)}'
username = 'mqtt'
password = 's3lksakd'

def connect_mqtt():
    def on_connect(client, userdata, flags, rc):
        if rc == 0:
            print("Connected to MQTT Broker!")
        else:
            print("Failed to connect, return code %d\n", rc)
    # Set Connecting Client ID
    client = mqtt_client.Client(client_id)
    client.username_pw_set(username, password)
    client.on_connect = on_connect
    client.connect(broker, port)
    return client

client = connect_mqtt()

while True:
    try:
        # Print the values to the serial port
        temp_test = dht_test.temperature
        hum_test = dht_test.humidity
        msg_test = f'{{ "temperature" : {temp_test}, "humidity" : {hum_test} }}'
        client.publish(pub_topic_test, msg_test)
        temp_pracovna = dht_pracovna.temperature
        hum_pracovna = dht_pracovna.humidity
        msg_pracovna = f'{{ "temperature" : {temp_pracovna}, "humidity" : {hum_pracovna} }}'
        client.publish(pub_topic_pracovna, msg_pracovna)
        temp_detska = dht_detska.temperature
        hum_detska = dht_detska.humidity
        msg_detska = f'{{ "temperature" : {temp_detska}, "humidity" : {hum_detska} }}'
        client.publish(pub_topic_detska, msg_detska)


    except RuntimeError as error:
        # Errors happen fairly often, DHT's are hard to read, just keep going
        print(error.args[0])
        time.sleep(2.0)
        continue
    except Exception as error:
        dhtDevice.exit()
        raise error

    time.sleep(10.0)

