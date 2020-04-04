import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
      reward = Reward(
          minAmount: _minAmount,
          percentageOfAmount: _percentageOfAmount,
          minRedeemLimit: _minRedeemLimit);
      await widget.database.setReward(reward);
      print(reward);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.reward == null ? 'New Bill' : 'Edit Reward'),
        actions: <Widget>[
          FlatButton(
            child: Text(
              'Save',
              style: TextStyle(
                fontSize: 18,
                color: Colors.white,
              ),
            ),
            onPressed: _submit,
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
        initialValue: _minAmount != null ? _minAmount.toString() : '',
        onSaved: (value) => _minAmount = int.parse(value),
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Percentage of Amount'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        initialValue:
            _percentageOfAmount != null ? _percentageOfAmount.toString() : '',
        onSaved: (value) => _percentageOfAmount = int.parse(value),
      ),
      TextFormField(
        decoration: InputDecoration(
            labelText: 'Min Reward Points Required for Redemption'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        initialValue: _minRedeemLimit != null ? _minRedeemLimit.toString() : '',
        onSaved: (value) => _minRedeemLimit = int.parse(value),
      ),
    ];
  }
}
