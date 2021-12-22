import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/database/user_api.dart';
import 'package:digiloger/models/app_user.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/providers/digilog_provider.dart';
import 'package:digiloger/screens/digilog_view_screen/digilog_view.dart';
import 'package:digiloger/screens/other_user_profile/other_user_profile.dart';
import 'package:digiloger/utilities/custom_image.dart';
import 'package:digiloger/utilities/utilities.dart';

import 'package:extended_image/extended_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';
import 'package:provider/provider.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage>
    with SingleTickerProviderStateMixin {
  late FocusNode myFocusNode;
  bool search = false;
  bool _focused = false;
  late TabController _controller;
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _controller = TabController(length: 3, vsync: this, initialIndex: 1);
    myFocusNode = FocusNode();
    myFocusNode.addListener(_handleFocusChange);
    _searchController.addListener(() {
      _onChanged();
    });
  }

  @override
  Widget build(BuildContext context) {
    DigilogProvider _provider = Provider.of<DigilogProvider>(context);
    Size _screen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: searchappbar(68),
      body: _focused
          ? TabBarView(
              controller: _controller,
              children: <Widget>[
                getAccountsList(),
                getDigilogsList(_provider),
                getDigilogsListbylocation(_provider),
              ],
            )
          : Container(
              height: _screen.height,
              width: _screen.width,
              color: Colors.white,
              child: FutureBuilder<List<Digilog>>(
                  future: getdigilogs(),
                  builder: (BuildContext context,
                      AsyncSnapshot<List<Digilog>> snapshot) {
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return const SizedBox(
                          height: double.infinity,
                          width: double.infinity,
                          child: CircularProgressIndicator.adaptive(),
                        );
                      default:
                        if ((snapshot.hasError)) {
                          return _errorWidget();
                        } else {
                          if (snapshot.hasData) {
                            if (snapshot.data!.isNotEmpty) {
                              return StaggeredGridView.countBuilder(
                                crossAxisCount: 4,
                                itemCount: snapshot.data!.length,
                                itemBuilder:
                                    (BuildContext context, int index) =>
                                        InkWell(
                                  onTap: () {
                                    _provider
                                        .onUpdatedigi(snapshot.data![index]);
                                    Navigator.of(context)
                                        .pushNamed(DigilogView.routeName);
                                  },
                                  child: ExtendedImage.network(
                                    snapshot.data![index].experiences.first
                                        .mediaUrl,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                                staggeredTileBuilder: (int index) =>
                                    StaggeredTile.count(
                                        2, index.isEven ? 2 : 1),
                                mainAxisSpacing: 1,
                                crossAxisSpacing: 1,
                              );
                            } else {
                              return const Text("NO DIGILOGS POSTED");
                            }
                          } else {
                            return const Text("NO DIGILOGS POSTED");
                          }
                        }
                    }
                  }),
            ),
    );
  }

  Future<List<Digilog>> getdigilogs() async {
    return await DigilogAPI().getallfirebasedigilogs();
  }

  SizedBox _errorWidget() {
    return SizedBox(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child: Column(
          children: const <Widget>[
            Icon(Icons.info, color: Colors.grey),
            Text(
              'Facing some issues',
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  void _handleFocusChange() {
    if (myFocusNode.hasFocus != _focused) {
      setState(() {
        _focused = myFocusNode.hasFocus;
      });
    }
  }

  AppBar searchappbar(double height) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      title: TextFormField(
        controller: _searchController,
        scrollPadding: EdgeInsets.zero,
        decoration: InputDecoration(
          contentPadding: EdgeInsets.zero,
          hintText: 'Search',
          prefixIcon: const Icon(CupertinoIcons.search),
          border: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.grey),
            borderRadius: BorderRadius.circular(20),
          ),
        ),
      ),
      bottom: _focused
          ? TabBar(
              controller: _controller,
              indicatorColor: Theme.of(context).primaryColor,
              tabs: const <Tab>[
                Tab(
                  text: "Accounts",
                ),
                Tab(
                  text: "Digilogs",
                ),
                Tab(
                  text: "Locations",
                )
              ],
              labelColor: Theme.of(context).primaryColor,
              unselectedLabelColor: Colors.grey,
            )
          : null,
    );
  }

  Widget _searchBarContainer(double height) {
    // double width = 335;
    // if (_focused) {
    //   width = 300;
    // } else {
    //   width = 335;
    // }
    return SizedBox(
      height: (height - 20),
      child: Row(
        children: <Widget>[
          _focused
              ? Container(
                  height: 40,
                  padding: const EdgeInsets.only(left: 5),
                  decoration: const BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                      bottomLeft: Radius.circular(10),
                      topLeft: Radius.circular(10),
                    ),
                  ),
                  child: InkWell(
                    onTap: () {
                      setState(() {
                        _focused = false;
                        myFocusNode.unfocus();
                      });
                    },
                    child: Icon(
                      Icons.arrow_back,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                )
              : Container(),
          Container(
            height: 40,
            padding: const EdgeInsets.only(left: 5),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(10),
                topLeft: Radius.circular(10),
              ),
            ),
            child: Icon(
              Icons.search,
              color: Colors.grey[600],
            ),
          ),
          Container(
            height: 40,
            width: double.infinity,
            decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: const BorderRadius.only(
                  bottomRight: Radius.circular(10),
                  topRight: Radius.circular(10),
                )),
            child: TextField(
              controller: _searchController,
              focusNode: myFocusNode,
              decoration: InputDecoration(
                hintText: 'Search',
                hintStyle: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                border: const OutlineInputBorder(
                  borderSide: BorderSide.none,
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(10),
                    bottomRight: Radius.circular(10),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getAccountsList() {
    return FutureBuilder<List<AppUser>>(
        future: UserAPI().getallfirebaseusersbyname(_searchController.text),
        builder: (BuildContext context, AsyncSnapshot<List<AppUser>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: CircularProgressIndicator.adaptive(),
              );
            default:
              if ((snapshot.hasError)) {
                return _errorWidget();
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              Navigator.of(context)
                                  .push(MaterialPageRoute<OtherUserProfile>(
                                builder: (BuildContext context) =>
                                    OtherUserProfile(
                                  uid: snapshot.data![index].uid,
                                  username: snapshot.data![index].name,
                                ),
                              ));
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: ExtendedImage.network(
                                CustomImages.domeURL,
                                width: 70,
                                height: 74,
                                fit: BoxFit.cover,
                                cache: true,
                                shape: BoxShape.circle,
                              ),
                            ),
                            title: Text(
                              snapshot.data![index].name,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              snapshot.data![index].email,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                        itemCount: snapshot.data!.length);
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "No Users Found ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 14),
                        ),
                      ],
                    );
                  }
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "No Users Found",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 14),
                      ),
                    ],
                  );
                }
              }
          }
        });
  }

  Widget getDigilogsList(DigilogProvider provider) {
    return FutureBuilder<List<Digilog>>(
        future:
            DigilogAPI().getallfirebasedigilogsbytitle(_searchController.text),
        builder: (BuildContext context, AsyncSnapshot<List<Digilog>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: CircularProgressIndicator.adaptive(),
              );
            default:
              if ((snapshot.hasError)) {
                return _errorWidget();
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              provider.onUpdatedigi(snapshot.data![index]);
                              Navigator.of(context)
                                  .pushNamed(DigilogView.routeName);
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: ExtendedImage.network(
                                snapshot
                                    .data![index].experiences.first.mediaUrl,
                                width: 70,
                                height: 74,
                                fit: BoxFit.cover,
                                cache: true,
                                shape: BoxShape.circle,
                              ),
                            ),
                            title: Text(
                              snapshot.data![index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              snapshot.data![index].location.maintext,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                        itemCount: snapshot.data!.length);
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "No Digilogs Found ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 14),
                        ),
                      ],
                    );
                  }
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "No Digilogs Found",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 14),
                      ),
                    ],
                  );
                }
              }
          }
        });
  }

  Widget getDigilogsListbylocation(DigilogProvider provider) {
    return FutureBuilder<List<Digilog>>(
        future: DigilogAPI()
            .getallfirebasedigilogsbylocation(_searchController.text),
        builder: (BuildContext context, AsyncSnapshot<List<Digilog>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const SizedBox(
                height: double.infinity,
                width: double.infinity,
                child: CircularProgressIndicator.adaptive(),
              );
            default:
              if ((snapshot.hasError)) {
                return _errorWidget();
              } else {
                if (snapshot.hasData) {
                  if (snapshot.data!.isNotEmpty) {
                    return ListView.separated(
                        itemBuilder: (BuildContext context, int index) {
                          return ListTile(
                            onTap: () {
                              provider.onUpdatedigi(snapshot.data![index]);
                              Navigator.of(context)
                                  .pushNamed(DigilogView.routeName);
                            },
                            contentPadding: EdgeInsets.zero,
                            leading: CircleAvatar(
                              backgroundColor: Theme.of(context).primaryColor,
                              child: ExtendedImage.network(
                                snapshot
                                    .data![index].experiences.first.mediaUrl,
                                width: 70,
                                height: 74,
                                fit: BoxFit.cover,
                                cache: true,
                                shape: BoxShape.circle,
                              ),
                            ),
                            title: Text(
                              snapshot.data![index].title,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                            subtitle: Text(
                              snapshot.data![index].location.maintext,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          );
                        },
                        separatorBuilder: (BuildContext context, int index) {
                          return const Divider();
                        },
                        itemCount: snapshot.data!.length);
                  } else {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          "No Digilogs Found ",
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                              fontSize: 14),
                        ),
                      ],
                    );
                  }
                } else {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Text(
                        "No Digilogs Found",
                        style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Theme.of(context).primaryColor,
                            fontSize: 14),
                      ),
                    ],
                  );
                }
              }
          }
        });
  }

  void _onChanged() {
    if (search) {
      setState(() {
        search = false;
      });
    } else {
      setState(() {
        search = true;
      });
    }
  }
}
