#!/data/data/com.termux/files/usr/bin/bash

# This script installs the full ktx package, init_sddm from GitHub, proot-distro with Debian,
# and installs plasma-desktop and plasma-mobile on Debian.

echo "Installing KDE Plasma & dependencies..."

# Step 1: Update Termux and install required packages
pkg update -y
pkg upgrade -y
pkg install -y git proot-distro wget pulseaudio tigervnc

# Step 2: Install proot-distro (already installed in Step 1, no need to repeat)
# echo "Installing proot-distro..."  # Redundant, as it's already installed above.

# Step 3: Install Debian using proot-distro
echo "Installing Debian distribution..."
proot-distro install debian

# Step 4: Login to the Debian environment and install Plasma desktop, Plasma mobile, and init_plasma.
echo "Installing KDE Plasma Desktop and Plasma Mobile in Debian..."
proot-distro login debian -- bash -c "
    apt update -y && apt upgrade -y &&
    apt install -y plasma-desktop plasma-mobile git &&
    git clone https://github.com/leon8326/ktx.git ~/ktx-repo &&
    cd ~/ktx-repo &&
    chmod +x init_plasma &&
    cp init_plasma /bin/init_plasma
"

# Step 5: Clone the ktx repository from GitHub (for Termux usage)
echo "Cloning the ktx repository from GitHub..."
git clone https://github.com/leon8326/ktx /data/data/com.termux/files/home/ktx_repo

# Check if the repository was cloned successfully
if [ ! -d "/data/data/com.termux/files/home/ktx_repo" ]; then
    echo "Failed to clone the repository. Please check the repository URL."
    exit 1
fi

# Step 6: Make the ktx and init_sddm scripts executable
echo "Setting executable permissions for ktx and init_plasma scripts..."
chmod +x ~/ktx-repo/ktx ~/ktx-repo/init_plasma

# Step 7: Move the scripts to a directory in the PATH (e.g., /data/data/com.termux/files/usr/bin)
echo "Moving ktx, update_ktx and init_plasma scripts to /data/data/com.termux/files/home/bin for easier access..."
mv ~/ktx-repo/ktx ~/ktx-repo/init_plasma ~/ktx-repo/update_ktx /data/data/com.termux/files/home/bin/

# Step 8: Verify the installation
if [ ! -f "/data/data/com.termux/files/home/bin/ktx" ]; then
    echo "Error: ktx script was not installed properly."
    exit 1
fi

echo "Installation complete! You can now run the ktx script by typing 'ktx' in Termux."

# Optional: Show a usage message
echo "To use ktx, run 'ktx' in Termux. Make sure you have Termux X11 installed and running on your device."
echo "You can log into your Debian environment using 'proot-distro login debian'."
echo "To start Plasma Desktop, run 'startplasma-x11' within Debian."

# Optional: Run KTX for the first time.
echo ""
echo "KTX will run for the first time in 10 seconds."
echo "This will install required dependencies."
sleep 10
ktx
