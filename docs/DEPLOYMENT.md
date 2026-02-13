# Deployment & Launch Guide

Your SarvadarshiTarang news app is ready to launch! Follow this checklist to get live.

## Pre-Launch Checklist

### Phase 1: GitHub Setup (1-2 hours)

- [ ] Create GitHub repository
- [ ] Enable GitHub Pages
  - Go to Settings → Pages
  - Source: Deploy from main branch
  - Your site: `https://YOUR_USERNAME.github.io/SarvadarshiTarang/`
- [ ] Create `.github/workflows/generate-feed.yml`
- [ ] Create `.github/workflows/notify-users.yml`
- [ ] Create all Python scripts in `scripts/`
- [ ] Test workflows locally
- [ ] Create branch protection rules
- [ ] Add PR template in `.github/pull_request_template.md`

### Phase 2: Firebase Setup (30 minutes)

- [ ] Create Firebase project at console.firebase.google.com
- [ ] Register Android app
  - Bundle: `com.example.sarvadarshi_tarang`
  - Download `google-services.json`
  - Place in `android/app/`
- [ ] Register iOS app
  - Bundle ID: `com.example.sarvadarshiTarang`
  - Download `GoogleService-Info.plist`
  - Add to Xcode
- [ ] Get Firebase Server Key
  - Go to Cloud Messaging tab
  - Copy "Server Key"
  - Add to GitHub Secrets as `FCM_SERVER_KEY`
- [ ] Enable Cloud Messaging
- [ ] Setup Notification topic: `news`

### Phase 3: Mobile App Setup (2-3 hours)

- [ ] Create Flutter project
- [ ] Install dependencies: `flutter pub get`
- [ ] Update Firebase configuration
- [ ] Build and test on emulator: `flutter run`
- [ ] Test Firebase initialization
- [ ] Test notification receiver
- [ ] Build release APK: `flutter build apk --release`
- [ ] Build release iOS: `flutter build ios --release` (requires Mac)

### Phase 4: Blog Setup (1-2 hours)

Choose one of these free options:

**Option A: Medium**
- [ ] Create free Medium account
- [ ] Create publication for your news
- [ ] Write test article
- [ ] Note publication URL for PR template

**Option B: Substack**
- [ ] Create free Substack newsletter
- [ ] Create first article
- [ ] Set custom domain (optional)
- [ ] Note URL for articles

**Option C: Dev.to**
- [ ] Create free Dev.to account
- [ ] Write test article
- [ ] Link to portfolio
- [ ] Note URL format

**Option D: Self-hosted (Free Tier)**
- [ ] GitHub Pages free blog
- [ ] Vercel deploy (free)
- [ ] Netlify deploy (free)
- [ ] Heroku deploy (paid, but cheap)

## Launch Timeline

### Week 1: Foundation

**Day 1-2: Core Setup**
```
- Create GitHub repo
- Setup GitHub Pages
- Create workflows
- Test locally
```

**Day 3-5: Firebase**
```
- Create Firebase project
- Configure messaging
- Get credentials
- Add GitHub secrets
```

**Day 6-7: Mobile App**
```
- Create Flutter project
- Build & test
- Setup notifications
- Create release build
```

### Week 2: Soft Launch

**Day 1-3: Internal Testing**
```
- Test on real devices
- Send test notifications
- Verify article loading
- Check images display
```

**Day 4-7: Beta Release**
- Invite friends to test
- Gather feedback
- Fix any issues
- Prepare store submissions

### Week 3: Public Launch

**Day 1-2: Store Submissions**
- [ ] Google Play
- [ ] Apple App Store
- [ ] Alternative stores (optional)

**Day 3: Go Live!**
- [ ] Announce on social media
- [ ] Send launch notification
- [ ] Monitor user feedback
- [ ] Release marketing

## Deployment Steps

### Step 1: Initial Content

Create your first few articles:

```bash
# Article 1
nano content/articles/2026-02-13-welcome.md
cp image.jpg content/assets/2026-02-13-welcome.jpg

# Article 2
nano content/articles/2026-02-13-news2.md
cp image.jpg content/assets/2026-02-13-news2.jpg

# Commit
git add content/
git commit -m "chore: add initial articles"
git push origin main
```

Wait for GitHub Actions to run:
- Check **Actions** tab
- Search for "Generate News Feed"
- Wait for ✅ success
- Check `dist/feed.json` generated

### Step 2: Test Feed URL

Access your feed:

```
https://raw.githubusercontent.com/YOUR_USERNAME/SarvadarshiTarang/main/dist/feed.json
```

Or GitHub Pages:
```
https://YOUR_USERNAME.github.io/SarvadarshiTarang/dist/feed.json
```

Should see JSON with your articles:
```json
{
  "meta": {
    "name": "SarvadarshiTarang",
    "total_articles": 2
  },
  "articles": [...]
}
```

### Step 3: Update App Configuration

In `lib/services/api_service.dart`:

Change:
```dart
static const String feedUrl =
    'https://raw.githubusercontent.com/YOUR_USERNAME/SarvadarshiTarang/main/dist/feed.json';
```

### Step 4: Build for Stores

**Android APK:**
```bash
flutter build apk --release
# Output: build/app/outputs/flutter-app.apk
```

**Android App Bundle (Google Play preferred):**
```bash
flutter build appbundle --release
# Output: build/app/outputs/bundle/release/app-release.aab
```

