# How to Build APK from SarvadarshiTarang

We've successfully created a Flutter project structure. Now let's build the APK for testing.

## Current Status ✅

- [x] Flutter SDK installed at `C:\flutter\`
- [x] Dart SDK ready
- [x] Test Flutter app created at `D:\repos\SarvadarshiTarang\test_news_app\`
- [x] Android licenses accepted
- [ ] Android SDK needed
- [ ] Build APK

## Option 1: Quick Setup (Recommended - 20 minutes)

### Step 1: Download Android SDK

We need the Android SDK for building. Here's the fastest way:

**Download pre-configured Android SDK:**
1. Go to [Android Studio Downloads](https://developer.android.com/studio)
2. Download Android Studio for Windows
3. Run the installer
4. Complete the setup wizard:
   - Choose "Standard" installation
   - Accept SDK licenses
   - Let it download components (takes 5-10 minutes)

### Step 2: Configure Flutter

After Android Studio finishes:

```powershell
# Find Android SDK location (usually):
# C:\Users\YourUsername\AppData\Local\Android\Sdk

# Configure Flutter to use it:
C:\flutter\bin\flutter config --android-sdk "C:\Users\YourUsername\AppData\Local\Android\Sdk"

# Verify setup:
C:\flutter\bin\flutter doctor
# Should show [√] Android toolchain
```

### Step 3: Build APK

```powershell
# Navigate to test project
cd D:\repos\SarvadarshiTarang\test_news_app

# Build release APK
C:\flutter\bin\flutter build apk --release

# Output will be in:
# build\app\outputs\apk\release\app-release.apk
```

Done! ✅

## Option 2: Using Android Studio Directly

### Step 1: Install Android Studio
1. Download from [https://developer.android.com/studio](https://developer.android.com/studio)
2. Run installer
3. Complete setup wizard

### Step 2: Open Project in Android Studio
1. Open Android Studio
2. File → Open
3. Navigate to: `D:\repos\SarvadarshiTarang\test_news_app`
4. Click Open
5. Wait for Gradle sync to complete

### Step 3: Build APK
1. Build → Build Bundle(s) / APK(s) → Build APK(s)
2. Android Studio generates the APK
3. Find it in `build\app\outputs\apk\release\`

## Option 3: Command Line (Advanced)

If you prefer command line without Android Studio GUI:

```powershell
# Install Android SDK command line tools only
# Download from: https://developer.android.com/studio#command-tools
# Extract to: D:\Android\cmdline-tools

# Set environment variables
$env:ANDROID_HOME = "D:\Android\Sdk"
[Environment]::SetEnvironmentVariable("ANDROID_HOME", "D:\Android\Sdk", [EnvironmentVariableTarget]::User)

# Download SDK components
& "D:\Android\cmdline-tools\bin\sdkmanager" --sdk_root="D:\Android\Sdk" "build-tools;34.0.0" "platforms;android-34" "platform-tools"

# Configure Flutter
C:\flutter\bin\flutter config --android-sdk "D:\Android\Sdk"

# Build
cd D:\repos\SarvadarshiTarang\test_news_app
C:\flutter\bin\flutter build apk --release
```

## Testing the APK

### On Android Phone/Emulator

**Enable Unknown Sources:**
- Phone Settings → Security → Allow installation from unknown sources

**Install APK:**

```powershell
# If Android emulator running
adb install -r build\app\outputs\apk\release\app-release.apk

# Or copy file to phone via USB and tap to install
```

**Or use Flutter directly:**

```powershell
C:\flutter\bin\flutter install  # Install on connected device
C:\flutter\bin\flutter run       # Run app on device
```

### APK File Locations

After successful build, the APK will be at:

```
test_news_app\build\app\outputs\apk\release\app-release.apk
test_news_app\build\app\outputs\flutter-app.apk
```

## Troubleshooting

### "No Android SDK found"

**Solution:**
```powershell
# Download Android Studio from https://developer.android.com/studio
# Let it auto-configure SDK during first launch
# Then run:
C:\flutter\bin\flutter config --android-sdk "C:\Users\YourName\AppData\Local\Android\Sdk"
```

### "Gradle version incompatible"

**Solution:**
```powershell
cd test_news_app\android
# Delete gradle wrapper
rm -r gradle
# Re-download during next build
cd ..
C:\flutter\bin\flutter build apk --release
```

### Build still failing?

**Full diagnostics:**
```powershell
C:\flutter\bin\flutter clean
C:\flutter\bin\flutter pub get
C:\flutter\bin\flutter build apk --release -v  #verbose mode
```

## File Locations for Reference

| Item | Location |
|------|----------|
| **Flutter SDK** | `C:\flutter\` |
| **Flutter Project** | `D:\repos\SarvadarshiTarang\test_news_app\` |
| **Source Code** | `test_news_app\lib\main.dart` |
| **Android Config** | `test_news_app\android\` |
| **Build Output** | `test_news_app\build\app\outputs\` |
| **APK File** | `test_news_app\build\app\outputs\apk\release\app-release.apk` |

## Next Steps

### After Building APK:

1. **Test on Device/Emulator**
   ```powershell
   C:\flutter\bin\flutter run
   ```

2. **Test Notifications** (requires Firebase setup)
   - See: [NOTIFICATIONS_SETUP.md](docs/NOTIFICATIONS_SETUP.md)

3. **Build for Production**
   - Sign the APK
   - Optimize for size
   - Build App Bundle for Play Store

4. **Create Actual News App**
   - Copy our app structure from `mobile-app/` folder
   - Integrate with GitHub API
   - Add Firebase configuration
   - Deploy to Play Store

## Android Studio Installation Summary

**Estimated Time: 15-20 minutes**

1. Download Android Studio (550 MB)
2. Run installer
3. Accept license (5 min)
4. Let it download SDK components (10 min)
5. Close Android Studio
6. Configure Flutter
7. Build APK (5-10 min)

**Total: 30-40 minutes**

## Questions?

- Flutter Docs: [flutter.dev/docs](https://flutter.dev/docs)
- Android Studio: [developer.android.com/studio](https://developer.android.com/studio)
- Check [MOBILE_SETUP.md](docs/MOBILE_SETUP.md) for app setup

---

**Once you complete these steps, you'll have a working APK ready for testing!** 🚀

Then you can:
1. Test on your phone
2. Integrate the real news app architecture
3. Add Firebase notifications
4. Deploy to Google Play Store
