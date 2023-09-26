#!/bin/bash

# Installer script for Quick View, a previewer for the Dolphin file manager
# https://github.com/Nyre221/dolphin-quick-view

SELF=$(readlink -f "$0")
HERE=${SELF%/*}

exit_w_error() {
    local msg="$1"
    echo -e "ERROR: ${msg} Exiting...\n"
    exit 1
}

# Check if the script is being run as root
if [[ ${EUID} -eq 0 ]]; then
    exit_w_error "This script must not be run as root."
fi


echo "Installing Quick View previewer for Dolphin..."

mkdir -p ~/.config/quick_view || \
  exit_w_error "Failed to create install folder."

mkdir -p ~/.local/share/kservices5/ServiceMenus/ || \
  exit_w_error "Failed to create ServiceMenus folder."

cp "$HERE"/quick_view.pyz ~/.config/quick_view || \
  exit_w_error "Failed to copy 'quick_view.pyz' file."

chmod +x ~/.config/quick_view/quick_view.pyz || \
  exit_w_error "Failed to set 'quick_view.pyz' as executable."

cp "$HERE"/dolphin_quick_view_shortcut.sh ~/.config/quick_view || \
  exit_w_error "Failed to copy shortcut script."

chmod +x ~/.config/quick_view/dolphin_quick_view_shortcut.sh || \
  exit_w_error "Failed to set shortcut script as executable."

cp "$HERE"/quick_view.desktop ~/.local/share/kservices5/ServiceMenus/ || \
  exit_w_error "Failed to copy desktop file to ServiceMenus folder."


#send desktop notification
if command -v gdbus >/dev/null 2>&1; then
    gdbus call --session --dest=org.freedesktop.Notifications --object-path=/org/freedesktop/Notifications \
    --method=org.freedesktop.Notifications.Notify   "Quick View Installer"   0   "quickview"   \
    "Quick View successfully installed"   ""   '[]'   '{"urgency": <1>}'   5000 >/dev/null
else
    echo "WARNING: The 'gdbus' command was not found. Cannot display success notification."
fi

echo -e "\nQuick View successfully installed.\n"
