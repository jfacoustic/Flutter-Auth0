# flutter_auth0

Unofficial Auth0 SDK for flutter.

## Getting Started

add flutter_auth0 to pubspec.

### iOS:

0. Pod install in iOS directory
1. Create Auth0.plist in Runner
2. Fill in Auth0.plist with the following:

```plist
<!-- Auth0.plist -->

<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
  <key>ClientId</key>
  <string>{Your Client Id}</string>
  <key>Domain</key>
  <string>{Your Auth0 Domain}</string>
</dict>
</plist>
```

3.  Add Auth0 Callback
