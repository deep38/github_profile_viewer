import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/route_manager.dart';
import 'package:github_profile_viewer/data/api/github_api_service.dart';
import 'package:github_profile_viewer/domain/repos/github_repository.dart';
import 'package:github_profile_viewer/domain/service/github_data_service.dart';
import 'package:github_profile_viewer/presentation/controllers/profile_page_controller.dart';
import 'package:github_profile_viewer/presentation/controllers/repository_page_controller.dart';
import 'package:github_profile_viewer/presentation/pages/profile_page.dart';
import 'package:github_profile_viewer/presentation/pages/repository_page.dart';
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
      darkTheme: ThemeData.dark(),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => WelcomePage()),
        GetPage(name: '/user/:username', page: () => ProfilePage(), binding: BindingsBuilder(() {
          Get.lazyPut<GithubDataService>(() => GithubApiService());
          Get.lazyPut<GithubRepository>(() => GithubRepository(Get.find<GithubDataService>()));
          Get.lazyPut(() => ProfilePageController(Get.find<GithubRepository>()));
        })),
        GetPage(name: '/repo/:username/:reponame', page: () => RepositoryPage(), binding: BindingsBuilder(() {
          Get.lazyPut<GithubDataService>(() => GithubApiService());
          Get.lazyPut<GithubRepository>(() => GithubRepository(Get.find<GithubDataService>()));
          Get.lazyPut<RepositoryPageController>(() => RepositoryPageController(Get.find<GithubRepository>()));
        }))
      ],
    );
  }
}
