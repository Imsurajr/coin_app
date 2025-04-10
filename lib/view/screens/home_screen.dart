import 'package:coin_app/view/screens/history_screen.dart';
import 'package:coin_app/view/screens/redemption_store_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:async';
import 'dart:math';
import '../../controller/bloc/coin_cubit.dart';
import '../../controller/bloc/transaction_cubit.dart';
import '../../controller/constants/constants.dart';
import '../../controller/bloc/scratch_time_cubit.dart';
import '../../model/transaction_model.dart';
import '../widgets/widgets.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int rewardAmount = 0;
  bool scratched = false;
  DateTime? nextScratchTime;
  List<Offset> scratchPoints = [];

  void handleScratch(Offset point) {
    if (!scratched &&
        (nextScratchTime == null || DateTime.now().isAfter(nextScratchTime!))) {
      setState(() {
        scratchPoints.add(point);

        if (scratchPoints.length > 30) {
          rewardAmount = Random().nextInt(451) + 50;
          context.read<CoinCubit>().addCoins(rewardAmount);
          context.read<TransactionCubit>().addTransaction(
                Transaction(
                  date: DateTime.now(),
                  type: "Scratch Card Reward",
                  amount: rewardAmount,
                ),
              );
          scratched = true;
          nextScratchTime = DateTime.now().add(const Duration(hours: 1));

          context.read<ScratchTimerCubit>().startTimer(nextScratchTime!);

          Future.delayed(const Duration(seconds: 2), () {
            setState(() {
              scratchPoints.clear();
            });
          });
        }
      });
    }
  }

  void _onMenuOptionSelected(String option) {
    if (option == 'store') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => RedemptionStoreScreen()),
      );
    } else if (option == 'history') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HistoryScreen()),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.sizeOf(context);

    return BlocListener<ScratchTimerCubit, String>(
      listener: (context, countdown) {
        if (countdown == "Now") {
          setState(() {
            scratched = false;
            nextScratchTime = null;
            scratchPoints.clear();
          });
        }
      },
      child: Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0,
          title: Text(
            appName,
            style:
                constantTextStyle.copyWith(color: darkBlueColor, fontSize: 30),
          ),
          actions: [
            PopupMenuButton<String>(
              icon: Icon(
                Icons.menu_rounded,
                color: darkBlueColor,
                size: 28,
              ),
              onSelected: _onMenuOptionSelected,
              itemBuilder: (context) => [
                PopupMenuItem(
                  value: 'store',
                  child: Text(
                    'Redemption Store',
                    style: subtitleTextStyle(mediaQuery).copyWith(
                        color: darkBlueColor, fontFamily: 'MulishBold'),
                  ),
                ),
                PopupMenuItem(
                  value: 'history',
                  child: Text('History',
                      style: subtitleTextStyle(mediaQuery).copyWith(
                          color: darkBlueColor, fontFamily: 'MulishBold')),
                ),
              ],
            ),
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0).copyWith(top: 30),
          child: Column(
            children: [
              BlocBuilder<CoinCubit, int>(
                builder: (context, coinBalance) {
                  return Padding(
                    padding: EdgeInsets.only(bottom: mediaQuery.height * 0.05),
                    child: Card(
                      color: darkBlueColor,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Current Coin Balance: $coinBalance",
                                  style: constantTextStyle,
                                  overflow: TextOverflow.ellipsis,
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Text(
                                  "Scratch the card below to earn \n more coins!",
                                  textAlign: TextAlign.center,
                                  style: constantTextStyle.copyWith(
                                      color: Colors.white70,
                                      fontSize: 15,
                                      fontFamily: "MulishMedium"),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
              GestureDetector(
                onPanUpdate: (details) {
                  final renderBox = context.findRenderObject() as RenderBox;
                  final localPosition =
                      renderBox.globalToLocal(details.localPosition);
                  handleScratch(localPosition);
                },
                child: Stack(
                  children: [
                    Container(
                      height: 200,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(16),
                        boxShadow: const [
                          BoxShadow(
                              color: Colors.black26,
                              blurRadius: 8,
                              offset: Offset(0, 4)),
                        ],
                      ),
                      child: scratched
                          ? Center(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Congratulations! You earned $rewardAmount coins!",
                                    textAlign: TextAlign.center,
                                    style: headingTextStyle(mediaQuery),
                                  ),
                                  const SizedBox(height: 12),
                                  BlocBuilder<ScratchTimerCubit, String>(
                                    builder: (context, countdown) {
                                      return Text(
                                        "Next scratch available in:\n$countdown",
                                        textAlign: TextAlign.center,
                                        style: subtitleTextStyle(mediaQuery),
                                      );
                                    },
                                  ),
                                ],
                              ),
                            )
                          : BlocBuilder<ScratchTimerCubit, String>(
                              builder: (context, countdown) {
                                return Center(
                                  child: Text(
                                    (nextScratchTime != null &&
                                            DateTime.now()
                                                .isBefore(nextScratchTime!))
                                        ? "Next scratch in $countdown"
                                        : "Scratch to Win!",
                                    style: const TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w700),
                                  ),
                                );
                              },
                            ),
                    ),
                    if (!scratched &&
                        (nextScratchTime == null ||
                            DateTime.now().isAfter(nextScratchTime!)))
                      CustomPaint(
                        size: const Size(double.infinity, 200),
                        painter: ScratchPainter(scratchPoints),
                      ),
                  ],
                ),
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}
