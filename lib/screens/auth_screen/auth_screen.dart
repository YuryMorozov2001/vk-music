import 'package:flutter/material.dart'; 
import 'widgets/auth_button.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key, required this.context1}) : super(key: key);
  final BuildContext context1;

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  late TextEditingController loginController;
  late TextEditingController passwordController;
  String login = '';
  String password = '';
  @override
  void initState() {
    loginController = TextEditingController();
    passwordController = TextEditingController();
    super.initState();
  }

  bool obscurePassword = true;
  @override
  Widget build(BuildContext context) {
    InputDecorationTheme inputDecoration = InputDecorationTheme(
      focusedBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(16)),
      enabledBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: Colors.white, width: 2.0),
          borderRadius: BorderRadius.circular(16)),
    );
    return LayoutBuilder(builder: (_, c) {
      return Scaffold(
        backgroundColor: Theme.of(context).backgroundColor,
        body: Center(
            child: SizedBox(
          width: c.maxWidth * 0.8,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Align(
                alignment: Alignment.center,
                child: Text(
                  'Авторизация',
                  style: TextStyle(
                      fontFamily: 'Inter',
                      fontWeight: FontWeight.bold,
                      fontSize:
                          Theme.of(context).textTheme.titleLarge!.fontSize),
                ),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: loginController,
                onChanged: (value) => setState(() {}),
                decoration: const InputDecoration(hintText: 'Логин')
                    .applyDefaults(inputDecoration),
              ),
              const SizedBox(height: 8),
              TextField(
                controller: passwordController,
                obscureText: obscurePassword,
                enableSuggestions: false,
                autocorrect: false,
                onChanged: (value) => setState(() {}),
                decoration: InputDecoration(
                  hintText: 'Пароль',
                  suffixIcon: IconButton(
                    onPressed: () => setState(() {
                      obscurePassword = !obscurePassword;
                    }),
                    icon: Icon(obscurePassword
                        ? Icons.visibility_rounded
                        : Icons.visibility_off),
                  ),
                ).applyDefaults(inputDecoration),
              ),
              const SizedBox(height: 8),
              AuthButton(
                context1: widget.context1,
                login: loginController.text,
                password: passwordController.text,
              )
            ],
          ),
        )),
      );
    });
  }
}
