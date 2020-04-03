import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_flutter_course/app/owner/models/bill.dart';
import 'package:time_tracker_flutter_course/app/owner/models/reward.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditRewardPage extends StatefulWidget {
  const EditRewardPage({Key key, @required this.database, this.reward})
      : super(key: key);
  final Database database;
  final Reward reward;

  static Future<void> show(
    BuildContext context, {
    Database database,
    Reward reward,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) =>
            EditRewardPage(database: database, reward: reward),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditRewardPageState createState() => _EditRewardPageState();
}

class _EditRewardPageState extends State<EditRewardPage> {
  final _formKey = GlobalKey<FormState>();
//  String phoneNumberVaridationErrorText = 'Invalid Phone Number';
  String _id;
  num _minAmount;
  num _percentageOfAmount;
  num _minRedeemLimit;

  @override
  void initState() {
    super.initState();
    print("widget.organization");
    print(widget.reward?.id);
    if (widget.reward != null) {
      _id = widget.reward.id;
      _minAmount = widget.reward.minAmount;
      _percentageOfAmount = widget.reward.percentageOfAmount;
      _minRedeemLimit = widget.reward.minRedeemLimit;
    }
  }

  bool _validateAndSaveForm() {
    final form = _formKey.currentState;
    if (form.validate()) {
      form.save();
      return true;
    }
    return false;
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      _id = widget.reward?.id;
      Reward reward;
      if (_id != null) {
        bill = Bill(
            id: _id,
            customerPhoneNumber: _customerPhoneNumber,
            amount: _amount,
            rewardPoints: _rewardPoints);
        await widget.database.setBill(bill, true);
      } else {
        bill = Bill(
            customerPhoneNumber: _customerPhoneNumber,
            amount: _amount,
            rewardPoints: _rewardPoints);
        await widget.database.setBill(bill, false);
      }
      print(bill);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.bill == null ? 'New Bill' : 'Edit Bill'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                color: isLoading ? Colors.black54 : Colors.white,
              ),
            ),
            onPressed: isLoading ? null : _submit,
          ),
        ],
      ),
      body: _buildContents(),
      backgroundColor: Colors.grey[200],
    );
  }

  Widget _buildContents() {
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: _buildForm(),
          ),
        ),
      ),
    );
  }

  Widget _buildForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: _buildFormChildren(),
      ),
    );
  }

  List<Widget> _buildFormChildren() {
    return [
      TextFormField(
        decoration: InputDecoration(labelText: 'Minimum Amount'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        initialValue: _amount != null ? _amount.toString() : '',
        onSaved: (value) => _amount = int.parse(value),
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Percentage of Amount'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        initialValue: _amount != null ? _amount.toString() : 0.toString(),
        onSaved: (value) => _amount = int.parse(value),
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Reward Points'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        initialValue:
            _rewardPoints != null ? _rewardPoints.toString() : 0.toString(),
        onSaved: (value) => _rewardPoints = int.parse(value),
      ),
    ];
  }
}
