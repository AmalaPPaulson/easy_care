import 'package:easy_care/blocs/services/bloc/services_bloc.dart';
import 'package:easy_care/blocs/start_service/bloc/start_service_bloc.dart';
import 'package:easy_care/blocs/submit_tab/bloc/submit_tab_bloc.dart';
import 'package:easy_care/blocs/submit_visible/bloc/submit_visible_bloc.dart';
import 'package:easy_care/blocs/trip_bloc/trip_bloc.dart';
import 'package:easy_care/blocs/trip_visible/bloc/trip_visible_bloc.dart';
import 'package:easy_care/ui/active_screen.dart';
import 'package:easy_care/ui/home_screen.dart';
import 'package:easy_care/ui/widgets/Buttons/login_button1.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class SuccessScreen extends StatefulWidget {
  const SuccessScreen({super.key});

  @override
  State<SuccessScreen> createState() => _SuccessScreenState();
}

class _SuccessScreenState extends State<SuccessScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: createBody(),
    );
  }

  Widget createBody() {
    return SizedBox(
      width: MediaQuery.of(context).size.width,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text('Go to Next trip'),
          LoginButton1(
              onTap: () {
                context.read<TripVisibleBloc>().add(CleanTripVisibleET());
                context.read<ServicesBloc>().add(CleanServiceET());
                context.read<StartServiceBloc>().add(CleanStartServiceET());
                context.read<SubmitTabBloc>().add(CleanSubmitTabReportET());
                context.read<SubmitVisibleBloc>().add(CleanSubmitVisibleET());
                context.read<TripBloc>().add(CleanTripET());
                Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (context) => const HomeScreen()),
                    (Route route) => false);
              },
              isPressed: false,
              text: 'Ok')
        ],
      ),
    );
  }
}
