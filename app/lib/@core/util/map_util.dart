import 'package:logger/logger.dart';
import 'package:url_launcher/url_launcher.dart';
import 'dart:io' show Platform;

const SOURCE_ADDRESS_MY_LOCATION = 'My+Location';
const URL_SCHEME_GOOGLE = 'comgooglemaps://';
const URL_WEB_GOOGLE = 'https://maps.google.com/maps';
const URL_SCHEME_APPLE = 'maps://';
//const GOOGLE_DIRECTIONS_MODE = 'directionsmode=driving';

/// References/examples
/// Google Web: https://stackoverflow.com/a/22330384/1258525
/// Apple Maps URL Schemes: https://itnext.io/apple-maps-url-schemes-e1d3ac7340af
/// Apple Maps: https://developer.apple.com/library/archive/featuredarticles/iPhoneURLScheme_Reference/MapLinks/MapLinks.html
/// Info.plist for Google: https://stackoverflow.com/a/47056795/1258525 
/// comgooglemaps-x-callback was only used for iOS <= 8, a back link is provided by iOS >= 9
/// https://www.youtube.com/watch?v=7sG9kohQ_L4
/// https://stackoverflow.com/questions/52591556/custom-markers-with-flutter-google-maps-plugin

class MapUtil {
  static Logger _lg = Logger();

  static Future<void> openMapAddress(
      String address, String state, String zip) async {
    var concatAddress = '$address,$state,$zip';
    var urlApple = '$URL_SCHEME_APPLE?saddr=&daddr=$concatAddress';
    String urlGoogle = '$URL_SCHEME_GOOGLE?saddr=&daddr=$concatAddress';
    String urlGoogleWeb =
        '$URL_WEB_GOOGLE?saddr=$SOURCE_ADDRESS_MY_LOCATION&daddr=$concatAddress';
    if (Platform.isIOS) {
      _launchUrl(urlApple, urlGoogleWeb);
    } else {
      _launchUrl(urlGoogle, urlGoogleWeb);
    }
  }

  static Future<void> openMapLL(double latitude, double longitude) async {
    String urlGoogle = '$URL_SCHEME_GOOGLE?saddr=&daddr=$latitude,$longitude';
    String urlGoogleWeb =
        '$URL_WEB_GOOGLE?saddr=$SOURCE_ADDRESS_MY_LOCATION&daddr=$latitude,$longitude';
    String urlApple = '$URL_SCHEME_APPLE?ll=$latitude,$longitude';
   //String urlApple = '$URL_SCHEME_APPLE?saddr=&daddr=$latitude,$longitude';
    if (Platform.isIOS) {
      _launchUrl(urlApple, urlGoogleWeb);
    } else {
      _launchUrl(urlGoogle, urlGoogleWeb);
    }
  }

  static Future<void> _launchUrl(String url, String? urlFallback) async {
    var encoded = Uri.encodeFull(url);
    if (await canLaunch(encoded)) {
      await launch(encoded);
    } else {
      //go to google web instead
      _lg.d('cannot launch $encoded');
      if (urlFallback == null) {
        _lg.d('no fallback url provided');
        return;
      }
      var encodedFallback = Uri.encodeFull(urlFallback);
      _lg.d('using fallback: $encodedFallback');
      await launch(encodedFallback);
    }
  }
}
