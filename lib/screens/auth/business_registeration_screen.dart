import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl_phone_field/phone_number.dart';
import '../../database/auth_methods.dart';
import '../../database/user_api.dart';
import '../../models/app_user.dart';
import '../../utilities/custom_validator.dart';
import '../../utilities/utilities.dart';
import '../../widgets/circular_icon_button.dart';
import '../../widgets/custom_textformfield.dart';
import '../../widgets/custom_toast.dart';
import '../../widgets/password_textformfield.dart';
import '../../widgets/phone_number_field.dart';
import '../../widgets/show_loading.dart';
import 'login_screen.dart';

class BusinessRegisterationScreen extends StatefulWidget {
  const BusinessRegisterationScreen({Key? key}) : super(key: key);
  static const String routeName = '/BusinessRegisterationScreen';
  @override
  _BusinessRegisterationScreenState createState() =>
      _BusinessRegisterationScreenState();
}

class _BusinessRegisterationScreenState
    extends State<BusinessRegisterationScreen> {
  final TextEditingController _brandName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confPassword = TextEditingController();
  final TextEditingController _location = TextEditingController();
  // final TextEditingController _contact = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String number = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Register Business Account'),
      ),
      body: Padding(
        padding: EdgeInsets.all(Utilities.padding),
        child: Form(
          key: _key,
          child: Column(
            children: <Widget>[
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: <Widget>[
                    CustomTextFormField(
                      title: 'Brand Name',
                      controller: _brandName,
                      validator: (String? value) =>
                          CustomValidator.lessThen3(value),
                    ),
                    CustomTextFormField(
                      title: 'Email',
                      hint: 'test@test.com',
                      controller: _email,
                      validator: (String? value) =>
                          CustomValidator.email(value),
                    ),
                    PasswordTextFormField(controller: _password),
                    PasswordTextFormField(
                      controller: _confPassword,
                      title: 'Repeat Password',
                    ),
                    CustomTextFormField(
                      title: 'Location',
                      controller: _location,
                      validator: (String? value) =>
                          CustomValidator.lessThen3(value),
                    ),
                    PhoneNumberField(onChange: (PhoneNumber phone) {
                      number = phone.completeNumber;
                    }),
                    const SizedBox(height: 20),
                    CircularIconButton(
                      onTap: () async {
                        if (_key.currentState!.validate()) {
                          if (_password.text == _confPassword.text) {
                            showLoadingDislog(context);
                            final User? _user =
                                await AuthMethods().signupWithEmailAndPassword(
                              email: _email.text,
                              password: _password.text,
                            );
                            if (_user != null) {
                              final AppUser _appUser = AppUser(
                                uid: _user.uid,
                                name: _brandName.text,
                                email: _email.text,
                                isBuiness: true,
                                location: _location.text.trim(),
                                phoneNumber: number.trim(),
                              );
                              final bool _okay =
                                  await UserAPI().addUser(_appUser);
                              if (_okay) {
                                CustomToast.successToast(
                                  message: 'Register Successfully',
                                );
                                Navigator.of(context).pushNamedAndRemoveUntil(
                                  LoginScreen.routeName,
                                  (Route<dynamic> route) => false,
                                );
                              } else {
                                Navigator.of(context).pop();
                              }
                            }
                          } else {
                            CustomToast.errorToast(
                              message:
                                  'Password and Repeat password are not same!!',
                            );
                          }
                        }
                      },
                    ),
                  ],
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text(
                    '''Already have an account?''',
                    style: TextStyle(color: Colors.grey),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).pushNamedAndRemoveUntil(
                          LoginScreen.routeName,
                          (Route<dynamic> route) => false);
                    },
                    child: const Text('Login'),
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
