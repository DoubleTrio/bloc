import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_form_validation/bloc/my_form_bloc.dart';
import 'package:flutter_form_validation/models/models.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:formz/formz.dart';

void main() {
  group('MyFormBloc', () {
    const validEmail = Email.dirty('example123@gmail.com');
    const invalidEmail = Email.pure('invalid-email');
    const validPassword = Password.dirty('password123');
    const invalidPassword = Password.pure('invalid-password');

    test('initial state is MyFormState', () {
      expect(MyFormBloc().state, const MyFormState());
    });

    blocTest<MyFormBloc, MyFormState>(
      'emits valid form status '
      'when mail is changed to an valid email',
      build: () => MyFormBloc(),
      seed: () => const MyFormState(
        password: validPassword,
      ),
      act: (bloc) => bloc.add(EmailChanged(email: validEmail.value)),
      expect: () => <MyFormState>[
        const MyFormState(
          email: validEmail,
          password: validPassword,
          status: FormzStatus.valid,
        ),
      ],
    );

    blocTest<MyFormBloc, MyFormState>(
      'emits invalid form status '
      'when email is changed to an invalid email',
      build: () => MyFormBloc(),
      seed: () => const MyFormState(
        password: validPassword,
      ),
      act: (bloc) => bloc.add(EmailChanged(email: invalidEmail.value)),
      expect: () => <MyFormState>[
        const MyFormState(
          email: invalidEmail,
          password: validPassword,
          status: FormzStatus.invalid,
        ),
      ],
    );

    blocTest<MyFormBloc, MyFormState>(
      'emits valid form status '
      'when password is changed to a valid password',
      build: () => MyFormBloc(),
      seed: () => const MyFormState(
        email: validEmail,
      ),
      act: (bloc) => bloc.add(PasswordChanged(password: validPassword.value)),
      expect: () => <MyFormState>[
        const MyFormState(
          email: validEmail,
          password: validPassword,
          status: FormzStatus.valid,
        ),
      ],
    );

    blocTest<MyFormBloc, MyFormState>(
      'emits valid form status '
      'when password is changed to a valid password',
      build: () => MyFormBloc(),
      seed: () => const MyFormState(
        email: validEmail,
      ),
      act: (bloc) => bloc.add(PasswordChanged(password: validPassword.value)),
      expect: () => <MyFormState>[
        const MyFormState(
          email: validEmail,
          password: validPassword,
          status: FormzStatus.valid,
        ),
      ],
    );

    blocTest<MyFormBloc, MyFormState>(
      'emits invalid form status '
      'when password is changed to a invalid password',
      build: () => MyFormBloc(),
      seed: () => const MyFormState(
        email: validEmail,
      ),
      act: (bloc) => bloc.add(PasswordChanged(password: invalidPassword.value)),
      expect: () => <MyFormState>[
        const MyFormState(
          email: validEmail,
          password: invalidPassword,
          status: FormzStatus.invalid,
        ),
      ],
    );

    blocTest<MyFormBloc, MyFormState>(
      'emits dirty email when email field becomes unfocused',
      build: () => MyFormBloc(),
      seed: () => const MyFormState(
        email: invalidEmail,
      ),
      act: (bloc) => bloc.add(EmailUnfocused()),
      expect: () => <MyFormState>[
        MyFormState(
          email: Email.dirty(invalidEmail.value),
          status: FormzStatus.invalid,
        ),
      ],
    );

    blocTest<MyFormBloc, MyFormState>(
      'emits dirty password when password field becomes unfocused',
      build: () => MyFormBloc(),
      seed: () => const MyFormState(
        password: invalidPassword,
      ),
      act: (bloc) => bloc.add(PasswordUnfocused()),
      expect: () => <MyFormState>[
        MyFormState(
          password: Password.dirty(invalidPassword.value),
          status: FormzStatus.invalid,
        ),
      ],
    );

    blocTest<MyFormBloc, MyFormState>(
      'only emits dirty email, dirty password, and invalid status '
      'when invalid form is submitted',
      build: () => MyFormBloc(),
      seed: () => const MyFormState(
        email: invalidEmail,
        password: invalidPassword,
      ),
      act: (bloc) => bloc.add(FormSubmitted()),
      expect: () => <MyFormState>[
        MyFormState(
          email: Email.dirty(invalidEmail.value),
          password: Password.dirty(invalidPassword.value),
          status: FormzStatus.invalid,
        ),
      ],
    );

    blocTest<MyFormBloc, MyFormState>(
      'emits correct states when valid form is submitted successfully',
      build: () => MyFormBloc(),
      seed: () => const MyFormState(
        email: validEmail,
        password: validPassword,
      ),
      act: (bloc) => bloc.add(FormSubmitted()),
      expect: () => <MyFormState>[
        const MyFormState(
          email: validEmail,
          password: validPassword,
          status: FormzStatus.valid,
        ),
        const MyFormState(
          email: validEmail,
          password: validPassword,
          status: FormzStatus.submissionInProgress,
        ),
        const MyFormState(
          email: validEmail,
          password: validPassword,
          status: FormzStatus.submissionSuccess,
        ),
      ],
    );
  });
}
