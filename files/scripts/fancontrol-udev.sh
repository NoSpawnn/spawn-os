#!/usr/bin/env bash

set -euo pipefail

echo "Enabling udev rules for fan-control"

wget https://raw.githubusercontent.com/wiiznokes/fan-control/master/res/linux/60-fan-control.rules
sudo mv 60-fan-control.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules && sudo udevadm trigger