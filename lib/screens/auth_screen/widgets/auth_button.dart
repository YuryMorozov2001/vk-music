import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../const/enums.dart';
import '../../../logic/auth_bloc/auth_bloc.dart';

class AuthButton extends StatelessWidget {
  const AuthButton({
    Key? key,
    required this.login,
    required this.password,
    required this.context1,
  }) : super(key: key);

  final BuildContext context1;
  final String login;
  final String password;

  @override
  Widget build(BuildContext context) {
    snackBar(errorMsg) => SnackBar(
          duration: const Duration(seconds: 5),
          backgroundColor: Colors.white,
          content: Text(errorMsg),
          action: SnackBarAction(
            label: '[закрыть]',
            textColor: Colors.black,
            onPressed: () {},
          ),
        );
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state.status == Status.submissionFailure &&
            state.errorMessage != null) {
          ScaffoldMessenger.of(context)
              .showSnackBar(snackBar(state.errorMessage));
        }
      },
      builder: (context, state) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: Material(
            color: Colors.white,
            child: InkWell(
              onTap: () {
                FocusScope.of(context).requestFocus(FocusNode());
                if (state.status != Status.submissionInProgress) {
                  context.read<AuthBloc>().add(AuthUserEvent(
                      login: login, password: password, context: context1));
                }
              },
              splashColor: Colors.purple[100],
              splashFactory: InkRipple.splashFactory,
              child: Container(
                color: Colors.transparent,
                height: 50,
                child: Center(
                  child: state.status != Status.submissionInProgress
                      ? Text(
                          'войти',
                          style: TextStyle(
                              color: Colors.black,
                              fontFamily: 'Inter',
                              fontWeight: FontWeight.bold,
                              fontSize: Theme.of(context)
                                  .textTheme
                                  .titleMedium!
                                  .fontSize),
                        )
                      : const SizedBox(
                          height: 18,
                          width: 18,
                          child: CircularProgressIndicator(color: Colors.black),
                        ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
