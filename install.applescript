--  Script to install plugin.
-- 
--  Leveraged docs here: 
--  * [MailRecent Home Page]( http://www.cs.unc.edu/~welch/MailRecent/ )
--  * [Original MsgFiler Mail Plugin | MsgFiler]( http://msgfiler.com/support/plugin/ )
-- 
--  NOTES:
--  * This script only tested on 10.11.  It may not work on other OS versions
--  * Leave BundleCompatibilityVersion alone unless you know what you're doing
-- 
-- 
-- Quit the Mail application.
if application "Mail" is running then

-- 	tell application "Mail" to quit 
--    return "quit"
end if





-- Download (see above), expand, and mount the MailRecent disk image.
--  copy *.mailbundle to ~/Library/Mail/Bundles/ ("~"means a user's home directory). You might need to create the Bundles folder if it does not already exist.

-- If you have never used another Mail bundle, you will need to run the following two commands in the Terminal application (omit the % prompt). 
-- 

-- location
set pluginLocation to "~/Library/Mail/Bundles/"

-- warn overwriting existing bundle
if false then -- TODO: check if file exists
	display dialog "GMailinator installer will move existing mail plugin to the trash." ¬
		with icon caution ¬
		with title "GMailinator Installer" ¬
		buttons {"Cancel", "OK"} ¬
		default button "OK"
	set button_pressed to button returned of result
	if button_pressed is "OK" then
		-- move plugin to the trash
		tell application "Finder"
		    move POSIX file pluginLocation & "GMailinator.mailbundle" to trash
		end
	else
		-- statements for cancel button
	end if

else
	-- statements for cancel button
end if

-- TODO: copy bundle


-- enable bundles
set shell_output to do shell script ¬
	"defaults write com.apple.mail EnableBundles -bool true" ¬
	without altering line endings

-- Restart Mail if needed
if application "Mail" is running then
	display dialog "GMailinator installation complete.  Click ok to restart Apple Mail to enable the plugin." ¬
		with icon caution ¬
		with title "GMailinator Installer" ¬
		buttons {"Cancel", "OK"} ¬
		default button "OK"
	set button_pressed to button returned of result
	if button_pressed is "OK" then
		tell application "Mail" to quit
		delay 3 -- add a sleep to allow Mail to quit
		tell application "Mail" to activate		
	else
		-- statements for cancel button
	end if

else
	display dialog "GMailinator installation complete." ¬
		with icon caution ¬
		with title "GMailinator Installer" ¬
		buttons {"OK"} ¬
		default button "OK"
end if