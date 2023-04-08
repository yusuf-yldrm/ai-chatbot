import 'package:flutter/foundation.dart';

enum StoreKey { appleStore, googlePlay }

class StoreConfig {
  
  // Properties
  late StoreKey store;
  late String apiKey;

  // Initializer
  static final StoreConfig instance = StoreConfig._internal();

  factory StoreConfig() => instance;

  StoreConfig._internal();

  // Methods
  static bool isForAppleStore() => instance.store == StoreKey.appleStore;

  static bool isForGooglePlay() => instance.store == StoreKey.googlePlay;
}
  