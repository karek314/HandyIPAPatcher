# HandyIPAPatcher

Shell scripts to extract thin binaries from IPA, patch with modified ones and then prepare for deploying.<br>

<b>extract_thin.sh</b> - Extracts thin binaries from already decrypted app.ipa file, if needed also with all framework binaries.
<b>replace_bin.sh</b> - Packs all binaries into app.ipa, if frameworks work directory was created by <b>extract_thin.sh</b> it will replace those binaries as well. If necessary it can also remove plugins if there are some signing issues.

It's convenient tool to swiftly repack .ipa to assist with patching binaries.

![workdir](/screenshots/workdir.png?raw=true)

HandyIPAPatcher is meant only for educational purposes and security research.

## Usage
1. Download needed decrypted IPA file. It can be downloaded from [IphoneCake](https://www.iphonecake.com) or prepared manually by using [Clutch](https://github.com/KJCracks/Clutch)
2. Copy IPA file to <b>HandyIPAPatcher</b> directory. Before running make sure there is only one input IPA file at time, app.ipa and orginal_app.ipa can remain!
3. Use <b>bash extract_thin.sh help</b>
![workdir](/screenshots/extract_thin.png?raw=true)
4. This is step when you work with binaries
5. Repacking help <b>bash replace_bin.sh help</b><br>Usually <b>bash replace_bin.sh fat trim</b> is best option. After repacking, app.ipa will become patched ipa file to install.
<br>![workdir](/screenshots/replace_bin.png?raw=true)
6. Install app to Jailbroken device or Non-Jailbroken with [Cydia Impactor](http://www.cydiaimpactor.com)

## License
MIT
