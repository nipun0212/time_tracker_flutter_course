import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_flutter_course/app/owner/models/bill.dart';
import 'package:time_tracker_flutter_course/app/owner/models/reward.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditBillPage extends StatefulWidget {
  const EditBillPage({Key key, @required this.database, this.bill})
      : super(key: key);
  final Database database;
  final Bill bill;

  static Future<void> show(
    BuildContext context, {
    Database database,
    Bill bill,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditBillPage(database: database, bill: bill),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditBillPageState createState() => _EditBillPageState();
}

class _EditBillPageState extends State<EditBillPage> {
  final _formKey = GlobalKey<FormState>();
//  String phoneNumberVaridationErrorText = 'Invalid Phone Number';
  bool isLoading = false;
  String _id;
  String _customerPhoneNumber;
  num _amount;
  num _rewardPoints;
  Reward reward;

  @override
  void initState() {
    setReward();
    super.initState();
    print("widget.organization");
    print(widget.bill?.id);
    if (widget.bill != null) {
      _id = widget.bill.id;
      _customerPhoneNumber = widget.bill.customerPhoneNumber.split('+91')[1];
      _amount = widget.bill.amount;
      _rewardPoints = widget.bill.rewardPoints;
    }
  }

  void setReward() async {
    reward = await widget.database.RewardSettingStream().first;
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
      _id = widget.bill?.id;
      _customerPhoneNumber = '+91' + _customerPhoneNumber;
      Bill bill;
      print('name is $_customerPhoneNumber');
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
        decoration: InputDecoration(labelText: 'Customer Phone Number'),
        initialValue: _customerPhoneNumber,
        maxLength: 10,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        validator: (v) => v?.length == 10 ? null : 'Invalid Phone Number',
        onSaved: (value) => _customerPhoneNumber = value,
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Amount'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onChanged: (v) =>
            _rewardPoints = int.parse(v) * reward.percentageOfAmount,
        initialValue: _amount != null ? _amount.toString() : '',
        onSaved: (value) => _amount = int.parse(value),
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Reward Points'),
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        readOnly: true,
        controller: TextEditingController(text: _rewardPoints.toString())
            .addListener(listener),
//        initialValue: _rewardPoints != null ? _rewardPoints.toString() : '',
        onSaved: (value) => _rewardPoints = int.parse(value),
      ),
    ];
  }
}
