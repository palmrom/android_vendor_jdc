#!/sbin/sh
#    ____  ____  __   ____  ____
#   (_  _)( ___)(  ) (_  _)( ___)
#  .-_)(   )__)  )(__  )(   )__)
#  \____) (__)  (____)(__) (____)
#   ____  ____  _  _  ___  _____  _  _
#  (  _ \( ___)( \/ )/ __)(  _  )( \( )
#   )(_) ))__)  \  /( (__  )(_)(  )  (
#  (____/(____)  \/  \___)(_____)(_)\_)
#
# Copyright (c) 2015 - Mattia "AntaresOne" D'Alleva
# Copyright (c) 2015 - Jflte Dev Connection (JDCTeam)
#
# EXT4/F2FS format script with MultiROM support
# Check current /system FS and format accordingly to the FS found
# Check installation/upgrade type. If primary ROM run format process, else don't run it (installing as secondary ROM)

# MultiROM recognition
MROM=$(ls /tmp | grep "META-INF")

# Format
FORMAT() {
    if [ "$TYPE" == "ext4" ]; then
        echo "Found ext4 filesystem. Formatting..."
        mke2fs -T ext4 /dev/block/mmcblk0p16
    elif [ "$TYPE" == "f2fs" ]; then
        echo "Found F2FS filesystem. Formatting..."
        mkfs.f2fs /dev/block/mmcblk0p16
    else
        # Some recoveries may not have F2FS tools
        echo "No filesystem specified. Formatting as ext4..."
        mke2fs -T ext4 /dev/block/mmcblk0p16
    fi
    exit 0
}

# Primary ROM
MAIN() {
    echo "Installing in /system"
    # Mount /system
    mount /system
    # Copy mounts in a text file
    mount > /tmp/mount.txt
    # Unmount /system
    umount /system
    # Recognize FS type
    FS=$(eval $(blkid /dev/block/mmcblk0p16 | cut -c 68-); echo $TYPE > /tmp/type.txt)
    TYPE=$(cat /tmp/type.txt | grep "ext4")
    FORMAT
}

# Start
echo "Checking..."
if [ "$MROM" == "" ]; then
    MAIN
else
    echo "Installing in MultiROM environment"
    exit 0
fi
