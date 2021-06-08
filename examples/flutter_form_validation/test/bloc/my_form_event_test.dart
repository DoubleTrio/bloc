// ignore_for_file: prefer_const_constructors
import 'package:flutter_form_validation/bloc/my_form_bloc.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('MyFormEvent', () {
    group('EmailChanged', () {
      test('supports value comparison', () {
        expect(
          EmailChanged(email: 'example123@gmail.com'),
          EmailChanged(email: 'example123@gmail.com'),
        );
      });
    });

    group('EmailChanged', () {
      test('supports value comparison', () {
        expect(EmailUnfocused(), EmailUnfocused());
      });
    });

    group('PasswordChanged', () {
      test('supports value comparison', () {
        expect(PasswordChanged(password: 'password123'),
            PasswordChanged(password: 'password123'));
      });
    });

    group('PasswordUnfocused', () {
      test('supports value comparison', () {
        expect(PasswordUnfocused(), PasswordUnfocused());
      });
    });

    group('FormSubmitted', () {
      test('supports value comparison', () {
        expect(FormSubmitted(), FormSubmitted());
      });
    });
  });
}
