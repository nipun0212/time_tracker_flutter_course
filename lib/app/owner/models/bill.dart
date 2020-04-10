import 'package:meta/meta.dart';

class Bill {
  Bill(
      {this.id,
      this.updatedBy,
      @required this.amount,
      @required this.rewardPoints,
      @required this.customerPhoneNumber});

  final String id;
  String updatedBy;
  final String customerPhoneNumber;
  final num amount;
  final num rewardPoints;

  factory Bill.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    print(data);
    final String updatedBy = data['updatedBy'];
    final String customerPhoneNumber = data['customerPhoneNumber'];
    final num amount = data['amount'];
    final num rewardPoints = data['rewardPoints'];

    return Bill(
        id: documentId,
        updatedBy: updatedBy,
        amount: amount,
        rewardPoints: rewardPoints,
        customerPhoneNumber: customerPhoneNumber);
  }

  Map<String, dynamic> toMap() {
    return {
      'updatedBy': updatedBy,
      'amount': amount,
      'rewardPoints': rewardPoints,
      'customerPhoneNumber': customerPhoneNumber,
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
