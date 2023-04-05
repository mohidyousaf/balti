import 'package:balti_app/pages/user/user_dash_screen.dart';
import 'package:balti_app/repository/networkHandler.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:logger/logger.dart';
import 'package:mime/mime.dart';
import 'dart:io';

import '../../utils/size_config.dart';
import '../../widgets/custom_icon_button.dart';

var nw = NetworkHandler();

class EditProfileBody extends StatefulWidget {
  const EditProfileBody({Key? key, required this.userId}) : super(key: key);
  final String userId;
  @override
  State<EditProfileBody> createState() => _EditProfileBodyState();
}

class _EditProfileBodyState extends State<EditProfileBody> {
  final _formKey = GlobalKey<FormState>();
  final nameController = TextEditingController();
  final phoneNumberController = TextEditingController();

  File? imageFile;
  String filepath = "";
  String name = "";
  String phoneNumber = "";

  _getFromGallery() async {
    XFile? pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxWidth: 1800,
      maxHeight: 1800,
    );
    if (pickedFile != null) {
      setState(() {
        print("*********************");
        print(pickedFile.path);
        filepath = pickedFile.path;
        imageFile = File(pickedFile.path);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    getUserInfo();
  }

  void getUserInfo() async {
    var response = await nw.get("users/${widget.userId}");
    var log = Logger();
    log.d(response);
    setState(() {
      phoneNumber = response['number'];
      name = response['name'];
      nameController.text = name;
      phoneNumberController.text = phoneNumber;
    });
  }

  @override
  void dispose() {
    nameController.dispose();
    phoneNumberController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData mediaQuery = MediaQuery.of(context);
    SizeConfig().init(context);
    return SafeArea(
      child: Column(
        children: [
          const SizedBox(
            height: 20,
          ),
          Container(
            margin: EdgeInsets.only(
              top: mediaQuery.size.height * 0.01379,
              bottom: mediaQuery.size.height * 0.01379,
            ),
            width: mediaQuery.size.height * 0.155,
            height: mediaQuery.size.height * 0.155,
            child: FloatingActionButton(
                onPressed: () {
                  _getFromGallery();
                },
                backgroundColor: Color(0xffD9D9D9),
                shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(mediaQuery.size.width * 0.032)),
                child: imageFile == null
                    ? Icon(
                        Icons.camera_alt_rounded,
                        color: const Color.fromARGB(193, 27, 209, 161),
                        size: mediaQuery.size.width * 0.12,
                      )
                    : Image.file(
                        imageFile!,
                        fit: BoxFit.fitWidth,
                        width: mediaQuery.size.height * 0.155,
                        height: mediaQuery.size.height * 0.155,
                      )),
          ),
          Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.all(SizeConfig.screenWidth / 18),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Name",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextFormField(
                    key: const ValueKey('userName'),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.all(SizeConfig.screenWidth / 30),
                      fillColor: const Color(0xD9d9d9d9),
                      hintText: 'User name',
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(33, 0, 0, 0),
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(0, 0, 0, 0),
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    controller: nameController,
                    validator: (input) {
                      if (input == '') {
                        return 'Enter a name';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight / 24.17,
                  ),
                  const Text(
                    "Phone",
                    style: TextStyle(
                      fontSize: 16,
                      color: Colors.black,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  TextFormField(
                    key: const ValueKey('phoneNumber'),
                    style: const TextStyle(
                      fontSize: 14,
                    ),
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding:
                          EdgeInsets.all(SizeConfig.screenWidth / 30),
                      fillColor: const Color(0xD9d9d9d9),
                      hintText: '0320 4457283',
                      errorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      focusedErrorBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Colors.red,
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(33, 0, 0, 0),
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                      filled: true,
                      enabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(
                          color: Color.fromARGB(0, 0, 0, 0),
                        ),
                        borderRadius: BorderRadius.circular(40),
                      ),
                    ),
                    controller: phoneNumberController,
                    validator: (input) {
                      if (input == '') {
                        return 'Enter a phone number';
                      }
                      return null;
                    },
                  ),
                  SizedBox(
                    height: SizeConfig.screenHeight / 4.833,
                  ),
                  CustomIconButton(
                    color: const Color.fromARGB(193, 27, 209, 161),
                    buttonLabel: "Save",
                    icon: Icons.save_outlined,
                    onPressHandler: () async {
                      await nw.put('users/${widget.userId}', {
                        'name': nameController.text,
                        'number': phoneNumberController.text
                      });
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => UserDashScreen(),
                          ));
                      var log = Logger();
                      log.wtf(nameController.text, phoneNumberController.text);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
