import 'package:flutter_bloc/flutter_bloc.dart';
import '../../model/transaction_model.dart';

class TransactionCubit extends Cubit<List<Transaction>> {
  TransactionCubit() : super([]);

  void addTransaction(Transaction transaction) {
    final updatedList = List<Transaction>.from(state)..add(transaction);
    emit(updatedList);
  }

  void clearHistory() {
    emit([]);
  }
}
