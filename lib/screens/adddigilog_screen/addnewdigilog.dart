import 'package:digiloger/screens/adddigilog_screen/add_details.dart';
import 'package:digiloger/widgets/custom_text_button.dart';
import 'package:flutter/material.dart';
import '../../widgets/unposted_digilogs.dart';

class AddNewDigilog extends StatefulWidget {
  const AddNewDigilog({Key? key}) : super(key: key);

  @override
  @override
  _AddNewDigilogState createState() => _AddNewDigilogState();
}

class _AddNewDigilogState extends State<AddNewDigilog> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: <Widget>[
          const SizedBox(height: 150),
          CustomTextButton(
            text: 'ADD NEW'.toUpperCase(),
            onTap: () => Navigator.of(context).pushNamed(AddDetails.routeName),
          ),
          const SizedBox(height: 70),
          Text(
            "Continue working on unpublished DigiLogs".toUpperCase(),
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(
            height: 30,
          ),
          const SizedBox(
            height: 430,
            child: Unposteddigilogs(),
          ),
        ],
      ),
    );
  }
}
