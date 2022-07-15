import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../constants.dart';
import 'cubit/bloc_observer.dart';
import 'cubit/login_cubit.dart';
import 'cubit/social_cubit.dart';
import 'cubit/social_state.dart';
import 'firebase_options.dart';
import 'helpers/cache.dart';
import 'pages/home.dart';
import 'pages/register.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  BlocOverrides.runZoned(
    () async {
      await CacheHelper.init();
      return runApp(
        MultiBlocProvider(
          providers: [
            BlocProvider<LoginCubit>(
              create: (context) => LoginCubit(),
            ),
            BlocProvider<SocialCubit>(
              create: (context) => SocialCubit()
                ..takeCachedData()
                ..takeCachedThemeMode()
                ..getUserData()
                ..getPosts(),
            ),
          ],
          child: const MyApp(),
        ),
      );
    },
    blocObserver: MyBlocObserver(),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SocialCubit, SocialStates>(
      listener: (context, state) {},
      builder: (context, state) {
        SocialCubit cubit = SocialCubit.get(context);
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          themeMode: cubit.tm,
          theme: theme,
          darkTheme: darkTheme,
          home: appToken.isNotEmpty ? const HomePage() : RegisterPage(),
        );
      },
    );
  }
}
