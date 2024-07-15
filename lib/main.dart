// import 'package:danrom/api/firebase_api.dart';
import 'package:danrom/app_localization.dart';
import 'package:danrom/config/config.dart';
import 'package:danrom/config/routes.dart';
import 'package:danrom/data/constants.dart';
import 'package:danrom/data/local/local_data_access.dart';
import 'package:danrom/di/di.dart';
// import 'package:danrom/firebase_options.dart';
import 'package:danrom/language_cubit.dart';
// import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
// import 'package:google_mobile_ads/google_mobile_ads.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  // await FirebaseApi().initNotification();
  // await MobileAds.instance.initialize();
  await configureInjection();

  // RequestConfiguration requestConfiguration = RequestConfiguration(testDeviceIds: ["BE14F4D9DA41BFFFBEB21E23B3DFED6B"]);
  // MobileAds.instance.updateRequestConfiguration(requestConfiguration);

  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  LocalDataAccess localDataAccess = getIt.get();

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
}
