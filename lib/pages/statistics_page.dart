// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/widgets/secondary_action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StatisticsPage extends StatelessWidget {
  const StatisticsPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return _StatisticsPageContent();
  }
}

class _StatisticsPageContent extends StatelessWidget {
  const _StatisticsPageContent({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        // ignore: prefer_const_literals_to_create_immutables
        child: Column(children: [
          Container(
            margin: EdgeInsets.only(top: 24),
            alignment: Alignment.center,
            child: Text(
              "Statistics",
              style:
                  TextStyle(fontSize: 24, color: FightClubColors.darkGreyText),
            ),
          ),
          Expanded(child: SizedBox()),
          FutureBuilder<List>(
            future: SharedPreferences.getInstance().then((value) {
              List<int?> result = [
                value.getInt("stats_won"),
                value.getInt("stats_lost"),
                value.getInt("stats_draw"),
              ];
              return result;
            }),
            builder: (context, snapshot) {
              if (!snapshot.hasData ||
                  snapshot.data == null ||
                  snapshot.data![0] == null ||
                  snapshot.data![1] == null ||
                  snapshot.data![2] == null) {
                return SizedBox();
              }
              return SizedBox(
                height: 132,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Text("Won: ${snapshot.data![0]}",
                        style: TextStyle(fontSize: 16)),
                    Text("Lost: ${snapshot.data![1]}",
                        style: TextStyle(fontSize: 16)),
                    Text("Draw: ${snapshot.data![2]}",
                        style: TextStyle(fontSize: 16)),
                  ],
                ),
              );
            },
          ),
          Expanded(child: SizedBox()),
          Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: SecondaryActionButton(
                text: "Back", onTap: () => Navigator.of(context).pop()),
          ),
        ]),
      ),
    );
  }
}
