import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_fight_club/fight_result.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';
import 'package:flutter_fight_club/resources/fight_club_icons.dart';
import 'package:flutter_fight_club/resources/fight_club_images.dart';
import 'package:flutter_fight_club/widgets/action_button.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FightPage extends StatefulWidget {
  const FightPage({Key? key}) : super(key: key);

  @override
  FightPageState createState() => FightPageState();
}

class FightPageState extends State<FightPage> {
  static const maxLives = 5;
  BodyPart? defendedBodyPart;
  BodyPart? attackedBodyPart;

  BodyPart whatEnemyAttacks = BodyPart.random();
  BodyPart whatEnemyDefends = BodyPart.random();

  int yourLives = maxLives;
  int enemysLives = maxLives;

  bool gameOver = false;

  String statusText = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: FightClubColors.background,
      body: SafeArea(
        child: Column(
          children: [
            FightersInfo(
                maxLivesCount: maxLives,
                yourLivesCount: yourLives,
                enemysLivesCount: enemysLives),
            Expanded(
              child: Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 30),
                child: SizedBox(
                  width: double.infinity,
                  child: ColoredBox(
                    color: FightClubColors.darkPurple,
                    child: Center(
                      child: Text(
                        statusText,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                            fontSize: 10, color: FightClubColors.darkGreyText),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            ControlsWidget(
              defendedBodyPart: defendedBodyPart,
              attackedBodyPart: attackedBodyPart,
              selectDefendingBodyPart: _selectDefendingBodyPart,
              selectAttackingBodyPart: _selectAttackingBodyPart,
            ),
            SizedBox(height: 14),
            ActionButton(
              text: gameOver ? "Back" : "Go",
              onTap: _onGoButtonClicked,
              color: _getGoButtonColor(),
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  Color _getGoButtonColor() {
    if (gameOver) return FightClubColors.blackButton;

    return defendedBodyPart == null || attackedBodyPart == null
        ? FightClubColors.greyButton
        : FightClubColors.blackButton;
  }

  void _onGoButtonClicked() {
    statusText = "";

    if (gameOver) {
      Navigator.of(context).pop();
      // setState(() {
      //   enemysLives = maxLives;
      //   yourLives = maxLives;
      //   gameOver = false;
      // });
      // return;
    }

    if (defendedBodyPart != null && attackedBodyPart != null) {
      setState(() {
        final bool enemyLoseLife = attackedBodyPart != whatEnemyDefends;
        final bool youLoseLife = defendedBodyPart != whatEnemyAttacks;

        if (enemyLoseLife) {
          enemysLives--;
        }

        if (youLoseLife) {
          yourLives--;
        }

        gameOver = enemysLives == 0 || yourLives == 0;

        statusText = _calculateCenterText(enemyLoseLife, youLoseLife);

        whatEnemyAttacks = BodyPart.random();
        whatEnemyDefends = BodyPart.random();

        defendedBodyPart = null;
        attackedBodyPart = null;
      });
    }
  }

  String _calculateCenterText(
      final bool enemyLoseLife, final bool youLoseLife) {
    if (gameOver) {
      FightResult fightResult = FightResult.draw;
      statusText = "Draw";
      if (enemysLives == 0 && yourLives > 0) {
        statusText = "You won";
        fightResult = FightResult.won;
      }
      if (enemysLives > 0 && yourLives == 0) {
        statusText = "You lost";
        fightResult = FightResult.lost;
      }
      SharedPreferences.getInstance().then((sharedPreferences) {
        sharedPreferences.setInt("lastyourLives", yourLives);
        sharedPreferences.setInt("lastenemysLives", enemysLives);
        int countWon = sharedPreferences.getInt("stats_won") ?? 0;
        int countLost = sharedPreferences.getInt("stats_lost") ?? 0;
        int countDraw = sharedPreferences.getInt("stats_draw") ?? 0;
        switch (fightResult) {
          case FightResult.won:
            countWon++;
            break;
          case FightResult.lost:
            countLost++;
            break;
          case FightResult.draw:
            countDraw++;
            break;
        }
        sharedPreferences.setInt("stats_won", countWon);
        sharedPreferences.setInt("stats_lost", countLost);
        sharedPreferences.setInt("stats_draw", countDraw);
      });
    } else {
      statusText = enemyLoseLife
          ? "You hit enemy's ${attackedBodyPart?.name.toLowerCase()}.\n"
          : statusText = "Your attack was blocked.\n";

      statusText = youLoseLife
          ? statusText +
              "Enemy hit your ${whatEnemyAttacks.name.toLowerCase()}."
          : statusText = statusText + "Enemy's attack was blocked.";
    }
    return statusText;
  }

  void _selectDefendingBodyPart(BodyPart value) {
    if (gameOver) return;
    setState(() {
      defendedBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(BodyPart value) {
    if (gameOver) return;
    setState(() {
      attackedBodyPart = value;
    });
  }
}

class ControlsWidget extends StatelessWidget {
  final BodyPart? defendedBodyPart;
  final BodyPart? attackedBodyPart;
  final ValueSetter<BodyPart> selectDefendingBodyPart;
  final ValueSetter<BodyPart> selectAttackingBodyPart;

  const ControlsWidget({
    Key? key,
    required this.defendedBodyPart,
    required this.attackedBodyPart,
    required this.selectDefendingBodyPart,
    required this.selectAttackingBodyPart,
  }) : super(key: key);

  //  const ControlsWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            children: [
              Text(
                "Defend".toUpperCase(),
                style: TextStyle(color: FightClubColors.darkGreyText),
              ),
              SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: defendedBodyPart == BodyPart.head,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: defendedBodyPart == BodyPart.torso,
                bodyPartSetter: selectDefendingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: defendedBodyPart == BodyPart.legs,
                bodyPartSetter: selectDefendingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            children: [
              Text("Attack".toUpperCase(),
                  style: TextStyle(color: FightClubColors.darkGreyText)),
              SizedBox(height: 13),
              BodyPartButton(
                bodyPart: BodyPart.head,
                selected: attackedBodyPart == BodyPart.head,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.torso,
                selected: attackedBodyPart == BodyPart.torso,
                bodyPartSetter: selectAttackingBodyPart,
              ),
              SizedBox(height: 14),
              BodyPartButton(
                bodyPart: BodyPart.legs,
                selected: attackedBodyPart == BodyPart.legs,
                bodyPartSetter: selectAttackingBodyPart,
              ),
            ],
          ),
        ),
        const SizedBox(width: 16),
      ],
    );
  }
}

class FightersInfo extends StatelessWidget {
  final int maxLivesCount;
  final int yourLivesCount;
  final int enemysLivesCount;

  const FightersInfo({
    Key? key,
    required this.maxLivesCount,
    required this.yourLivesCount,
    required this.enemysLivesCount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 160,
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              const Expanded(child: ColoredBox(color: Colors.white)),
              const Expanded(
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.white, FightClubColors.darkPurple],
                    ),
                  ),
                ),
              ),
              const Expanded(
                  child: ColoredBox(color: FightClubColors.darkPurple))
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            // ignore: prefer_const_literals_to_create_immutables
            children: [
              LivesWidget(
                  overallLivesCount: maxLivesCount,
                  currentLivesCount: yourLivesCount),
              SizedBox(width: 16),
              Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  SizedBox(height: 16),
                  Text("You",
                      style: TextStyle(color: FightClubColors.darkGreyText)),
                  SizedBox(height: 12),
                  Image.asset(
                    FightClubImages.youAvatar,
                    width: 92,
                    height: 92,
                  ),
                ],
              ),
              SizedBox(
                height: 44,
                width: 44,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: FightClubColors.blueButton),
                  child: Center(
                    child: Text(
                      "vs",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
              ),
              Column(
                // ignore: prefer_const_literals_to_create_immutables
                children: [
                  SizedBox(height: 16),
                  Text("Enemy",
                      style: TextStyle(color: FightClubColors.darkGreyText)),
                  SizedBox(height: 12),
                  Image.asset(
                    FightClubImages.enemyAvatar,
                    width: 92,
                    height: 92,
                  )
                ],
              ),
              SizedBox(width: 16),
              LivesWidget(
                  overallLivesCount: maxLivesCount,
                  currentLivesCount: enemysLivesCount),
            ],
          ),
        ],
      ),
    );
  }
}

