
import 'package:flutter/material.dart';
import 'package:time_tracker_flutter_course/app/home/models/bill.dart';
import 'package:time_tracker_flutter_course/app/home/models/organization.dart';

class OrganizationListTile extends StatelessWidget {
  const OrganizationListTile({Key key, @required this.organization, this.onTap}) : super(key: key);
  final Organization organization;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(organization.name),
      trailing: Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }
}
