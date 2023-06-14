import 'package:form_field_validator/form_field_validator.dart';

class NPPhoneValidator extends TextFieldValidator {
  NPPhoneValidator({String errorText = 'Not a valid phone number'})
      : super(errorText);

  @override
  bool get ignoreEmptyValues => true;

  @override
  bool isValid(String? value) {
    return hasMatch(r'(\+977)?[9][6-9]\d{8}', value ?? "");
  }
}
