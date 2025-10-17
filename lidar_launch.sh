#!/bin/bash

source install/setup.bash
sudo chmod 666 /dev/ttyS0
ros2 launch ldlidar ldlidar.launch.py serial_port:=/dev/ttyS0 frame_id:=laser