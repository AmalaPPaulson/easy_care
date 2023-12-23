import 'package:easy_care/ui/active_screen.dart';
import 'package:easy_care/ui/home_screen.dart';
import 'package:easy_care/ui/widgets/Buttons/login_button1.dart';
import 'package:flutter/material.dart';

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
          LoginButton1(onTap: () {
             Navigator.of(context).pushAndRemoveUntil(
              MaterialPageRoute(builder: (context) => const HomeScreen()),
              (Route route) => false);
          }, isPressed: false, text: 'Ok')
        ],
      ),
    );
  }
}
