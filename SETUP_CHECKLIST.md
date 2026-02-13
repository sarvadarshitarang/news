# Complete Setup Checklist

This comprehensive checklist will guide you from zero to a fully operational news app.

## 📋 Phase 1: Initial Planning (15 minutes)

- [ ] Define your news niche (Tech, Sports, Politics, etc.)
- [ ] Choose your blog platform (Medium, Substack, Dev.to, or self-hosted)
- [ ] Get your blog URL ready (e.g., yourblog.com)
- [ ] Decide on team size (solo or with contributors)
- [ ] Create social media presence for app (optional)
- [ ] Design basic brand identity (name, colors, logo)

**Files to update**: None

---

## 🔐 Phase 2: GitHub Setup (30 minutes)

### Create Repository

- [ ] Create GitHub account (if not already)
- [ ] Create new public repository: `SarvadarshiTarang`
- [ ] Copy this project structure into your repo
- [ ] Add `.gitignore` file (included)
- [ ] Enable GitHub Pages
  - Go to Settings → Pages
  - Source: Deploy from main branch
  - Branch: `main`
  - Folder: `/(root)`
- [ ] Your site URL: `https://YOUR_USERNAME.github.io/SarvadarshiTarang/`

### Configure Branch Protection

- [ ] Go to Settings → Branches
- [ ] Create rule for `main` branch:
  - ✓ Require a pull request before merging
  - ✓ Require approvals (minimum 1)
  - ✓ Dismiss stale reviews
  - ✓ Require status checks to pass
  - ✓ Require branches to be up to date

### Setup PR Template

- [ ] Create `.github/pull_request_template.md`
- [ ] Copy template from [COLLABORATION_GUIDE.md](COLLABORATION_GUIDE.md)

### Create Workflow Files

- [ ] Create `.github/workflows/generate-feed.yml`
  - Copy from [WORKFLOW_SETUP.md](WORKFLOW_SETUP.md)
- [ ] Create `.github/workflows/notify-users.yml`
  - Copy from [WORKFLOW_SETUP.md](WORKFLOW_SETUP.md)

### Setup Secrets

- [ ] Go to Settings → Secrets and variables → Actions
- [ ] Create secrets (will add values later):
  - `FCM_SERVER_KEY` (Firebase)
  - `FIREBASE_CREDENTIALS` (Firebase)
  - `GITHUB_TOKEN` (auto-created)

**Files to create**:
- `.github/workflows/generate-feed.yml`
- `.github/workflows/notify-users.yml`
- `.github/pull_request_template.md`

**Files to configure**:
- `.gitignore`

---

## 📱 Phase 3: Firebase Setup (45 minutes)

### Create Firebase Project

