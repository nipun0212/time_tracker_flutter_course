
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/bill.dart';

class BillListTile extends StatelessWidget {
  const BillListTile({Key key, @required this.bill, this.onTap}) : super(key: key);
  final Bill bill;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(bill.organizationId),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
