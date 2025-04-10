import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controller/bloc/coin_cubit.dart';
import '../../controller/bloc/transaction_cubit.dart';
import '../../controller/constants/constants.dart';
import '../../model/transaction_model.dart';

void showSuccessDialog(BuildContext context, String itemName) {
  final updatedBalance = context.read<CoinCubit>().state;

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        'Redemption Successful!',
        textAlign: TextAlign.center,
        style: alertTextStyle(mediaQuery),
      ),
      content: Text(
        'Congratulations! You have redeemed "$itemName".\n\nYour current balance is $updatedBalance coins.',
        textAlign: TextAlign.center,
        style: subtitleTextStyle(mediaQuery).copyWith(fontFamily: "MulishBold"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void showFailureDialog(BuildContext context, String itemName, int itemPrice) {
  context.read<TransactionCubit>().addTransaction(
        Transaction(
          date: DateTime.now(),
          type: "Unsuccessful",
          amount: 0,
        ),
      );

  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        'Insufficient Coins',
        textAlign: TextAlign.center,
        style: alertTextStyle(mediaQuery),
      ),
      content: Text(
        'You do not have enough coins to redeem "$itemName" (costs $itemPrice coins).',
        textAlign: TextAlign.center,
        style: subtitleTextStyle(mediaQuery).copyWith(fontFamily: "MulishBold"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('OK'),
        ),
      ],
    ),
  );
}

void showConfirmationDialog(
    BuildContext context, String itemName, int itemPrice) {
  showDialog(
    context: context,
    builder: (_) => AlertDialog(
      title: Text(
        'Confirm Redemption',
        textAlign: TextAlign.center,
        style: alertTextStyle(mediaQuery),
      ),
      content: Text(
        'Are you sure you want to redeem "$itemName" for $itemPrice coins?',
        style: subtitleTextStyle(mediaQuery).copyWith(fontFamily: "MulishBold"),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.of(context).pop(),
          child: const Text('No'),
        ),
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
            context.read<CoinCubit>().spendCoins(itemPrice);
            context.read<TransactionCubit>().addTransaction(
                  Transaction(
                    date: DateTime.now(),
                    type: "Redeemed Item",
                    amount: -itemPrice,
                  ),
                );

            showSuccessDialog(context, itemName);
          },
          child: const Text('Yes'),
        ),
      ],
    ),
  );
}
