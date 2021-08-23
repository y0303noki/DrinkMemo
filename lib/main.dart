import 'package:coffee_project2/const/common.dart';
import 'package:coffee_project2/pages/coffeePage/coffee_list_page.dart';
import 'package:coffee_project2/pages/home_page.dart';
import 'package:coffee_project2/pages/login_check_page.dart';
import 'package:coffee_project2/providers/album/album_list_provider.dart';
import 'package:coffee_project2/providers/bottom_navigation/bottom_navigation_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_provider.dart';
import 'package:coffee_project2/providers/modal_tab/modal_tab_provider.dart';
import 'package:coffee_project2/providers/setting/developper_provider.dart';
import 'package:coffee_project2/providers/user/user_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:provider/provider.dart';

// void main() {
//   runApp(const MyApp());
// }

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Firebase初期化
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => CoffeeListProvider()..findCoffeeDatas(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AlbumListProvider()..findAlbumDatas(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => CoffeeProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => UserProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => ModalTabProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => DeveloperProvider(),
        ),
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        // theme: ThemeData(
        //   primarySwatch: Common.lightPrimaryColor, // ここ
        // ),
        // darkTheme: ThemeData(
        //   primarySwatch: Common.darkPrimaryColor,
        // ),
        home: LoginCheck(),
        builder: (BuildContext context, Widget? child) {
          return FlutterEasyLoading(child: child);
        },
      ),
    );
  }
}
