# Extractr
![Mac](https://img.shields.io/badge/platform-Mac-1C92F5.svg)
![Swift](https://img.shields.io/badge/lang-Swift-FFAC45.svg?style=flat)

<img src="https://github.com/roonieone/Extractr/blob/master/PR/Etxractr%402x.png" alt="pr-image" width="650"/>

Extractr is a tool to extract the iOS root file system from an OTA update. Currently the only *offically* supported iOS versions are **iOS 10.0 betas 1-3**.

Extractr is a GUI tool that automates the manual "Extract the Root File System" instructions found [here](https://gist.github.com/roonieone/d6567e80500d1e3f6e5fa8e80d5d8b3c).

[Download the latest version of Extractr](https://github.com/roonieone/Extractr/releases)

[Download the iOS 10 OTA ZIPs](https://ipsw.me/ota)

## Usage
1. Download an OTA ZIP from [ipsw.me](https://ipsw.me/ota)
2. Select the OTA ZIP file and an output directory (wherever you would like the iOS File System to be copied)
3. Hit "Extract Root File System" and watch the magic happen

May take up to 10 minutes to execute, depending on the speed of the machine on which it's run.

## Future
In the comming weeks and months I plan to add various features to Extractr:
- [ ] Quick unpacking and copying of the root file system via iOS 10 `IPSW`s
- [ ] [ipsw.me API](https://api.ipsw.me/) support for downloading OTA `ZIP`s and `IPSW`s from within the app
- [ ] Preferences for deleting the original `ZIP`, etc.
- [ ] Light and dark themes for the concole output
- [ ] Add [Sparkle](https://github.com/sparkle-project/Sparkle) support for updates

Extractr is completely free and open source. If you come across any bugs or have some free time on your hands and want to take a stab at implementing any of the above features, feel free to send me a pull request or file an issue.

## Credit
Extractr was made in large part with help from tools made by [Jonathan Levin](https://twitter.com/Morpheus______) and [The Unarchiver](https://unarchiver.c3.cx/unarchiver). Levin's tools, as part of [OTApack](http://newosxbook.com/files/OTApack.tar), are explained in a three-part blog post which can be found here: [Part 1](http://newosxbook.com/articles/OTA.html), [Part 2](http://newosxbook.com/articles/OTA2.html), and [Part 3](http://newosxbook.com/articles/OTA3.html). The Unarchiver's [command line tools](https://unarchiver.c3.cx/commandline) and [source code](https://bitbucket.org/WAHa_06x36/theunarchiver) are avaliable for free.
