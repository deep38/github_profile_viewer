import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get/route_manager.dart';
import 'package:github_profile_viewer/presentation/controllers/welcome_page_controller.dart';
import 'package:github_profile_viewer/presentation/pages/welcome_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/',
      getPages: [
        GetPage(
          name: '/',
          page: () => WelcomePage(),
          binding: BindingsBuilder(() {
            Get.lazyPut<WelcomePageController>(() => WelcomePageController());
          }),
        ),
      ],
    );
  }
}
