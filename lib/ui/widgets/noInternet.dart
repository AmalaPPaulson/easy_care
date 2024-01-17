import 'package:flutter/material.dart';

class NoInternetCard extends StatelessWidget {
  const NoInternetCard({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(
                width: 300,
                child: Image(
                    image:
                        AssetImage('assets/images/no internet connection.webp'))),
            Text('Whoops!'),
            Text('No internet connection found')
          ],
        ),
      ),
    );
  }
}
