#!/bin/bash

for username in `cat users.txt`

        do
        userdel -f -r $username

done

Echo "Done!"
