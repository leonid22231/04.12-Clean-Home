import 'dart:io';

import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:cleanhome/admin/manager_page.dart';
import 'package:cleanhome/admin_page.dart';
import 'package:cleanhome/api/RestClient.dart';
import 'package:cleanhome/block/login_bloc.dart';
import 'package:cleanhome/cleaner/cleaner_page.dart';
import 'package:cleanhome/entities/enums/Role.dart';
import 'package:cleanhome/firebase_options.dart';
import 'package:cleanhome/generated/l10n.dart';
import 'package:cleanhome/login/login.dart';
import 'package:cleanhome/theme.dart';
import 'package:cleanhome/utils/GlobalWidgets.dart';
import 'package:dio/dio.dart';
import 'package:firebase_app_check/firebase_app_check.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:cleanhome/main/main_page.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  await FirebaseAppCheck.instance.activate(
      webProvider: ReCaptchaV3Provider("recaptcha-v3-site-key"),
      androidProvider:
          kDebugMode ? AndroidProvider.debug : AndroidProvider.playIntegrity,
      appleProvider: kDebugMode
          ? AppleProvider.debug
          : AppleProvider.appAttestWithDeviceCheckFallback);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterFatalError;
  await FirebaseMessaging.instance.setAutoInitEnabled(true);
  int i = 0;
  FirebaseMessaging.onMessage.listen((event) {
    if (event.notification != null) {
      AwesomeNotifications().createNotification(
          content: NotificationContent(
        id: i,
        channelKey: 'basic_channel',
        actionType: ActionType.Default,
        title: event.notification!.title,
        body: event.notification!.body,
      ));
      i++;
    }
  });
  FirebaseMessaging.instance.onTokenRefresh.listen((event) async {
    print("Notify update $event");
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    IdTokenResult? token =
        await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    client.notifyUpdate("Bearer ${token!.token!}", event);
  });
  AwesomeNotifications().initialize(
      null,
      [
        NotificationChannel(
            channelGroupKey: 'basic_channel_group',
            channelKey: 'basic_channel',
            channelName: 'Basic notifications',
            channelDescription: 'Notification channel for basic tests',
            defaultColor: Color(0xFF9D50DD),
            ledColor: Colors.white)
      ],
      channelGroups: [
        NotificationChannelGroup(
            channelGroupKey: 'basic_channel_group',
            channelGroupName: 'Basic group')
      ],
      debug: true);
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});
  static final GlobalKey<NavigatorState> navigatorKey =
      GlobalKey<NavigatorState>();
  static const String name = 'Awesome Notifications - Example App';
  static const Color mainColor = Colors.deepPurple;

  @override
  State<StatefulWidget> createState() {
    return _MyApp();
  }
}

class _MyApp extends State<MyApp> {
  LoginBloc? loginBloc;
  @override
  void initState() {
    loginBloc = LoginBloc();
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  @override
  void dispose() {
    loginBloc!.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    AwesomeNotifications().isNotificationAllowed().then((isAllowed) {
      if (!isAllowed) {
        AwesomeNotifications().requestPermissionToSendNotifications();
      }
    });
    return BlocProvider<LoginBloc>.value(
      value: loginBloc!,
      child: BlocBuilder<LoginBloc, LoginState>(
        builder: (context, state) {
          if (state is LoginLoaded) {
            return ResponsiveSizer(builder: (context, _, __) {
              return MaterialApp(
                title: "Woosh Wash",
                localizationsDelegates: const [
                  S.delegate,
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                ],
                supportedLocales: const [Locale("ru"), Locale("en")],
                locale: Locale(Platform.localeName.split("_")[0],
                    Platform.localeName.split("_")[1]),
                navigatorKey: MyApp.navigatorKey,
                theme: CustomTheme.theme1,
                home: Main(
                  signIn: state.login,
                ),
              );
            });
          } else {
            return SizedBox();
          }
        },
      ),
    );
  }
}

class Main extends StatefulWidget {
  bool signIn;
  Main({super.key, required this.signIn});

  @override
  State<StatefulWidget> createState() {
    return _Main();
  }
}

class _Main extends State<Main> {
  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      final loginBloc = BlocProvider.of<LoginBloc>(context);
      if (FirebaseAuth.instance.currentUser != null) {
        if (!GlobalWidgets.login) {
          loginBloc.add(
            LoginChangeStatusEvent(true),
          );
          GlobalWidgets.login = true;
        }
      } else {
        if (GlobalWidgets.login) {
          loginBloc.add(LoginChangeStatusEvent(false));
          GlobalWidgets.login = false;
        }
      }
      if (widget.signIn) {
        return FutureBuilder(
            future: getRole(),
            builder: (context, snapshot) {
              if (snapshot.data != null) {
                switch (GlobalWidgets.roleFromString(snapshot.data!.first)) {
                  case Role.USER:
                    return const Mainpage();
                  case Role.MANAGER:
                    return ManagerPage();
                  case Role.CLEANER:
                    return const CleanerPage();
                  case Role.ADMIN:
                    return AdminPage();
                  default:
                    return const Mainpage();
                }
              } else {
                return SizedBox();
              }
            });
      } else {
        return const Login();
      }
    });
  }

  Future<List<String>> getRole() async {
    Dio dio = Dio();
    RestClient client = RestClient(dio);
    IdTokenResult? tokenId =
        await FirebaseAuth.instance.currentUser?.getIdTokenResult();
    String token = tokenId!.token!;
    if (kDebugMode) print("Token ${token}");

    return client.getRole("Bearer $token");
  }
}

class NotificationController {
  /// Use this method to detect when a new notification or a schedule is created
  @pragma("vm:entry-point")
  static Future<void> onNotificationCreatedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect every time that a new notification is displayed
  @pragma("vm:entry-point")
  static Future<void> onNotificationDisplayedMethod(
      ReceivedNotification receivedNotification) async {
    // Your code goes here
  }

  /// Use this method to detect if the user dismissed a notification
  @pragma("vm:entry-point")
  static Future<void> onDismissActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here
  }

  /// Use this method to detect when the user taps on a notification or action button
  @pragma("vm:entry-point")
  static Future<void> onActionReceivedMethod(
      ReceivedAction receivedAction) async {
    // Your code goes here

    // Navigate into pages, avoiding to open the notification details page over another details page already opened
    MyApp.navigatorKey.currentState?.pushNamedAndRemoveUntil(
        '/notification-page',
        (route) =>
            (route.settings.name != '/notification-page') || route.isFirst,
        arguments: receivedAction);
  }
}
