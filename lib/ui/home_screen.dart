import 'dart:developer';

import 'package:easy_care/blocs/HomeScreen/bloc/home_screen_bloc.dart';
import 'package:easy_care/blocs/auth_bloc/auth_bloc_bloc.dart';
import 'package:easy_care/repositories/user_repo.dart';
import 'package:easy_care/ui/active_screen.dart';
import 'package:easy_care/ui/completed_screen.dart';
import 'package:easy_care/ui/login_phone.dart';
import 'package:easy_care/ui/rescheduled_screen.dart';
import 'package:easy_care/ui/tabTitletile.dart';
import 'package:easy_care/utils/constants/asset_constants.dart';
import 'package:easy_care/utils/constants/color_constants.dart';
import 'package:easy_care/utils/size_config.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  UserRepository userRepository = UserRepository();
  final PageController _pageController = PageController();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

    @override
  void initState() {
    context.read<HomeScreenBloc>().add(TabClickET(tabNo: 0));
    super.initState();
  }



  @override
  void dispose() {
    // Clean up the controller when the widget is removed from the
    // widget tree.
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     String?  phoneNo = userRepository.getPhoneNo();
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          'Registered Complaints',
          style: TextStyle(
              color: Colors.white, fontFamily: AssetConstants.poppinsMedium),
        ),
        backgroundColor: ColorConstants.primaryColor,
        leading: GestureDetector(
          onTap: () => _scaffoldKey.currentState?.openDrawer(),
          /* WScaffold.of(context).openDrawer();rite listener code here */

          child: const Icon(
            Icons.menu,
            color: Colors.white, // add custom icons also
          ),
        ),
      ),
      body: createBody(),
      drawer: Drawer(
        backgroundColor: Colors.white,
        child: ListView(
          // Important: Remove any padding from the ListView.
          padding: EdgeInsets.zero,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: SizeConfig.blockSizeHorizontal * 18,
                ),
                CircleAvatar(
                  backgroundImage: const AssetImage(AssetConstants.userImage),
                  radius: SizeConfig.blockSizeHorizontal * 10,
                ),
                SizedBox(
                  height: SizeConfig.blockSizeHorizontal * 4,
                ),
               Text(
                  '$phoneNo',
                  style: const TextStyle(fontFamily: AssetConstants.poppinsBold),
                ),
              ],
            ),
            ListTile(
              leading: const Icon(
                Icons.timer,
                color: Colors.black,
              ),
              title: const Text(
                'Contact Admin',
                style: TextStyle(
                  fontFamily: AssetConstants.poppinsMedium,
                ),
              ),
              onTap: () {},
            ),
            ListTile(
              leading: const Icon(
                Icons.app_blocking,
                color: Colors.black,
              ),
              title: const Text(
                'About App',
                style: TextStyle(
                  fontFamily: AssetConstants.poppinsMedium,
                ),
              ),
              onTap: () {
                // Update the state of the app.
                // ...
              },
            ),
            BlocListener<AuthBlocBloc, AuthBlocState>(
              listener: (context, state) {
                if (state is AuthLogoutFailST) {
                  Fluttertoast.showToast(msg: state.errorMsg!);
                }
                if (state is AuthLogoutSuccST) {
                  Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: ((context) => const LoginPhone())),
                      (route) => false);
                }
              },
              child: ListTile(
                leading: const Icon(
                  Icons.logout,
                  color: Colors.black,
                ),
                title: const Text(
                  'Log out',
                  style: TextStyle(
                    fontFamily: AssetConstants.poppinsMedium,
                  ),
                ),
                onTap: () {
                  context.read<AuthBlocBloc>().add(AuthLogoutEvent());
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  //Create Body
  Widget createBody() {
    return SafeArea(
      child: SizedBox(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        child: BlocBuilder<HomeScreenBloc, HomeScreenState>(
          
          builder: (context, state) {
            int currentTab =0 ;
            if(state.currentTab !=null){
              currentTab =state.currentTab!;
            }
            log('$currentTab');
            return Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [tabTitle(currentTab), pageView(currentTab)],
            );
          },
        ),
      ),
    );
  }

  Widget tabTitle(int currentTab) {
    return Container(
      height: SizeConfig.blockSizeHorizontal * 15,
      width: MediaQuery.of(context).size.width,
      color: ColorConstants.backgroundColor1,
      child: Row(
        children: <Widget>[
          TabTitleTile(
            width: MediaQuery.of(context).size.width/3,
            title: 'Active',
            currentTab: currentTab,
            tabNo: 0,
            color2: (currentTab == 0)
                ? ColorConstants.backgroundColor1
                : ColorConstants.backgroundColor2,
            onPressed: () {
             
              context.read<HomeScreenBloc>().add(TabClickET(tabNo: 0));
              log('inside active: $currentTab');
              _pageController.animateToPage(0,
                  duration: const Duration(milliseconds: 5),
                  curve: Curves.decelerate);
            },
            borderRadiusGeometry: (currentTab == 0)
                ? const BorderRadius.only(topRight: Radius.circular(5))
                : (currentTab == 1)
                    ? const BorderRadius.only(bottomRight: Radius.circular(5))
                    : BorderRadius.circular(0),
          ),
          TabTitleTile(
            width: MediaQuery.of(context).size.width/3,
            title: 'Completed',
            tabNo: 1,
            currentTab: currentTab,
            color2: (currentTab == 1)
                ? ColorConstants.backgroundColor1
                : ColorConstants.backgroundColor2,
            borderRadiusGeometry: (currentTab == 0)
                ? const BorderRadius.only(bottomLeft: Radius.circular(8))
                : (currentTab == 1)
                    ? const BorderRadius.only(
                        topLeft: Radius.circular(8),
                        topRight: Radius.circular(8))
                    : const BorderRadius.only(bottomRight: Radius.circular(8)),
            onPressed: () {
              
              context.read<HomeScreenBloc>().add(TabClickET(tabNo: 1));
              _pageController.animateToPage(1,
                  duration: const Duration(milliseconds: 5),
                  curve: Curves.decelerate);
            },
          ),
          TabTitleTile(
            width: MediaQuery.of(context).size.width/3,
            title: 'Rescheduled',
            currentTab: currentTab,
            tabNo: 2,
            color2: (currentTab == 2)
                ? ColorConstants.backgroundColor1
                : ColorConstants.backgroundColor2,
            onPressed: () {

              context.read<HomeScreenBloc>().add(TabClickET(tabNo: 2));
              _pageController.animateToPage(2,
                  duration: const Duration(milliseconds: 5),
                  curve: Curves.decelerate);
            },
            borderRadiusGeometry: (currentTab == 2)
                ? const BorderRadius.only(topLeft: Radius.circular(5))
                : (currentTab == 1)
                    ? const BorderRadius.only(bottomLeft: Radius.circular(5))
                    : BorderRadius.circular(0),
          ),
        ],
      ),
    );
  }

  Widget pageView(int currentTab) {
    return Expanded(
      child: PageView(
        controller: _pageController,
        physics: const NeverScrollableScrollPhysics(),
        onPageChanged: (index) {
          //context.read<HomeScreenBloc>().add(TabClickET(tabNo: index));
        },
        children: const [
          ActiveScreen(),
          CompletedScreen(),
          RescheduledScreen(),
        ],
      ),
    );
  }
}
