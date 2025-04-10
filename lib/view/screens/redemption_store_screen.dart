import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controller/bloc/transaction_cubit.dart';
import '../../controller/constants/constants.dart';
import '../../controller/bloc/coin_cubit.dart';
import '../../model/transaction_model.dart';
import '../widgets/dialogs.dart';

class RedemptionStoreScreen extends StatelessWidget {
  RedemptionStoreScreen({super.key});

  final List<Map<String, dynamic>> items = [
    {
      'image': 'assets/images/item1.jpg',
      'name': 'Discount Coupon',
      'price': 99,
    },
    {
      'image': 'assets/images/item2.jpg',
      'name': 'Gift Card',
      'price': 999,
    },
    {
      'image': 'assets/images/item3.jpeg',
      'name': 'Special Voucher',
      'price': 1199,
    },
    {
      'image': 'assets/images/item4.jpg',
      'name': 'Premium Access',
      'price': 1299,
    },
  ];

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: whiteColor,
        elevation: 0,
        title: Text(
          'Redemption Store',
          style: headingTextStyle(mediaQuery),
        ),
      ),
      body: BlocBuilder<CoinCubit, int>(
        builder: (context, userCoinBalance) {
          return Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12.0),
            child: GridView.builder(
              itemCount: items.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 12,
                mainAxisSpacing: 12,
                childAspectRatio: 0.75,
              ),
              itemBuilder: (context, index) {
                final item = items[index];

                return Card(
                  color: whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                    side: const BorderSide(color: darkBlueColor, width: 2),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          child: Image.asset(
                            item['image'],
                            fit: BoxFit.contain,
                          ),
                        ),
                        const SizedBox(height: 12),
                        Text(
                          item['name'],
                          style: productTextStyle,
                          textAlign: TextAlign.center,
                        ),
                        const SizedBox(height: 8),
                        Text(
                          '${item['price']} Coins',
                          style: subtitleTextStyle(mediaQuery)
                              .copyWith(fontSize: mediaQuery.height * 0.017),
                        ),
                        const SizedBox(height: 12),
                        ElevatedButton(
                          onPressed: () {
                            if (userCoinBalance >= item['price']) {
                              showConfirmationDialog(
                                  context, item['name'], item['price']);
                            } else {
                              showFailureDialog(
                                  context, item['name'], item['price']);
                            }
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: darkBlueColor,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8),
                            ),
                          ),
                          child: const Text(
                            'Redeem',
                            style: buttonTextStyle,
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          );
        },
      ),
    );
  }



}
