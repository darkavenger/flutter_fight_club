// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  BodyPart? defendedBodyPart;
  BodyPart? attackedBodyPart;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ColoredBox(
        color: Color(0xFFD5DEF0),
        child: Column(
          children: [
            SizedBox(height: 59),
            Row(
              // ignore: prefer_const_literals_to_create_immutables
              children: [
                SizedBox(width: 16),
                Expanded(
                    child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Center(child: Text("You")),
                    SizedBox(height: 11),
                    Center(child: Text("1")),
                    SizedBox(height: 4),
                    Center(child: Text("1")),
                    SizedBox(height: 4),
                    Center(child: Text("1")),
                    SizedBox(height: 4),
                    Center(child: Text("1")),
                    SizedBox(height: 4),
                    Center(child: Text("1")),
                  ],
                )),
                SizedBox(width: 12),
                Expanded(
                    child: Column(
                  // ignore: prefer_const_literals_to_create_immutables
                  children: [
                    Center(child: Text("Enemy")),
                    SizedBox(height: 11),
                    Center(child: Text("1")),
                    SizedBox(height: 4),
                    Center(child: Text("1")),
                    SizedBox(height: 4),
                    Center(child: Text("1")),
                    SizedBox(height: 4),
                    Center(child: Text("1")),
                    SizedBox(height: 4),
                    Center(child: Text("1")),
                  ],
                )),
                SizedBox(width: 16),
              ],
            ),
            Expanded(child: SizedBox()),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    children: [
                      Text("Defend".toUpperCase()),
                      SizedBox(height: 13),
                      BodyPartButton(
                        bodyPart: BodyPart.head,
                        selected: defendedBodyPart == BodyPart.head,
                        bodyPartSetter: _selectDefendingBodyPart,
                      ),
                      SizedBox(height: 14),
                      BodyPartButton(
                        bodyPart: BodyPart.torso,
                        selected: defendedBodyPart == BodyPart.torso,
                        bodyPartSetter: _selectDefendingBodyPart,
                      ),
                      SizedBox(height: 14),
                      BodyPartButton(
                        bodyPart: BodyPart.legs,
                        selected: defendedBodyPart == BodyPart.legs,
                        bodyPartSetter: _selectDefendingBodyPart,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    children: [
                      Text("Attack".toUpperCase()),
                      SizedBox(height: 13),
                      BodyPartButton(
                        bodyPart: BodyPart.head,
                        selected: attackedBodyPart == BodyPart.head,
                        bodyPartSetter: _selectAttackingBodyPart,
                      ),
                      SizedBox(height: 14),
                      BodyPartButton(
                        bodyPart: BodyPart.torso,
                        selected: attackedBodyPart == BodyPart.torso,
                        bodyPartSetter: _selectAttackingBodyPart,
                      ),
                      SizedBox(height: 14),
                      BodyPartButton(
                        bodyPart: BodyPart.legs,
                        selected: attackedBodyPart == BodyPart.legs,
                        bodyPartSetter: _selectAttackingBodyPart,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            SizedBox(height: 14),
            Row(
              children: [
                const SizedBox(width: 16),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() {
                      defendedBodyPart = null;
                      attackedBodyPart = null;
                    }),
                    child: SizedBox(
                      height: 40,
                      child: ColoredBox(
                        color:
                            defendedBodyPart == null || attackedBodyPart == null
                                ? Color(0x61000000)
                                : Color(0xDE000000),
                        child: Center(
                          child: Text(
                            "Go".toUpperCase(),
                            style: TextStyle(
                                color: Color.fromRGBO(255, 255, 255, 0.87),
                                fontWeight: FontWeight.w900,
                                fontSize: 16),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 16),
              ],
            ),
            SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  void _selectDefendingBodyPart(BodyPart value) {
    setState(() {
      defendedBodyPart = value;
    });
  }

  void _selectAttackingBodyPart(BodyPart value) {
    setState(() {
      attackedBodyPart = value;
    });
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
        child: ColoredBox(
          color: selected ? Color(0xFF1C79CE) : Color(0x61000000),
          child: Center(child: Text(bodyPart.name.toUpperCase())),
        ),
      ),
    );
  }
}
