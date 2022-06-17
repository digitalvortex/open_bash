#!/bin/bash
# Name: mnk_encrypt.sh
# Decription: A wrapper for openssl to encrypt and decrypt files
# Author: Michael N. Kingsnorth
# Version: 1.0
# Date: 17th June 2022
# Notes: You need openssl installed.
# I may refactor the code at some point in time. 


# Set full path to commands, so the script could be run as a cronjob.
OPENSSL=/usr/bin/openssl
SRM=/usr/bin/srm

# Check to see if the command line arguments are set
if [ -v 1 ] || [ -v 2 ]
then
   # Check to see if we are encrypting and the given file exits
   if [ "$1" == "-e" ] && [ -f "$2" ]
   then
      # Encrypts the file
      ${OPENSSL} enc -aes-256-cbc -md sha512 -pbkdf2 -iter 100000 -salt -in $2 -out $2.dat
      # safely delete of the original file
      ${SRM} $2
      echo "${2} encrypted to ${2}.dat"
   # Check to see if we are decrypting the file and the given file exits   
   elif [ "$1" == "-d" ] && [ -f "${2}.dat" ]
   then
       # Decrypts the file
       ${OPENSSL} enc -aes-256-cbc -d -md sha512 -pbkdf2 -iter 100000 -salt -in $2.dat -out "${2}_restored"
       echo "${2}.dat encrypted to ${2}_restored"
       return 0
    else
        # Generic error message
        echo "Something went wrong!"
    fi
else
  # If no argument values are given the following is displated.
  echo "command should be run as \"mnk_encrypt -e or -d filename\""
  echo "-e = encrypt"
  echo "-d = decrypt"
  echo "input = file to encrypt or decrypt"
fi








