import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/home/jobs/list_items_builder.dart';
import 'package:time_tracker_flutter_course/app/owner/jobs/bill_list_tile.dart';
import 'package:time_tracker_flutter_course/app/owner/jobs/edit_bill_page.dart';
import 'package:time_tracker_flutter_course/app/owner/models/bill.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class BillsPage extends StatefulWidget {
  BillsPage({Key key}) : super(key: key);

  @override
  _BillsPageState createState() {
    return _BillsPageState();
  }
}

class _BillsPageState extends State<BillsPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  static String get executable => "q.limit(l).orderBy('amount')";
  int l = 10;
  void setLimit() {
    setState(() {
      l = l + 4;
    });
  }

  Future<void> _delete(BuildContext context, Bill bill) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
      await database.deleteBill(bill);
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
        title: Text('Bills'),
        actions: <Widget>[
          IconButton(
              icon: Icon(Icons.add, color: Colors.white),
              onPressed: () => {
                    EditBillPage.show(
                      context,
                      database: Provider.of<Database>(context, listen: false),
                    )
                  }),
        ],
      ),
      body: _buildContents(context),
    );
  }

  Query c(Query q) {
    setLimit();
    return q.limit(l).orderBy('amount');
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<List<Bill>>(
      stream: database.billStream(c),
      builder: (context, snapshot) {
        return ListItemsBuilder<Bill>(
          snapshot: snapshot,
          onEnd: setLimit,
          itemBuilder: (context, bill) => Dismissible(
            key: Key('bill-${bill.id}'),
            background: Container(color: Colors.red),
            direction: DismissDirection.endToStart,
            onDismissed: (direction) => _delete(context, bill),
            child: BillListTile(
              bill: bill,
              onTap: () => EditBillPage.show(context,
                  database: Provider.of<Database>(context, listen: false),
                  bill: bill),

//                async {
//                  print('current user called');
////                CloudFunctions.instance.useFunctionsEmulator(origin: "http://localhost:5001");
//
////                CloudFunctions.instance.useFunctionsEmulator(origin: "http://0.0.0.0:5001");
//                  final HttpsCallable callable =
//                      CloudFunctions.instance.getHttpsCallable(
//                    functionName: 'addMessage',
//                  );
//                  print('resp1');
//                  try {
//                    dynamic resp = await callable.call();
//                    print('resp');
////                  print(resp.getData());
//                    print(resp.data);
//                  } catch (e) {
//                    print(e);
//                  }
//                  print('done');
//                }
            ),
          ),
        );
      },
    );
  }
}
