// models/app_state.dart
import 'package:flutter/material.dart';

class AppStateProvider extends InheritedWidget {
  final AppState state = AppState();

  AppStateProvider({required Widget child}) : super(child: child);

  static AppState of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<AppStateProvider>()!.state;
  }

  @override
  bool updateShouldNotify(AppStateProvider oldWidget) => true;
}

class AppState extends ChangeNotifier {
  int waterDrops = 0;
  int sunPoints = 0;
  int forestLevel = 1;
  double forestHealth = 50.0;
  List<HabitLog> habitLogs = [];
  List<Friend> friends = [];
  
  void addWaterDrops(int amount) {
    waterDrops += amount;
    forestHealth = (forestHealth + amount * 2).clamp(0, 100);
    _checkLevelUp();
    notifyListeners();
  }
  
  void addSunPoints(int amount) {
    sunPoints += amount;
    forestHealth = (forestHealth + amount * 1.5).clamp(0, 100);
    _checkLevelUp();
    notifyListeners();
  }
  
  void _checkLevelUp() {
    int totalPoints = waterDrops + sunPoints;
    int newLevel = (totalPoints / 100).floor() + 1;
    if (newLevel > forestLevel) {
      forestLevel = newLevel;
    }
  }
  
  void logHabit(String habitType, int reward) {
    habitLogs.add(HabitLog(
      habitType: habitType,
      timestamp: DateTime.now(),
      reward: reward,
    ));
    
    if (habitType.contains('water') || habitType.contains('air')) {
      addWaterDrops(reward);
    } else {
      addSunPoints(reward);
    }
  }
  
  void waterFriendForest(String friendName) {
    var friend = friends.firstWhere((f) => f.name == friendName, orElse: () => Friend(name: '', level: 0));
    if (friend.name.isNotEmpty) {
      friend.lastWatered = DateTime.now();
      notifyListeners();
    }
  }
}

class HabitLog {
  final String habitType;
  final DateTime timestamp;
  final int reward;
  
  HabitLog({
    required this.habitType,
    required this.timestamp,
    required this.reward,
  });
}

class Friend {
  final String name;
  final int level;
  DateTime? lastWatered;
  
  Friend({
    required this.name,
    required this.level,
    this.lastWatered,
  });
}