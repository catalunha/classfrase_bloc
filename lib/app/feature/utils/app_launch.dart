import 'package:url_launcher/url_launcher.dart';

class AppLaunch {
  static void launchLink(String url) async {
    final Uri uri = Uri.parse(url);
    _launchUri(uri);
  }

  static void _launchUri(Uri uri) async {
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    }
  }

  static void launchWhatsApp(
      {required String phone, required String message}) async {
    final Uri uri = Uri.parse("https://wa.me/$phone/?text=$message");
    _launchUri(uri);
  }

  static void launchGoogleMaps(num lat, num long) async {
    final Uri uri = Uri.parse(
        "https://www.google.com/maps/place/$lat+$long/@$lat,$long,15z");
    _launchUri(uri);
  }
}
