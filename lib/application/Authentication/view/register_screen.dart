import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../utils/images.dart';
import '../../../widgets/custom_text_form_field.dart';
import '../bloc/auth_bloc.dart';
import '../model/user_model.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AuthBloc(),
      child: const RegisterView(),
    );
  }
}

class RegisterView extends StatefulWidget {
  const RegisterView({super.key});

  @override
  State<RegisterView> createState() => _RegisterViewState();
}

class _RegisterViewState extends State<RegisterView> {
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    super.dispose();
  }

  _signUp() {
    final authBloc = BlocProvider.of<AuthBloc>(context);

    UserModel user = UserModel(
      name: nameController.text,
      email: emailController.text,
      password: passwordController.text,
    );

    authBloc.add(SignupEvent(user: user));
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<AuthBloc, AuthState>(builder: (context, state) {
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
                    controller: nameController, hintText: "Enter Name"),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                    controller: emailController, hintText: "Enter Email"),
                const SizedBox(
                  height: 20,
                ),
                CustomTextFormField(
                    obscureText: true,
                    controller: passwordController,
                    hintText: "Enter Password"),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                InkResponse(
                  onTap: () {
                    _signUp();
                  },
                  child: Container(
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
                        "Register",
                        style: TextStyle(
                            fontSize: 18,
                            color: Theme.of(context).primaryColorLight),
                      )),
                ),
                const SizedBox(
                  height: 20,
                ),
                TextButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: Text("Login",
                        style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w500,
                            color: Theme.of(context).primaryColorDark)))
              ],
            ),
          ),
        ),
      );
    });
  }
}
