import 'dart:ui';

import 'package:meta/meta.dart';

class Organization {
  Organization({@required this.id, @required this.name, @required this.address,@required this.ownerUID});
  final String id;
  final String name;
  final String address;
  final String ownerUID;

  factory Organization.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    if (name == null) {
      return null;
    }
    final String address = data['address'];
    return Organization(id: documentId, name: name, address: address);
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
    };
  }

  @override
  int get hashCode => hashValues(id, name, address);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final Organization otherJob = other;
    return id == otherJob.id &&
        name == otherJob.name &&
        address == otherJob.address;
  }

  @override
  String toString() => 'id: $id, name: $name, address: $address';
}
