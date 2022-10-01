import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';
import 'package:get_it/get_it.dart';
import 'package:get_storage/get_storage.dart';
import 'package:lugat/repository/sqlite/directory_dal.dart';

import '/controller/main_controller.dart';
import '/repository/base/i_directory_repository.dart';
import '/repository/base/i_sentence_repository.dart';
import '/ui/pages/page_not_found.dart';
import 'firebase_options.dart';
import 'repository/sqlite/sentence_dal.dart';
import 'utilities/router.dart';
import 'utilities/ui_constant.dart';

late FirebaseFirestore fireStore;
late ISentenceRepository sentenceDal;
late IDirectoryRepository directoryDal;

void main() async {
  await init;
  await initFirebase;
  setupLocators;
  await initControllers;
  runApp(const MainApp());
}

Future<void> get init async {
  WidgetsFlutterBinding.ensureInitialized();
  await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Color(0XFF333340),
    statusBarIconBrightness: Brightness.light,
  ));
}

Future<void> get initFirebase async {
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);

  fireStore = FirebaseFirestore.instance;
}

void get setupLocators {
  final getIt = GetIt.instance;

  getIt.registerSingleton<ISentenceRepository>(SentenceDal());
  getIt.registerSingleton<IDirectoryRepository>(DirectoryDal());

  sentenceDal = getIt<ISentenceRepository>();
  directoryDal = getIt<IDirectoryRepository>();
}

Future<void> get initControllers async {
  await GetStorage.init();
  Get.put(MainController());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(1440, 2960),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (BuildContext context, Widget? child) {
        return GetMaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Risale-i Nur Lugat',
          theme: UIConstant.getDefaultThemeData,
          getPages: routes,
          unknownRoute: GetPage(
            name: '/pageNotFound',
            page: () => const PageNotFound(),
          ),
        );
      },
    );
  }
}
