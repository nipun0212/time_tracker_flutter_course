import 'package:meta/meta.dart';

class Organization {
  Organization(
      {this.id,
      @required this.name,
      @required this.address,
      @required this.ownerPhoneNumber,
      this.lastUpdatedBy});

  final String id;
  final String name;
  final String address;
  final String ownerPhoneNumber;
  String lastUpdatedBy;

  factory Organization.fromMap(Map<String, dynamic> data, String documentId) {
    print('Organization from org is $data');
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

  void setLastUpdated(String lastUpdatedBy) {
    this.lastUpdatedBy = lastUpdatedBy;
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'address': address,
      'ownerPhoneNumber': ownerPhoneNumber,
      'lastUpdatedBy': lastUpdatedBy
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
