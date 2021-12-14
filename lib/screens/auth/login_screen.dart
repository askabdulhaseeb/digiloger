import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../database/auth_methods.dart';
import '../../utilities/custom_image.dart';
import '../../utilities/custom_validator.dart';
import '../../utilities/utilities.dart';
import '../../widgets/circular_icon_button.dart';
import '../../widgets/custom_iconic_text_button.dart';
import '../../widgets/custom_textformfield.dart';
import '../../widgets/custom_toast.dart';
import '../../widgets/password_textformfield.dart';
import '../../widgets/show_loading.dart';
import '../main_screen/main_screen.dart';
import 'forget_password_screen.dart';
import 'registeration_type_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({Key? key}) : super(key: key);
  static const String routeName = '/LoginScreen';
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(Utilities.padding),
        child: Form(
          key: _key,
          child: Column(
            children: <Widget>[
              const SizedBox(height: 60),
              Padding(
                padding: EdgeInsets.all(Utilities.padding * 2),
                child: Image.asset(CustomImages.logo),
              ),
              CustomTextFormField(
                title: 'Email',
                controller: _email,
                hint: 'test@test.com',
                validator: (String? value) => CustomValidator.email(value),
              ),
              PasswordTextFormField(
                controller: _password,
              ),
              Container(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => Navigator.of(context)
                      .pushNamed(ForgetPasswordScreen.routeName),
                  child: const Text('Forget Password?'),
                ),
              ),
              CircularIconButton(onTap: () async {
                if (_key.currentState!.validate()) {
                  showLoadingDislog(context);
                  final User? _user =
                      await AuthMethods().loginWithEmailAndPassword(
                    _email.text,
                    _password.text,
                  );
                  if (_user != null) {
                    Navigator.of(context).pushNamedAndRemoveUntil(
                      MainScreen.routeName,
                      (Route<dynamic> route) => false,
                    );
                  } else {
                    Navigator.of(context).pop();
                  }
                }
              }),
              Padding(
                padding: EdgeInsets.symmetric(vertical: Utilities.padding * 2),
                child: Row(
                  children: <Widget>[
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width * 0.4,
                      color: Colors.grey,
                    ),
                    const Text(' OR '),
                    Container(
                      height: 1,
                      width: MediaQuery.of(context).size.width * 0.4,
                      color: Colors.grey,
                    ),
                  ],
                ),
              ),
              CustomImageTextButton(
                image: CustomImages.facebook,
                text: 'Login with Facebook',
                onTap: () {
                  CustomToast.showSnackBar(
                    context: context,
                    text: 'chup karke beh jini teri auqat aa othy reh',
                  );
                },
              ),
              const SizedBox(height: 10),
              CustomImageTextButton(
                image: CustomImages.google,
                text: 'Login with Google',
                onTap: () {
                  CustomToast.showSnackBar(
                    context: context,
                    text: 'Bhoooot Ram mot mro gy',
                  );
                },
              ),
              const Spacer(),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    '''Don't have an account?''',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context)
                          .pushNamed(RegisterationTypeScreen.routeName);
                    },
                    child: const Text('Register'),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }
}
