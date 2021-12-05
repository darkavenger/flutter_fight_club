import 'package:flutter/material.dart';
import 'package:flutter_fight_club/resources/fight_club_colors.dart';

class SecondaryActionButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const SecondaryActionButton({
    Key? key,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16),
        height: 40,
        alignment: Alignment.center,
        // color: Colors.transparent,
        decoration: BoxDecoration(
          color: Colors.transparent,
          border: Border.all(
            color: FightClubColors.darkGreyText,
            width: 2,
          ),
        ),
        child: Text(
          text.toUpperCase(),
          style: const TextStyle(
            color: FightClubColors.darkGreyText,
            fontWeight: FontWeight.w400,
            fontSize: 13,
          ),
        ),
      ),
    );
  }
}
