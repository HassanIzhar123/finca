import 'dart:developer';

import 'package:finca/assets/assets.dart';
import 'package:finca/cubits/notification/notification_cubit.dart';
import 'package:finca/cubits/notification/notification_state.dart';
import 'package:finca/models/notification/notification_model.dart';
import 'package:finca/utils/app_colors.dart';
import 'package:finca/utils/app_strings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/state_manager.dart';
import 'package:intl/intl.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> {
  bool isLoading = true;
  List<NotificationModel> notifications = [];

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => NotificationCubit()..getAllNotification(),
      child: BlocConsumer<NotificationCubit, NotificationState>(
        listener: (BuildContext context, NotificationState state) {
          log('notificationState: ${state.toString()}');
          if (state is NotificationLoadingState) {
            isLoading = true;
          } else if (state is NotificationSuccessState) {
            isLoading = false;
            notifications = state.notifications;
          } else if (state is NotificationFailedState) {
            isLoading = false;
          }
        },
        builder: (context, state) {
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
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            GestureDetector(
                              onTap: () {
                                Navigator.pop(context);
                              },
                              child: SvgPicture.asset(Assets.backIcon),
                            ),
                            const SizedBox(
                              width: 20,
                            ),
                            Text(
                              AppStrings.notification,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w700,
                                color: AppColors.greenColor,
                                fontFamily: Assets.rubik,
                              ),
                            ),
                          ],
                        ),
                        Container(
                          margin: const EdgeInsets.only(
                            left: 40,
                          ),
                          child: Text(
                            AppStrings.activities,
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              color: const Color(0xFF3B3B3B),
                              fontFamily: Assets.rubik,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.only(
                        left: 15,
                        right: 15,
                      ),
                      child: isLoading
                          ? const Center(
                              child: CircularProgressIndicator(),
                            )
                          : notifications.isNotEmpty
                              ? ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: notifications.length,
                                  itemBuilder: (context, index) {
                                    return Padding(
                                      padding: const EdgeInsets.only(
                                        top: 10,
                                      ),
                                      child: Container(
                                        decoration: BoxDecoration(
                                          color: const Color(0xFFF4F4F4),
                                          borderRadius: BorderRadius.circular(10),
                                        ),
                                        child: Row(
                                          children: [
                                            Expanded(
                                              child: Padding(
                                                padding: const EdgeInsets.all(10),
                                                child: Column(
                                                  crossAxisAlignment: CrossAxisAlignment.start,
                                                  children: [
                                                    Text(
                                                      notifications[index].notificationTitle,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w500,
                                                        color: AppColors.greenColor,
                                                        fontFamily: Assets.rubik,
                                                      ),
                                                    ),
                                                    Text(
                                                      notifications[index].notificationBody,
                                                      maxLines: 2,
                                                      overflow: TextOverflow.ellipsis,
                                                      style: TextStyle(
                                                        fontSize: 11,
                                                        fontWeight: FontWeight.w400,
                                                        color:const Color(0xFF4A4A4A),
                                                        fontFamily: Assets.rubik,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              ),
                                            ),
                                            //show date
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                right: 10,
                                              ),
                                              child: Column(
                                                crossAxisAlignment: CrossAxisAlignment.end,
                                                children: [
                                                  Text(
                                                    '${notifications[index].createdAt.day} ${DateFormat('MMM').format(
                                                      notifications[index].createdAt,
                                                    )} ${notifications[index].createdAt.year}',
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xFFD1D1D1),
                                                      fontFamily: Assets.rubik,
                                                    ),
                                                  ),
                                                  Text(
                                                    DateFormat('hh:mm a').format(
                                                      notifications[index].createdAt,
                                                    ),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      fontWeight: FontWeight.w500,
                                                      color: const Color(0xFFD1D1D1),
                                                      fontFamily: Assets.rubik,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    );
                                  },
                                )
                              : Center(
                                  child: Text(
                                    AppStrings.noNotification,
                                    style: TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: AppColors.greenColor,
                                      fontFamily: Assets.rubik,
                                    ),
                                  ),
                                ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
