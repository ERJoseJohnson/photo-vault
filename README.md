# photo_vault

## Steps to run 
- Application has been tested on my Pixel 4a, running Android 11.
- Running `flutter run` with a physical device connected should install eand execute the application.
- Alternatively, VS Code's built-in debugger can be used for execution.
- NOTE: Not tested for iOS. But the relevant permissions has been added to the best of my knowledge.
## Implemented features
1. Set master PIN to lock app
2. Create albums
3. Set PIN to lock albums
4. Import photos into app
5. View photos per album


## Know bugs
- Creating duplicate album names seems to overwrite the database instead of showing a warning to user
- Java specific storage API has been deprecated on android 10. Therefore unable to implement secure storage on application directory. Link: https://github.com/flutter/flutter/issues/71355#issuecomment-736321687
  - Application storage functions have been implemented in storage.dart but are not used.
- The same deprecated API affects storing pictures that are taken from the camera.
