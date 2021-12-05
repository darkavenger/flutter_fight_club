// ignore_for_file: prefer_const_constructors

import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/pages/fight_page.dart';
import 'package:flutter_fight_club/pages/statistics_page.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_images.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:flutter_fight_club/widgets/fight_result_widget.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _MainPageContent();
  }
}

class _MainPageContent extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // ignore: prefer_const_constructors
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          // ignore: prefer_const_literals_to_create_immutables
          children: [
            const SizedBox(height: 24),
            Center(
              child: Text(
                "The\nFight\nClub".toUpperCase(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 30,
                  color: FightClubColors.darkGreyText,
                ),
              ),
            ),
            Expanded(child: SizedBox()),
            FutureBuilder<List>(
              future: SharedPreferences.getInstance().then((value) {
                List<int?> result = [
                  value.getInt("lastyourLives"),
                  value.getInt("lastenemysLives"),
                ];
                return result;
              }),
              builder: (context, snapshot) {
                if (!snapshot.hasData ||
                    snapshot.data == null ||
                    snapshot.data![0] == null ||
                    snapshot.data![1] == null) {
                  return SizedBox();
                }
                return Column(
                  children: [
                    Text("Last fight result"),
                    FightResultWidget(
                      fightResult: FightResult.calculateResult(
                        snapshot.data![0],
                        snapshot.data![1],
                      )!,
                    )
                  ],
                );
              },
            ),
            Expanded(child: SizedBox()),
            SecondaryActionButton(
                text: "Statistics",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => StatisticsPage(),
                    ),
                  );
                }),
            SizedBox(
              height: 12,
            ),
            ActionButton(
                text: "Start",
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => FightPage(),
                    ),
                  );
                },
                color: FightClubColors.blackButton),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}