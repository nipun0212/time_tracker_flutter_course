import 'dart:ui';

import 'package:time_tracker_flutter_course/app/sign_in/validators.dart';

enum PhoneSignInFormType { sendOTP, submit }

class PhoneSignInModel with EmailAndPasswordValidators {
  PhoneSignInModel({
    this.phoneNumber = '',
    this.otp = '',
    this.formType = PhoneSignInFormType.sendOTP,
    this.isLoading = false,
    this.submitted = false,
  });
  final String phoneNumber;
  final String otp;
  final PhoneSignInFormType formType;
  final bool isLoading;
  final bool submitted;

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
        passwordValidator.isValid(otp) &&
        !isLoading;
  }

  String get passwordErrorText {
    bool showErrorText = submitted && !passwordValidator.isValid(otp);
    return showErrorText ? invalidPasswordErrorText : null;
  }

  String get emailErrorText {
    bool showErrorText = submitted && !emailValidator.isValid(phoneNumber);
    return showErrorText ? invalidEmailErrorText : null;
  }

  PhoneSignInModel copyWith({
    String phoneNumber,
    String otp,
    PhoneSignInFormType formType,
    bool isLoading,
    bool submitted,
  }) {
    return PhoneSignInModel(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      formType: formType ?? this.formType,
      isLoading: isLoading ?? this.isLoading,
      submitted: submitted ?? this.submitted,
    );
  }

  @override
  int get hashCode =>
      hashValues(phoneNumber, otp, formType, isLoading, submitted);

  @override
  bool operator ==(other) {
    if (identical(this, other)) return true;
    if (runtimeType != other.runtimeType) return false;
    final PhoneSignInModel otherModel = other;
    return phoneNumber == otherModel.phoneNumber &&
        otp == otherModel.otp &&
        formType == otherModel.formType &&
        isLoading == otherModel.isLoading &&
        submitted == otherModel.submitted;
  }

  @override
  String toString() =>
      'email: $phoneNumber, password: $otp, formType: $formType, isLoading: $isLoading, submitted: $submitted';

}
