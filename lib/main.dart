import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lapcoffee/view/no_connection_view.dart';
import 'package:lapcoffee/view/takeaway_view.dart';
import 'package:provider/provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'dependency_injection.dart';
// Import controllers
import 'package:lapcoffee/controllers/auth_controller.dart';
import 'package:lapcoffee/controllers/http_controller.dart';
import 'package:lapcoffee/controllers/qr_controller.dart';
import 'package:lapcoffee/controllers/review_controller.dart';
import 'package:lapcoffee/controllers/weather_controller.dart';
import 'package:lapcoffee/controllers/audio_controller.dart';
// Import AudioController

// Import views
import 'package:lapcoffee/view/landing_page_view.dart';
import 'package:lapcoffee/view/login_page_view.dart';
import 'package:lapcoffee/view/register_page.dart';
import 'package:lapcoffee/view/menu_page.dart';
import 'package:lapcoffee/view/qr_page.dart';
import 'package:lapcoffee/view/review_page.dart';
import 'package:lapcoffee/view/music_list_view.dart'; // Import MusicListView
import 'package:lapcoffee/http/http_view.dart';
import 'package:lapcoffee/article/article_detail.dart';

// Import Firebase configuration
import 'package:lapcoffee/firebase_options.dart';

Future<void> _firebaseMessagingBackgroundHandler(RemoteMessage message) async {
  await Firebase.initializeApp();
  print("Handling a background message: ${message.messageId}");
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Background message handler
  FirebaseMessaging.onBackgroundMessage(_firebaseMessagingBackgroundHandler);

    // Inisialisasi Dependency Injection
  DependencyInjection.init();
  
  // Register controllers with GetX
  Get.put(AuthController());
  Get.put(HttpController());
  Get.put(QRController());
  Get.put(ReviewController());
  Get.put(AudioController());
  

  // Register AudioController with GetX

  // Run the app with providers
  runApp(
    MultiProvider(
      providers: [
        Provider(
          create: (_) => WeatherService(),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // Request notification permission (for iOS)
    FirebaseMessaging.instance.requestPermission();

    // Retrieve FCM token for device
    FirebaseMessaging.instance.getToken().then((token) {
      print("FCM Token: $token");
    });

    // Listen for foreground messages
    FirebaseMessaging.onMessage.listen((RemoteMessage message) {
      print("Received a foreground message: ${message.notification?.title}");
      if (message.notification != null) {
        Get.snackbar(
          message.notification!.title ?? 'New Notification',
          message.notification!.body ?? '',
          snackPosition: SnackPosition.TOP,
          backgroundColor: Colors.greenAccent,
          colorText: Colors.white,
        );
      }
    });

    // Handle messages when app is opened from a notification
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage message) {
      print("Notification caused app to open: ${message.notification?.title}");
      // Navigate or handle as needed
    });

    return GetMaterialApp(
      title: 'Coffee App',
      theme: ThemeData(
        primarySwatch: Colors.green,
      ),
      initialRoute: Routes.LANDING,
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
      
        GetPage(name: Routes.QRCODE, page: () => const QRGeneratorView()),
        GetPage(name: Routes.REVIEW, page: () => ReviewPage()),
        GetPage(name: Routes.MUSIC_LIST, page: () => MusicListView()),
        GetPage(name: Routes.TAKEAWAY, page: () => const TakeawayPage()),
        GetPage(name: Routes.CONNECTION, page: () => const NoConnectionView())
      ],

    );
  }
}

// Define your routes
abstract class Routes {
  static const LANDING = '/landing';
  static const LOGIN = '/login';
  static const REGISTER = '/register';
  static const MENU = '/menu';
  static const HTTP_VIEW = '/http-view';
  static const ARTICLE_DETAILS = '/article-details';
  static const QRCODE = '/qr';
  static const REVIEW = '/review';
  static const MUSIC_LIST = '/music-list';
  static const TAKEAWAY = '/takeaway';
  static const CONNECTION = '/NoConnection';
}
