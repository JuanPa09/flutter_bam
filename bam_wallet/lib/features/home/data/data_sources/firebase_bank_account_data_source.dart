import 'package:bam_wallet/features/home/data/models/bank_account_model.dart';
import 'package:bam_wallet/features/home/data/models/transfer_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:bam_wallet/features/home/data/data_sources/bank_account_data_source.dart';

const String _kCollection = 'history_accounts';

class FirebaseBankAccountDataSource implements BankAccountDataSource {
  final FirebaseFirestore _firestore;

  FirebaseBankAccountDataSource({FirebaseFirestore? firestore})
    : _firestore = firestore ?? FirebaseFirestore.instance;

  @override
  Future<List<BankAccountModel>> getAllAccounts() async {
    try {
      final querySnapshot = await _firestore.collection('accounts').get();

      final accounts = querySnapshot.docs.map((doc) {
        try {
          return BankAccountModel.fromJson(doc.data());
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
  Future<List<TransferModel>> getAllTransfers() async {
    try {
      final querySnapshot = await _firestore.collection(_kCollection).get();

      final transfers = querySnapshot.docs.map((doc) {
        try {
          final data = doc.data();

          // Convertir Timestamp a DateTime si es necesario
          if (data['date'] is Timestamp) {
            data['date'] = (data['date'] as Timestamp)
                .toDate()
                .toIso8601String();
          }

          return TransferModel.fromJson(data);
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

  @override
  Future<TransferPageResult> getTransfersPage({
    String? afterDocumentId,
    int limit = 10,
  }) async {
    try {
      Query<Map<String, dynamic>> query = _firestore
          .collection(_kCollection)
          .orderBy('date', descending: true)
          .limit(limit + 1);

      if (afterDocumentId != null) {
        final cursor = await _firestore
            .collection(_kCollection)
            .doc(afterDocumentId)
            .get();
        if (cursor.exists) query = query.startAfterDocument(cursor);
      }

      final snapshot = await query.get();
      final hasMore = snapshot.docs.length > limit;
      final docs = hasMore ? snapshot.docs.take(limit).toList() : snapshot.docs;

      final items = docs.map((doc) {
        final data = Map<String, dynamic>.from(doc.data());
        if (data['date'] is Timestamp) {
          data['date'] = (data['date'] as Timestamp).toDate().toIso8601String();
        }
        return TransferModel.fromJson(data);
      }).toList();

      return (
        items: items,
        hasMore: hasMore,
        lastId: docs.isNotEmpty ? docs.last.id : null,
      );
    } on FirebaseException catch (e) {
      throw Exception('Firebase Error (${e.code}): ${e.message}');
    } catch (e) {
      throw Exception('Error al obtener página de transferencias: $e');
    }
  }

  @override
  Future<void> saveTransfer(TransferModel transfer) async {
    try {
      await _firestore
          .collection(_kCollection)
          .doc(transfer.id)
          .set(transfer.toJson());
    } on FirebaseException catch (e) {
      throw Exception('Firebase Error (${e.code}): ${e.message}');
    } catch (e) {
      throw Exception('Error al guardar transferencia: $e');
    }
  }

  @override
  Future<void> updateAccountBalance({
    required String accountNumber,
    required double newBalance,
  }) async {
    try {
      final querySnapshot = await _firestore
          .collection('accounts')
          .where('accountNumber', isEqualTo: accountNumber)
          .get();

      if (querySnapshot.docs.isEmpty) {
        throw Exception('Account not found');
      }

      // Obtener el documento de la cuenta
      final accountDoc = querySnapshot.docs.first;

      // Actualizar el balance
      await accountDoc.reference.update({'balance': newBalance});
    } on FirebaseException catch (e) {
      throw Exception('Firebase Error (${e.code}): ${e.message}');
    } catch (e) {
      throw Exception('Error al actualizar balance: $e');
    }
  }
}
