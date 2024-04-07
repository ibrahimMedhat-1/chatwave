// ignore_for_file: file_names

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class CacheHelper {
  static SharedPreferences? sharedPreference;

  static Future<SharedPreferences> init() async {
    return sharedPreference = await SharedPreferences.getInstance();
  }

  static dynamic getData({
    required String key,
  }) {
    return sharedPreference!.get(key);
  }

  static Future<dynamic> setData({required String key, required dynamic value}) async {
    if (value is bool) return await sharedPreference!.setBool(key, value);
    if (value is double) return await sharedPreference!.setDouble(key, value);
    if (value is int) return await sharedPreference!.setInt(key, value);
    return await sharedPreference!.setString(key, value);
  }

  static Future<bool> removeData({required String key}) async {
    return await sharedPreference!.remove(key);
  }

  static Future<void> cachingUser(Map<String, dynamic> value, String userId) async {
    List<String> map = [];
    dynamic array = value.toString().split('');
    await array.removeAt(0);
    await array.removeLast();
    array = await array.join('');
    array = await array.split(',');
    await CacheHelper.setData(key: userId, value: (handlingMapResponse(array, map).toString()));
  }

  static String handlingMapResponse(List array, List<String> map) {
    for (int i = 0; i < array.length; i++) {
      dynamic key = array[i].toString().trim().split(" ")[0].split("");
      var value = array[i].toString().trim().split(" ").last == array[i].toString().trim().split(" ")[0]
          ? ''
          : array[i].toString().trim().split(":").last.trim();
      debugPrint(array[i].toString().trim().split(":").last.trim());
      key.removeLast();
      key = key.join();
      map.add('"$key" : "$value",');
    }
    String last = (map.last.split('')..removeLast()).join();
    map
      ..removeLast()
      ..insert(map.length, last);
    debugPrint(map.join());
    return '{${map.join().toString()}}';
  }
}
