import 'package:camera/camera.dart';
import 'package:digiloger/screens/adddigilog_screen/cameraview.dart';
import 'package:digiloger/widgets/show_loading.dart';
import 'package:flutter/material.dart';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);
  static const String routeName = '/CameraPage';

  @override
  @override
  _CameraScreenState createState() => _CameraScreenState();
}

class CommonUser {}

class _CameraScreenState extends State<CameraScreen> {
  late CameraController _cameraController;
  Future<void>? cameraValue;
  bool isRecoring = false;
  bool flash = false;
  bool iscamerafront = true;
  double transform = 0;
  @override
  void initState() {
    super.initState();
    getCamera(0).then((CameraDescription camera) {
      setState(() {
        _cameraController = CameraController(
          camera,
          ResolutionPreset.high,
        );
        cameraValue = _cameraController.initialize();
      });
    });
  }

  Future<CameraDescription> getCamera(int i) async {
    final List<CameraDescription> c = await availableCameras();
    return c.elementAt(i);
  }

  @override
  void dispose() {
    super.dispose();
    _cameraController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: <Widget>[
          FutureBuilder<void>(
            future: cameraValue,
            builder: (BuildContext context, AsyncSnapshot<Object?> snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                return SizedBox(
                    width: MediaQuery.of(context).size.width,
                    height: MediaQuery.of(context).size.height,
                    child: CameraPreview(_cameraController));
              } else {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              }
            },
          ),
          Positioned(
            bottom: 0.0,
            child: Container(
              color: Colors.black,
              padding: const EdgeInsets.only(top: 5, bottom: 5),
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: <Widget>[
                      IconButton(
                          icon: Icon(
                            flash ? Icons.flash_on : Icons.flash_off,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () {
                            setState(() {
                              flash = !flash;
                            });
                            flash
                                ? _cameraController
                                    .setFlashMode(FlashMode.torch)
                                : _cameraController.setFlashMode(FlashMode.off);
                          }),
                      GestureDetector(
                        onTap: () {
                          if (!isRecoring) takePhoto(context);
                        },
                        child: isRecoring
                            ? const Icon(
                                Icons.radio_button_on,
                                color: Colors.red,
                                size: 80,
                              )
                            : const Icon(
                                Icons.panorama_fish_eye,
                                color: Colors.white,
                                size: 70,
                              ),
                      ),
                      IconButton(
                          icon: const Icon(
                            Icons.flip_camera_ios,
                            color: Colors.white,
                            size: 28,
                          ),
                          onPressed: () async {
                            setState(() {
                              iscamerafront = !iscamerafront;
                            });
                            final int cameraPos = iscamerafront ? 0 : 1;
                            getCamera(cameraPos)
                                .then((CameraDescription camera) {
                              setState(() {
                                _cameraController = CameraController(
                                  camera,
                                  ResolutionPreset.high,
                                );
                                cameraValue = _cameraController.initialize();
                              });
                            });
                          }),
                    ],
                  ),
                  const SizedBox(
                    height: 4,
                  ),
                  const Text(
                    "Hold for Video, tap for photo",
                    style: TextStyle(
                      color: Colors.white,
                    ),
                    textAlign: TextAlign.center,
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Future<void> takePhoto(BuildContext context) async {
    showLoadingDislog(context);
    final XFile file = await _cameraController.takePicture();
    Navigator.of(context)
        .pushNamed(CameraViewPage.routeName, arguments: file.path);
  }
}
