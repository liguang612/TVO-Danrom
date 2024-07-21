import 'package:danrom/api/firebase_api.dart';
import 'package:danrom/app_ad.dart';
import 'package:danrom/app_localization.dart';
import 'package:danrom/config/config.dart';
import 'package:danrom/config/routes.dart';
import 'package:danrom/data/constants.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
import 'package:danrom/firebase_options.dart';
import 'package:danrom/language_cubit.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await FirebaseApi().initNotification();
  await MobileAds.instance.initialize();
  await configureInjection();

  RequestConfiguration requestConfiguration = RequestConfiguration(testDeviceIds: ["BE14F4D9DA41BFFFBEB21E23B3DFED6B", "a4fbf4ea5a502146a2bb381f0a1d1941"]);
  MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  final AppAd appAd = getIt.get();
  LocalDataAccess localDataAccess = getIt.get();

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    appAd.loadAppOpenAd();

    if (localDataAccess.getCardRepo().isEmpty) localDataAccess.addCardSkin(cardSkins.keys.first);
    if (localDataAccess.getCoinRepo().isEmpty) localDataAccess.addCoinSkin(coinSkins.first);
    if (localDataAccess.getWheelRepo().isEmpty) localDataAccess.addWheelSkin(wheelSkins.keys.first);
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    super.didChangeAppLifecycleState(state);

    final AppAd appAd = getIt.get();
    if (appAd.justHidden) {
      appAd.loadAppOpenAd();
      appAd.justHidden = false;
    }
    if (state == AppLifecycleState.hidden) appAd.justHidden = true;
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) => LanguageCubit(context),
        child: BlocBuilder<LanguageCubit, Locale?>(builder: (context, state) {
          return MaterialApp(
              debugShowCheckedModeBanner: false,
              initialRoute: AppRoute.splash,
              localizationsDelegates: const [
                AppLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate
              ],
              locale: state,
              localeResolutionCallback: (locale, supportedLocales) {
                if (state != null) {
                  return state;
                }
                String? str = localDataAccess.getLanguage();
                if (str != null && str != LanguageDisplay.system) return Locale(str);

                for (var supportedLocale in supportedLocales) {
                  if (supportedLocale.languageCode == locale?.languageCode) {
                    return supportedLocale;
                  }
                }
                return supportedLocales.first;
              },
              supportedLocales: const [Locale('en'), Locale('ar'), Locale('id'), Locale('vi'), Locale('zh')],
              onGenerateRoute: (settings) => AppRoute.onGenerateRoute(settings),
              onGenerateInitialRoutes: (value) {
                return [AppRoute.onGenerateRoute(RouteSettings(name: value))!];
              },
              routes: AppRoute.generateRoute(),
              title: AppConfig.appName,
              theme: ThemeData(colorScheme: ColorScheme.fromSeed(seedColor: Colors.white), useMaterial3: true));
        }));
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);

    super.dispose();
  }
}
