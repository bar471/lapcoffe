import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:provider/provider.dart';
import 'package:lapcoffee/view/landing_page_view.dart';
import 'package:lapcoffee/view/login_page_view.dart';
import 'package:lapcoffee/view/register_page.dart';
import 'package:lapcoffee/view/menu_page.dart';
import 'package:lapcoffee/http/http_view.dart';
import 'package:lapcoffee/article/article_detail.dart';
import 'package:lapcoffee/controllers/auth_controller.dart';
import 'package:lapcoffee/controllers/weather_controller.dart';
import 'package:lapcoffee/controllers/http_controller.dart';
import 'package:lapcoffee/firebase_options.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';


Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  // Inisialisasi Firebase jika belum terinisialisasi di background
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  // Initialize Firebase and ensure Widgets are properly initialized
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

   // Background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

  // Register AuthController and HttpController with GetX
  Get.put(AuthController());
  Get.put(HttpController());

  // Run the app with providers
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => WeatherService(),
        ), // WeatherController to handle API data
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
 // Request Notification Permission (for iOS)
    FirebaseMessaging.instance.requestPermission();

    // FCM Token (useful if you need to send notifications to a specific device)
    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM Token: $token");
    });

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a foreground message: ${message.notification?.title}");
      if (message.notification != null) {
        // You can customize your UI for the notification here
        Get.snackbar(
          message.notification!.title ?? 'New Notification',
          message.notification!.body ?? '',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.greenAccent,
          colorText: Colors.white,
        );
      }
    });

    // Handling messages when the app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification caused app to open: ${message.notification?.title}");
      // Navigate to a specific page or handle as needed
    });

    return GetMaterialApp(
      title: 'Coffee App',
      theme: ThemeData(
        primarySwatch: Colors.green, // Main theme of the app
      ),
      initialRoute: Routes.LANDING, // Start with the Landing Page
      getPages: [
        GetPage(name: Routes.LANDING, page: () => const LandingPage()),
        GetPage(name: Routes.LOGIN, page: () => LoginPage()),
        GetPage(name: Routes.REGISTER, page: () => const RegisterPage()),
        GetPage(name: Routes.MENU, page: () => const MenuPage()),
        GetPage(name: Routes.HTTP_VIEW, page: () => const HttpView()),
        GetPage(
          name: Routes.ARTICLE_DETAILS,
          page: () => ArticleDetailPage(article: Get.arguments),
        ),
      ],
    );
  }
}

// Define your routes here
abstract class Routes {
  static const LANDING = '/landing';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const MENU = '/menu';
  static const HTTP_VIEW = '/http-view';
  static const ARTICLE_DETAILS = '/article-details';
}
