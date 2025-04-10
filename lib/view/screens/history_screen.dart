import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../controller/constants/constants.dart';
import '../../controller/bloc/transaction_cubit.dart';
import '../../model/transaction_model.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  String selectedType = 'All';
  DateTimeRange? selectedDateRange;

  @override
  Widget build(BuildContext context) {
    mediaQuery = MediaQuery.sizeOf(context);

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: whiteColor,
        elevation: 0,
        title: Text(
          'Transaction History',
          style: headingTextStyle(mediaQuery),
        ),
      ),
      body: Column(
        children: [
          _buildFilters(context),
          Expanded(
            child: BlocBuilder<TransactionCubit, List<Transaction>>(
              builder: (context, transactions) {
                final filtered = _applyFilters(transactions);
                return filtered.isEmpty
                    ? Center(
                        child: Text(
                        "No transactions found!",
                        style: headingTextStyle(mediaQuery).copyWith(
                            color: greyColor,
                            fontSize: 20,
                            fontFamily: "MulishMedium"),
                      ))
                    : ListView.builder(
                        itemCount: filtered.length,
                        itemBuilder: (context, index) {
                          final tx = filtered[index];
                          return Card(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 8),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                              side: BorderSide(color: darkBlueColor),
                            ),
                            child: ListTile(
                              title: Text(
                                tx.type,
                                style: subtitleTextStyle(mediaQuery),
                              ),
                              subtitle: Text(
                                _formatDate(tx.date),
                                style: TextStyle(
                                    fontSize: mediaQuery.height * 0.018),
                              ),
                              trailing: tx.type == 'Unsuccessful'
                                  ? Text(
                                      'Failed',
                                      style: TextStyle(
                                        fontSize: mediaQuery.height * 0.02,
                                        color: greyColor,
                                        fontFamily: "MulishBold",
                                      ),
                                    )
                                  : Text(
                                      '${tx.amount > 0 ? '+' : ''}${tx.amount} Coins',
                                      style: TextStyle(
                                        fontSize: mediaQuery.height * 0.02,
                                        color: tx.amount > 0
                                            ? greenColor
                                            : redColor,
                                        fontFamily: "MulishBold",
                                      ),
                                    ),
                            ),
                          );
                        },
                      );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildFilters(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: DropdownButtonFormField<String>(
                  value: selectedType,
                  decoration: const InputDecoration(
                      labelText: 'Transaction Type',
                      labelStyle:
                          TextStyle(fontFamily: "MulishBold", fontSize: 18)),
                  items: [
                    'All',
                    'Scratch Card Reward',
                    'Redeemed Item',
                    'Unsuccessful'
                  ]
                      .map((type) =>
                          DropdownMenuItem(value: type, child: Text(type)))
                      .toList(),
                  onChanged: (value) => setState(() => selectedType = value!),
                ),
              ),
              const SizedBox(width: 12),
              ElevatedButton(
                onPressed: () async {
                  final picked = await showDateRangePicker(
                    context: context,
                    firstDate: DateTime(2023),
                    lastDate: DateTime.now(),
                  );
                  if (picked != null) {
                    setState(() => selectedDateRange = picked);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: darkBlueColor,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                ),
                child: Text(
                  'Filter by Date',
                  style: subtitleTextStyle(mediaQuery).copyWith(
                      color: whiteColor,
                      fontSize: 15,
                      fontFamily: "MulishBold"),
                ),
              ),
            ],
          ),
          if (selectedDateRange != null)
            Padding(
              padding: const EdgeInsets.only(top: 8),
              child: Row(
                children: [
                  Text(
                    '${_formatDate(selectedDateRange!.start)} - ${_formatDate(selectedDateRange!.end)}',
                    style: TextStyle(fontSize: mediaQuery.height * 0.015),
                  ),
                  const Spacer(),
                  TextButton(
                    onPressed: () => setState(() => selectedDateRange = null),
                    child: const Text(
                      'Clear Date Filter',
                      style: TextStyle(
                          fontFamily: 'MulishBold', color: darkBlueColor),
                    ),
                  )
                ],
              ),
            ),
        ],
      ),
    );
  }

  List<Transaction> _applyFilters(List<Transaction> transactions) {
    return transactions.where((tx) {
      if (selectedType != 'All' && tx.type != selectedType) return false;

      if (selectedDateRange != null) {
        final date = tx.date;
        if (date.isBefore(selectedDateRange!.start) ||
            date.isAfter(selectedDateRange!.end)) {
          return false;
        }
      }

      return true;
    }).toList();
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year} ${date.hour}:${date.minute.toString().padLeft(2, '0')}";
  }
}
