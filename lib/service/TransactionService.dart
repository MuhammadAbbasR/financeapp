import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/TransactionModel.dart';

class TransactionService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String get userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is logged in");
    }
    return user.email!;
  }

  CollectionReference get transactionsCollection =>
      _firestore.collection('users').doc(userId).collection('transactions');

  Future<List<TransactionModel>> getAllTransactions() async {
    try {
      final snapshot =
      await transactionsCollection.orderBy('date', descending: true).get();

      return snapshot.docs
          .map((doc) =>
          TransactionModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching transactions: $e");
      return [];
    }
  }

  Future<List<TransactionModel>> getTransactions(String accountId) async {
    try {
      final snapshot = await transactionsCollection
          .where('accountId', isEqualTo: accountId)
          .orderBy('date', descending: true)
          .get();

      return snapshot.docs
          .map((doc) =>
          TransactionModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching transactions: $e");
      return [];
    }
  }

  Future<bool> addTransaction(TransactionModel transaction) async {
    try {
      final docRef = transactionsCollection.doc();
      transaction.id = docRef.id;

      await docRef.set(transaction.toMap());
      return true;
    } catch (e) {
      print("Error adding transaction: $e");
      return false;
    }
  }

  Future<bool> removeTransaction(String id) async {
    try {
      await transactionsCollection.doc(id).delete();
      return true;
    } catch (e) {
      print("Error removing transaction: $e");
      return false;
    }
  }

  Future<bool> updateTransaction(TransactionModel transaction) async {
    try {
      await transactionsCollection
          .doc(transaction.id)
          .update(transaction.toMap());
      return true;
    } catch (e) {
      print("Error updating transaction: $e");
      return false;
    }
  }

  Future<List<TransactionModel>> getTransactionbyType(String type) async {
    try {
      final snaphsot =
      await transactionsCollection.where('type', isEqualTo: type).get();
      return snaphsot.docs
          .map((doc) =>
          TransactionModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      throw (e.toString());
    }
  }
}
