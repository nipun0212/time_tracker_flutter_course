import 'package:meta/meta.dart';

class Reward {
  Reward({
    this.id,
    @required this.minAmount,
    @required this.percentageOfAmount,
    @required this.minRedeemLimit,
  });

  final String id;
  final num minAmount;
  final num percentageOfAmount;
  final num minRedeemLimit;

  factory Reward.fromMap(Map<String, dynamic> data, String documentId) {
    if (data == null) {
      return null;
    }
    print(data);
    final num minAmount = data['minAmount'];
    final num percentageOfAmount = data['percentageOfAmount'];
    final num minRedeemLimit = data['minRedeemLimit'];

    return Reward(
        id: documentId,
        minAmount: minAmount,
        percentageOfAmount: percentageOfAmount,
        minRedeemLimit: minRedeemLimit);
  }

  Map<String, dynamic> toMap() {
    return {
      'minAmount': minAmount,
      'minRedeemLimit': minRedeemLimit,
      'percentageOfAmount': percentageOfAmount,
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
