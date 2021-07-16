#!/bin/bash

cat users.txt | while IFS= read -r username

        do
        userdel -f -r "$username"

done

echo "Done!"
