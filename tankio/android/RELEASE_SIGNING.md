# Release Signing

This project uses a local Android release keystore for Play Store builds.

## Files

- `android/app/upload-keystore.jks`
  - This is the private release keystore.
- `android/key.properties`
  - This file stores the keystore alias and passwords.
- `android/app/build.gradle.kts`
  - This file reads `key.properties` and signs the `release` build.

## What the key is

The signing key is the keystore file:

- `android/app/upload-keystore.jks`

The `key.properties` file points Gradle to that file and provides:

- `storePassword`
- `keyPassword`
- `keyAlias`
- `storeFile`

## Build command

To generate a Play Store release:

```bash
flutter build appbundle --release
```

## Important notes

- Do not share `upload-keystore.jks` publicly.
- Do not share `android/key.properties`.
- Keep a secure backup of both files.
- If you lose the keystore, you will not be able to update the same Play Store app unless you still have Play App Signing recovery available.
