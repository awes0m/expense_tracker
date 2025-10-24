import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';


@HiveType(typeId: 1)
class Budget extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String category;
  
  @HiveField(2)
  double limit;
  
  @HiveField(3)
  double spent;
  
  @HiveField(4)
  bool synced;

  Budget({
    required this.id,
    required this.category,
    required this.limit,
    required this.spent,
    this.synced = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'category': category,
    'limit': limit,
    'spent': spent,
    'synced': synced,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  factory Budget.fromJson(Map<String, dynamic> json) => Budget(
    id: json['id'],
    category: json['category'],
    limit: json['limit'].toDouble(),
    spent: json['spent'].toDouble(),
    synced: json['synced'] ?? false,
  );
}

class BudgetAdapter extends TypeAdapter<Budget> {
  @override
  final typeId = 1;

  @override
  Budget read(BinaryReader reader) {
    return Budget(
      id: reader.readString(),
      category: reader.readString(),
      limit: reader.readDouble(),
      spent: reader.readDouble(),
      synced: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Budget obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.category);
    writer.writeDouble(obj.limit);
    writer.writeDouble(obj.spent);
    writer.writeBool(obj.synced);
  }
}
