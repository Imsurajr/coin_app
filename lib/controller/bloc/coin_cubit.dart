import 'package:flutter_bloc/flutter_bloc.dart';

class CoinCubit extends Cubit<int> {
  CoinCubit() : super(1000);

  void addCoins(int coins) {
    emit(state + coins);
  }

  void spendCoins(int amount) {
    emit(state - amount);
  }

  void resetCoins() {
    emit(0);
  }

  void setCoins(int coins) {
    emit(coins);
  }
}
