#!/bin/bash

# Set Sony WH-1000XM4 profile to Headset
pactl set-card-profile bluez_card.14_3F_A6_10_B5_AF headset-head-unit
pactl set-default-sink bluez_output.14_3F_A6_10_B5_AF.1
