import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:hive_flutter/hive_flutter.dart';


@HiveType(typeId: 0)
class Transaction extends HiveObject {
  @HiveField(0)
  String id;
  
  @HiveField(1)
  String date;
  
  @HiveField(2)
  String description;
  
  @HiveField(3)
  String category;
  
  @HiveField(4)
  String type;
  
  @HiveField(5)
  double amount;
  
  @HiveField(6)
  String payment;
  
  @HiveField(7)
  bool synced;

  Transaction({
    required this.id,
    required this.date,
    required this.description,
    required this.category,
    required this.type,
    required this.amount,
    required this.payment,
    this.synced = false,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'date': date,
    'description': description,
    'category': category,
    'type': type,
    'amount': amount,
    'payment': payment,
    'synced': synced,
    'updatedAt': FieldValue.serverTimestamp(),
  };

  factory Transaction.fromJson(Map<String, dynamic> json) => Transaction(
    id: json['id'],
    date: json['date'],
    description: json['description'],
    category: json['category'],
    type: json['type'],
    amount: json['amount'].toDouble(),
    payment: json['payment'],
    synced: json['synced'] ?? false,
  );
}

class TransactionAdapter extends TypeAdapter<Transaction> {
  @override
  final typeId = 0;

  @override
  Transaction read(BinaryReader reader) {
    return Transaction(
      id: reader.readString(),
      date: reader.readString(),
      description: reader.readString(),
      category: reader.readString(),
      type: reader.readString(),
      amount: reader.readDouble(),
      payment: reader.readString(),
      synced: reader.readBool(),
    );
  }

  @override
  void write(BinaryWriter writer, Transaction obj) {
    writer.writeString(obj.id);
    writer.writeString(obj.date);
    writer.writeString(obj.description);
    writer.writeString(obj.category);
    writer.writeString(obj.type);
    writer.writeDouble(obj.amount);
    writer.writeString(obj.payment);
    writer.writeBool(obj.synced);
  }
}
