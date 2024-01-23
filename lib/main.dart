import 'package:easy_care/blocs/ActiveComplaints/bloc/active_complaints_bloc.dart';
import 'package:easy_care/blocs/HomeScreen/bloc/home_screen_bloc.dart';
import 'package:easy_care/blocs/auth_bloc/auth_bloc_bloc.dart';
import 'package:easy_care/blocs/completed/bloc/completed_bloc.dart';
import 'package:easy_care/blocs/login_bloc/login_bloc_bloc.dart';
import 'package:easy_care/blocs/rescheduled/bloc/rescheduled_bloc.dart';
import 'package:easy_care/blocs/services/bloc/services_bloc.dart';
import 'package:easy_care/blocs/start_service/bloc/start_service_bloc.dart';
import 'package:easy_care/blocs/submit_tab/bloc/submit_tab_bloc.dart';
import 'package:easy_care/blocs/submit_visible/bloc/submit_visible_bloc.dart';
import 'package:easy_care/blocs/trip_bloc/trip_bloc.dart';
import 'package:easy_care/blocs/trip_visible/bloc/trip_visible_bloc.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:easy_care/ui/home_screen.dart';
import 'package:easy_care/ui/login_phone.dart';
import 'package:easy_care/ui/reachDestination_screen.dart';
import 'package:easy_care/ui/splash_screen.dart';
import 'package:easy_care/ui/start_service.dart';
import 'package:easy_care/ui/submit_report.dart';
import 'package:easy_care/utils/constants/string_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:device_preview/device_preview.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
  await UserRepository().initLocal();
  runApp(DevicePreview(
      enabled: false, builder: (context) => const MyApp()));
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (BuildContext context) =>
              AuthBlocBloc()..add(AuthStartedET2()),
        ),
        BlocProvider(
          create: (BuildContext context) => LoginBlocBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => ActiveComplaintsBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => CompletedBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => RescheduledBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => TripBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => HomeScreenBloc(),
        ),
        BlocProvider(
          create: (BuildContext context) => StartServiceBloc(),
        ),
        BlocProvider(create: (BuildContext context) => ServicesBloc()),
        BlocProvider(create: (BuildContext context) => SubmitTabBloc()),
        BlocProvider(create: (BuildContext context) => SubmitVisibleBloc()),
        BlocProvider(create: (BuildContext context) => TripVisibleBloc()),
      ],
      child: MaterialApp(
        useInheritedMediaQuery: false,
      locale: DevicePreview.locale(context),
      builder: DevicePreview.appBuilder,
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: BlocBuilder<AuthBlocBloc, AuthBlocState>(
          builder: (context, state) {
            if (state is AuthStartedST) {
              return const SplashScreen();
            }
            if (state is AuthFailureST) {
              return const LoginPhone();
            }
            if (state is AuthSuccessST) {
              return const HomeScreen();
            }
            if (state is AuthTripDetailST) {
              if (state.tripStatus == StringConstants.startTrip) {
                return const ReachDestination();
              } else if (state.tripStatus == StringConstants.reachDestination) {
                return const StartService();
              } else if (state.tripStatus == StringConstants.tripStartService) {
                return const SubmitReport();
              } else {
                return const HomeScreen();
              }
            }

            return const SplashScreen(); 
          },
        ),
      ),
    );
  }
}
