import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:github_profile_viewer/data/api/github_api_service.dart';
import 'package:github_profile_viewer/domain/repos/github_data_repository.dart';
import 'package:github_profile_viewer/domain/service/github_data_service.dart';
import 'package:github_profile_viewer/presentation/controllers/profile_page_controller.dart';
import 'package:github_profile_viewer/presentation/controllers/repository_page_controller.dart';
import 'package:github_profile_viewer/presentation/pages/profile_page.dart';
import 'package:github_profile_viewer/presentation/pages/repository_page.dart';
import 'package:github_profile_viewer/presentation/pages/welcome_page.dart';
import 'package:github_profile_viewer/utils/constants.dart';
import 'package:github_profile_viewer/utils/routes.dart';
import 'package:github_profile_viewer/utils/theme_extensions.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: Strings.appName,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        extensions: [
          ShimmerEffectThemeExtension(
            baseColor: Color(0xffEBEBEB),
            highlightColor: Colors.white,
          ),
        ],
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(brightness: Brightness.dark, seedColor: Colors.deepPurple),
        extensions: [
          ShimmerEffectThemeExtension(
            baseColor: Color(0xff333333),
            highlightColor: Color(0xff666666),
          ),
        ],
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => WelcomePage()),

        GetPage(
          name: Routes.profilePagePath,
          page: () => ProfilePage(),
          binding: BindingsBuilder(() {
            Get.lazyPut<GithubDataService>(() => GithubApiService());
            Get.lazyPut<GithubDataRepository>(
              () => GithubDataRepository(Get.find<GithubDataService>()),
            );
            Get.lazyPut(
              () => ProfilePageController(Get.find<GithubDataRepository>()),
            );
          }),
        ),

        GetPage(
          name: Routes.repositoryPagePath,
          page: () => RepositoryPage(),
          binding: BindingsBuilder(() {
            Get.lazyPut<GithubDataService>(() => GithubApiService());
            Get.lazyPut<GithubDataRepository>(
              () => GithubDataRepository(Get.find<GithubDataService>()),
            );
            Get.lazyPut<RepositoryPageController>(
              () => RepositoryPageController(Get.find<GithubDataRepository>()),
            );
          }),
        ),
      ],
    );
  }
}
