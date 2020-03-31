import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/job_entries/job_entries_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/edit_job_page.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/job_list_tile.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/bill_list_tile.dart';
import 'package:cloud_functions/cloud_functions.dart';

import 'package:time_tracker_flutter_course/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/organization_list_tile.dart';
import 'package:time_tracker_flutter_course/app/home/models/organization.dart';

import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

import 'edit_organization_page.dart';

class OrganizationsPage extends StatelessWidget {

  Future<void> _delete(BuildContext context, Organization organization) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteOrganization(organization);
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Operation failed',
        exception: e,
      ).show(context);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Organizations'),
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => EditOrganizationPage.show(
              context,
              database: Provider.of<Database>(context, listen: false),
            ),
          ),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Organization>>(
      stream: database.organizationsStream(null),
      builder: (context, snapshot) {
        return ListItemsBuilder<Organization>(
          snapshot: snapshot,
          itemBuilder: (context, organization) => Dismissible(
            key: Key('organization-${organization.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, organization),
            child: OrganizationListTile(
                organization: organization,
                onTap: () =>EditOrganizationPage.show(context,database: Provider.of<Database>(context, listen: false),organization: organization)


//                async{
//                  print('current user called');
//                 print(CloudFunctions.instance.useFunctionsEmulator(origin: "http://61.2.3.156:5001").getHttpsCallable(functionName: "addMessage").call());
////                CloudFunctions.instance.useFunctionsEmulator(origin: "http://0.0.0.0:5001");
////                  final HttpsCallable callable = i.getHttpsCallable(
////                    functionName: 'addMessage',
////                  );
//                  print('resp1');
////                  try {
////                    dynamic resp = await callable.
////                    print('resp');
//////                  print(resp.getData());
////                    print(resp.data);
////                  }catch(e ){
////                    print(e);
////                  }
//                  print('done');
//
//                }
            ),
          ),
        );
      },
    );
  }
}
