import 'package:meta/meta.dart';

class Bill {
  Bill(
      {this.id,
      @required this.uid,
      @required this.organizationId,
      @required this.amount,
      @required this.rewardPoints,
      @required this.phoneNumber});

  final String id;
  final String uid;
  final String phoneNumber;
  final String organizationId;
  final num amount;
  final num rewardPoints;

  factory Bill.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    print(data);
    final String uid = data['uid'];
    final String organizationId = data['organizationId'];
    final String phoneNumber = data['phoneNumber'];
    final num amount = data['amount'];
    final num rewardPoints = data['rewardPoints'];

    return Bill(
        id: documentId,
        uid: uid,
        organizationId: organizationId,
        amount: amount,
        rewardPoints: rewardPoints,
        phoneNumber: phoneNumber);
  }

  Map<String, dynamic> toMap() {
    return {
      'uid': uid,
      'organizationId': organizationId,
      'amount': amount,
      'rewardPoints': rewardPoints,
      'phoneNumber': phoneNumber,
    };
  }

//
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
//
//  @override
//  String toString() => 'id: $id, name: $name, ratePerHour: $ratePerHour';
}
