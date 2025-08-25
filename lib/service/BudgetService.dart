import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/BudgetModel.dart';
import '../models/TransactionModel.dart';

class BudgetService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String get userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is logged in");
    }
    return user.email!;
  }

  CollectionReference get budgetCollection =>
      _firestore.collection('users').doc(userId).collection('budget');
  CollectionReference get transactionsCollection =>
      _firestore.collection('users').doc(userId).collection('transactions');

  Future<List<BudgetModel>> getBudgets() async {
    try {
      final snapshot = await budgetCollection.get();
      return snapshot.docs
          .map((doc) => BudgetModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching budgets: $e");
      return [];
    }
  }

  // Stream all budgets
  Stream<List<BudgetModel>> getBudgetsStream() {
    return budgetCollection.snapshots().map((snapshot) {
      return snapshot.docs
          .map((doc) => BudgetModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    });
  }

  // Stream transactions by category
  Stream<List<TransactionModel>> getTransactionsByCategoryStream(
      String category) {
    return transactionsCollection
        .where('category', isEqualTo: category)
        .snapshots()
        .map((snapshot) => snapshot.docs
        .map((doc) =>
        TransactionModel.fromMap(doc.data() as Map<String, dynamic>))
        .toList());
  }

  Future<List<TransactionModel>> getTransactionsByCategory({
    required String category,

  }) async {
    try {
      final snapshot = await transactionsCollection
          .where('category', isEqualTo: category)
      //   .where('date', isGreaterThanOrEqualTo: startDate)
      //  .where('date', isLessThanOrEqualTo: endDate)
          .get();

      return snapshot.docs
          .map((doc) =>
          TransactionModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching transactions by category, type, and date: $e");
      return [];
    }
  }

  Future<bool> addBudget(BudgetModel budgetModel) async {
    try {
      final docref = budgetCollection.doc(budgetModel.title);
      await docref.set(budgetModel.toMap());
      return true;
    } catch (e) {
      print("Error adding Budget: $e");
      return false;
    }
  }

  Future<bool> removeBudget(BudgetModel budgetModel) async {
    try {
      await budgetCollection.doc(budgetModel.title).delete();
      return true;
    } catch (e) {
      print("Error removing Budget: $e");
      return false;
    }
  }

  Future<bool> updateBudget(BudgetModel budgetModel) async {
    try {
      await budgetCollection.doc(budgetModel.title).update(budgetModel.toMap());
      return true;
    } catch (e) {
      print("Error updating Budget: $e");
      return false;
    }
  }
}
