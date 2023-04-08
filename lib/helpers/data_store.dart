import 'dart:convert';
import 'dart:ffi';
import 'package:flutter/material.dart';
import 'package:purchases_flutter/object_wrappers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:use/models/message.dart';
import 'package:use/models/paywall.dart';
import 'package:use/models/paywall_session.dart';
import 'package:uuid/uuid.dart';

class DataStore with ChangeNotifier {

  // Properties

  String? _deviceId = null;
  bool _isFirstSession = true;
  int _sessionCount = 0;
  bool _isFirstLaunch = true;
  bool _inReview = false;
  bool _hasPermission = false;
  bool _approvedAgePermission = false;
  int _remainingRatingPopCount = 2;
  int _paywallSessionCount = 0;
  List<Message> _messages = [];
  late Offerings? _offerings;
  late List<Paywall> _paywalls = [];
  late List<Paywall> _reviewPaywalls = [];
  late List<PaywallSession> _sessions = [];
  late DateTime? generationDate = null;

  // Getters

  String? get deviceId => _deviceId;
  bool get isFirstSession => _isFirstSession;
  int get sessionCount => _sessionCount;
  bool get isFirstLaunch => _isFirstLaunch;
  bool get inReview => _inReview;
  bool get hasPermission => _hasPermission;
  bool get approvedAgePermission => _approvedAgePermission;
  int get remainingRatingPopCount => _remainingRatingPopCount;
  int get paywallSessionCount => _paywallSessionCount;
  Offerings? get offerings => _offerings;
  List<Message> get messages => _messages;
  List<Paywall> get paywalls => _paywalls;
  List<Paywall> get reviewPaywalls => _reviewPaywalls;
  List<PaywallSession> get sessions => _sessions;
  Paywall get checkoutPaywall {
    if (inReview) {
      return hasPermission ? reviewPaywalls[2] : reviewPaywalls[1];
    } else {
      return hasPermission ? paywalls[2] : paywalls[1];
    }
  }
  List<Paywall> get checkoutPaywalls {
    if (inReview) {
      return [reviewPaywalls[1], reviewPaywalls[2]];
    } else {
      return [paywalls[1], paywalls[2]];
    }
  }

  Paywall get standardPaywall {
    if (inReview) {
      return _reviewPaywalls[0];
    } else {
      try {
        final PaywallSession session = _sessions.firstWhere((session) => session.count == sessionCount);
        try {
          final Paywall paywall = _paywalls.firstWhere((paywall) => paywall.id == session.paywallId);
          return paywall;
        } catch (_) {
          try {
            final Paywall defaultPaywall = _paywalls.firstWhere((paywall) => paywall.isDefault == true);
            return defaultPaywall;
          } catch (_) {
            return _paywalls[0];
          }
        }
      } catch (_) {
        try {
          final Paywall defaultPaywall = _paywalls.firstWhere((paywall) => paywall.isDefault == true);
          return defaultPaywall;
        } catch (_) {
          return _paywalls[0];
        }
      }
    }
  }

  // Setters

  Future<void> finishOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("is_first_launch", false);
    _isFirstSession = false;

    notifyListeners();
  }

  set isFirstLaunch(bool value) {
    _isFirstLaunch = value;

    notifyListeners();
  }

  set isFirstSession(bool value) {
    _isFirstSession = value;

    notifyListeners();
  }

  set inReview(bool value) {
    _inReview = value;
    notifyListeners();
  }

  set hasPermission(bool value) {
    _hasPermission = value;
    notifyListeners();
  }

  Future<void> setApproveAgePermission(bool value) async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setBool("approved_age_permission", value);
    _approvedAgePermission = value;
    notifyListeners();
  }

  set offerings(Offerings? value) {
    _offerings = value;
    notifyListeners();
  }

  set messages(List<Message> messages) {
    _messages = messages;
    notifyListeners();
  }

  set paywalls(List<Paywall> value) {
    _paywalls = value;
    notifyListeners();
  }

  set reviewPaywalls(List<Paywall> value) {
    _reviewPaywalls = value;
    notifyListeners();
  }

  set sessions(List<PaywallSession> value) {
    _sessions = value;
    notifyListeners();
  }

  Future<void> increaseSessionCount() async {
    if (_sessionCount < 1 && isFirstLaunch == false) {
      return;
    }

    final prefs = await SharedPreferences.getInstance();
    if (_sessionCount == null) {
      prefs.setInt("session_count", 1);
      _sessionCount = 1;
    } else {
      prefs.setInt("session_count", _sessionCount + 1);
      _sessionCount++;
    }

    notifyListeners();
  }

  // Load values from SharedPreferences
  Future<void> loadValues() async {
    final prefs = await SharedPreferences.getInstance();

    _sessionCount = prefs.getInt('session_count') ?? 0;
    _isFirstLaunch = prefs.getBool('is_first_launch') ?? true;
    _inReview = prefs.getBool('in_review') ?? false;
    _hasPermission = prefs.getBool('has_permission') ?? false;
    _remainingRatingPopCount = prefs.getInt('remaining_rating_pop_count') ?? 0;
    _paywallSessionCount = prefs.getInt('paywall_session_count') ?? 0;

    notifyListeners();
  }
}
