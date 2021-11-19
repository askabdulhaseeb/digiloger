import 'package:digiloger/utilities/custom_validator.dart';
import 'package:digiloger/utilities/utilities.dart';
import 'package:digiloger/widgets/circular_icon_button.dart';
import 'package:digiloger/widgets/custom_textformfield.dart';
import 'package:digiloger/widgets/password_textformfield.dart';
import 'package:digiloger/widgets/phone_number_field.dart';
import 'package:flutter/material.dart';
import 'package:intl_phone_field/phone_number.dart';

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
  final TextEditingController _contact = TextEditingController();
  final GlobalKey<FormState> _key = GlobalKey<FormState>();
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
            children: [
              Expanded(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    CustomTextFormField(
                      title: 'Brand Name',
                      controller: _brandName,
                      validator: (value) => CustomValidator.lessThen3(value),
                    ),
                    CustomTextFormField(
                      title: 'Email',
                      hint: 'test@test.com',
                      controller: _email,
                      validator: (value) => CustomValidator.email(value),
                    ),
                    PasswordTextFormField(controller: _password),
                    PasswordTextFormField(
                      controller: _confPassword,
                      title: 'Repeat Password',
                    ),
                    CustomTextFormField(
                      title: 'Location',
                      controller: _email,
                      validator: (value) => CustomValidator.email(value),
                    ),
                    PhoneNumberField(onChange: (PhoneNumber phone) {}),
                    const SizedBox(height: 20),
                    CircularIconButton(onTap: () {
                      if (_key.currentState!.validate()) {}
                    }),
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
