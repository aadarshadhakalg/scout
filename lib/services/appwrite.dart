import 'package:appwrite/appwrite.dart';

class AppwriteService {
  Client client = Client();

  static final AppwriteService _singleton = AppwriteService._internal();

  factory AppwriteService() {
    return _singleton;
  }

  AppwriteService._internal() {
    client
        .setEndpoint('https://cloud.appwrite.io/v1')
        .setProject('64885c9430d0b6f2e888')
        .setSelfSigned(status: true);
  }

  Account get account => Account(client);
  Databases get databases => Databases(client);
  Storage get storage => Storage(client);
}
