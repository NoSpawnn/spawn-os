#!/usr/bin/env bash

echo "Downloading ublue packages config"
curl -fLs --create-dirs https://github.com/ublue-os/packages/archive/refs/heads/main.zip -o /tmp/ublue-config/packages.zip
unzip -q /tmp/ublue-config/packages.zip -d /tmp/ublue-config/

echo "Copying ublue udev rules"
cp /tmp/ublue-config/packages-main/packages/ublue-os-udev-rules/src/udev-rules.d/*.rules /usr/lib/udev/rules.d/

echo "Copying ublue flatpak and rpm-ostree updater"
cp /tmp/ublue-config/packages-main/packages/ublue-os-update-services/src/usr/lib/systemd/system/flatpak-system-update.timer /usr/lib/systemd/system/flatpak-system-update.timer
cp /tmp/ublue-config/packages-main/packages/ublue-os-update-services/src/usr/lib/systemd/system/flatpak-system-update.service /usr/lib/systemd/system/flatpak-system-update.service
cp /tmp/ublue-config/packages-main/packages/ublue-os-update-services/src/usr/lib/systemd/user/flatpak-user-update.timer /usr/lib/systemd/user/flatpak-user-update.timer
cp /tmp/ublue-config/packages-main/packages/ublue-os-update-services/src/usr/lib/systemd/user/flatpak-user-update.service /usr/lib/systemd/user/flatpak-user-update.service
echo "Enabling systemd timers for flatpak updaters"
systemctl --system enable flatpak-system-update.timer
systemctl --global enable flatpak-user-update.timer

rm -r /tmp/ublue-config/