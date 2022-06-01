# Flutter Fire Flow Framework (`4F`)

## Menu:
* [Overview](#overview)
* [Getting Started (*Flutter App*)](#flutter-getting-started)
* [Getting Started (*Node API*)](#api-getting-started)
* [Publishing App (*iOS*)](#app-publish)
* [Connecting to localhost APIs from real device](#conn-local-device)

## <a href="overview"/></a>Overview:
* `4F` provides an architecture/framework to rapidly developer Flutter mobile apps, using Firebase as a backend (*though the API layer, and `AuthUtility` allow for Firebase to be swapped easily for custom auth and another NoSQL persistence choice, such as `MongoDB`)
* `4F` provides a tab menu configuration
* `4F` consolidates styles and theme to a central location `UIUtility`
    * `4F` relies on MaterialUI for theming and UI element loook/feel 
* `4F` uses a Google Cloud Function Node API, written in Typescript
    * CORS middleware
    * Firebase bearer token middleware
    * Javascript was once preferred as the language of choice for the API layer of `4F` but Google evangelist Douglas Stevenson was [convincing enough](https://firebase.blog/posts/2018/01/why-you-should-use-typescript-for).
    * I still have a moments I regret that the API layer is Typescript and not Javascript but it is, what it is (*Javascript is valid Typescript, when in doubt*)
* `4F` provides a quick `iOS`, `Android` and `Web` setup, and includes instructions to use local Firebase APIs (*undeployed Google Cloud Functions changes*) on a native device.
* `4F` provides a mildly rich, "built-in" in Forms validation library and pattern
* `4F` provides the basics for the `Web` version of your app (*Work in Progress*)

## <a href="flutter-getting-started"></a>Getting Started (*Flutter App*):
(*iOS / Macbook Pro Development Focused*)
* [Install Flutter](https://docs.flutter.dev/get-started/install)
* open `app` folder in VSCode (*VSCode should install Dart language for you*)
    * install the VSCode `Dart` extension
    * install the VSCode `Flutter` extension
* start an iOS simulator
* `flutter run -t lib/main_dev.dart` or `flutter run -t lib/main_local.dart`
    * *see [Getting Started (*Node API*)](#api-getting-started) below*
    * *see also advanced [Connecting to localhost APIs from real device](#conn-local-device)*
* Reload Flutter/Dart code changes by pressing `r` in running terminal

## <a href="api-getting-started"></a>Gettings Started (*Node API*)

* `npm install -g firebase-tools`
* `firebase login`
* `npm run build:watch` (*in secondary terminal*)
    * Hot reload Typescript changes
* `npm run serve`

## <a href="app-publish"></a>App Publish (*iOS*)
* `flutter build ios -t lib/main.dart`
    * **DON'T EVER PUBLISH WITHOUT RUNNING `flutter build ios -t lib/main.dart` FIRST**
* Open `app/ios/Runner.xcworkspace` in XCode 
* In XCode tick build number of version 
* Use XCode Organizer to publish build artifacts for Test Flight or Publishing to App Store


## <a href="conn-local-device"></a> Connecting to localhost APIs from real device
- **DON'T EVER PUBLISH WITHOUT RUNNING `flutter build ios -t lib/main.dart` AFTER THIS SETUP BELOW**
    - You will hate your life and everyone will hate you too
    - Publishing the app with localhost APIs setup make the published app work correctly in your house on your network!
- `flutter run -t lib/main_local_device.dart`
- Sharing internet connection with phone
	- Make sure your phone and mac are connected to the same WiFi network
	- On your Mac, go to System Preferences → Sharing
	- Uncheck the “Internet Sharing” checkbox if it is enabled
	- In “To computers using”, select iPhone USB
	- Turn on the Internet Sharing checkbox again. It will prompt you. Click yes.
	- In this same Sharing settings page, change your Computer Name to your first name, all lower case. http://yourname.local is the site you will navigate to on your phone
- Make sure that you got CORS covered http://macog.local:5001 to origin array in API CORS middleware
- add "host": "0.0.0.0" to firebase.json->emulators.functions
- Make sure to use the shared internet connection address when spinning up the flutter app
```
var relativeFunctionsUrl = 'stormwater-c643b/us-central1/app';

  var functionsUrl =
      'http://10.0.2.2:5001/$relativeFunctionsUrl'; //android simualtor

  if (Platform.isIOS) {
    functionsUrl = 'http://macog.local:5001/$relativeFunctionsUrl'; //ios simulator
  }
```