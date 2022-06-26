import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import "package:flutter/material.dart";
import 'package:save_your_ass/components/alert.dart';
import 'package:save_your_ass/components/list.dart';
import 'package:save_your_ass/components/reusable_card.dart';
import 'package:save_your_ass/constant.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:save_your_ass/model/sit.dart';
import 'package:save_your_ass/model/sit_type.dart';
import 'package:save_your_ass/utils/get_series.dart';

class UserScreen extends StatefulWidget {
  static const String id = "user_screen";

  @override
  State<UserScreen> createState() => _UserScreenState();
}



class _UserScreenState extends State<UserScreen> {
  // For login
  late User loggedInUser;
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  // For user's data
  late List<Sit> sitData;
  late List<SitType> pastSit = [];
  int height = 0;
  int weight = 0;
  int age = 0;
  double sitHour = 0;
  int sitScore = 6;

  void getCurrentUser() async {
    // Init the data to avoid error
    for (int i = 0; i < sitNames.length; ++i) {
      pastSit.add(SitType(sitNames[i], 0));
    }
    sitData = [
      Sit("sit", 24, const charts.Color(r: 117, g: 108, b: 95)),
      Sit("not sit", 0, const charts.Color(r: 206, g: 200, b: 191)),
    ];

    try {
      final user = _auth.currentUser;
      if (user != null) {
        loggedInUser = user;
        final temp = await _firestore
            .collection("users")
            .doc(loggedInUser.email!.split("@")[0])
            .get();

        if (temp.data() != null) {
          final userData = temp.data()!;
          setState(() {
            height = userData["height"];
            weight = userData["weight"];
            age = userData["age"];
            sitHour = userData["hour"];
            sitData = [
              Sit("sit", sitHour, const charts.Color(r: 117, g: 108, b: 95)),
              Sit("not sit", 24.0 - sitHour,
                  const charts.Color(r: 206, g: 200, b: 191)),
            ];
            sitScore = userData["score"];
            pastSit = [];
            for (var i = 0; i < sitNames.length; ++i) {
              pastSit.add(
                  SitType(sitNames[i], userData["past_sit"][i].toDouble()));
            }
          });
        } else {
          throw Exception("User data is null");
        }
      }
    } on FirebaseAuthException catch (e) {
      print(e);
    }
  }

  void updateHeight(value) {
    if (height != value) {
      _firestore
          .collection("users")
          .doc(loggedInUser.email!.split("@")[0])
          .update({"height": value});

      setState(() {
        height = value;
      });
    }
  }

  void updateWeight(value) {
    if (weight != value) {
      _firestore
          .collection("users")
          .doc(loggedInUser.email!.split("@")[0])
          .update({"weight": value});

      setState(() {
        weight = value;
      });
    }
  }

  void updateAge(value) {
    if (age != value) {
      _firestore
          .collection("users")
          .doc(loggedInUser.email!.split("@")[0])
          .update({"age": value});

      setState(() {
        age = value;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: const BackButton(color: Color(0xffb0d1aa)),
        actions: <Widget>[
          IconButton(
              icon: const Icon(Icons.close),
              color: const Color(0xffb0d1aa),
              onPressed: () {
                _auth.signOut();
                Navigator.pop(context);
              }),
        ],
        centerTitle: true,
        title: const Text(
          "Save Our Ass Together!",
          style: TextStyle(
            color: Colors.black,
            fontFamily: "MonMed",
          ),
        ),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: CustomScrollView(
          slivers: [
            SliverFillRemaining(
              hasScrollBody: false,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Expanded(
                    child: ReusableCard(
                      onPress: () {
                        getCurrentUser();
                      },
                      color: const Color(0xffd2c68d),
                      cardChild: Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    loggedInUser.email!.split("@")[0],
                                    textAlign: TextAlign.start,
                                    style: kNameTextStyle,
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ModifyUserAlert(
                                          title: "height",
                                          onPress: updateHeight,
                                          oriValue: height,
                                        ),
                                      );
                                    },
                                    child: ListLabel(
                                      title: "Height:",
                                      trailing: "${height}cm",
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ModifyUserAlert(
                                          title: "weight",
                                          onPress: updateWeight,
                                          oriValue: weight,
                                        ),
                                      );
                                    },
                                    child: ListLabel(
                                      title: "Weight:",
                                      trailing: "${weight}kg",
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      showDialog(
                                        context: context,
                                        builder: (context) => ModifyUserAlert(
                                          title: "age",
                                          onPress: updateAge,
                                          oriValue: age,
                                        ),
                                      );
                                    },
                                    child: ListLabel(
                                      title: "Age:",
                                      trailing: "${age}yr",
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                              child: SizedBox(
                                width: 100.0,
                                height: 100.0,
                                child: CircleAvatar(
                                  backgroundColor: Colors.white,
                                  child: Image.asset("images/dog.png"),
                                ),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ReusableCard(
                            color: const Color(0xffe7e5d1),
                            cardChild: Center(
                              child: ListTile(
                                contentPadding: const EdgeInsets.all(0.0),
                                title: Text(
                                  scoreMap[sitScore]!,
                                  textAlign: TextAlign.center,
                                  style: kCommentStyle,
                                ),
                                subtitle: const Text(
                                  "Sitting Score",
                                  textAlign: TextAlign.center,
                                  style: kSubTitleStyle,
                                ),
                              ),
                            ),
                            onPress: () {
                              null;
                            },
                          ),
                        ),
                        Expanded(
                          child: ReusableCard(
                            color: Colors.white,
                            cardChild: Stack(children: [
                              charts.PieChart<String>(
                                getSeriesData(sitData)!,
                                animate: true,
                                defaultRenderer: charts.ArcRendererConfig(
                                  strokeWidthPx: 0,
                                  arcWidth: 15,
                                ),
                              ),
                              Center(
                                child: Text(
                                  "$sitHour hr",
                                  style: const TextStyle(
                                      fontSize: 20.0, color: Color(0xff756c5f)),
                                ),
                              )
                            ]),
                            onPress: () {
                              null;
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    child: ReusableCard(
                      color: const Color(0xffe9f2ce),
                      cardChild: Column(
                        children: [
                          const Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Text(
                                "Sitting Statistics",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                    fontFamily: "MonRegular",
                                    color: Colors.black),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 3,
                            child: charts.BarChart(
                              getBarData(pastSit)!,
                              barRendererDecorator:
                                  charts.BarLabelDecorator<String>(),
                              primaryMeasureAxis: const charts.NumericAxisSpec(
                                renderSpec: charts.NoneRenderSpec(),
                              ),
                              animate: true,
                            ),
                          ),
                        ],
                      ),
                      onPress: () {
                        null;
                      },
                    ),
                  ),
                  Expanded(
                      child: ReusableCard(
                    color: const Color(0xffd7e8d4),
                    onPress: () {
                      null;
                    },
                    cardChild: const Padding(
                      padding: EdgeInsets.all(20.0),
                      child: Center(
                        child: Text(
                          "Stand Stand Stand!",
                          style: kCommentStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ),
                  )),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
