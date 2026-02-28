#!/bin/bash
set -euo pipefail

# Enable debug logging if DEBUG=1
if [[ "${DEBUG:-0}" == "1" ]]; then
  set -x
fi

trap 'echo "ERROR: Install failed at line $LINENO"' ERR

#Set the default install directory in the Workspace install script
sed -ie 's/DefaultInstallDir=.*$/DefaultInstallDir=\/app\/ICAClient\/linuxx64/' /tmp/icaclient/linuxx64/hinst
#The installation options selected below answer yes to using the gstreamer pluging from ICAClient. The "app protection component" and USB support
#require the installer to be run as root, so they cannot be installed in this case.
echo -e "1\n\ny\ny\n3\n" | /tmp/icaclient/setupwfc || { echo "ERROR: Citrix setup failed"; exit 1; }

#HDX RTME requires some directories for storing settings, log, and version info. These directories aren't persistant
#so they get recreated everytime the Flatpak is run. I haven't observed any negative effects from settings being wiped every time the app closes.
mkdir -p /var/lib/RTMediaEngineSRV
chmod a+rw -v /var/lib/RTMediaEngineSRV || { echo "ERROR: Failed to chmod RTMediaEngineSRV"; exit 1; }
mkdir -p /var/log/RTMediaEngineSRV
chmod a+rw -v /var/log/RTMediaEngineSRV || { echo "ERROR: Failed to chmod log directory"; exit 1; }
mkdir -p /var/lib/Citrix/HDXRMEP
chmod a+rw -v /var/lib/Citrix/HDXRMEP || { echo "ERROR: Failed to chmod HDXRMEP"; exit 1; }

#Install HDX RTME.
cd /app/ICAClient/linuxx64 || { echo "ERROR: Failed to cd to ICAClient directory"; exit 1; }
mkdir -p rtme
cp /tmp/icaclient/x86_64/usr/local/bin/HDXRTME.so . || { echo "ERROR: Failed to copy HDXRTME.so"; exit 1; }
chmod +x HDXRTME.so
cp /tmp/icaclient/x86_64/usr/local/bin/* rtme || { echo "ERROR: Failed to copy rtme binaries"; exit 1; }
MODULE_INI=config/module.iniflatpak
if [ -L "$MODULE_INI" ] ; then
    MODULE_INI=$(readlink -f "$MODULE_INI")
fi
cp "$MODULE_INI" . || { echo "ERROR: Failed to copy module.ini"; exit 1; }
chmod a+rw -v module.ini
rtme/RTMEconfig -install -ignoremm || { echo "ERROR: RTMEconfig failed"; exit 1; }
if [ -s "./new_module.ini" ] ; then
    rm -rf "$MODULE_INI"
    cp ./new_module.ini "$MODULE_INI" || { echo "ERROR: Failed to copy new_module.ini"; exit 1; }
    chmod a+rw -v "$MODULE_INI"
fi
rm -rf ./module.ini
rm -rf ./new_module.ini

echo "✓ Install script completed successfully"
exit 0