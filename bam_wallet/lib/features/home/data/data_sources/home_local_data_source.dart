import 'package:bam_wallet/features/home/data/data_sources/home_data_source.dart';
import 'package:bam_wallet/features/home/data/models/bank_account.dart';
import 'package:bam_wallet/features/home/data/models/transfer.dart';

class HomeLocalDataSource implements HomeDataSource {
  static const List<BankAccount> _accounts = [
    BankAccount(
      id: '1',
      name: 'Cuenta Monetaria',
      accountNumber: '1234567890',
      holderName: 'Test User',
      balance: 15420.50,
      currency: 'GTQ',
      status: 'Activa',
    ),
    BankAccount(
      id: '2',
      name: 'Cuenta Ahorro',
      accountNumber: '0987654321',
      holderName: 'Test User',
      balance: 8320.00,
      currency: 'GTQ',
      status: 'Activa',
    ),
    BankAccount(
      id: '3',
      name: 'Cuenta Corriente',
      accountNumber: '5555666677',
      holderName: 'Test User',
      balance: 2100.75,
      currency: 'GTQ',
      status: 'Activa',
    ),
  ];

  static final List<Transfer> _transfers = [
    Transfer(
      id: '1',
      fromAccountNumber: '1234567890',
      toAccountNumber: '1111222233',
      fromHolder: 'Test User',
      toHolder: 'María López',
      amount: 500.00,
      currency: 'GTQ',
      date: DateTime.now().subtract(const Duration(days: 1)),
      isOutgoing: true,
    ),
    Transfer(
      id: '2',
      fromAccountNumber: '4444555566',
      toAccountNumber: '1234567890',
      fromHolder: 'Juan Pérez',
      toHolder: 'Test User',
      amount: 1200.50,
      currency: 'GTQ',
      date: DateTime.now().subtract(const Duration(days: 2)),
      isOutgoing: false,
    ),
    Transfer(
      id: '3',
      fromAccountNumber: '1234567890',
      toAccountNumber: '7777888899',
      fromHolder: 'Test User',
      toHolder: 'Ana García',
      amount: 250.00,
      currency: 'GTQ',
      date: DateTime.now().subtract(const Duration(days: 3)),
      isOutgoing: true,
    ),
    Transfer(
      id: '4',
      fromAccountNumber: '3333444455',
      toAccountNumber: '0987654321',
      fromHolder: 'Carlos Martínez',
      toHolder: 'Test User',
      amount: 3500.00,
      currency: 'GTQ',
      date: DateTime.now().subtract(const Duration(days: 5)),
      isOutgoing: false,
    ),
  ];

  @override
  Future<List<BankAccount>> getAccounts() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _accounts;
  }

  @override
  Future<List<Transfer>> getTransfers() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return _transfers;
  }
}
