import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/AccountModel.dart';

class AccountService {
  final CollectionReference accountsCollection =
  FirebaseFirestore.instance.collection('accounts');

  Future<List<AccountModel>> getAccounts() async {
    final snapshot = await accountsCollection.get();
    return snapshot.docs
        .map((doc) => AccountModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList();
  }

  Future<bool> addAccount(AccountModel account) async {
    try {
      await accountsCollection.doc(account.id).set(account.toMap());
      return true;
    } catch (e) {
      print("Error adding account: $e");
      return false;
    }
  }

  Future<bool> removeAccount(String id) async {
    try {
      await accountsCollection.doc(id).delete();
      return true;
    } catch (e) {
      print("Error adding account: $e");
      return false;
    }
  }

  Future<bool> updateaccountbalance(String id, double newbalance) async {
    try {
      await accountsCollection.doc(id).update({'balance': newbalance});
      return true;
    } catch (e) {
      print("Error adding account: $e");
      return false;
    }
  }
}
