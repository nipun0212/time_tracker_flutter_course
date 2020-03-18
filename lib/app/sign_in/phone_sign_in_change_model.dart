import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:time_tracker_flutter_course/app/sign_in/email_sign_in_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/phone_sign_in_model.dart';
import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';
import 'package:time_tracker_flutter_course/services/auth.dart';

class PhoneSignInChangeModel with EmailAndPasswordValidators, ChangeNotifier {
  PhoneSignInChangeModel({
    @required this.auth,
    this.phoneNumber = '',
    this.otp = '',
    this.formType = PhoneSignInFormType.sendOTP,
    this.isLoading = false,
    this.submitted = false,
    this.verificationId = '',
  });

  final AuthBase auth;
  String phoneNumber;
  String otp;
  String verificationId;
  PhoneSignInFormType formType;
  bool isLoading;
  bool submitted;

  void ab(String verificationId, [int forceResendingToken]) async {
    print('me 2called');
    print('verificationId$verificationId');
    updateWith(isLoading: true);
    this.verificationId = verificationId;
    formType = PhoneSignInFormType.submit;
    updateWith(isLoading: false);
  }
  void verificationFailed(AuthException error) {
    print("Error Occured");
    print(error.message);
    updateWith(isLoading: false);
  }
  Future<void> submit() async {
    try {
      if (formType == PhoneSignInFormType.sendOTP) {
        updateWith(isLoading: true);
        await auth.signInWithPhoneNumber(phoneNumber, ab,verificationFailed);
//       print(await auth.sendOTP('123456'));
      } else {
        print("This otp is $otp");
        updateWith(submitted: true, isLoading: true);
        await auth.sendOTP(otp, verificationId);

//     print(await auth.sendOTP('123456'));
      }
    } catch (e) {
      print('Got Error');
      updateWith(submitted:false,isLoading: false);
      rethrow;
    }
  }

  String get primaryButtonText {
    return formType == PhoneSignInFormType.sendOTP ? 'Send OTP' : 'Submit';
  }

  String get secondaryButtonText {
    return formType == PhoneSignInFormType.sendOTP
        ? 'Want to Change Number'
        : 'Have an account? Sign in';
  }

  bool get canSubmit {
//    return emailValidator.isValid(phoneNumber) &&
//        !isLoading;
    return true;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(otp);
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
      otp: '',
      formType: formType,
      isLoading: false,
      submitted: false,
    );
  }

  void updatePhoneNumber(String phoneNumber) =>
      updateWith(phoneNumber: phoneNumber);

  void updateOTP(String otp) => updateWith(otp: otp);

  void updateWith({
    String phoneNumber,
    String otp,
    PhoneSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    this.phoneNumber = phoneNumber ?? this.phoneNumber;
    this.otp = otp ?? this.otp;
    this.formType = formType ?? this.formType;
    this.isLoading = isLoading ?? this.isLoading;
    this.submitted = submitted ?? this.submitted;
    notifyListeners();
  }
}
