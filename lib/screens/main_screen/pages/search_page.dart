import 'package:digiloger/database/digilog_api.dart';
import 'package:digiloger/models/digilog.dart';
import 'package:digiloger/widgets/search_app_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_staggered_grid_view/flutter_staggered_grid_view.dart';

class SearchPage extends StatelessWidget {
  const SearchPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Size _screen = MediaQuery.of(context).size;
    return Scaffold(
      //TODO:Implement search
      appBar: const ExploreAppBar(height: 68),
      body: Container(
        height: _screen.height,
        width: _screen.width,
        color: Colors.white,
        child: FutureBuilder<List<Digilog>>(
            future: getdigilogs(),
            builder:
                (BuildContext context, AsyncSnapshot<List<Digilog>> snapshot) {
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
                          itemBuilder: (BuildContext context, int index) =>
                              Image(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              snapshot.data![index].experiences.first.mediaUrl,
                            ),
                          ),
                          staggeredTileBuilder: (int index) =>
                              StaggeredTile.count(2, index.isEven ? 2 : 1),
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
}
