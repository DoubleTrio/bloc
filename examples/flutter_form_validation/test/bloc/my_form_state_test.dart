// ignore_for_file: prefer_const_constructors
import 'package:flutter_form_validation/bloc/my_form_bloc.dart';
import 'package:flutter_form_validation/models/models.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyFormState', () {
    test('supports value comparison', () {
      expect(MyFormState(), MyFormState());
    });

    test('copyWith works as intended', () {
      expect(MyFormState().copyWith(), MyFormState());
      expect(
        MyFormState().copyWith(email: Email.dirty('example123@gmail.com')),
        isNot(equals(MyFormState())),
      );
    });
  });
}
