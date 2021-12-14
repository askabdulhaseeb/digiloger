import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../../database/auth_methods.dart';
import '../../database/user_api.dart';
import '../../models/app_user.dart';
import '../../utilities/custom_validator.dart';
import '../../utilities/utilities.dart';
import '../../widgets/circular_icon_button.dart';
import '../../widgets/custom_textformfield.dart';
import '../../widgets/custom_toast.dart';
import '../../widgets/password_textformfield.dart';
import '../../widgets/show_loading.dart';
import 'login_screen.dart';

class PersonalRegisterationScreen extends StatefulWidget {
  const PersonalRegisterationScreen({Key? key}) : super(key: key);
  static const String routeName = '/PersonalRegisterationScreen';
  @override
  _PersonalRegisterationScreenState createState() =>
      _PersonalRegisterationScreenState();
}

class _PersonalRegisterationScreenState
    extends State<PersonalRegisterationScreen> {
  final TextEditingController _firstName = TextEditingController();
  final TextEditingController _lastName = TextEditingController();
  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final TextEditingController _confPassword = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
  String? _gender;
  int? _date;
  int? _month;
  int? _year;
  final List<int> _dateList = <int>[for (int i = 1; i <= 31; i++) i];
  final List<int> _monthList = <int>[for (int i = 1; i <= 12; i++) i];
  final List<int> _yearList = <int>[
    for (int i = DateTime.now().year; i >= 1900; i--) i
  ];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text('Register Personal Account'),
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
                      title: 'First Name',
                      hint: 'First Name',
                      controller: _firstName,
                      validator: (String? value) =>
                          CustomValidator.lessThen3(value),
                    ),
                    CustomTextFormField(
                      title: 'Last Name',
                      hint: 'Last Name',
                      controller: _lastName,
                      validator: (String? value) =>
                          CustomValidator.lessThen3(value),
                    ),
                    CustomTextFormField(
                      title: 'email',
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
                    const SizedBox(height: 10),
                    const Text(
                      ' Date of Birth',
                      style: TextStyle(fontSize: 18, color: Colors.black54),
                    ),
                    _dobDropdown(context),
                    DropdownButton<String>(
                      underline: const SizedBox(),
                      hint: const Text("Select Gender"),
                      value: _gender,
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem<String>(
                          child: Text('Male'),
                          value: 'm',
                        ),
                        DropdownMenuItem<String>(
                          child: Text('Female'),
                          value: 'f',
                        ),
                        DropdownMenuItem<String>(
                          child: Text('other'),
                          value: 'o',
                        ),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
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
                                name: '${_firstName.text} ${_lastName.text}',
                                email: _email.text,
                                isBuiness: false,
                                gender: _gender,
                                dob: '$_date-$_month-$_year',
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
                    const SizedBox(height: 20),
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

  Row _dobDropdown(BuildContext context) {
    return Row(
      children: <Widget>[
        const SizedBox(width: 4),
        DropdownButton<int>(
          menuMaxHeight: MediaQuery.of(context).size.height * 0.7,
          underline: const SizedBox(),
          hint: const Text("Date"),
          value: _date,
          items: _dateList
              .map((int e) => DropdownMenuItem<int>(
                    value: e,
                    child: Text('$e'),
                  ))
              .toList(),
          onChanged: (int? value) {
            setState(() {
              _date = value!;
            });
          },
        ),
        DropdownButton<int>(
          menuMaxHeight: MediaQuery.of(context).size.height * 0.7,
          underline: const SizedBox(),
          hint: const Text("Month"),
          value: _month,
          items: _monthList
              .map((int e) => DropdownMenuItem<int>(
                    value: e,
                    child: Text('$e'),
                  ))
              .toList(),
          onChanged: (int? value) {
            setState(() {
              _month = value!;
            });
          },
        ),
        DropdownButton<int>(
          menuMaxHeight: MediaQuery.of(context).size.height * 0.7,
          underline: const SizedBox(),
          hint: const Text("Date"),
          value: _year,
          items: _yearList
              .map((int e) => DropdownMenuItem<int>(
                    value: e,
                    child: Text('$e'),
                  ))
              .toList(),
          onChanged: (int? value) {
            setState(() {
              _year = value!;
            });
          },
        ),
      ],
    );
  }
}
