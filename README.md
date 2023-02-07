# google-drive-revoking-access
This little tool is used to help with revoking access on a large set of folders and files on Google Drive.

This tool is using `gdrive` https://github.com/prasmussen/gdrive

## Installation

⚠ **Warning:** If you want to give these tool a try, you should first review the code. Don’t blindly use it unless you know what that entails. Use at your own risk!

You can clone the repository wherever you want:

```bash
git clone https://github.com/jeromin/google-drive-revoking-access.git && cd google-drive-revoking-access
```

Or install without git:

```bash
curl -fsSL https://raw.githubusercontent.com/jeromin/google-drive-revoking-access/main/gdrive-revoke.sh
```

Simply `./gdrive-revoke.sh` to test it out.

Don't forget to give your user execute permission `chmod u+x ./gdrive-revoke.sh`

## ⚙️ Configuration

Follow instruction from [gdrive](https://github.com/prasmussen/gdrive) to configure gdrive command.

## How to use it

**Usage**
* `list fileID`								: List file permissions with permission ID
* `[-s number] show filename emailaddress`	: Save files shared with
* `[-p] revoke filename permisionID`		: Revoke permission with

**Global**
* `-a` 	Google service account key needed for gdrive (located in ~/.gdrive)

**Options**
* `-s` 	Split result in n lines
* `-p` 	Use splitted files to run in parallel

## Feedback

Feel free to use or [contribute](https://github.com/jeromin/google-drive-revoking-access/issues)!