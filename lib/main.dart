import 'package:coffee_project2/pages/coffeePage/coffee_list_page.dart';
import 'package:coffee_project2/pages/home_page.dart';
import 'package:coffee_project2/providers/album/album_list_provider.dart';
import 'package:coffee_project2/providers/bottom_navigation/bottom_navigation_provider.dart';
import 'package:coffee_project2/providers/coffee/coffee_list_provider.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
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
          create: (ctx) => CoffeeListProvider()..testFirebase(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => BottomNavigationProvider(),
        ),
        ChangeNotifierProvider(
          create: (ctx) => AlbumListProvider(),
        )
      ],
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: HomePage(),
      ),
    );
  }
}
