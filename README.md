# Flutter Fire Flow Framework (`4F`)

## Menu:
* [Overview](#overview)
* [Getting Started (*Flutter App*)](#flutter-getting-started)
* [Getting Started (*Node API*)](#api-getting-started)

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

## <a href="api-getting-started"></a>Gettings Started (*Node API*)

* `npm install -g firebase-tools`
* `firebase login`
* `npm run build:watch` (*in secondary terminal*)
    * Hot reload Typescript changes
* `npm run serve`