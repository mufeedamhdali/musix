import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/images.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../bloc/auth_bloc.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  _login() {
    final authBloc = BlocProvider.of<AuthBloc>(context);
    authBloc.add(LoginEvent(
        password: passwordController.text.trim(),
        email: emailController.text.trim()));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
      if (state is AuthLoading) {
        return Scaffold(
          body: Center(
            child: CircularProgressIndicator(
              color: Theme.of(context).primaryColorDark,
            ),
          ),
        );
      }

      if (state is Authenticated) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          Navigator.pushNamedAndRemoveUntil(context, '/home', (route) => false);
        });
      }

      return Scaffold(
        backgroundColor: Theme.of(context).scaffoldBackgroundColor,
        body: Center(
          child: Container(
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(Images.loginBg),
                  fit: BoxFit.fitWidth,
                  opacity: 30,
                  alignment: Alignment.topCenter),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                const SizedBox(
                  height: 40,
                ),
                CustomTextFormField(
                    key: const Key('email_field'),
                    controller: emailController,
                    marginHorizontal: 0,
                    hintText: "Email"),
                const SizedBox(
                  height: 10,
                ),
                CustomTextFormField(
                    key: const Key('password_field'),
                    obscureText: true,
                    controller: passwordController,
                    hintText: "Password"),
                const SizedBox(
                  height: 10,
                ),
                InkResponse(
                    onTap: () {
                      _login();
                    },
                    child: Container(
                        key: const Key('login_btn'),
                        alignment: Alignment.center,
                        width: MediaQuery.of(context).size.width,
                        padding: const EdgeInsets.only(top: 15, bottom: 15),
                        decoration: BoxDecoration(
                          color: Theme.of(context).primaryColorDark,
                          borderRadius: BorderRadius.circular(15),
                          boxShadow: [
                            BoxShadow(
                              offset: const Offset(5, 5),
                              blurRadius: 15,
                              color: Theme.of(context).shadowColor,
                              spreadRadius: 2,
                            )
                          ],
                        ),
                        margin: const EdgeInsets.only(left: 20, right: 20),
                        child: Text(
                          "Login",
                          style: TextStyle(
                              fontSize: 18,
                              color: Theme.of(context).primaryColorLight),
                        ))),
                const SizedBox(
                  height: 20,
                ),
                InkWell(
                  onTap: () {
                    Navigator.pushNamed(context, '/register');
                  },
                  child: Center(
                      child: Text(
                    "Create Account",
                    style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Theme.of(context).primaryColorDark),
                  )),
                ),
                const SizedBox(
                  height: 150,
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
