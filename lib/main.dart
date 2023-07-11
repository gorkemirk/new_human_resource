import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:new_human_resource/FireBaseService/base_database_managment.dart';
import 'package:new_human_resource/FireBaseService/firebase_managment.dart';
import 'AuthService/auth_service.dart';
import 'AuthService/base_auth_service.dart';
import 'FireBaseService/FirebaseStorageService/firebase_storage.dart';
import 'Pages/create_user_page.dart';
import 'Pages/user_checking_page.dart';
import 'FireBaseService/firebase_options.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  FirebaseAuth.instance.authStateChanges().listen((User? user) {
    if (user == null) {
      debugPrint('User is currently signed out!');
    } else {
      debugPrint('User is signed in!');
    }
  });
  //await authenticationService.userLogOut();
  runApp(const ProviderScope(child: MyApp()));
}

AuthenticationService authenticationService = FirebaseAuthentication();
DatabaseServices databaseService = FireBaseManagment();
FireBaseStorage firebaseStorage = FireBaseStorage();

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(412, 869),
      builder: (BuildContext context, Widget? child) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          theme: ThemeData(
            fontFamily: 'OpenSans',
          ),
          initialRoute: "/",
          routes: {
            "/": (context) => LandingPage(
                authenticationService: authenticationService,
                databaseService: databaseService),
            "/createuserpage": (context) => const CreateUserPage()
          },
        );
      },
    );
  }
}
