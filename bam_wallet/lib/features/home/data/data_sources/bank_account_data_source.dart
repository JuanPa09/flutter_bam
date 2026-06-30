import 'package:bam_wallet/features/home/data/models/bank_account_model.dart';
import 'package:bam_wallet/features/home/data/models/transfer_model.dart';

interface class BankAccountDataSource {
  BankAccountDataSource();

  Future<List<BankAccountModel>> getAllAccounts() async {
    return [];
  }

  Future<List<TransferModel>> getAllTransfers() async {
    return [];
  }
}
