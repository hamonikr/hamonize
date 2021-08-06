#!/bin/bash

# Link to the binary
ln -sf '/opt/hamonikr-support/hamonize-support' '/usr/bin/hamonize-support'

# SUID chrome-sandbox for Electron 5+
# Remove this entire file (after-install.tpl) and remove the reference in
# package.json once this change has been upstreamed so we go back to the copy
# from upstream.
# https://github.com/electron-userland/electron-builder/pull/4163
chmod 4755 '/opt/hamonikr-support/chrome-sandbox' || true

update-mime-database /usr/share/mime || true
update-desktop-database /usr/share/applications || true

chmod +x /usr/share/applications/hamonikr-support.desktop

#cp /usr/share/applications/${executable}.desktop /etc/skel/.config/autostart

cp /usr/share/applications/${executable}.desktop /home/$user/바탕화면

# for u in $(ls /home)
# do
# cp /usr/share/applications/hamonikr-support.desktop /home/$u/Desktop/
# chown $u:$u /home/$u/Desktop/hamonikr-support.desktop
# done
