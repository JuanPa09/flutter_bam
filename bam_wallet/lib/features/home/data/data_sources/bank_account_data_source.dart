import 'package:bam_wallet/features/home/data/models/bank_account_model.dart';
import 'package:bam_wallet/features/home/data/models/transfer_model.dart';

typedef TransferPageResult = ({
  List<TransferModel> items,
  bool hasMore,
  String? lastId,
});

interface class BankAccountDataSource {
  BankAccountDataSource();

  Future<List<BankAccountModel>> getAllAccounts() async {
    return [];
  }

  Future<List<TransferModel>> getAllTransfers() async {
    return [];
  }

  Future<TransferPageResult> getTransfersPage({
    String? afterDocumentId,
    int limit = 10,
  }) async {
    return (items: <TransferModel>[], hasMore: false, lastId: null);
  }
}
