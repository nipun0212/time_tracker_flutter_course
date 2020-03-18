import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loading/indicator/ball_pulse_indicator.dart';
import 'package:loading/loading.dart';
import 'package:provider/provider.dart';
import 'package:time_tracker_flutter_course/app/sign_in/phone_sign_in_change_model.dart';
import 'package:time_tracker_flutter_course/common_widgets/form_submit_button.dart';
import 'package:time_tracker_flutter_course/common_widgets/platform_exception_alert_dialog.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

import 'phone_sign_in_model.dart';

class PhoneSignInFormChangeNotifier extends StatefulWidget {
  PhoneSignInFormChangeNotifier({@required this.model});

  final PhoneSignInChangeModel model;

  static Widget create(BuildContext context) {
    final AuthBase auth = Provider.of<AuthBase>(context, listen: false);
    return ChangeNotifierProvider<PhoneSignInChangeModel>(
      create: (context) => PhoneSignInChangeModel(auth: auth),
      child: Consumer<PhoneSignInChangeModel>(
        builder: (context, model, _) =>
            PhoneSignInFormChangeNotifier(model: model),
      ),
    );
  }

  @override
  _PhoneSignInFormChangeNotifierState createState() =>
      _PhoneSignInFormChangeNotifierState();
}

class _PhoneSignInFormChangeNotifierState
    extends State<PhoneSignInFormChangeNotifier> {
  final TextEditingController _phoneNumberController = TextEditingController();

  final TextEditingController _passwordController = TextEditingController();

  final FocusNode _emailFocusNode = FocusNode();

  final FocusNode _passwordFocusNode = FocusNode();

  PhoneSignInChangeModel get model => widget.model;

  @override
  void dispose() {
    _phoneNumberController.dispose();
    _passwordController.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    try {
      await model.submit();
      if (model.submitted)
        Navigator.pushNamed(context, '/');
    } on PlatformException catch (e) {
      PlatformExceptionAlertDialog(
        title: 'Sign in failed',
        exception: e,
      ).show(context);
    }
  }

  void _emailEditingComplete() {
    final newFocus = model.emailValidator.isValid(model.phoneNumber)
        ? _passwordFocusNode
        : _emailFocusNode;
    FocusScope.of(context).requestFocus(newFocus);
  }

  void _toggleFormType() {
    model.toggleFormType();
    _phoneNumberController.clear();
    _passwordController.clear();
  }

  List<Widget> _otpNumberScreen() {
    return [
      SizedBox(height: 8.0),
      _buildPhoneTextField(),
      SizedBox(height: 8.0),
      _buildOTPextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(
        text: model.primaryButtonText,
        onPressed: model.canSubmit ? _submit : null,
      ),
      SizedBox(height: 8.0),
      FlatButton(
        child: Text('Want to Change Number'),
        onPressed: _toggleFormType,
      ),
    ];
  }

  List<Widget> _phoneNumberScreen() {
    return [
      SizedBox(height: 8.0),
      _buildPhoneTextField(),
      SizedBox(height: 8.0),
      FormSubmitButton(text: model.primaryButtonText, onPressed: _submit),
    ];
  }

  TextField _buildOTPextField() {
    return TextField(
      controller: _passwordController,
      focusNode: _passwordFocusNode,
      decoration: InputDecoration(
        labelText: 'OTP',
        errorText: model.passwordErrorText,
//        enabled: model.isLoading == false,
      ),
      textInputAction: TextInputAction.done,
      onChanged: model.updateOTP,
      onEditingComplete: _submit,
    );
  }

  Widget _buildPhoneTextField() {
    return Column(
      children: <Widget>[
        Text(
          "INDIA",
          style: TextStyle(fontSize: 24, color: Colors.indigo),
        ),
        TextField(
          controller: _phoneNumberController,
          focusNode: _emailFocusNode,
          decoration: InputDecoration(
            labelText: 'PhoneNumber',
            hintText: '8971819883',
            errorText: model.emailErrorText,
//                enabled: model.isLoading == false,
          ),
          autocorrect: false,
          keyboardType: TextInputType.phone,
          textInputAction: TextInputAction.next,
          onChanged: model.updatePhoneNumber,
          readOnly: model.formType == PhoneSignInFormType.submit ? true : false,
//              onEditingComplete: () => _emailEditingComplete(),
        ),
      ],
    );
  }

  Widget buildPhoneSignIn() {
    List<Widget> screenType;
    if (model.formType == PhoneSignInFormType.sendOTP)
      screenType = _phoneNumberScreen();
    else
      screenType = _otpNumberScreen();
    print('ssss');
    print(screenType.runtimeType);
    return Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          mainAxisSize: MainAxisSize.min,
          children: screenType,
        ));
  }

  @override
  Widget build(BuildContext context) {
    if (model.isLoading)
      return Center(
          child: Loading(
              indicator: BallPulseIndicator(),
              size: 100.0,
              color: Colors.indigo));
    return buildPhoneSignIn();
  }
}
