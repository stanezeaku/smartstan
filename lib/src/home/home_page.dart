import 'dart:io';

import 'package:smartstan/src/db/database.dart';
import 'package:smartstan/src/utils/size_config.dart';
import 'package:smartstan/src/theme/colors/light_colors.dart';
import 'package:smartstan/src/home/widgets/active_project_card.dart';
import 'package:smartstan/src/home/widgets/task_column.dart';
import 'package:smartstan/src/home/widgets/top_container.dart';
import 'package:flutter/material.dart';
import 'package:percent_indicator/percent_indicator.dart';

class HomePage extends StatefulWidget {
  final String username;
  final String? imagePath;
  final DataBaseService dataBaseService;

  const HomePage(this.username,
      {Key? key, this.imagePath, required this.dataBaseService})
      : super(key: key);

  static CircleAvatar calendarIcon() {
    return const CircleAvatar(
      radius: 25.0,
      // backgroundColor: LightColors.kGreen,
      child: Icon(
        Icons.calendar_today,
        size: 20.0,
        // color: Colors.white,
      ),
    );
  }

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Text subheading(String title) {
    return Text(
      title,
      style: const TextStyle(
        // color: LightColors.kDarkBlue,
        fontSize: 20.0,
        fontWeight: FontWeight.w700,
        letterSpacing: 1.2,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig.init(context);
    double width = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: AppBar(
        leading: Container(),
        elevation: 0,
        // backgroundColor: LightColors.kDarkYellow,
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.only(right: 20, top: 20),
            child: PopupMenuButton<String>(
              child: const Icon(
                Icons.more_vert,
                // color: Colors.black,
              ),
              onSelected: (value) {
                switch (value) {
                  case 'Clear DB':
                    widget.dataBaseService.cleanDB();
                    break;
                }
              },
              itemBuilder: (BuildContext context) {
                return {'Clear DB'}.map((String choice) {
                  return PopupMenuItem<String>(
                    value: choice,
                    child: Text(choice),
                  );
                }).toList();
              },
            ),
          ),
        ],
      ),
      // backgroundColor: LightColors.kLightYellow,
      body: SafeArea(
        child: Column(
          children: [
            TopContainer(
              height: SizeConfig.availableHeight * 0.2,
              width: width,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  // Row(
                  //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  //     children: const [
                  //       Icon(
                  //         Icons.menu,
                  //         color: LightColors.kDarkBlue,
                  //         size: 30.0,
                  //       ),
                  //       Icon(
                  //         Icons.code,
                  //         color: LightColors.kDarkBlue,
                  //         size: 25.0,
                  //       ),
                  //     ]),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 0,
                      vertical: 0.0,
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        CircularPercentIndicator(
                          radius: 90.0,
                          lineWidth: 5.0,
                          animation: true,
                          percent: 0.90,
                          circularStrokeCap: CircularStrokeCap.round,
                          progressColor: LightColors.kRed,
                          // backgroundColor: LightColors.kDarkYellow,
                          center: CircleAvatar(
                            // backgroundColor: LightColors.kBlue,
                            radius: 35.0,
                            backgroundImage: FileImage(File(widget.imagePath!)),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Text(
                              'Hi ${widget.username}',
                              textAlign: TextAlign.start,
                              style: const TextStyle(
                                fontSize: 22.0,
                                // color: LightColors.kDarkBlue,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            const Text(
                              'Your great AI Apps',
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                fontSize: 16.0,
                                // color: Colors.black45,
                                fontWeight: FontWeight.w400,
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    Container(
                      color: Colors.transparent,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20.0, vertical: 10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          subheading('Active Projects'),
                          const SizedBox(height: 5.0),
                          Row(
                            children: const <Widget>[
                              ActiveProjectsCard(
                                cardColor: LightColors.kGreen,
                                loadingPercent: 0.25,
                                title: 'Medical App',
                                subtitle: '9 hours progress',
                              ),
                              SizedBox(width: 20.0),
                              ActiveProjectsCard(
                                cardColor: LightColors.kRed,
                                loadingPercent: 0.6,
                                title: 'Making History Notes',
                                subtitle: '20 hours progress',
                              ),
                            ],
                          ),
                          Row(
                            children: const <Widget>[
                              ActiveProjectsCard(
                                cardColor: LightColors.kDarkYellow,
                                loadingPercent: 0.45,
                                title: 'Sports App',
                                subtitle: '5 hours progress',
                              ),
                              SizedBox(width: 20.0),
                              ActiveProjectsCard(
                                cardColor: LightColors.kBlue,
                                loadingPercent: 0.9,
                                title: 'Online Flutter Course',
                                subtitle: '23 hours progress',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    // Container(
                    //   color: Colors.transparent,
                    //   padding: const EdgeInsets.symmetric(
                    //       horizontal: 20.0, vertical: 10.0),
                    //   child: Column(
                    //     children: const <Widget>[
                    //       // Row(
                    //       //   crossAxisAlignment: CrossAxisAlignment.center,
                    //       //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //       //   children: <Widget>[
                    //       //     subheading('My Tasks'),
                    //       //     GestureDetector(
                    //       //       onTap: () {
                    //       //         // Navigator.push(
                    //       //         //   context,
                    //       //         //   MaterialPageRoute(
                    //       //         //       builder: (context) => CalendarPage()
                    //       //         //       ),
                    //       //         // );
                    //       //       },
                    //       //       child: calendarIcon(),
                    //       //     ),
                    //       //   ],
                    //       // ),
                    //       // const SizedBox(height: 15.0),
                    //       // const TaskColumn(
                    //       //   icon: Icons.alarm,
                    //       //   iconBackgroundColor: LightColors.kRed,
                    //       //   title: 'To Do',
                    //       //   subtitle: '5 tasks now. 1 started',
                    //       // ),
                    //       // const SizedBox(
                    //       //   height: 15.0,
                    //       // ),
                    //       // const TaskColumn(
                    //       //   icon: Icons.blur_circular,
                    //       //   iconBackgroundColor: LightColors.kDarkYellow,
                    //       //   title: 'In Progress',
                    //       //   subtitle: '1 tasks now. 1 started',
                    //       // ),
                    //       // const SizedBox(height: 15.0),
                    //       // const TaskColumn(
                    //       //   icon: Icons.check_circle_outline,
                    //       //   iconBackgroundColor: LightColors.kBlue,
                    //       //   title: 'Done',
                    //       //   subtitle: '18 tasks now. 13 started',
                    //       // ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
