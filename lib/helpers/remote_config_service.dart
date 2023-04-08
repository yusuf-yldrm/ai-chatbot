import 'dart:ffi';
import 'package:firebase_remote_config/firebase_remote_config.dart';
import 'package:flutter/material.dart';
import 'package:use/models/gptmodel.dart';
import 'package:use/models/paywall.dart';
import 'dart:convert';

import 'package:use/models/paywall_session.dart';
import 'package:use/models/version.dart';

class RemoteConfigService {

  // MARK: Properties
  
  RemoteConfigService() : remoteConfig = FirebaseRemoteConfig.instance;

  final FirebaseRemoteConfig remoteConfig;

  // Premium
  List<Paywall> get paywalls {
    final String jsonString = remoteConfig.getString(RemoteConfigKeys.paywalls);
    List<Paywall> paywalls = [];
    var data = jsonDecode(jsonString);
    for (final item in data) {
      paywalls.add(Paywall.fromJson(item));
    }
    return paywalls;
  }

  List<Paywall> get reviewPaywalls {
    final String jsonString = remoteConfig.getString(RemoteConfigKeys.reviewPaywalls);
    List<Paywall> paywalls = [];
    var data = jsonDecode(jsonString);
    for (final item in data) {
      paywalls.add(Paywall.fromJson(item));
    }
    return paywalls;
  }

  List<GPTModel> get models {
    final String jsonString = remoteConfig.getString(RemoteConfigKeys.models);
    List<GPTModel> models = [];
    var data = jsonDecode(jsonString);
    for (var item in data) {
      models.add(GPTModel.fromJson(item));
    }
    return models;
  }

  // Rating
  List<int> get messageCountsForRating {
    final String jsonString = remoteConfig.getString(RemoteConfigKeys.messageCountsForRating);
    List<int> counts = [];
    var data = jsonDecode(jsonString);
    for (var item in data) {
      counts.add(item);
    }
    return counts;
  }

  // Review
  List<Version> get versions {
    final String jsonString = remoteConfig.getString(RemoteConfigKeys.versions);
    List<Version> versions = [];
    var data = jsonDecode(jsonString);
    for (var item in data) {
      versions.add(Version.fromJson(item));
    }
    return versions;
  }

  bool get isFree => remoteConfig.getBool(RemoteConfigKeys.isFree);
  int get messageLimit => remoteConfig.getInt(RemoteConfigKeys.messageLimit);

  // MARK: Methods
  Future<void> setConfigSettings() async {
    await remoteConfig.setConfigSettings(
      RemoteConfigSettings(
        fetchTimeout: Duration(seconds: 30),
        minimumFetchInterval: Duration(minutes: 0),
      ),
    );
  }

