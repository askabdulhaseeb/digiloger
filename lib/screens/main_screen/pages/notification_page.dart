import 'package:digiloger/widgets/notification_tile.dart';
import 'package:flutter/material.dart';

class NotificationPage extends StatelessWidget {
  const NotificationPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Notifications',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView.builder(
        itemCount: 100,
        itemBuilder: (BuildContext context, int index) =>
            const NotificationTile(),
      ),
    );
  }
}
