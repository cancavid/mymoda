import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:mymoda/classes/notification_service.dart';
import 'package:mymoda/classes/version_check.dart';
import 'package:mymoda/controllers/cart_controller.dart';
import 'package:mymoda/controllers/darkmode_controller.dart';
import 'package:mymoda/controllers/language_controller.dart';
import 'package:mymoda/controllers/login_controller.dart';
import 'package:mymoda/controllers/notification_controller.dart';
import 'package:mymoda/controllers/welcome_controller.dart';
import 'package:mymoda/controllers/wishlist_controller.dart';
import 'package:mymoda/pages/account/account.dart';
import 'package:mymoda/pages/shop/cart.dart';
import 'package:mymoda/pages/screens/categories.dart';
import 'package:mymoda/pages/screens//home.dart';
import 'package:mymoda/pages/shop/wishlist.dart';
import 'package:mymoda/themes/dependency_injection.dart';
import 'package:mymoda/themes/theme.dart';
import 'package:mymoda/themes/welcome.dart';
import 'package:mymoda/themes/widgets/bottom_navbar_item.dart';
import 'package:mymoda/themes/widgets/bottom_sheet.dart';
import 'package:mymoda/themes/widgets/buttons.dart';
import 'package:mymoda/themes/widgets/modal.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NotificationService.initializeNotification();

  await Firebase.initializeApp();
  FirebaseMessaging messaging = FirebaseMessaging.instance;
  await messaging.requestPermission();
  FirebaseMessaging.instance.subscribeToTopic("all");

  FirebaseMessaging.onBackgroundMessage(firebaseBackgroundMessage);

  DependencyInjection.init();

  FirebaseMessaging.onMessage.listen(firebaseBackgroundMessage);

  await GetStorage.init();
  SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
    statusBarColor: MsColors.primary, // status bar color
  ));
  runApp(MyApp());
}

Future<void> firebaseBackgroundMessage(RemoteMessage message) async {
  AwesomeNotifications().createNotification(
      content: NotificationContent(
          id: 1,
          wakeUpScreen: true,
          criticalAlert: true,
          channelKey: 'high_importance_channel', //channel configuration key
          title: message.data["title"],
          body: message.data["body"],
          summary: message.data["summary"],
          bigPicture: message.data["media"],
          payload: {'navigate': 'true', 'post_type': message.data['post_type'], 'post_id': message.data['post_id']},
          notificationLayout: NotificationLayout.BigPicture));
}

class MyApp extends StatelessWidget {
  static final navigatorKey = GlobalKey<NavigatorState>();

  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      defaultTransition: Transition.rightToLeft,
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: 'MyModa',
      theme: MsThemeMode().lightTheme,
      darkTheme: MsThemeMode().darkTheme,
      home: const MyAppHome(),
    );
  }
}

class MyAppHome extends StatefulWidget {
  const MyAppHome({super.key});

  @override
  State<MyAppHome> createState() => _MyAppHomeState();
}

class _MyAppHomeState extends State<MyAppHome> {
  bool darkmode = false;
  bool welcome = true;
  bool update = false;

  final GlobalKey<NavigatorState> firstTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> secondTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> thirdTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fourthTabNavKey = GlobalKey<NavigatorState>();
  final GlobalKey<NavigatorState> fifthTabNavKey = GlobalKey<NavigatorState>();

  late CupertinoTabController tabController;

  var loginController = Get.put(LoginController());
  var wishlistController = Get.put(WishlistController());
  var cartController = Get.put(CartController());
  var darkmodeController = Get.put(DarkModeController());
  var welcomeController = Get.put(WelcomeController());
  var languageController = Get.put(LanguageController());
  var notificationController = Get.put(NotificationController());

  void getToken() async {
    await FirebaseMessaging.instance.getToken().then((token) {
      // print(token);
    });
  }

  @override
  void initState() {
    super.initState();

    getToken();

    tabController = CupertinoTabController(initialIndex: 0);

    darkmodeController.get();
    welcomeController.get();
    loginController.get();
    languageController.get();
    notificationController.get();

    darkmode = darkmodeController.darkmode.value;

    // if (notificationController.notification.value) {}

    if (welcomeController.welcome.value) {
      SystemChrome.setPreferredOrientations([
        DeviceOrientation.portraitUp,
        DeviceOrientation.portraitDown,
      ]);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      VersionCheck.checkVersion(context);
    });
  }

  @override
  dispose() {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeRight,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);
    super.dispose();
  }

  int selectedIndex = 0;

  List pages = [HomePage(), CategoriesPage(), WishlistPage(), CartPage(), AccountPage()];

  @override
  Widget build(BuildContext context) {
    final listOfKeys = [firstTabNavKey, secondTabNavKey, thirdTabNavKey, fourthTabNavKey, fifthTabNavKey];

    return Obx(() => (welcomeController.welcome.value)
        ? const WelcomeScreen()
        : WillPopScope(
            onWillPop: () async {
              final currentState = listOfKeys[tabController.index].currentState;
              if (currentState != null && currentState.canPop()) {
                return !await listOfKeys[tabController.index].currentState!.maybePop();
              } else {
                showModalBottomSheet(
                    context: context,
                    builder: (context) {
                      return MsBottomSheet(
                        static: true,
                        child: Wrap(
                          children: [
                            Container(
                              padding: const EdgeInsets.all(30.0),
                              child: MsModal(
                                title: 'Hazırda tətbiqdən çıxış etmək istəyirsiniz?',
                                buttons: [
                                  [
                                    'İmtina et',
                                    MsButtonStyle.light,
                                    () {
                                      Navigator.pop(context);
                                    }
                                  ],
                                  [
                                    'Çıxış',
                                    MsButtonStyle.primary,
                                    () {
                                      Navigator.pop(context);
                                      SystemNavigator.pop();
                                    }
                                  ],
                                ],
                              ),
                            ),
                          ],
                        ),
                      );
                    });
                return true;
              }
            },
            child: CupertinoTabScaffold(
                controller: tabController,
                tabBar: CupertinoTabBar(
                    onTap: (index) {
                      setState(() {
                        selectedIndex = index;
                      });
                    },
                    border: Border(bottom: BorderSide(color: Colors.transparent)),
                    height: 70.0,
                    backgroundColor: Colors.white,
                    activeColor: MsColors.secondary,
                    items: [
                      BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'home.svg', label: 'Əsas səhifə', index: 0, selected: selectedIndex)),
                      BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'category.svg', label: 'Kataloq', index: 1, selected: selectedIndex)),
                      BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'favorite.svg', label: 'İstək listi', index: 2, selected: selectedIndex, badge: wishlistController.quantity.value)),
                      BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'cart.svg', label: 'Səbət', index: 3, selected: selectedIndex, badge: cartController.quantity.value)),
                      BottomNavigationBarItem(icon: MsBottomNavItem(icon: 'account.svg', label: 'Hesabım', index: 4, selected: selectedIndex)),
                    ]),
                tabBuilder: (context, index) {
                  return CupertinoTabView(
                      navigatorKey: listOfKeys[index],
                      builder: (context) {
                        return CupertinoPageScaffold(child: pages[index]);
                      });
                }),
          ));
  }
}
