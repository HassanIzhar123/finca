import 'package:finca/assets/assets.dart';
import 'package:finca/modules/activity_screen/pages/activity_screen.dart';
import 'package:finca/modules/climate_screen/climate_screen.dart';
import 'package:finca/modules/farms_screen/pages/farms_screen.dart';
import 'package:finca/modules/notification/notification_page.dart';
import 'package:finca/modules/reports_screen/reports_page.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _pageNumber = 0;
  List<String> labels = ["Activity", "Climate", "Reports", "Farms"];

  @override
  Widget build(BuildContext context) {
    Widget layout = navigationLayouts()[_pageNumber];
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 10,
                left: 15,
                right: 15,
              ),
              child: Row(
                children: [
                  SvgPicture.asset(Assets.menuIcon),
                  const SizedBox(
                    width: 20,
                  ),
                  Text(
                    labels[_pageNumber],
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w700,
                      color: Colors.green,
                      fontFamily: Assets.rubik,
                    ),
                  ),
                  //notification icon
                  const Spacer(),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(context, MaterialPageRoute(builder: (context) => const NotificationPage()));
                      },
                      child: SvgPicture.asset(Assets.notificationIcon)),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(
                  left: 15,
                  right: 15,
                ),
                child: layout,
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: AppColors.lightGreen,
        currentIndex: _pageNumber,
        onTap: (index) {
          setState(() {
            _pageNumber = index;
          });
        },
        // selectedIconTheme: const IconThemeData(size: 30, color: Colors.white,),
        selectedItemColor: Colors.green,
        unselectedItemColor: Colors.green,
        items: bottomNavigationItems(),
        type: BottomNavigationBarType.fixed,
      ),
    );
  }

  List<BottomNavigationBarItem> bottomNavigationItems() {
    return [
      BottomNavigationBarItem(icon: SvgPicture.asset(Assets.calendarIcon), label: "Activity"),
      BottomNavigationBarItem(icon: SvgPicture.asset(Assets.weatherIcon), label: "Climate"),
      BottomNavigationBarItem(icon: SvgPicture.asset(Assets.reportIcon), label: "Reports"),
      BottomNavigationBarItem(
          icon: SizedBox(height: 30, width: 30, child: SvgPicture.asset(Assets.appIcon)), label: "Farms"),
    ];
  }

  List<Widget> navigationLayouts() {
    return [
      const ActivityScreen(),
      const ClimateScreen(),
      const ReportsScreen(),
      const FarmsScreen(),
    ];
  }
}
