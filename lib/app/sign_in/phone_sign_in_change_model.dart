import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/phone_sign_in_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class PhoneSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  PhoneSignInChangeModel({
    @required this.auth,
    this.phoneNumber = '',

    this.password = '',
    this.formType = PhoneSignInFormType.sendOTP,
    this.isLoading = false,
    this.submitted = false,
  });
  final AuthBase auth;
  String phoneNumber;
  String password;
  String verificationId;
  PhoneSignInFormType formType;
  bool isLoading;
  bool submitted;

  Future<void> submit() async {
    updateWith(submitted: true, isLoading: true);
    try {
      if (formType == PhoneSignInFormType.sendOTP) {
       await auth.signInWithPhoneNumber(phoneNumber);
       print(await auth.sendOTP('123456'));
      } else {
     await auth.signInWithPhoneNumber(phoneNumber);
     print(await auth.sendOTP('123456'));
      }
    } catch (e) {
      updateWith(isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == PhoneSignInFormType.sendOTP
        ? 'Send OTP'
        : 'Submit';
  }

  String get secondaryButtonText {
    return formType == PhoneSignInFormType.sendOTP
        ? 'Need an account? Register'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
    return emailValidator.isValid(phoneNumber) &&
        !isLoading;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(password);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(phoneNumber);
    return showErrorText ? invalidEmailErrorText : null;
  }

  void toggleFormType() {
    final formType = this.formType == PhoneSignInFormType.sendOTP
        ? PhoneSignInFormType.submit
        : PhoneSignInFormType.sendOTP;
    updateWith(
      phoneNumber: '',
      password: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updatePhoneNumber(String phoneNumber) => updateWith(phoneNumber: phoneNumber);

  void updatePassword(String password) => updateWith(password: password);

  void updateWith({
    String phoneNumber,
    String password,
    PhoneSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.phoneNumber = phoneNumber ?? this.phoneNumber;
    this.password = password ?? this.password;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
