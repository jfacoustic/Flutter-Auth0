# flutter_auth0

Unofficial Auth0 SDK for flutter.

## Getting Started

### iOS:

1. Pod install in iOS directory
2. Add the following to info.plist:

```plist
<key>CFBundleURLTypes</key>
<array>
    <dict>
        <key>CFBundleTypeRole</key>
        <string>None</string>
        <key>CFBundleURLName</key>
        <string>auth0</string>
        <key>CFBundleURLSchemes</key>
        <array>
            <string>$(PRODUCT_BUNDLE_IDENTIFIER)</string>
        </array>
    </dict>
</array>
```

### Android
TODO

### Web
Add the following to index.html:

```html
<script src="https://cdn.auth0.com/js/auth0-spa-js/1.12/auth0-spa-js.production.js"></script>
```

Note: Web only returns an access_token.

### Login:


```dart
final Auth0Credentials credentials = await FlutterAuth0.login(
    clientId: "{YOUR AUTH0 CLIENT ID}",
    domain: "{YOUR AUTH0 DOMAIN}",
    scope: "{SCOPES}"
);
```

Launches popup window on web.  TODO: Add redirect functionality in web

### Logout:
TODO