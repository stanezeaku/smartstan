// ignore_for_file: use_key_in_widget_constructors

import 'package:smartstan/src/db/database.dart';
// import 'package:ai_stan/features/home/home_page.dart';
import 'package:smartstan/src/authentication/models/user_model.dart';
import 'package:smartstan/src/authentication/widgets/app_button.dart';
import 'package:smartstan/src/authentication/services/camera_service.dart';
import 'package:smartstan/src/authentication/services/facenet_service.dart';
import 'package:smartstan/src/home/home_page.dart';
import 'package:smartstan/src/theme/colors/light_colors.dart';
import 'package:flutter/material.dart';
import '../auth_screen.dart';
import 'package:smartstan/src/authentication/widgets/app_text_field.dart';

class AuthActionButton extends StatefulWidget {
  const AuthActionButton(this._initializeControllerFuture,
      {Key? key,
      required this.onPressed,
      required this.isLogin,
      this.reload,
      required this.dataBaseService})
      : super(key: key);

  final DataBaseService dataBaseService;
  final Future? _initializeControllerFuture;
  final Function onPressed;
  final bool isLogin;
  final Function? reload;
  @override
  _AuthActionButtonState createState() => _AuthActionButtonState();
}

class _AuthActionButtonState extends State<AuthActionButton> {
  /// service injection
  final FaceNetService _faceNetService = FaceNetService();
  final DataBaseService _dataBaseService = DataBaseService();
  final CameraService _cameraService = CameraService();

  final TextEditingController _userTextEditingController =
      TextEditingController(text: '');
  final TextEditingController _passwordTextEditingController =
      TextEditingController(text: '');

  User? predictedUser;

  Future _signUp(context) async {
    /// gets predicted data from facenet service (user face detected)
    List? predictedData = _faceNetService.predictedData;
    String user = _userTextEditingController.text;
    String password = _passwordTextEditingController.text;

    /// creates a new user in the 'database'
    await _dataBaseService.saveData(user, password, predictedData);

    /// resets the face stored in the face net sevice
    _faceNetService.setPredictedData(null);
    Navigator.push(
        context,
        MaterialPageRoute(
            builder: (BuildContext context) => const AuthScreen()));
  }

  Future _signIn(context) async {
    String password = _passwordTextEditingController.text;

    if (predictedUser!.password == password) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (BuildContext context) => HomePage(
                    predictedUser!.user,
                    imagePath: _cameraService.imagePath,
                    dataBaseService: widget.dataBaseService,
                  )));

      // HomePage(
      //       predictedUser!.user,
      //       imagePath: _cameraService.imagePath,
      //       dataBaseService: widget.dataBaseService,
      //     )));
    } else {
      showDialog(
        context: context,
        builder: (context) {
          return const AlertDialog(
            content: Text('Wrong password!'),
          );
        },
      );
    }
  }

  String? _predictUser() {
    String? userAndPass = _faceNetService.predict();
    return userAndPass;
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
        onTap: () async {
          try {
            // Ensure that the camera is initialized.
            await widget._initializeControllerFuture;
            // onShot event (takes the image and predict output)
            bool faceDetected = await widget.onPressed();

            if (faceDetected) {
              if (widget.isLogin) {
                var userAndPass = _predictUser();
                if (userAndPass != null) {
                  predictedUser = User.fromDB(userAndPass);
                }
              }
              PersistentBottomSheetController bottomSheetController =
                  Scaffold.of(context)
                      .showBottomSheet((context) => signSheet(context));

              bottomSheetController.closed.whenComplete(() => widget.reload!());
            }
          } catch (e) {
            // If an error occurs, log the error to the console.
            print(e);
          }
        },
        child: const CircleAvatar(
            radius: 40.0,
            // backgroundColor: LightColors.kGreen,
            child: Icon(
              Icons.camera_alt,
              size: 40.0,
              // color: Colors.white,
            ))

        //   Container(
        //     decoration: BoxDecoration(
        //       borderRadius: BorderRadius.circular(10),
        //       color: LightColors.kGreen,
        //       boxShadow: <BoxShadow>[
        //         BoxShadow(
        //           color: Colors.blue.withOpacity(0.1),
        //           blurRadius: 1,
        //           offset: const Offset(0, 2),
        //         ),
        //       ],
        //     ),
        //     alignment: Alignment.center,
        //     padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 16),
        //     width: MediaQuery.of(context).size.width * 0.8,
        //     height: 60,
        //     child: Row(
        //       mainAxisAlignment: MainAxisAlignment.center,
        //       children: const [

        //      CircleAvatar(
        //   radius: 25.0,
        //   backgroundColor: LightColors.kGreen,
        //   child: Icon(
        //     Icons.calendar_today,
        //     size: 20.0,
        //     color: Colors.white,
        //   ),
        // )

        //         // Text(
        //         //   'CAPTURE',
        //         //   style: TextStyle(color: Colors.white),
        //         // ),
        //         // SizedBox(
        //         //   width: 10,
        //         // ),
        //         // Icon(Icons.camera_alt, color: Colors.white)
        //       ],
        //     ),
        //   ),
        );
  }

  signSheet(context) {
    return Container(
      padding: const EdgeInsets.all(20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          widget.isLogin && predictedUser != null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    const CircleAvatar(
                      backgroundColor: LightColors.kBlue,
                      radius: 35.0,
                      backgroundImage: AssetImage('assets/welcome.png'),
                    ),
                    Text(
                      'Welcome Back ' + predictedUser!.user + '!',
                      style: const TextStyle(fontSize: 20),
                    ),
                  ],
                )
              : widget.isLogin
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: const [
                        CircleAvatar(
                          backgroundColor: LightColors.kBlue,
                          radius: 35.0,
                          backgroundImage: AssetImage('assets/notfound.png'),
                        ),
                        Text(
                          'User Not Found',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    )
                  : Container(),
          Column(
            children: [
              !widget.isLogin
                  ? AppTextField(
                      controller: _userTextEditingController,
                      labelText: "Your Name",
                    )
                  : Container(),
              const SizedBox(height: 10),
              widget.isLogin && predictedUser == null
                  ? Container()
                  : AppTextField(
                      controller: _passwordTextEditingController,
                      labelText: "Password",
                      isPassword: true,
                    ),
              const SizedBox(height: 10),
              const Divider(),
              const SizedBox(height: 10),
              widget.isLogin && predictedUser != null
                  ? AppButton(
                      text: 'LOGIN',
                      onPressed: () async {
                        _signIn(context);
                      },
                      icon: const Icon(
                        Icons.login,
                        // color: Colors.white,
                      ),
                    )
                  : !widget.isLogin
                      ? AppButton(
                          text: 'REGISTER',
                          onPressed: () async {
                            await _signUp(context);
                          },
                          icon: const Icon(
                            Icons.person_add,
                            // color: Colors.white,
                          ),
                        )
                      : Container(),
            ],
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
  }
}
