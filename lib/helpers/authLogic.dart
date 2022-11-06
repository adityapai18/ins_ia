// ignore_for_file: avoid_print, library_prefixes

import 'dart:convert';
import 'dart:math';

import 'package:encrypt/encrypt.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:crypto/crypto.dart';

class AuthLogic {
  String generatedKey = '';
  static final Random _random = Random.secure();
  final storage = const FlutterSecureStorage();
  AuthLogic(String str) {
    generatedKey = decryptAES(str);
  }
  AuthLogic.foo();

  String decryptAES(String str) {
    String iv = str.substring(0, 32);
    String hash = str.substring(32, 96);
    String cipherText = str.substring(96);
    print('iv=' + iv + " hash=" + hash + " cipher=" + cipherText);
    if (compareHMAC(iv, cipherText, hash)) {
      return extractPayload(cipherText, iv);
    }
    return '';
  }

  List<int> convertToByteArray(String text) {
    while (text.length % 8 != 0) {
      text = '0' + text;
    }
    return splitWithCount(text, 8);
  }

  List<int> splitWithCount(String string, int splitCount) {
    var array = <int>[];
    for (var i = 0; i <= (string.length - splitCount); i += splitCount) {
      var start = i;
      var temp = string.substring(start, start + splitCount);
      array.add(int.parse(convertRadix(2, 10, temp)));
    }
    return array;
  }

  bool compareHMAC(String iv, String cipherText, String hash) {
    var key = utf8.encode(r"kYp3s6v9y$B&E)H@McQeThWmZq4t7w!z");
    var bytes = convertRadix(16, 2, cipherText + iv);
    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(convertToByteArray(bytes));
    if (digest.toString() == hash) return true;
    return false;
  }

  static List<int> generateRandomBytes() {
    return List<int>.generate(16, (i) => _random.nextInt(256));
  }

  String convertRadix(int from, int to, String text) {
    return BigInt.parse(text, radix: from).toRadixString(to);
  }

  // ignore: non_constant_identifier_names
  String extractPayload(String cipherText, String iv_str) {
    var key = Key.fromBase16(
        '6B5970337336763979244226452948404D6351655468576D5A7134743777217A');
    final cipher = Encrypter(AES(key, mode: AESMode.cbc));
    var dec = cipher.decrypt16(cipherText, iv: IV.fromBase16(iv_str));
    putKeyInSecureStore(dec);
    return dec;
  }

  void putKeyInSecureStore(String key) {
    storage.write(key: 'store', value: key);
    readKey().then((value) => print(value));
  }

  Future<String> genHMAC(String iv, String cipherText) async {
    var storedKey = await readKey();
    var key = convertToByteArray(convertRadix(16, 2, storedKey));
    var bytes = convertRadix(16, 2, iv + cipherText);
    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(convertToByteArray(bytes));
    return digest.toString();
  }

  static Future<String> encryptUsingStoredKey(String plainText) async {
    var authObj = AuthLogic.foo();
    var key = await readKey();
    print(key);
    var iv = IV.fromSecureRandom(16);
    final cipher = Encrypter(AES(Key.fromBase16(key), mode: AESMode.cbc));
    var encrypted = cipher.encrypt(plainText, iv: iv);
    var hash = await authObj.genHMAC(iv.base16, encrypted.base16);
    return iv.base16 + hash + encrypted.base16;
  }

  static void putUserCredInSecureStorage(Map<String, String> data) {
    const storage = FlutterSecureStorage();
    storage.write(key: 'creadentials', value: json.encode(data));
  }

  static Future<dynamic> getUserCredInSecureStorage() async {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'creadentials');
    print(value);
    if (value != null) {
      return json.decode(value);
    }
    return {'password': '', 'email': ''};
  }

  String genHMACusingEncKey(String cipherText, String iv) {
    var key = convertToByteArray(convertRadix(16, 2,
        '6B5970337336763979244226452948404D6351655468576D5A7134743777217A'));
    var bytes = convertRadix(16, 2, cipherText + iv);
    var hmacSha256 = Hmac(sha256, key); // HMAC-SHA256
    var digest = hmacSha256.convert(convertToByteArray(bytes));
    print(digest.toString());
    return digest.toString();
  }

  static Future<String> encryptUsingEncKey(String plainText) async {
    var authObj = AuthLogic.foo();
    var iv = IV.fromSecureRandom(16);
    var key = Key.fromBase16(
        '6B5970337336763979244226452948404D6351655468576D5A7134743777217A');
    final cipher = Encrypter(AES(key, mode: AESMode.cbc));
    var encrypted = cipher.encrypt(plainText, iv: iv);
    var hash = authObj.genHMACusingEncKey(iv.base16, encrypted.base16);
    return iv.base16 + hash + encrypted.base16;
  }

  static Future<String> readKey() async {
    const storage = FlutterSecureStorage();
    String? value = await storage.read(key: 'store');
    if (value != null) return value;
    return '';
  }
}