- [ ] Go to [console.firebase.google.com](https://console.firebase.google.com)
- [ ] Click "Create Project"
- [ ] Name: `SarvadarshiTarang`
- [ ] Disable Google Analytics (optional)
- [ ] Click "Create project" (wait 2-3 minutes)

### Register Android App

- [ ] In Firebase Console, click Add App → Android
- [ ] Package name: `com.example.sarvadarshi_tarang`
- [ ] App nickname: `SarvadarshiTarang`
- [ ] Debug SHA-1: Leave for now (need Android setup)
- [ ] Click "Register app"
- [ ] **Download `google-services.json`**
- [ ] Place in `android/app/google-services.json`

### Register iOS App

- [ ] Click Add App → iOS
- [ ] Bundle ID: `com.example.sarvadarshiTarang`
- [ ] Click "Register app"
- [ ] **Download `GoogleService-Info.plist`**
- [ ] Save in `ios/Runner/` (will add via Xcode later)

### Enable Cloud Messaging

- [ ] In Firebase Console: Go to Cloud Messaging tab
- [ ] Verify it's enabled
- [ ] Copy **Server Key** (legacy) or generate new key
- [ ] Go to GitHub Settings → Secrets
- [ ] Create secret: `FCM_SERVER_KEY` = paste key

### Get Service Account Key (for GitHub Actions)

- [ ] In Firebase Console: Go to Project Settings (gear icon)
- [ ] Select "Service Accounts" tab
- [ ] Click "Generate New Private Key"
- [ ] **Download JSON file** and save securely
- [ ] In GitHub Secrets, create `FIREBASE_CREDENTIALS` = entire JSON content

### Setup Notification Topic

- [ ] In Cloud Messaging tab
- [ ] Note topic name: `news` (we'll use this)

**Files to configure**:
- `android/app/google-services.json` (add Firebase file)
- `ios/Runner/GoogleService-Info.plist` (add Firebase file)

**GitHub Secrets to add**:
- `FCM_SERVER_KEY`
- `FIREBASE_CREDENTIALS`

---

## 💻 Phase 4: Python Scripts Setup (20 minutes)

### Create Script Files

- [ ] Create `scripts/generate_feed.py`
  - Copy from [WORKFLOW_SETUP.md](docs/WORKFLOW_SETUP.md)
  - Verify imports: `pyyaml`, `markdown2`, `Pillow`

- [ ] Create `scripts/validate_feed.py`
  - Copy from [WORKFLOW_SETUP.md](docs/WORKFLOW_SETUP.md)

- [ ] Create `scripts/send_notifications.py`
  - Copy from [WORKFLOW_SETUP.md](docs/WORKFLOW_SETUP.md)
  - Verify imports: `firebase-admin`

### Test Scripts Locally

- [ ] Install Python 3.11+
- [ ] Create virtual environment:
  ```bash
  python -m venv venv
  source venv/bin/activate  # On Windows: venv\Scripts\activate
  ```
- [ ] Install dependencies:
  ```bash
  pip install pyyaml markdown2 Pillow firebase-admin requests
  ```
- [ ] Test generate_feed script:
  ```bash
  python scripts/generate_feed.py
  ```
  - Should create `dist/feed.json`
  - Should have your example article

**Files to create**:
- `scripts/generate_feed.py`
- `scripts/validate_feed.py`
- `scripts/send_notifications.py`
- `scripts/test_notification.py`

---

## 📰 Phase 5: Content Setup (15 minutes)

### Create Article Files

- [ ] Create `content/articles/2026-02-13-example-article.md`
  - Copy from example included
  - Update with your content
  - Update date to today

- [ ] Create `content/articles/2026-02-13-welcome.md`
  - Write a welcome article for your app
  - Introduce yourself and your news focus
  - Include blog URL

### Add Images

- [ ] Place images in `content/assets/`
- [ ] File naming: `YYYY-MM-DD-article-slug.jpg`
- [ ] Image requirements:
  - Size: < 300KB
  - Dimensions: 800x600px or 16:9 aspect ratio
  - Format: JPG or PNG

### Verify Content Format

- [ ] Check articles have complete frontmatter:
  - `title`
  - `description`
  - `image`
  - `date`
  - `author`
  - `category`
  - `blog_url`
  - `read_time`

**Files to create**:
- `content/articles/YYYY-MM-DD-article.md`
- `content/assets/YYYY-MM-DD-images.jpg`

---

## 📡 Phase 6: Local Testing (30 minutes)

### Test GitHub Actions Locally

- [ ] Commit and push your article:
  ```bash
  git add content/
  git add scripts/
  git add .github/workflows/
  git commit -m "chore: setup complete workflow"
  git push origin main
  ```

- [ ] Go to GitHub → Actions tab
- [ ] Click "Generate News Feed" workflow
- [ ] Watch it run (should take 1-2 minutes)
- [ ] Verify ✅ success

### Verify Feed Generated

- [ ] Go to GitHub repository
- [ ] Navigate to `dist/feed.json`
- [ ] Click "Raw" to see JSON
- [ ] Verify structure:
  ```json
  {
    "meta": { ... },
    "articles": [ ... ]
  }
  ```

- [ ] Or curl:
  ```bash
  curl https://raw.githubusercontent.com/YOUR_USERNAME/SarvadarshiTarang/main/dist/feed.json | python -m json.tool
  ```

**No new files needed**

---

## 🛠️ Phase 7: Flutter App Setup (1-2 hours)

### Install Flutter

- [ ] Download Flutter from [flutter.dev](https://flutter.dev/docs/get-started/install)
- [ ] Extract to a folder
- [ ] Add to PATH:
  - Windows: Add `flutter\bin` to PATH
  - Mac/Linux: Add to `.bashrc` or `.zshrc`
- [ ] Run `flutter doctor` and fix any issues
- [ ] Install Android Studio (for Android development)
- [ ] Install Xcode (for iOS development, Mac only)

### Setup Flutter Project

- [ ] Go to `mobile-app/` directory
- [ ] Create Flutter app:
  ```bash
  flutter create .
  ```

- [ ] Update `pubspec.yaml`
  - Copy dependencies from included `pubspec.yaml`
  - Or manually add required packages

- [ ] Install packages:
  ```bash
  flutter pub get
  ```

- [ ] For iOS (Mac only):
  ```bash
  cd ios && pod install && cd ..
  ```

### Add Firebase Configuration

#### Android

- [ ] Place `google-services.json` in `android/app/`
- [ ] Update `android/app/build.gradle`:
  ```gradle
  dependencies {
    implementation 'com.google.firebase:firebase-messaging'
  }
  apply plugin: 'com.google.gms.google-services'
  ```

#### iOS

- [ ] In Xcode:
  - Open `ios/Runner.xcodeproj`
  - Select Runner project
  - Select Runner target
  - Go to Build Phases
  - Click "+" → "Add Files"
  - Select `GoogleService-Info.plist`

### Create Core App Files

- [ ] Create `lib/models/article.dart`
  - Copy from [MOBILE_SETUP.md](docs/MOBILE_SETUP.md)

- [ ] Create `lib/services/api_service.dart`
  - Copy from [MOBILE_SETUP.md](docs/MOBILE_SETUP.md)
  - Update feed URL to your Repository

- [ ] Create `lib/services/notification_service.dart`
  - Copy from [MOBILE_SETUP.md](docs/MOBILE_SETUP.md)

- [ ] Update `lib/main.dart`
  - Copy from [MOBILE_SETUP.md](docs/MOBILE_SETUP.md)
  - Update package names
  - Update resource paths

### Test on Emulator

- [ ] Start emulator:
  ```bash
  flutter emulators --launch android_emulator
  ```

- [ ] Run app:
  ```bash
  flutter run
  ```

- [ ] Verify:
  - App launches
  - Articles load from feed
  - Images display
  - No errors in console

**Files to create**:
- `mobile-app/lib/main.dart`
- `mobile-app/lib/models/article.dart`
- `mobile-app/lib/services/api_service.dart`
- `mobile-app/lib/services/notification_service.dart`
- `mobile-app/lib/widgets/article_card.dart`

**Files to configure**:
- `mobile-app/pubspec.yaml`
- `android/app/build.gradle`
- `android/app/google-services.json`
- `ios/Podfile` (Firebase)

---

## 📤 Phase 8: Build & Release (1-2 hours)

### Build Android Release

- [ ] Generate keystore (one-time):
  ```bash
  keytool -genkey -v -keystore ~/android.keystore \
    -keyalg RSA -keysize 2048 -validity 10000 \
    -alias MY_KEY_ALIAS
  ```

- [ ] Build APK:
  ```bash
  flutter build apk --release
  ```
  - Output: `build/app/outputs/flutter-app.apk`

- [ ] Or build App Bundle (for Play Store):
  ```bash
  flutter build appbundle --release
  ```
  - Output: `build/app/outputs/bundle/release/app-release.aab`

### Build iOS Release (Mac only)

- [ ] Build iOS:
  ```bash
  flutter build ios --release
  ```

- [ ] Archive in Xcode:
  - Open `ios/Runner.xcodeproj`
  - Product → Archive
  - Validate and distribute

- [ ] Upload via Transporter

**Artifacts created**:
- APK file
- AAB file (for Google Play)
- iOS archive

---

## 🚀 Phase 9: App Store Submission (2-3 hours)

### Google Play Store

- [ ] Create Google Play Developer Account ($25 fee)
- [ ] Create app in Play Console
- [ ] Fill store listing:
  - App name
  - Short & full descriptions
  - Screenshots
  - Icon
  - Privacy policy link
- [ ] Upload AAB file
- [ ] Submit for review (24-48 hours)
- [ ] Wait for approval

### Apple App Store

- [ ] Create Apple Developer Account ($99/year)
- [ ] Create app in App Store Connect
- [ ] Fill app information
- [ ] Upload iOS build
- [ ] Submit for review (24-48 hours)
- [ ] Wait for approval

**No local files needed**

---

## 📊 Phase 10: Post-Launch (Ongoing)

### Monitoring

- [ ] Check Firebase Analytics daily
- [ ] Monitor notification delivery
- [ ] Review app ratings and reviews
- [ ] Check user growth

### Content

- [ ] Publish articles regularly (3-5/day)
- [ ] Engage with readers
- [ ] Monitor trending topics
- [ ] Plan editorial calendar

### Community

- [ ] Recruit contributors
- [ ] Establish editing guidelines
- [ ] Build community around app
- [ ] Gather user feedback

### Maintenance

- [ ] Monitor app crashes
- [ ] Update dependencies monthly
- [ ] Fix bugs promptly
- [ ] Release new features quarterly

---

## ✅ Final Verification Checklist

Before launching, verify everything:

### Content
- [ ] At least 3 articles published
- [ ] All images properly optimized
- [ ] All frontmatter fields filled
- [ ] Blog URLs working

### GitHub
- [ ] Repository public
- [ ] GitHub Pages enabled
- [ ] Workflows running successfully
- [ ] Feed.json generating correctly
- [ ] Branch protection enabled

### Firebase
- [ ] Project created
- [ ] Android app registered
- [ ] iOS app registered
- [ ] Cloud Messaging enabled
- [ ] Credentials saved in GitHub Secrets

### Mobile App
- [ ] Builds without errors
- [ ] Runs on emulator
- [ ] Fetches feed successfully
- [ ] Articles display correctly
- [ ] Images load properly
- [ ] No console errors

### Documentation
- [ ] README.md complete
- [ ] All docs in place:
  - QUICK_START.md
  - CONTENT_GUIDE.md
  - WORKFLOW_SETUP.md
  - MOBILE_SETUP.md
  - NOTIFICATIONS_SETUP.md
  - COLLABORATION_GUIDE.md
  - DEPLOYMENT.md

### Testing
- [ ] Create test article in PR
- [ ] Verify PR workflow
- [ ] Merge and verify publish
- [ ] Check feed.json updated
- [ ] Reload app and see new article

---

## Performance Targets

Aim for these metrics:

- **Feed generation**: < 2 minutes
- **App startup**: < 3 seconds
- **Article load**: < 1 second
- **Notification delivery**: < 5 minutes
- **App Store submission to approval**: 24-48 hours

---

## Got Stuck?

Refer to specific guides:

| Issue | Guide |
|-------|-------|
| How to write articles | [CONTENT_GUIDE.md](docs/CONTENT_GUIDE.md) |
| GitHub Actions not working | [WORKFLOW_SETUP.md](docs/WORKFLOW_SETUP.md) |
| App won't build | [MOBILE_SETUP.md](docs/MOBILE_SETUP.md) |
| Notifications not working | [NOTIFICATIONS_SETUP.md](docs/NOTIFICATIONS_SETUP.md) |
| How to manage team | [COLLABORATION_GUIDE.md](docs/COLLABORATION_GUIDE.md) |
| Launching on stores | [DEPLOYMENT.md](docs/DEPLOYMENT.md) |

---

## Estimated Timeline

- **Week 1**: GitHub + Firebase setup (4-5 hours)
- **Week 2**: Flutter app development (5-6 hours)
- **Week 3**: Testing & refinement (3-4 hours)
- **Week 4**: App store submission (2-3 hours)

**Total: 14-18 hours** of work to launch!

---

**Congratulations!** You now have a complete roadmap to launch your news app. Follow each phase, and you'll have a fully operational news platform with zero hosting costs.

**Ready?** Start with [QUICK_START.md](docs/QUICK_START.md)! 🚀
