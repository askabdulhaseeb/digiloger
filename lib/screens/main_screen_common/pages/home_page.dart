import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/widgets/show_loading.dart';
import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import '../../../utilities/custom_image.dart';
import '../../../widgets/post_tile.dart';
import '../../chat_dashboard_screen/chat_dashboard_screen.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: SizedBox(
          height: 46,
          child: Image.asset(CustomImages.logo),
        ),
        actions: <Widget>[
          IconButton(
            splashRadius: 20,
            onPressed: () =>
                Navigator.of(context).pushNamed(ChatDashboardScreen.routeName),
            icon: const Icon(CupertinoIcons.chat_bubble_2),
          )
        ],
      ),
      body: FutureBuilder<List<Digilog>>(
        future: DigilogAPI().getallfirebasedigilogs(),
        builder: (BuildContext context, AsyncSnapshot<List<Digilog>> snapshot) {
          if (snapshot.hasError) {
            return const _ErrorWidget();
          } else {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const ShowLoading();
            } else {
              List<Digilog> _digilog = snapshot.data!;
              return ListView.separated(
                itemCount: _digilog.length,
                separatorBuilder: (BuildContext context, int index) => Divider(
                  color: Colors.grey[200],
                  thickness: 4,
                ),
                itemBuilder: (BuildContext context, int index) {
                  return PostTile(digilog: _digilog[index]);
                },
              );
            }
          }
        },
      ),
    );
  }
}

class _ErrorWidget extends StatelessWidget {
  const _ErrorWidget({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: const <Widget>[
          Text(
            'Some thing goes wrong',
            style: TextStyle(color: Colors.grey),
          ),
        ],
      ),
    );
  }
}
