# macos-screen-sharing-resolution-automation
Automatically set the Screen Sharing Virtual Display resolution when a session is established.

The MacOS "Screen Sharing" application is using a "safe" resolution of 1920x1080 when connecting to a remote Mac.  
The user then needs to open the settings and set the desired resolution for the Screen Sharing Virtual Display manually on every new session.  
This automation will allow you to select a desired resolution and apply it right after a Screen Sharing session is established.

## Installation
Perform this installation in the host system. The client does not need any setup.

### Get the source
Download the repo to your desired location.

```bash
cd /Users/siw36/code
git clone https://github.com/siw36/macos-screen-sharing-resolution-automation
cd macos-screen-sharing-resolution-automation
```

### Install dependencies
```bash
brew install displayplacer
```

### Permissions
Allow the "Terminal" application to change Accessibility settings.
`System Settings > Privacy & Security > Accessibility > "+" > Terminal.app`

### LaunchAgent
The launch agent is a background process that is started when the users signs in.  

Update the path in `com.user.macos-screen-sharing-resolution-automation.plist` to point to the `set_resolution.sh` script in this repo.

Copy the config to your LaunchAgent directory.
```bash
cp com.user.macos-screen-sharing-resolution-automation.plist /Users/siw36/Library/LaunchAgents/
```
### Resolution
Find the desired resolution.
```bash
displayplacer list

# Copy the string starting with `res`, e.g.
# res:3840x2160 hz:60 color_depth:4
```

Set the desired resolution in the `set_resolution.sh` file as `DP_RES`

Make sure the script is executable.
```bash
chmod u+x set_resolution.sh
```

Test the script. (You should be on a different resolution than the desired one)
```bash
./set_resolution.sh
```
This should change the resolution as configured.

### Enable the LaunchAgent

```bash
launchctl unload ~/Library/LaunchAgents/com.user.macos-screen-sharing-resolution-automation.plist
launchctl load ~/Library/LaunchAgents/com.user.macos-screen-sharing-resolution-automation.plist
```

### Verify the LaunchAgent

```bash
launchctl list | grep com.user.macos-screen-sharing-resolution-automation
```

```plain
21714	0	com.user.macos-screen-sharing-resolution-automation
```

If the agent is loaded, this command should print a line containing the label. If there is no output, the agent is not currently loaded.

### Try it
Disconnect your Screen Sharing session and reconnect.  
The resolution should be automatically updated a few seconds after the connection is established.

### Troubleshooting
Logs are stored in
```bash
tail -f tmp/macos-screen-sharing-resolution-automation.out.log
tail -f tmp/macos-screen-sharing-resolution-automation.err.log
```