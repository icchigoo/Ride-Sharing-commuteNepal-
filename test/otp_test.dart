// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: unused_import, directives_ordering

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import './step/i_am_on_the_login_page.dart';
import './step/i_enter_a_valid_phone_number.dart';
import './step/i_click_on_the_next_button.dart';
import './step/i_should_get_verification_code.dart';

void main() {
  group('''OTP Verification''', () {
    testWidgets('''The number field is empty''', (tester) async {
      await iAmOnTheLoginPage(tester);
      await iEnterAValidPhoneNumber(tester);
      await iClickOnTheNextButton(tester);
      await iShouldGetVerificationCode(tester);
    });
  });
}
