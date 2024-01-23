#!/bin/bash
# Create users, by G. Smith Feb 2014-2021
# Requires users.txt containing list of student ids (usernames) as input in the current directory
#
# Depenencies: putty-tools (for puttygen) for ppk key generation, zip for packing the files for users
#
# NOTE: Paths and command switches may differ for other Linux distros, this is built for Debian
# so please test before using for bulk.

# Stop script on error
set -e
set -o pipefail

# Select a non-root local user to collect the resulting file of ssh keys for distribution
nonroot="x90021605"
# Note that each new user needs access to the temporary path during key generation, not just root.
# So whilst /tmp is readable to all there is a small window where the priv keys are accessible.
# If required, this could be modified to add new users to a group that has rw access to a temp path.
TMP_DIR="/tmp/"

# convert all student IDs to lowercase:
userlist="$(<users.txt)"
echo "$userlist" | tr [:upper:] [:lower:] | sort | uniq > users.txt

# Check that users in file don't already exist on system
for duplicates in $(cat users.txt)
	do
	if getent passwd $duplicates > /dev/null 2>&1; then echo "A user already found on the system" $duplicates ;exit;  fi
done


# Some random digits in case we run several times to ensure unique output each run
rdn=$(echo $RANDOM | head -c 4)
rundate=$(date +"%d-%m-%y-$rdn")

# Length of file
len=$(cat users.txt | wc -l)
# Start counter at zero
count=0


# Cycle through student accounts list of X numbers:
for username in $(cat users.txt)

        do
        # Create user account
        adduser --home /home/$username --disabled-password --gecos "" --shell /bin/bash $username
        # Generate ssh key as each user
        su - -c "ssh-keygen -q -t ed25519 -f ~/.ssh/id_ed25519 -N '' -C $username" $username
        su - -c "cp ~/.ssh/id_ed25519.pub ~/.ssh/authorized_keys" $username
        # Copy private key per user to temp directory
        su - -c "cp ~/.ssh/id_ed25519 $TMP_DIR/id_ed25519.$username" $username
        # Create putty key with puttygen ~/.ssh/id_rsa -o id_rsa.ppk
        su - -c "puttygen ~/.ssh/id_ed25519 -o $TMP_DIR/id_ed25519.$username.ppk" $username
        # Show Progress
        ((++count))
        echo $((count*100/len)) |  dialog --gauge "waiting" 7 50

done


# Archive the student private keys in openssh format for delivery:
zip -r /home/$nonroot/"$HOSTNAME"_private_keys_$rundate.zip $TMP_DIR/id_ed25519.*
chmod 644 /home/$nonroot/"$HOSTNAME"_private_keys_$rundate.zip

# Clean up cached private keys from temp folder for security:

shred -u -f $TMP_DIR/id_ed25519.*
rm -rf "$TMP_DIR"

# backup
mv --backup=t users.txt users.$rundate.log

dialog --msgbox "Complete! file collection "$HOSTNAME"_private_keys_$rundate.zip from /home/$nonroot" 7 50
clear
