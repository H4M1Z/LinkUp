extension TextFieldValidations on String? {
  bool isAValidNumber() => this!.codeUnits.every(
        (element) => _isADigit(element),
      );

  bool _isADigit(int element) {
    return element >= 48 && element <= 57;
  }
}
