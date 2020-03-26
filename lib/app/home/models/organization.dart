import 'dart:ui';

import 'package:meta/meta.dart';

class Organization {
  Organization(
      {this.id,
      @required this.name,
      @required this.address,
      @required this.ownerPhoneNumber});

  final String id;
  final String name;
  final String address;
  final String ownerPhoneNumber;

  factory Organization.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    final String name = data['name'];
    if (name == null) {
      return null;
    }
    final String address = data['address'];
    final String ownerPhoneNumber = data['ownerPhoneNumber'];
    return Organization(
      id: documentId,
      name: name,
      address: address,
      ownerPhoneNumber: ownerPhoneNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'ownerPhoneNumber': ownerPhoneNumber
    };
  }

//  @override
//  int get hashCode => hashValues(id, name, ratePerHour);

//  @override
//  bool operator ==(other) {
//    if (identical(this, other)) return true;
//    if (runtimeType != other.runtimeType) return false;
//    final Job otherJob = other;
//    return id == otherJob.id &&
//        name == otherJob.name &&
//        ratePerHour == otherJob.ratePerHour;
//  }

//  @override
//  String toString() => 'id: $id, name: $name, ratePerHour: $ratePerHour';
}
