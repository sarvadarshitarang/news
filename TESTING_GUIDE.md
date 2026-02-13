# Testing Your Flutter App

## 🌐 Testing on Web (Easiest - Running Now!)

Your app is currently launching in Chrome browser. This is the fastest way to test without Android setup.

### What's Happening:
```
✓ Flutter is compiling your app for web
✓ Chrome will open automatically
✓ You'll see your test app running
```

**Hot Reload:** Press `r` in the terminal to reload changes without restarting!

---

## 📱 Testing on Android Emulator (Requires Setup)

### Quick Setup (15 minutes):

#### Option 1: Using Android Studio (Recommended)

**Step 1: Install Android Studio**
1. Download from [https://developer.android.com/studio](https://developer.android.com/studio)
2. Run installer
3. Complete setup wizard (standard installation)

**Step 2: Create Virtual Device**
1. Open Android Studio
2. Tools → Device Manager (or AVD Manager)
3. Click "Create Virtual Device"
4. Select device: **Pixel 5** (or any device)
5. Select system image: **Android 34 (UpsideDownCake)** - click Download
6. Click Next → Finish
7. Click ▶️ Play button to start emulator

**Step 3: Run Your App**
```powershell
# Wait for emulator to fully boot (1-2 minutes)
cd D:\repos\SarvadarshiTarang\test_news_app

# Check device is connected
C:\flutter\bin\flutter devices

# Run app
C:\flutter\bin\flutter run
```

**App will install and launch on emulator!** ✅

---

#### Option 2: Command Line Only

```powershell
# Set Android SDK location (after installing Android Studio)
$env:ANDROID_HOME = "$env:LOCALAPPDATA\Android\Sdk"
[Environment]::SetEnvironmentVariable("ANDROID_HOME", $env:ANDROID_HOME, [EnvironmentVariableTarget]::User)

# Configure Flutter
C:\flutter\bin\flutter config --android-sdk $env:ANDROID_HOME

# List available emulators
C:\flutter\bin\flutter emulators

# Launch an emulator
C:\flutter\bin\flutter emulators --launch <emulator_id>

# Run app
cd D:\repos\SarvadarshiTarang\test_news_app
C:\flutter\bin\flutter run
```

---

## 📲 Testing on Physical Android Phone (No Emulator Needed!)

**Fastest option if you have an Android phone:**

### Step 1: Enable Developer Mode on Phone
1. Open Settings → About Phone
2. Tap "Build Number" **7 times**
3. Go back to Settings → Developer Options
4. Enable **USB Debugging**

### Step 2: Connect Phone via USB
1. Connect phone to computer with USB cable
2. Accept "Allow USB Debugging" prompt on phone
3. Keep screen unlocked

### Step 3: Run App
```powershell
# Check phone is detected
C:\flutter\bin\flutter devices

# Should show something like:
# SM-G991B (mobile) • xxxxx • android-arm64 • Android 13

# Run app on your phone
cd D:\repos\SarvadarshiTarang\test_news_app
C:\flutter\bin\flutter run
```

**App installs directly to your phone!** 📱

---

## 🖥️ Testing on Windows Desktop

You can also run it as a native Windows app:

```powershell
cd D:\repos\SarvadarshiTarang\test_news_app
C:\flutter\bin\flutter run -d windows
```

*Note: Requires Visual Studio with C++ tools (see BUILD_APK_GUIDE.md)*

---

## 🔄 Development Workflow

### Hot Reload (While App is Running)

Press in terminal:
- **`r`** - Hot reload (apply changes instantly)
- **`R`** - Hot restart (full restart)
- **`q`** - Quit app
- **`h`** - Help

### Make Changes:
1. Edit `test_news_app\lib\main.dart`
2. Press `r` in terminal
3. See changes instantly!

Example quick edit:
```dart
// In lib/main.dart, change:
title: 'Flutter Demo Home Page',
// To:
title: 'My News App!',
```

Press `r` → Changes appear immediately! 🎉

---

## 📊 Performance Testing

### Check App Performance:
```powershell
# Profile mode (better performance metrics)
C:\flutter\bin\flutter run --profile

# Release mode (production-like)
C:\flutter\bin\flutter run --release
```

### Build Size Check:
```powershell
# Build and check size
C:\flutter\bin\flutter build apk --release
# Check size at: build\app\outputs\apk\release\app-release.apk
```

---

## 🐛 Debugging

### View Logs:
```powershell
# Run with verbose logging
C:\flutter\bin\flutter run -v

# Or check logs while running
C:\flutter\bin\flutter logs
```

### Common Issues:

**"No devices found"**
```powershell
# Check available devices
C:\flutter\bin\flutter devices

# Restart adb (Android Debug Bridge)
adb kill-server
adb start-server
```

**"Gradle build failed"**
```powershell
cd test_news_app
C:\flutter\bin\flutter clean
C:\flutter\bin\flutter pub get
C:\flutter\bin\flutter run
```

**App won't install on phone**
- Unlock phone screen
- Accept USB debugging prompt
- Check USB cable is data cable (not charge-only)
- Try different USB port

---

## 🎯 Testing Checklist

### Basic Tests:
- [ ] App launches successfully
- [ ] No crash on startup
- [ ] UI renders correctly
- [ ] Buttons are clickable
- [ ] Navigation works
- [ ] Hot reload works

### Performance Tests:
- [ ] Smooth scrolling
- [ ] Fast startup (< 3 seconds)
- [ ] No memory leaks
- [ ] Battery usage acceptable

### Device Tests:
- [ ] Works on Android phone
- [ ] Works in Chrome
- [ ] Works on emulator
- [ ] Landscape orientation
- [ ] Portrait orientation
- [ ] Different screen sizes

---

## 📱 Current Test Status

✅ **Web:** Running in Chrome (happening now!)  
⏳ **Android Emulator:** Requires Android Studio setup  
⏳ **Physical Phone:** Requires USB debugging enabled  
⏳ **Windows Desktop:** Requires Visual Studio  

---

## Next Steps

### After Testing:

1. **Integrate Real News App**
   - Copy code from `mobile-app/lib/` to `test_news_app/lib/`
   - Update `pubspec.yaml` with dependencies
   - Add Firebase configuration
   - Point to your GitHub feed URL

2. **Test with Real Content**
   - Create some articles in `content/articles/`
   - Generate feed with GitHub Actions
   - Update API service URL
   - Test article loading

3. **Setup Firebase Notifications**
   - Add Firebase to project
   - Test push notifications
   - See: [NOTIFICATIONS_SETUP.md](docs/NOTIFICATIONS_SETUP.md)

4. **Build Production APK**
   - Sign with release key
   - Optimize for size
   - Test on multiple devices
   - Upload to Play Store

---

## Useful Commands Reference

```powershell
# Check environment
C:\flutter\bin\flutter doctor -v

# List devices
C:\flutter\bin\flutter devices

# Run on specific device
C:\flutter\bin\flutter run -d <device-id>

# Build APK
C:\flutter\bin\flutter build apk --release

# Clean build
C:\flutter\bin\flutter clean

# Get dependencies
C:\flutter\bin\flutter pub get

# Analyze code
C:\flutter\bin\flutter analyze

# Run tests
C:\flutter\bin\flutter test
```

---

## 🎉 You're Testing!

Your app is now running. Check your Chrome browser to see it!

**To continue development:**
1. Keep terminal open (for hot reload)
2. Edit files in VS Code
3. Press `r` to reload
4. See changes instantly

Happy testing! 🚀
