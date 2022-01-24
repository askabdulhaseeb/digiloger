import 'package:digiloger/database/user_api.dart';
import 'package:digiloger/models/app_user.dart';
import 'package:digiloger/screens/other_user_profile/other_user_profile.dart';
import 'package:digiloger/widgets/custom_textformfield.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({Key? key}) : super(key: key);
  static const String routeName = '/SearchScreennn';
  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String _text = '';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: _appBar(context),
      body: FutureBuilder<List<AppUser>>(
        future: UserAPI().allUsers(),
        builder: (BuildContext context, AsyncSnapshot<List<AppUser>> snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(
              child: SizedBox(
                height: 30,
                width: 30,
                child: CircularProgressIndicator.adaptive(),
              ),
            );
          } else {
            if (snapshot.hasError) {
              return const Center(
                child: Text('Facing some issues'),
              );
            } else {
              List<AppUser> _all = snapshot.data!;
              List<AppUser> _filter = <AppUser>[];
              _filter = _all
                  .where((AppUser element) =>
                      element.name.toLowerCase().contains(_text.toLowerCase()))
                  .toList();
              return ListView.builder(
                itemCount: _filter.length,
                itemBuilder: (BuildContext context, int index) {
                  AppUser _userr = _filter[index];
                  return ListTile(
                    onTap: () {
                      Navigator.of(context)
                          .push(MaterialPageRoute<OtherUserProfile>(
                        builder: (BuildContext context) => OtherUserProfile(
                          username: _userr.email,
                          uid: _userr.uid,
                        ),
                      ));
                    },
                    title: Text(_userr.name),
                    subtitle: Text(_userr.email),
                  );
                },
              );
            }
          }
        },
      ),
    );
  }

  AppBar _appBar(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.transparent,
      elevation: 0,
      title: TextFormField(
        onChanged: (String value) => setState(() {
          _text = value;
        }),
        decoration: InputDecoration(
          contentPadding: const EdgeInsets.all(0),
          hintText: 'search here ...',
          prefixIcon: const Icon(CupertinoIcons.search),
          focusColor: Theme.of(context).primaryColor,
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          border: OutlineInputBorder(
            borderSide: BorderSide(color: Theme.of(context).primaryColor),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
    );
  }
}
