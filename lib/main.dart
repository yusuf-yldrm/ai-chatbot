// ignore_for_file: unnecessary_nullable_for_final_variable_declarations, null_closures

import 'dart:io' show Platform;
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:provider/provider.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:use/firebase_options.dart';
import 'package:use/helpers/data_store.dart';
import 'package:use/helpers/message_store.dart';
import 'package:use/helpers/remote_config_service.dart';
import 'package:use/helpers/store_config.dart';
import 'package:use/models/version.dart';
import 'routes/app_pages.dart';
import 'routes/app_routes.dart';
import 'themes/app_theme.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';

void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();

  // UI
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarBrightness: Brightness.dark,
    statusBarColor: Colors.black,
    statusBarIconBrightness: Brightness.dark,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarDividerColor: Colors.transparent,
  ));

  // Splash
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  // Data Store
  final DataStore dataStore = DataStore();
  await dataStore.loadValues();
  await dataStore.increaseSessionCount();
  dataStore.isFirstSession = dataStore.sessionCount == 1;

  try {
    // Firebase
    await Firebase.initializeApp(
        options: DefaultFirebaseOptions.currentPlatform);
    await RemoteConfigService().initialize();
    FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;

    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final String platform = Platform.isAndroid ? "Android" : "iOS";
    print(packageInfo.version);
    final Version? currentVersion = RemoteConfigService().versions.firstWhere(
        (version) =>
            version.number == packageInfo.version &&
            version.platform == platform,
        orElse: null);
    if (currentVersion != null) {
      dataStore.inReview = currentVersion.underReview;
    } else {
      dataStore.inReview = false;
    }

    dataStore.messages = await MessageDatabase.instance.readAllMessages();

    PurchasesConfiguration configuration;
    if (Platform.isAndroid) {
      configuration =
          PurchasesConfiguration("goog_bjZqTppaZDRKsWfZqIPBypyJbSz");
      await Purchases.configure(configuration);
    } else if (Platform.isIOS) {
      configuration =
          PurchasesConfiguration("appl_zrMeuBBoYOYbbsjKoaxLKdZiLnf");
      await Purchases.configure(configuration);
    }

    if (Platform.isIOS) {
      StoreConfig.instance.store = StoreKey.appleStore;
      StoreConfig.instance.apiKey = "appl_zrMeuBBoYOYbbsjKoaxLKdZiLnf";
    } else if (Platform.isAndroid) {
      StoreConfig.instance.store = StoreKey.googlePlay;
      StoreConfig.instance.apiKey = "goog_bjZqTppaZDRKsWfZqIPBypyJbSz";
    }

    final remoteConfigService = RemoteConfigService();

    dataStore.paywalls = remoteConfigService.paywalls;
    dataStore.reviewPaywalls = remoteConfigService.reviewPaywalls;

    CustomerInfo customerInfo = await Purchases.getCustomerInfo();
    if (customerInfo.entitlements.all["premium"] != null &&
        customerInfo.entitlements.all["premium"]?.isActive == true) {
      dataStore.hasPermission = true;
    } else {
      dataStore.hasPermission = false;
    }

    start(dataStore);
  } catch (_) {
    start(dataStore);
  }
}

void start(DataStore dataStore) {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: dataStore),
  ], child: App()));
}

class App extends StatefulWidget {
  const App({super.key});

  @override
  State<App> createState() => AppState();
}

class AppState extends State<App> {
  // Initialization

  @override
  void initState() {
    super.initState();

    FlutterNativeSplash.remove();
  }

  // View

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      initialRoute: Provider.of<DataStore>(context, listen: false).isFirstLaunch
          ? AppRoutes.Onboarding
          : AppRoutes.BottomBar,
      getPages: AppPages.list,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.dark,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.dark,
    );
  }
}
