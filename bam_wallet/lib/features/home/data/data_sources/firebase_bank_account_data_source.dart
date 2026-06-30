import 'package:bam_wallet/features/home/data/models/bank_account.dart';
import 'package:bam_wallet/features/home/data/models/transfer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bam_wallet/features/home/data/data_sources/bank_account_data_source.dart';

class FirebaseBankAccountDataSource implements BankAccountDataSource {
  final FirebaseFirestore _firestore;

  FirebaseBankAccountDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<BankAccount>> getAllAccounts() async {
    try {
      final querySnapshot = await _firestore.collection('accounts').get();

      final accounts = querySnapshot.docs.map((doc) {
        try {
          return BankAccount.fromJson(doc.data());
        } catch (e) {
          rethrow;
        }
      }).toList();

      return accounts;
    } on FirebaseException catch (e) {
      final errorMsg = 'Firebase Error (${e.code}): ${e.message}';
      throw Exception(errorMsg);
    } catch (e) {
      final errorMsg = 'Error al obtener cuentas: $e';
      throw Exception(errorMsg);
    }
  }

  @override
  Future<List<Transfer>> getAllTransfers() async {
    try {
      final querySnapshot = await _firestore
          .collection('history_accounts')
          .get();

      final transfers = querySnapshot.docs.map((doc) {
        try {
          final data = doc.data();

          // Convertir Timestamp a DateTime si es necesario
          if (data['date'] is Timestamp) {
            data['date'] = (data['date'] as Timestamp)
                .toDate()
                .toIso8601String();
          }

          return Transfer.fromJson(data);
        } catch (e) {
          print('Error parsing transfer document: $e');
          print('Raw document data: ${doc.data()}');
          rethrow;
        }
      }).toList();

      return transfers;
    } on FirebaseException catch (e) {
      final errorMsg = 'Firebase Error (${e.code}): ${e.message}';
      throw Exception(errorMsg);
    } catch (e) {
      final errorMsg = 'Error al obtener transferencias: $e';
      throw Exception(errorMsg);
    }
  }
}
