# External Services Setup Guide

This document provides step-by-step instructions for setting up all external services required for the Eng Alaa Hammed app.

## Table of Contents

1. [Google Cloud Console Setup](#1-google-cloud-console-setup)
2. [Google OAuth 2.0 Configuration](#2-google-oauth-20-configuration)
3. [YouTube Data API v3](#3-youtube-data-api-v3)
4. [Firebase Setup (Optional)](#4-firebase-setup-optional)
5. [Environment Variables](#5-environment-variables)
6. [Troubleshooting](#6-troubleshooting)

---

## 1. Google Cloud Console Setup

### Step 1: Create or Select Project

1. Go to [Google Cloud Console](https://console.cloud.google.com/)
2. Click on the project dropdown at the top
3. Click **New Project** or select existing project "AlaaHamedApp"
4. Project Name: `AlaaHamedApp`
5. Click **Create**

### Step 2: Enable Required APIs

Navigate to **APIs & Services > Library** and enable:

| API | Purpose | Required |
|-----|---------|----------|
| YouTube Data API v3 | Fetch channel videos | Yes |
| Google Sign-In API | OAuth authentication | Yes |
| People API | User profile info | Optional |

To enable each API:
1. Search for the API name
2. Click on it
3. Click **Enable**

---

## 2. Google OAuth 2.0 Configuration

### Configure OAuth Consent Screen

1. Go to **APIs & Services > OAuth consent screen**
2. Select **External** user type
3. Fill in the required fields:

| Field | Value |
|-------|-------|
| App name | قناة علاء حامد |
| User support email | hmdy7486@gmail.com |
| App logo | Upload app logo (optional) |
| App domain | (leave empty for now) |
| Developer contact email | hmdy7486@gmail.com |

4. Click **Save and Continue**

### Add Scopes

1. Click **Add or Remove Scopes**
2. Add these scopes:
   - `email`
   - `profile`
   - `openid`
3. Click **Save and Continue**

### Add Test Users (Development Mode)

While in testing mode, add test users:
1. Click **Add Users**
2. Add: `hmdy7486@gmail.com`
3. Add any other test emails
4. Click **Save and Continue**

---

### Create OAuth Client IDs

Go to **APIs & Services > Credentials > Create Credentials > OAuth client ID**

#### Android Client

| Field | Value |
|-------|-------|
| Application type | Android |
| Name | Android Client - Alaa Hamed |
| Package name | `com.ashwah.eng_alaa_hammed` |
| SHA-1 certificate fingerprint | (see below) |

**Get SHA-1 Fingerprint:**

For **Debug** keystore (development):
```bash
# Windows
keytool -list -v -keystore "%USERPROFILE%\.android\debug.keystore" -alias androiddebugkey -storepass android -keypass android

# macOS/Linux
keytool -list -v -keystore ~/.android/debug.keystore -alias androiddebugkey -storepass android -keypass android
```

For **Release** keystore (production):
```bash
keytool -list -v -keystore <path-to-your-release-keystore> -alias <your-key-alias>
```

Copy the **SHA1** line (format: `12:34:56:78:90:AB:CD:EF:12:34:56:78:90:AB:CD:EF:AA:BB:CC:DD`)

#### iOS Client

| Field | Value |
|-------|-------|
| Application type | iOS |
| Name | iOS Client - Alaa Hamed |
| Bundle ID | `com.ashwah.engAlaaHammed` |

After creation, download the `.plist` file and place it in:
```
ios/Runner/GoogleService-Info.plist
```

#### Web Client (for development/testing)

| Field | Value |
|-------|-------|
| Application type | Web application |
| Name | Web Client - Alaa Hamed |
| Authorized JavaScript origins | `http://localhost` |
| Authorized redirect URIs | `http://localhost:8080/callback` |

---

## 3. YouTube Data API v3

### Enable the API

1. Go to **APIs & Services > Library**
2. Search for "YouTube Data API v3"
3. Click **Enable**

### Create API Key

1. Go to **APIs & Services > Credentials**
2. Click **Create Credentials > API Key**
3. Copy the API key
4. Click **Restrict Key** for security:

**API Restrictions:**
- Select **Restrict key**
- Choose **YouTube Data API v3**

**Application Restrictions (Android):**
- Select **Android apps**
- Add item:
  - Package name: `com.ashwah.eng_alaa_hammed`
  - SHA-1: (your debug/release SHA-1)

### Get Channel ID

1. Go to the YouTube channel: https://www.youtube.com/@EngAlaaHammed
2. View page source or use this method:
   - Go to any video from the channel
   - Click on the channel name
   - The URL will show: `youtube.com/channel/UC...`
   - Copy the `UC...` part - that's the Channel ID

Or use the API:
```
https://www.googleapis.com/youtube/v3/search?part=snippet&q=Eng+Alaa+Hammed&type=channel&key=YOUR_API_KEY
```

---

## 4. Firebase Setup (Optional)

If you want to add Firebase services (Analytics, Crashlytics, Push Notifications):

### Step 1: Create Firebase Project

1. Go to [Firebase Console](https://console.firebase.google.com/)
2. Click **Add Project**
3. Select your Google Cloud project "AlaaHamedApp"
4. Enable/Disable Google Analytics as needed
5. Click **Create Project**

### Step 2: Add Android App

1. Click **Add App > Android**
2. Fill in:
   - Package name: `com.ashwah.eng_alaa_hammed`
   - App nickname: Eng Alaa Hammed
   - Debug signing certificate SHA-1: (your SHA-1)
3. Download `google-services.json`
4. Place it in: `android/app/google-services.json`

### Step 3: Add iOS App

1. Click **Add App > iOS**
2. Fill in:
   - Bundle ID: `com.ashwah.engAlaaHammed`
   - App nickname: Eng Alaa Hammed
3. Download `GoogleService-Info.plist`
4. Place it in: `ios/Runner/GoogleService-Info.plist`

### Step 4: Configure Android Build

Add to `android/build.gradle.kts`:
```kotlin
plugins {
    id("com.google.gms.google-services") version "4.4.0" apply false
}
```

Add to `android/app/build.gradle.kts`:
```kotlin
plugins {
    id("com.google.gms.google-services")
}
```

---

## 5. Environment Variables

### Create .env File

Create a `.env` file in the project root:

```env
# YouTube API Configuration
YOUTUBE_API_KEY=your_youtube_api_key_here
YOUTUBE_CHANNEL_ID=UCxxxxxxxxxxxxxxxxxxxxxxx

# OAuth Client IDs (optional - can be configured in native code)
GOOGLE_WEB_CLIENT_ID=your_web_client_id.apps.googleusercontent.com

# Firebase (if using)
# FIREBASE_PROJECT_ID=alaahamed-app
```

### Security Notes

- **Never commit `.env` to version control**
- The `.env` file is already in `.gitignore`
- For production, use secure environment variable management
- Consider using `--dart-define` for build-time variables

---

## 6. Troubleshooting

### Common Issues

#### "Error: redirect_uri_mismatch"
- Check that your OAuth client has the correct package name
- Verify SHA-1 fingerprint matches your keystore

#### "Error: This app is not verified"
- In development, add test users to OAuth consent screen
- For production, submit app for verification

#### "Error: API key not valid"
- Check API key restrictions
- Ensure YouTube Data API v3 is enabled
- Verify package name and SHA-1 in API restrictions

#### "Error: Sign in failed"
- Check internet connection
- Verify Google Play Services is installed (Android)
- Check that package name matches exactly

### Debug Commands

```bash
# Check current SHA-1 fingerprints
cd android && ./gradlew signingReport

# Verify package name
grep -r "applicationId" android/app/build.gradle.kts

# Check Google Sign-In configuration
flutter pub deps | grep google_sign_in
```

### Useful Links

- [Google Cloud Console](https://console.cloud.google.com/)
- [Firebase Console](https://console.firebase.google.com/)
- [YouTube Data API Documentation](https://developers.google.com/youtube/v3)
- [Google Sign-In for Flutter](https://pub.dev/packages/google_sign_in)
- [OAuth 2.0 for Mobile Apps](https://developers.google.com/identity/protocols/oauth2/native-app)

---

## Quick Reference

| Service | Console URL | Status |
|---------|-------------|--------|
| Google Cloud | console.cloud.google.com | Required |
| OAuth Consent | console.cloud.google.com/apis/credentials/consent | Required |
| YouTube API | console.cloud.google.com/apis/library/youtube.googleapis.com | Required |
| Firebase | console.firebase.google.com | Optional |

| Credential | Where to Use |
|------------|--------------|
| YouTube API Key | `.env` file |
| Android OAuth Client ID | Automatic via package name |
| iOS OAuth Client ID | `GoogleService-Info.plist` |
| Web OAuth Client ID | For testing only |

---

## App Configuration Summary

| Platform | Package/Bundle ID |
|----------|------------------|
| Android | `com.ashwah.eng_alaa_hammed` |
| iOS | `com.ashwah.engAlaaHammed` |

| File | Location | Purpose |
|------|----------|---------|
| `.env` | Project root | API keys |
| `google-services.json` | `android/app/` | Firebase Android |
| `GoogleService-Info.plist` | `ios/Runner/` | Firebase/OAuth iOS |

---

## Contact

For questions about this setup:
- Email: hmdy7486@gmail.com
- Phone: +201019793768