**iOS:**
```bash
# Requires macOS and Apple Developer Account
flutter build ios --release
# Follow Xcode steps for App Store upload
```

### Step 5: Submit to App Stores

#### Google Play Store

1. **Create Developer Account**
   - Go to [play.google.com/console](https://play.google.com/console)
   - Pay $25 one-time fee
   - Verify identity

2. **Create App**
   - Click Create App
   - Name: "SarvadarshiTarang"
   - Category: News
   - Fill store listing

3. **Upload APK**
   - Go to **Release** → **Production**
   - Upload `app-release.aab`
   - Fill release notes
   - Submit for review (takes 2-4 hours)

4. **Store Listing**
   - Add screenshots
   - Write description (500 chars max)
   - Add icon (512x512)
   - Set privacy policy (link to your blog)

#### Apple App Store

1. **Create Developer Account**
   - Go to [developer.apple.com](https://developer.apple.com)
   - Pay $99/year
   - Verify ID

2. **App Store Connect**
   - Create new app
   - Fill app information
   - Add screenshots for different sizes

3. **Build & Upload**
   - Archive in Xcode
   - Use Application Loader or Transporter
   - Submit for review (takes 24-48 hours)

### Step 6: Celebrate! 🎉

Once approved:
- [ ] App available on Google Play
- [ ] App available on App Store
- [ ] Share with friends
- [ ] Post on social media
- [ ] Send launch announcement

## Post-Launch Operations

### Daily Tasks

- **Morning**: Review any submitted articles/PRs
- **Accept/Request Changes**: Provide feedback to contributors
- **Merge**: Accept articles for publication
- **Monitor**: Check notification delivery in Firebase Console

### Weekly Tasks

- [ ] Check app ratings and reviews
- [ ] Monitor user count growth
- [ ] Analyze top articles (Firebase Analytics)
- [ ] Plan content calendar
- [ ] Recruit new contributors

### Monthly Tasks

- [ ] Review app performance metrics
- [ ] Gather user feedback
- [ ] Plan feature additions
- [ ] Update app with new features
- [ ] Major version releases

## Monitoring & Analytics

### Firebase Console

1. Go to [console.firebase.google.com](https://console.firebase.google.com)
2. Select your project
3. Check dashboards:
   - **Analytics**: User engagement
   - **Cloud Messaging**: Notification stats
   - **Crashlytics**: Error tracking (setup required)

### GitHub Insights

1. Go to repository **Insights** tab
2. Check:
   - **Traffic**: Page views
   - **Contributors**: Team activity
   - **Network**: Branch history
   - **Community**: Issues, PRs, discussions

### Mobile App Stores

**Google Play Console**:
- User acquisition
- Retention rates
- Crash reports
- Rating trends

**App Store Connect**:
- Sales information
- User feedback
- Crash logs
- Performance metrics

## Scaling Your App

### Adding Features

1. **Dark Mode**
   - Add in Flutter theme
   - Store user preference

2. **Offline Reading**
   - Cache articles locally
   - Use Hive database

3. **Search**
   - Implement Elasticsearch
   - Or simple local search

4. **User Accounts**
   - Firebase Authentication
   - Save reading history
   - Personalized feed

5. **Comments**
   - Firebase Realtime Database
   - Or GitHub Discussions API

### Growing Your Team

As you get busy:

1. **Recruit Editors**
   - Train on review process
   - Set editorial guidelines
   - Delegate merge responsibilities

2. **Onboard Contributors**
   - Create contributor guide
   - Set article standards
   - Build community

3. **Automation**
   - Scheduled article publishing
   - Auto-tag articles
   - Smart notification timing

## Troubleshooting Launch Issues

### App Crashes on Launch

- [ ] Check Firebase initialization
- [ ] Verify API endpoint URL
- [ ] Check network permissions
- [ ] Review crash logs in Firebase

### Feed Not Loading

- [ ] Verify GitHub Actions succeeded
- [ ] Check JSON syntax: `https://jsonlint.com`
- [ ] Verify URL is publicly accessible
- [ ] Check app's CORS permissions

### Notifications Not Received

- [ ] Verify topic subscription in app
- [ ] Check Firebase credentials
- [ ] Test with Firebase Console sender
- [ ] Review app log output

### App Store Rejection

**Common reasons**:
- Missing privacy policy
- Broken links in description
- Screenshots don't match app
- Violates app store policies

**Prevention**:
- [ ] Private policy linked
- [ ] Beta test on real devices
- [ ] Accurate store screenshots
- [ ] Follow platform guidelines

## Continued Growth

### Content Strategy

- Publish 3-5 articles daily
- Mix of different categories
- Consistent publication times
- Engage with readers

### Community Building

- Recruit more contributors
- Start Discord/Telegram community
- Feature best contributors
- Monthly highlights

### Marketing

- Social media presence
- Guest articles on other platforms
- Podcasts or interviews
- Partnerships with other news apps

---

## Post-Launch Support

You now have a fully operational news app! 

**Next steps**:
1. Promote to early users
2. Gather feedback
3. Implement improvements
4. Build community
5. Grow your audience

**Key Contacts**:
- Firebase Support: support.google.com/firebase
- GitHub Help: github.com/support
- Flutter Docs: flutter.dev/docs
- Apple Support: developer.apple.com/support
- Google Play Help: support.google.com/googleplay

---

**Congratulations on your launch!** 🚀

Don't hesitate to reach out for help. The community is here!
