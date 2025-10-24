import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';

@HiveType(typeId: 2)
class Goal extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String name;
  
  @HiveField(2)
  double target;
  
  @HiveField(3)
  double current;
  
  @HiveField(4)
  bool synced;

  Goal({
    required this.id,
    required this.name,
    required this.target,
    required this.current,
    this.synced = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'name': name,
    'target': target,
    'current': current,
    'synced': synced,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  factory Goal.fromJson(Map<String, dynamic> json) => Goal(
    id: json['id'],
    name: json['name'],
    target: json['target'].toDouble(),
    current: json['current'].toDouble(),
    synced: json['synced'] ?? false,
  );
}

class GoalAdapter extends TypeAdapter<Goal> {
  @override
  final typeId = 2;

  @override
  Goal read(BinaryReader reader) {
    return Goal(
      id: reader.readString(),
      name: reader.readString(),
      target: reader.readDouble(),
      current: reader.readDouble(),
      synced: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Goal obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.name);
    writer.writeDouble(obj.target);
    writer.writeDouble(obj.current);
    writer.writeBool(obj.synced);
  }
}
