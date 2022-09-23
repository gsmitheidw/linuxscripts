#!/bin/bash

cat users.txt | while IFS= read -r username

        do
        userdel -f -r "$username"

done
shred -u -f /tmp/id_ed25519.*


echo "Done!"
