import 'package:coin_app/view/screens/home_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'controller/bloc/coin_cubit.dart';
import 'controller/bloc/scratch_time_cubit.dart';
import 'controller/bloc/transaction_cubit.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [

        BlocProvider(create: (context) => ScratchTimerCubit()),
        BlocProvider(create: (context) => CoinCubit()),
        BlocProvider(create: (_) => TransactionCubit()),

      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: HomeScreen(),
      ),
    );
  }
}
