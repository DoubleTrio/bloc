import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_form_validation/app.dart';
import 'package:flutter_form_validation/bloc/my_form_bloc.dart';
import 'package:flutter_form_validation/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';
import 'package:mocktail/mocktail.dart';

class MockMyFormBloc extends Mock implements MyFormBloc {}

class FakeMyFormState extends Fake implements MyFormState {}

class FakeMyFormEvent extends Fake implements MyFormEvent {}

extension on WidgetTester {
  Future<void> pumpMyForm(MyFormBloc myFormBloc) {
    return pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: BlocProvider.value(
            value: myFormBloc,
            child: MyForm(),
          ),
        ),
      ),
    );
  }
}

void main() {
  group('App', () {
    testWidgets('renders MyForm', (tester) async {
      await tester.pumpWidget(App());
      expect(find.byType(MyForm), findsOneWidget);
    });
  });

  group('MyForm', () {
    const validEmail = Email.dirty('example123@gmail.com');
    const invalidEmail = Email.pure('invalid-email');
    const validPassword = Password.dirty('password123');
    const invalidPassword = Password.pure('invalid-password');

    late MyFormBloc myFormBloc;

    setUpAll(() {
      registerFallbackValue<MyFormState>(FakeMyFormState());
      registerFallbackValue<MyFormEvent>(FakeMyFormEvent());
    });

    setUp(() {
      myFormBloc = MockMyFormBloc();
      whenListen<MyFormState>(myFormBloc, Stream.value(const MyFormState()),
          initialState: const MyFormState());
    });

    testWidgets('unfocuses away from EmailInput', (tester) async {
      await tester.pumpMyForm(myFormBloc);

      await tester.tap(find.byType(EmailInput));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(PasswordInput));
      await tester.pumpAndSettle();
      verify(() => myFormBloc.add(EmailUnfocused())).called(1);
    });

    testWidgets('unfocuses away from PasswordInput', (tester) async {
      await tester.pumpMyForm(myFormBloc);

      await tester.tap(find.byType(PasswordInput));
      await tester.pumpAndSettle();
      await tester.tap(find.byType(EmailInput));
      await tester.pumpAndSettle();
      verify(() => myFormBloc.add(PasswordUnfocused())).called(1);
    });

    testWidgets('can change text in EmailInput', (tester) async {
      await tester.pumpMyForm(myFormBloc);
      await tester.enterText(find.byType(EmailInput), 'email');
      verify(() => myFormBloc.add(const EmailChanged(email: 'email')))
          .called(1);
    });

    testWidgets('can change text in PasswordInput', (tester) async {
      await tester.pumpMyForm(myFormBloc);
      await tester.enterText(find.byType(PasswordInput), 'password');
      verify(() => myFormBloc.add(const PasswordChanged(password: 'password')))
          .called(1);
    });

    testWidgets('renders error email text', (tester) async {
      when(() => myFormBloc.state).thenReturn(MyFormState(
        email: Email.dirty(invalidEmail.value),
      ));

      await tester.pumpMyForm(myFormBloc);

      expect(find.text('Please ensure the email entered is valid'),
          findsOneWidget);
    });

    testWidgets('renders error password text', (tester) async {
      when(() => myFormBloc.state).thenReturn(MyFormState(
        password: Password.dirty(invalidPassword.value),
      ));
      await tester.pumpMyForm(myFormBloc);

      expect(
          find.text(
              '''Password must be at least 8 characters and contain at least one letter and number'''),
          findsOneWidget);
    });

    testWidgets(
        'submits form when submit button is tapped '
        'and form is validated', (tester) async {
      when(() => myFormBloc.state).thenReturn(const MyFormState(
        email: validEmail,
        password: validPassword,
        status: FormzStatus.valid,
      ));
      await tester.pumpMyForm(myFormBloc);
      await tester.tap(find.text('Submit'));
      verify(() => myFormBloc.add(FormSubmitted())).called(1);
    });

    testWidgets('does not submit form when form is not validated',
        (tester) async {
      await tester.pumpMyForm(myFormBloc);
      await tester.tap(find.text('Submit'));
      verifyNever(() => myFormBloc.add(FormSubmitted()));
    });

    testWidgets('renders SnackBar while form is being submitted',
        (tester) async {
      whenListen<MyFormState>(
        myFormBloc,
        Stream.value(
            const MyFormState(status: FormzStatus.submissionInProgress)),
      );
      await tester.pumpMyForm(myFormBloc);
      await tester.pumpAndSettle();
      expect(find.byType(SnackBar), findsOneWidget);
      expect(find.text('Submitting...'), findsOneWidget);
    });

    testWidgets(
        'renders SuccessDialog '
        'when form is submitted', (tester) async {
      whenListen<MyFormState>(
        myFormBloc,
        Stream.value(const MyFormState(status: FormzStatus.submissionSuccess)),
      );
      await tester.pumpMyForm(myFormBloc);
      await tester.pumpAndSettle();
      expect(find.byType(SuccessDialog), findsOneWidget);
      expect(find.text('Form Submitted Successfully!'), findsOneWidget);
    });

    testWidgets(
        'pops SuccessDialog '
        'after pressing the \'OK\' button', (tester) async {
      whenListen<MyFormState>(
        myFormBloc,
        Stream.value(const MyFormState(status: FormzStatus.submissionSuccess)),
      );
      await tester.pumpMyForm(myFormBloc);
      await tester.pumpAndSettle();
      await tester.tap(find.text('OK'));
      await tester.pumpAndSettle();
      expect(find.byType(SuccessDialog), findsNothing);
    });
  });
}
