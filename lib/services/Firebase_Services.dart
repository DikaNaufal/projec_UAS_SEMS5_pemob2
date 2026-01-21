// lib/services/firebase_service.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/app_state.dart';

class FirebaseService {
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Get current user ID
  String? get currentUserId => _auth.currentUser?.uid;

  // Sign in anonymously
  Future<User?> signInAnonymously() async {
    try {
      UserCredential result = await _auth.signInAnonymously();
      return result.user;
    } catch (e) {
      print('Error signing in anonymously: $e');
      return null;
    }
  }

  // Save user data
  Future<void> saveUserData(AppState appState) async {
    if (currentUserId == null) return;

    try {
      await _firestore.collection('users').doc(currentUserId).set({
        'waterDrops': appState.waterDrops,
        'sunPoints': appState.sunPoints,
        'forestLevel': appState.forestLevel,
        'forestHealth': appState.forestHealth,
        'lastUpdated': FieldValue.serverTimestamp(),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error saving user data: $e');
    }
  }

  // Load user data
  Future<Map<String, dynamic>?> loadUserData() async {
    if (currentUserId == null) return null;

    try {
      DocumentSnapshot doc = await _firestore
          .collection('users')
          .doc(currentUserId)
          .get();

      if (doc.exists) {
        return doc.data() as Map<String, dynamic>;
      }
      return null;
    } catch (e) {
      print('Error loading user data: $e');
      return null;
    }
  }

  // Save habit log
  Future<void> saveHabitLog(HabitLog log) async {
    if (currentUserId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('habitLogs')
          .add({
        'habitType': log.habitType,
        'timestamp': Timestamp.fromDate(log.timestamp),
        'reward': log.reward,
      });
    } catch (e) {
      print('Error saving habit log: $e');
    }
  }

  // Load habit logs
  Future<List<HabitLog>> loadHabitLogs() async {
    if (currentUserId == null) return [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('habitLogs')
          .orderBy('timestamp', descending: true)
          .limit(50)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return HabitLog(
          habitType: data['habitType'],
          timestamp: (data['timestamp'] as Timestamp).toDate(),
          reward: data['reward'],
        );
      }).toList();
    } catch (e) {
      print('Error loading habit logs: $e');
      return [];
    }
  }

  // Get friends list
  Future<List<Friend>> getFriendsList() async {
    if (currentUserId == null) return [];

    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('friends')
          .get();

      List<Friend> friends = [];
      for (var doc in snapshot.docs) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        
        // Get friend's data
        DocumentSnapshot friendDoc = await _firestore
            .collection('users')
            .doc(data['userId'])
            .get();

        if (friendDoc.exists) {
          Map<String, dynamic> friendData = friendDoc.data() as Map<String, dynamic>;
          friends.add(Friend(
            name: data['name'],
            level: friendData['forestLevel'] ?? 1,
            lastWatered: data['lastWatered'] != null
                ? (data['lastWatered'] as Timestamp).toDate()
                : null,
          ));
        }
      }
      return friends;
    } catch (e) {
      print('Error getting friends: $e');
      return [];
    }
  }

  // Add friend
  Future<void> addFriend(String friendCode, String friendName) async {
    if (currentUserId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('friends')
          .doc(friendCode)
          .set({
        'userId': friendCode,
        'name': friendName,
        'addedAt': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error adding friend: $e');
    }
  }

  // Water friend's forest
  Future<void> waterFriendForest(String friendUserId) async {
    if (currentUserId == null) return;

    try {
      await _firestore
          .collection('users')
          .doc(currentUserId)
          .collection('friends')
          .doc(friendUserId)
          .update({
        'lastWatered': FieldValue.serverTimestamp(),
      });
    } catch (e) {
      print('Error watering friend\'s forest: $e');
    }
  }

  // Get leaderboard
  Future<List<Map<String, dynamic>>> getLeaderboard({int limit = 10}) async {
    try {
      QuerySnapshot snapshot = await _firestore
          .collection('users')
          .orderBy('forestLevel', descending: true)
          .limit(limit)
          .get();

      return snapshot.docs.map((doc) {
        Map<String, dynamic> data = doc.data() as Map<String, dynamic>;
        return {
          'userId': doc.id,
          'forestLevel': data['forestLevel'] ?? 1,
          'waterDrops': data['waterDrops'] ?? 0,
          'sunPoints': data['sunPoints'] ?? 0,
        };
      }).toList();
    } catch (e) {
      print('Error getting leaderboard: $e');
      return [];
    }
  }
}