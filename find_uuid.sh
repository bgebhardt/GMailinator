#! /bin/bash

echo "Reading the mail app uuid for Mail Version 9.3 or earlier..."
defaults read /Applications/Mail.app/Contents/Info PluginCompatibilityUUID

# With macOS Sierra there's a new UUID to look up
# See [Doesn't work with Mail 10. · Issue #43 · nompute/GMailinator]( https://github.com/nompute/GMailinator/issues/43#issuecomment-245329386 )
echo "Reading the mail app uuid for Mail Version (macOS Sierra) or later..."
defaults read /Applications/Mail.app/Contents/Supported10.12PluginCompatibilityUUIDs
