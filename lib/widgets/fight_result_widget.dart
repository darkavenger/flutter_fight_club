// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_images.dart';

class FightResultWidget extends StatelessWidget {
  final FightResult fightResult;
  const FightResultWidget({
    Key? key,
    required this.fightResult,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Color _resultColor = Color(0xFF038800);
    if (fightResult == FightResult.draw) {
      _resultColor = Color(0xFF1C79CE);
    } else if (fightResult == FightResult.lost) {
      _resultColor = Color(0xFFEA2C2C);
    }
    return SizedBox(
      height: 140,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: const [
              Expanded(child: ColoredBox(color: Colors.white)),
              Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      gradient: LinearGradient(
                    colors: [Colors.white, FightClubColors.darkPurple],
                  )),
                ),
              ),
              Expanded(child: ColoredBox(color: FightClubColors.darkPurple))
            ],
          ),
          Row(
            children: [
              Expanded(
                child: Container(
                  margin:
                      EdgeInsets.only(left: 30, bottom: 12, top: 12, right: 2),
                  child: Column(
                    children: [
                      Text(
                        "You",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Image.asset(
                        FightClubImages.youAvatar,
                        height: 92,
                        width: 92,
                      )
                    ],
                  ),
                ),
              ),
              Container(
                width: 72,
                height: 44,
                margin:
                    EdgeInsets.only(top: 53, bottom: 43, left: 24, right: 24),
                decoration: BoxDecoration(
                    color: _resultColor,
                    borderRadius: BorderRadius.circular(22)),
                child: Center(
                    child: Text(fightResult.result.toLowerCase(),
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: FightClubColors.whiteText,
                          fontSize: 16,
                        ))),
              ),
              Expanded(
                child: Container(
                  margin:
                      EdgeInsets.only(left: 2, bottom: 12, top: 12, right: 30),
                  child: Column(
                    children: [
                      Text(
                        "Enemy",
                        textAlign: TextAlign.center,
                        style: TextStyle(fontSize: 14),
                      ),
                      SizedBox(height: 10),
                      Image.asset(
                        FightClubImages.enemyAvatar,
                        height: 92,
                        width: 92,
                      )
                    ],
                  ),
                ),
              )
            ],
          )
        ],
      ),
    );
  }
}
