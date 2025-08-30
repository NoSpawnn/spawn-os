#!/usr/bin/env bash

set -euo pipefail

echo "Enabling udev rules for fan-control"

mkdir /tmp/fanctrl-udev
cd /tmp/fanctrl-udev
wget https://raw.githubusercontent.com/wiiznokes/fan-control/master/res/linux/60-fan-control.rules
mv ./60-fan-control.rules /etc/udev/rules.d/