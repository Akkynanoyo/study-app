import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/schedule.dart';

class FirestoreService {
  final _firestore = FirebaseFirestore.instance;
  final _auth = FirebaseAuth.instance;

  Future<void> addSchedule(Schedule schedule) async {
    try {
      await _firestore.collection('schedules').add(schedule.toMap());
    } catch (e) {
      print('Error adding schedule: $e');
    }
  }

  Stream<List<Schedule>> getSchedules() {
    return _firestore
        .collection('schedules')
        .where('userId', isEqualTo: _auth.currentUser!.uid)
        .orderBy('date')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => Schedule.fromMap(doc.data(), doc.id))
              .toList();
        });
  }

  Future<void> deleteSchedule(String id) async {
    try {
      await _firestore.collection('schedules').doc(id).delete();
    } catch (e) {
      print('Error deleting schedule: $e');
    }
  }

  Future<void> updateSchedule(String id, Schedule schedule) async {
    try {
      await _firestore.collection('schedules').doc(id).update(schedule.toMap());
    } catch (e) {
      print('Error updating schedule: $e');
    }
  }
}
