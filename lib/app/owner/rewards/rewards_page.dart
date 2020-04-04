import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/owner/models/reward.dart';
import 'package:time_tracker_flutter_course/app/owner/rewards/edit_reward_page.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class RewardsPage extends StatelessWidget {
  Future<void> _delete(BuildContext context, Reward reward) async {
    try {
      final database = Provider.of<Database>(context, listen: false);
//      await database.deleteJob(bill);
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
        title: Text('Reward Settings'),
        /* actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add, color: Colors.white),
            onPressed: () => EditRewardPage.show(
              context,
              database: Provider.of<Database>(context, listen: false),
            ),
          ),
        ],*/
      ),
      body: _buildContents(context),
    );
  }

  Widget _buildContents(BuildContext context) {
    final database = Provider.of<Database>(context, listen: false);
    return StreamBuilder<Reward>(
        stream: database.RewardSettingStream(),
        builder: (context, snapshot) {
          return GestureDetector(
            onTap: () => EditRewardPage.show(context,
                database: Provider.of<Database>(context, listen: false),
                reward: snapshot.data),
            child: Card(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: <Widget>[
                  Text('Reward Setting'),
                  Row(
                    children: <Widget>[
                      Text('Minimum Amount  '),
                      Text(snapshot.data?.minAmount.toString()),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Percentage of Amount  '),
                      Text(snapshot.data?.percentageOfAmount.toString()),
                    ],
                  ),
                  Row(
                    children: <Widget>[
                      Text('Minimum Redeem Limit  '),
                      Text(snapshot.data?.minRedeemLimit.toString()),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}
