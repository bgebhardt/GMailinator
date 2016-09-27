#!/bin/bash

# Script to install plugin.

# Leveraged docs here: 
# * [MailRecent Home Page]( http://www.cs.unc.edu/~welch/MailRecent/ )
# * [Original MsgFiler Mail Plugin | MsgFiler]( http://msgfiler.com/support/plugin/ )

# NOTES:
# * This script only tested on 10.11.  It may not work on other OS versions
# * Leave BundleCompatibilityVersion alone unless you know what you're doing


#Quit the Mail application.

#Download (see above), expand, and mount the MailRecent disk image.
# copy *.mailbundle to ~/Library/Mail/Bundles/ ("~"means a user's home directory). You might need to create the Bundles folder if it does not already exist.

#If you have never used another Mail bundle, you will need to run the following two commands in the Terminal application (omit the % prompt). 

# defaults write com.apple.mail EnableBundles -bool true

#Launch the Mail application