  Future<void> setDefaults() async {
    await remoteConfig.setDefaults({
      RemoteConfigKeys.isFree: false,
      RemoteConfigKeys.showPaywallInEveryLaunch: true,
      RemoteConfigKeys.showPaywallAtOnboarding: true,
      RemoteConfigKeys.paywalls: """
      [
        {
          "id": "standard_01",
          "title": "Unlock All Features",
          "description": "🤑 50% off on Magic Avatars\n🤠 Exclusive Avatar packs",
          "action_text": "Continue",
          "is_default": true,
          "products": [
            {
              "product_id": "ai_manga.weekly_premium_membership",
              "subscription_period": "week",
              "offer_text": null,
              "left_text": "\$4.99 / Weekly",
              "left_text_color": "#ffffff",
              "right_text": null,
              "right_text_color": null
            },
            {
              "product_id": "ai_manga.yearly_premium_membership",
              "subscription_period": "year",
              "offer_text": null,
              "left_text": "\$29.99 / Year",
              "left_text_color": "#ffffff",
              "right_text": null,
              "right_text_color": null
            },
            {	
              "product_id": "ai_manga.lifetime_premium_membership",
              "subscription_period": null,
              "offer_text": null,
              "left_text": "\$99.99 / One-Time",
              "left_text_color": "#ffffff",
              "right_text": "Lifetime Access",
              "right_text_color": "#868686"
            }
          ]
        },
        {
          "id": "checkout_01",
          "title": "What is it paid?",
          "description": "Magic Avatars consume tremendous computation power to create amazing avatars for you. It’s expensive, but we made it as affordable as possible.❤️",
          "action_text": "Continue",
          "is_default": false,
          "products": [
            {
              "product_id": "ai_manga.50_avatars",
              "subscription_period": null,
              "offer_text": null,
              "left_text": "50 unique avatars",
              "left_text_color": "#ffffff",
              "left_description": "5 variations of 10 styles",
              "left_description_color": "#787878",
              "right_text": "\$3.99",
              "right_text_color": "#ffffff",
              "right_description": null,
              "right_description_color": null
            },
            {
              "product_id": "ai_manga.100_avatars",
              "subscription_period": null,
              "offer_text": "MOST POPULAR",
              "left_text": "100 unique avatars",
              "left_text_color": "#ffffff",
              "left_description": "10 variations of 10 styles",
              "left_description_color": "#787878",
              "right_text": "\$5.99",
              "right_text_color": "#ffffff",
              "right_description": null,
              "right_description_color": null
            },
            {
              "product_id": "ai_manga.200_avatars",
              "subscription_period": null,
              "offer_text": null,
              "left_text": "200 unique avatars",
              "left_text_color": "#ffffff",
              "left_description": "20 variations of 10 styles",
              "left_description_color": "#787878",
              "right_text": "\$7.99",
              "right_text_color": "#ffffff",
              "right_description": null,
              "right_description_color": null
            }
          ]
        },
        {
          "id": "checkout_offer_01",
          "title": "What is it paid?",
          "description": "Magic Avatars consume tremendous computation power to create amazing avatars for you. It’s expensive, but we made it as affordable as possible.❤️",
          "action_text": "Continue",
          "is_default": false,
          "products": [
            {
              "product_id": "ai_manga.50_avatars_with_50_percent_off",
              "subscription_period": null,
              "offer_text": null,
              "left_text": "50 unique avatars",
              "left_text_color": "#ffffff",
              "left_description": "5 variations of 10 styles",
              "left_description_color": "#787878",
              "right_text": "\$1.99",
              "right_text_color": "#ffffff",
              "right_description": null,
              "right_description_color": null
            },
            {
              "product_id": "ai_manga.100_avatars_with_50_percent_off",
              "subscription_period": null,
              "offer_text": "MOST POPULAR",
              "left_text": "100 unique avatars",
              "left_text_color": "#ffffff",
              "left_description": "10 variations of 10 styles",
              "left_description_color": "#787878",
              "right_text": "\$2.99",
              "right_text_color": "#ffffff",
              "right_description": null,
              "right_description_color": null
            },
            {
              "product_id": "ai_manga.200_avatars_with_50_percent_off",
              "subscription_period": null,
              "offer_text": null,
              "left_text": "200 unique avatars",
              "left_text_color": "#ffffff",
              "left_description": "20 variations of 10 styles",
              "left_description_color": "#787878",
              "right_text": "\$3.99",
              "right_text_color": "#ffffff",
              "right_description": null,
              "right_description_color": null
            }
          ]
        }
      ]
      """,
      RemoteConfigKeys.versions: """
      [
        {
          "number": "1.0",
          "platform": "iOS",
          "under_review": true
        },
        {
          "number": "1.0",
          "platform": "Android",
          "under_review": true
        }
      ]
      """
    });
  }

  Future<void> fetchAndActivate() async {
    await remoteConfig.ensureInitialized();
    await remoteConfig.fetch();
    await remoteConfig.activate();
  }

  Future<void> initialize() async {
    try {
      await setConfigSettings();
      await setDefaults();
      await fetchAndActivate();
    } catch (e) {
      print("error: $e");
    }
  }
}

class RemoteConfigKeys {

  // Premium
  static const String paywalls = "paywalls";
  static const String reviewPaywalls = "review_paywalls";
  static const String models = "models";
  static const String showPaywallAtOnboarding = "show_paywall_at_onboarding";
  static const String showPaywallInEveryLaunch = "show_paywall_in_every_launch";
  static const String messageLimit = "message_limit";
  static const String isFree = "is_free";

  // Rating
  static const String messageCountsForRating = "messageCountsForRating";

  // Review
  static const String versions = "versions";
}