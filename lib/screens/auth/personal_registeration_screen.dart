import 'package:digiloger/screens/auth/login_screen.dart';
import 'package:digiloger/utilities/custom_validator.dart';
import 'package:digiloger/utilities/utilities.dart';
import 'package:digiloger/widgets/circular_icon_button.dart';
import 'package:digiloger/widgets/custom_textformfield.dart';
import 'package:digiloger/widgets/password_textformfield.dart';
import 'package:flutter/material.dart';

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
  final List<int> _dateList = [for (var i = 1; i <= 31; i++) i];
  final List<int> _monthList = [for (var i = 1; i <= 12; i++) i];
  final List<int> _yearList = [
    for (var i = DateTime.now().year; i >= 1900; i--) i
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
                    _dob_dropdown(context),
                    DropdownButton<String>(
                      underline: const SizedBox(),
                      hint: const Text("Select Gender"),
                      value: _gender,
                      items: const <DropdownMenuItem<String>>[
                        DropdownMenuItem(child: Text('Male'), value: 'm'),
                        DropdownMenuItem(child: Text('Female'), value: 'f'),
                        DropdownMenuItem(child: Text('other'), value: 'o'),
                      ],
                      onChanged: (String? value) {
                        setState(() {
                          _gender = value!;
                        });
                      },
                    ),
                    const SizedBox(height: 20),
                    CircularIconButton(onTap: () {
                      if (_key.currentState!.validate()) {}
                    }),
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

  Row _dob_dropdown(BuildContext context) {
    return Row(
      children: [
        const SizedBox(width: 4),
        DropdownButton<int>(
          menuMaxHeight: MediaQuery.of(context).size.height * 0.7,
          underline: const SizedBox(),
          hint: const Text("Date"),
          value: _date,
          items: _dateList
              .map((e) => DropdownMenuItem<int>(
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
              .map((e) => DropdownMenuItem<int>(
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
              .map((e) => DropdownMenuItem<int>(
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