class LivesWidget extends StatelessWidget {
  final int overallLivesCount;
  final int currentLivesCount;

  const LivesWidget({
    Key? key,
    required this.overallLivesCount,
    required this.currentLivesCount,
  })  : assert(overallLivesCount >= 1),
        assert(currentLivesCount >= 0),
        assert(currentLivesCount <= overallLivesCount),
        super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 106,
      child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: List.generate(overallLivesCount, (index) {
            String imageName = currentLivesCount > index
                ? FightClubIcons.heartFull
                : FightClubIcons.heartEmpty;
            return Image.asset(imageName, width: 18, height: 18);
          })),
    );
  }
}

class BodyPart {
  final String name;

  const BodyPart._(this.name);

  static const head = BodyPart._("Head");
  static const torso = BodyPart._("Torso");
  static const legs = BodyPart._("Legs");

  @override
  String toString() => 'BodyPart(name: $name)';

  static const List<BodyPart> _values = [head, torso, legs];
  static BodyPart random() {
    return _values[Random().nextInt(_values.length)];
  }
}

class BodyPartButton extends StatelessWidget {
  final BodyPart bodyPart;
  final bool selected;
  final ValueSetter<BodyPart> bodyPartSetter;

  const BodyPartButton({
    Key? key,
    required this.bodyPart,
    required this.selected,
    required this.bodyPartSetter,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => bodyPartSetter(bodyPart),
      child: SizedBox(
        height: 40,
        child: DecoratedBox(
          decoration: BoxDecoration(
              color: selected ? FightClubColors.blueButton : Colors.transparent,
              border: !selected
                  ? Border.all(color: FightClubColors.darkGreyText, width: 2)
                  : null),
          child: Center(
              child: Text(
            bodyPart.name.toUpperCase(),
            style: TextStyle(
              color: selected
                  ? FightClubColors.whiteText
                  : FightClubColors.darkGreyText,
            ),
          )),
        ),
      ),
    );
  }
}
