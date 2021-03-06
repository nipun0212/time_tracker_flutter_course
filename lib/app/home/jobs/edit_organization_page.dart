import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_flutter_course/app/home/models/organization.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditOrganizationPage extends StatefulWidget {
  const EditOrganizationPage(
      {Key key, @required this.database, this.organization})
      : super(key: key);
  final Database database;
  final Organization organization;

  static Future<void> show(
    BuildContext context, {
    Database database,
    Organization organization,
  }) async {
    await Navigator.of(context, rootNavigator: true).push(
      MaterialPageRoute(
        builder: (context) => EditOrganizationPage(
            database: database, organization: organization),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditOrganizationPageState createState() => _EditOrganizationPageState();
}

class _EditOrganizationPageState extends State<EditOrganizationPage> {
  final _formKey = GlobalKey<FormState>();
  String phoneNumberVaridationErrorText = 'Invalid Phone Number';
  bool isLoading = false;
  String _name;
  String _address;
  String _ownerPhoneNumber;
  int _otp;

  @override
  void initState() {
    super.initState();
    print("widget.organization");
    print(widget.organization?.id);
    if (widget.organization != null) {
      _name = widget.organization.name;
      _address = widget.organization.address;
      _ownerPhoneNumber = widget.organization.ownerPhoneNumber.split('+91')[1];
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

  Future<bool> isPhoneNumberUnique(String phoneNumber) async {
    phoneNumber = '+91' + phoneNumber;
    bool result = true;
    List<Organization> organizations = await widget.database
        .organizationsStream(
            (q) => q.where('ownerPhoneNumber', isEqualTo: phoneNumber).limit(1))
        .first;
    if (organizations.length > 0) result = false;
    return result;
  }

  void setPhoneNumberErrorText(String phoneNumber) async {
    setState(() {
      isLoading = true;
    });
//    await Future.delayed(Duration(seconds: 5));
    if (phoneNumber.length != 10) {
      phoneNumberVaridationErrorText = 'Invalid Phone Number';
    } else {
      bool unique = await isPhoneNumberUnique(phoneNumber);
      if (unique)
        phoneNumberVaridationErrorText = '';
      else
        phoneNumberVaridationErrorText = 'Phone Number Already Registered!';
    }
    _validateAndSaveForm();
    setState(() {
      isLoading = false;
    });
  }

  Future<void> _submit() async {
    if (_validateAndSaveForm()) {
      final id = widget.organization?.id;
      _ownerPhoneNumber = '+91' + _ownerPhoneNumber;
      Organization organization;
      print('name is $_name');
      if (id != null) {
        organization = Organization(
            id: id,
            name: _name,
            address: _address,
            ownerPhoneNumber: _ownerPhoneNumber);
        await widget.database.setOrganization(organization, true);
      } else {
        organization = Organization(
            name: _name,
            address: _address,
            ownerPhoneNumber: _ownerPhoneNumber);
        await widget.database.setOrganization(organization, false);
      }
      print(organization);

      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 2.0,
        title: Text(widget.organization == null ? 'New Job' : 'Edit Job'),
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
//      Card(
//        child: Padding(
//          padding: const EdgeInsets.all(16.0),
//          child: Column(
//            children: <Widget>[
//              TextFormField(
//                decoration: InputDecoration(labelText: 'Organization name'),
//                initialValue: _name,
//                validator: (value) =>
//                    value.isNotEmpty ? null : 'Name can\'t be empty',
//                onSaved: (value) {
//                  print("Name value is");
//                  print(value);
//                  _name = value;
//                },
//              ),
//              TextFormField(
//                decoration: InputDecoration(labelText: 'Organization Address'),
//                initialValue: _address,
//                onSaved: (value) => _address = value,
//              ),
//              TextFormField(
//                decoration: InputDecoration(labelText: 'Owner Phone Number'),
//                initialValue: _ownerPhoneNumber,
//                maxLength: 10,
//                keyboardType: TextInputType.numberWithOptions(
//                  signed: false,
//                  decimal: false,
//                ),
//                onChanged: (v) async {
//                  await setPhoneNumberErrorText(v);
//                },
//                validator: (v) => phoneNumberVaridationErrorText,
//                onSaved: (value) => _ownerPhoneNumber = value,
//              ),
//            ],
//          ),
//        ),
//      ),
//      Padding(
//        padding: const EdgeInsets.all(16.0),
//        child: Text("Organization Details",
//        style: TextStyle(fontSize: 16),),
//      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Organization name'),
        initialValue: _name,
        validator: (value) => value.isNotEmpty ? null : 'Name can\'t be empty',
        onSaved: (value) {
          print("Name value is");
          print(value);
          _name = value;
        },
      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Organization Address'),
        initialValue: _address,
        onSaved: (value) => _address = value,
      ),
//      Padding(
//        padding: const EdgeInsets.all(16.0),
//        child: Text("Owner Details"),
//      ),
      TextFormField(
        decoration: InputDecoration(labelText: 'Owner Phone Number'),
        initialValue: _ownerPhoneNumber,
        maxLength: 10,
        keyboardType: TextInputType.numberWithOptions(
          signed: false,
          decimal: false,
        ),
        onChanged: (v) async {
          await setPhoneNumberErrorText(v);
        },
        validator: (v) => phoneNumberVaridationErrorText != ''
            ? phoneNumberVaridationErrorText
            : null,
        onSaved: (value) => _ownerPhoneNumber = value,
      ),
//      TextFormField(
//        decoration: InputDecoration(labelText: 'Owner Phone Number'),
//        maxLength: 4,
//        keyboardType: TextInputType.numberWithOptions(
//          signed: false,
//          decimal: false,
//        ),
//        onChanged: (v) async {
//          await setPhoneNumberErrorText(v);
//        },
//        validator: (v) => phoneNumberVaridationErrorText!=''?phoneNumberVaridationErrorText:null,
//        onSaved: (value) => _ownerPhoneNumber = value,
//      ),
    ];
  }
}
