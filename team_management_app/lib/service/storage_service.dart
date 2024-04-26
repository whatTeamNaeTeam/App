import 'package:flutter_secure_storage/flutter_secure_storage.dart';

class StorageService {
  static const FlutterSecureStorage _storage = FlutterSecureStorage();

  static Future<String?> readClientID() async {
    try {
      // FlutterSecureStorage에서 clientID를 읽어옵니다.
      String? clientID = await _storage.read(key: 'clientID');
      return clientID;
    } catch (e) {
      print('Error reading client ID: $e');
      return null;
    }
  }
}
