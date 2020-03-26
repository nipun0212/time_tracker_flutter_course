import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:time_tracker_flutter_course/app/home/models/organization.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_alert_dialog.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/database.dart';

class EditOrganizationPage extends StatefulWidget {
  const EditOrganizationPage({Key key, @required this.database, this.organization})
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
        builder: (context) => EditOrganizationPage(database: database, organization: organization),
        fullscreenDialog: true,
      ),
    );
  }

  @override
  _EditOrganizationPageState createState() => _EditOrganizationPageState();
}

class _EditOrganizationPageState extends State<EditOrganizationPage> {
  final _formKey = GlobalKey<FormState>();

  String _name;
  String _address;
  String _ownerPhoneNumber;

  @override
  void initState() {
    super.initState();
    print("widget.organization");
    print(widget.organization?.id);
    if (widget.organization != null) {
      _name = widget.organization.name;
      _address = widget.organization.address;
      _ownerPhoneNumber = widget.organization.ownerPhoneNumber;
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
          _validateAndSaveForm();
          final id = widget.organization?.id;
           Organization organization;
           print('name is $_name');
          if(id!=null) {
            organization = Organization(id: id,
                name: _name,
                address: _address,
                ownerPhoneNumber: _ownerPhoneNumber);
            await widget.database.setOrganization(organization,true);
          } else {
            organization = Organization(name: _name,
                address: _address,
                ownerPhoneNumber: _ownerPhoneNumber);
            await widget.database.setOrganization(organization,false);
          }print(organization);

          Navigator.of(context).pop();
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
              style: TextStyle(fontSize: 18, color: Colors.white),
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
      TextFormField(
        decoration: InputDecoration(labelText: 'Owner Phone Number'),
        initialValue: _ownerPhoneNumber,
        onSaved: (value) => _ownerPhoneNumber = value,
      ),
    ];
  }
}
