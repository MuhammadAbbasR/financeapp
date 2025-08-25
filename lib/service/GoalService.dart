import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

import '../models/GoalModel.dart';
import '../models/TransactionGoalModel.dart';

class GoalService {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String get userId {
    final user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      throw Exception("No user is logged in");
    }
    return user.email!;
  }



  CollectionReference get goalsCollection =>
      _firestore.collection('users').doc(userId).collection('Goals');

  Future<List<GoalModel>> getGoals() async {
    try {
      final snapshot = await goalsCollection.get();
      return snapshot.docs
          .map((doc) => GoalModel.fromMap(doc.data() as Map<String, dynamic>))
          .toList();
    } catch (e) {
      print("Error fetching transactions: $e");
      return [];
    }
  }

  Future<bool> addGoals(GoalModel goalModel) async {
    try {
      final docref = goalsCollection.doc(goalModel.name);
      await docref.set(goalModel.toMap());
      return true;
    } catch (e) {
      print("Error fetching transactions: $e");
      return false;
    }
  }

  Future<bool> removeGoals(GoalModel goalModel) async {
    try {
      await goalsCollection.doc(goalModel.name).delete();
      return true;
    } catch (e) {
      print("Error removing goals: $e");
      return false;
    }
  }

  Future<bool> addTransaction(
      String goalId, TransactionGoalModel transaction) async {
    try {
      final docRef =
      goalsCollection.doc(goalId).collection("transactions").doc();
      transaction.id = docRef.id;
      await docRef.set(transaction.toMap());

      final goalDoc = await goalsCollection.doc(goalId).get();
      double currentAmount = (goalDoc["currentAmount"] ?? 0).toDouble();

      double updatedAmount = currentAmount + transaction.amount;

      await goalsCollection
          .doc(goalId)
          .update({"currentAmount": updatedAmount});
      return true;
    } catch (e) {
      print("Error adding transaction: $e");
      return false;
    }
  }

  Future<bool> removeTransaction(
      String goalId, TransactionGoalModel transaction) async {
    try {
      await goalsCollection
          .doc(goalId)
          .collection("transactions")
          .doc(transaction.id)
          .delete();

      final goalDoc = await goalsCollection.doc(goalId).get();
      double currentAmount = (goalDoc["currentAmount"] ?? 0).toDouble();

      double updatedAmount = currentAmount - transaction.amount;

      await goalsCollection
          .doc(goalId)
          .update({"currentAmount": updatedAmount});
      return true;
    } catch (e) {
      print("Error removing transaction: $e");
      return false;
    }
  }

  Future<List<TransactionGoalModel>> getTransactions(String goalId) async {
    try {
      final snapshot = await goalsCollection
          .doc(goalId)
          .collection("transactions")
          .orderBy("date", descending: true)
          .get();

      return snapshot.docs
          .map((doc) => TransactionGoalModel.fromMap(
        doc.data() as Map<String, dynamic>,
      ))
          .toList();
    } catch (e) {
      print("Error fetching transactions: $e");
      return [];
    }
  }
}
