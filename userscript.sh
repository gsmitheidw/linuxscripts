#!/bin/bash
# Create users, by G. Smith Feb 2014-2021
# Requires users.txt containing list of usernames as input in the current directory
#
# Depenencies: putty-tools (for puttygen) for ppk key generation, zip for packing the files for users
#
# NOTE: Paths and command switches may differ for other Linux distros, this is built for Debian
# so please test before using for bulk.

# Stop script on error
set -e

# Select a non-root local user to collect the resulting file of ssh keys for distribution
nonroot="gsmith"
# specify input file here:
input="users.txt"

# convert all usernames to lowercase:
tr '[:upper:]' '[:lower:]' < "$input" > usersL.txt
mv usersL.txt "$input"

# Length of file
len=$(wc -l < users.txt)
# Start counter at zero
count=0


# Cycle through user accounts list of X numbers:
while IFS= read -r username

        do
        # Create user account
        adduser --home /home/"$username" --disabled-password --gecos "" --shell /bin/bash "$username"
        # Generate ssh key as each user
        su - -c "ssh-keygen -q -f ~/.ssh/id_rsa -N '' -C $username" "$username"
        su - -c "cp ~/.ssh/id_rsa.pub ~/.ssh/authorized_keys" "$username"
        # Copy private key per user to temp directory
        su - -c "cp ~/.ssh/id_rsa /tmp/id_rsa.$username" "$username"
        # Create putty key with puttygen ~/.ssh/id_rsa -o id_rsa.ppk
        su - -c "puttygen ~/.ssh/id_rsa -o /tmp/id_rsa.$username.ppk" "$username"
        # Show Progress
        ((++count))
        echo $((count*100/len)) |  dialog --gauge "waiting" 7 50

done < "$input"

# Archive the users private keys in openssh format for delivery:
zip -r /home/$nonroot/private_keys_$(date +"%d-%m-%y").zip /tmp/id_rsa.*
chmod 644 /home/$nonroot/private_keys_$(date +"%d-%m-%y").zip

# Clean up cached private keys from temp folder for security:
shred -u -f /tmp/id_rsa.*

mv --backup=t users.txt users.$(date +"%Hh-%Mm-%d-%m-%y").txt

dialog --msgbox "Complete! file collection from /home/$nonroot" 7 50
clear
