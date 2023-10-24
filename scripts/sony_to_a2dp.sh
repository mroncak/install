#!/bin/bash

# Set Sony WH-1000XM4 profile to HIFI a2dp-sink
pactl set-card-profile bluez_card.14_3F_A6_10_B5_AF a2dp-sink
pactl set-default-sink bluez_output.14_3F_A6_10_B5_AF.1
