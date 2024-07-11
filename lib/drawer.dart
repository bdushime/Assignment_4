import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'contacts.dart';
import 'main.dart';

class DrawerScreen extends StatefulWidget {
  const DrawerScreen({super.key});

  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  XFile? _imageFile;
  final ImagePicker _picker = ImagePicker();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)?.helloWorld ?? 'Hello World',style: TextStyle(fontWeight: FontWeight.bold,fontSize: 30),textAlign: TextAlign.center,),
        backgroundColor: Colors.yellow.shade800,
      ),
      drawer: Drawer(
        child: Container(
          color: Colors.yellow.shade800,
          child: ListView(
            children: [
              DrawerHeader(
                child: imageProfile(context),

              ),
              ListTile(
                leading: Icon(Icons.home,size: 50,),
                title: Text(
                  'Home',
                  style: TextStyle(fontSize: 27, color: Colors.teal,fontWeight: FontWeight.bold),
                ),
                onTap: () => navigateToPage('Page 1'),
              ),
              // ListTile(
              //   leading: Icon(Icons.home),
              //   title: Text(
              //     'Page 2',
              //     style: TextStyle(
              //       fontSize: 20,
              //       color: Colors.yellow,
              //     ),
              //   ),
              //   onTap: () => navigateToPage('Page 2'),
              // ),
              ListTile(
                leading: Icon(Icons.contacts,size: 40,),
                title: Text(
                  'Contacts',
                  style: TextStyle(fontSize: 27, color: Colors.black,fontWeight: FontWeight.bold),
                ),
                onTap: () => navigateToPage('Contacts'),
              ),
              ListTile(
                leading: Icon(Icons.language,size: 40,),
                title: Text(
                  'English',
                  style: TextStyle(fontSize: 27, color: Colors.black,fontWeight: FontWeight.bold),
                ),
                onTap: () => changeLanguage('en'),
              ),
              ListTile(
                leading: Icon(Icons.language,size: 40,),
                title: Text(
                  'हिंदी',
                  style: TextStyle(fontSize: 27, color: Colors.black,fontWeight: FontWeight.bold),
                ),
                onTap: () => changeLanguage('hi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget imageProfile(BuildContext context) {
    return Center(
      child: Stack(
        children: [
          CircleAvatar(
            radius: 80.0,
            backgroundImage: _imageFile == null
                ? AssetImage("images/Capture.PNG")
                : FileImage(File(_imageFile!.path)) as ImageProvider,
          ),
          Positioned(
            bottom: 20.0,
            right: 25.0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: (context) => bottomSheet(context),
                );
              },
              child: Icon(
                Icons.camera_alt,
                color: Colors.teal,
                size: 28.0,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget bottomSheet(BuildContext context) {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Text(
            "Choose Profile photo",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(
            height: 20,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              TextButton.icon(
                icon: Icon(Icons.camera,color: Colors.yellow.shade800,),
                onPressed: () {
                  takePhoto(ImageSource.camera);
                },
                label: Text("Camera",style: TextStyle(color: Colors.black),),
              ),
              TextButton.icon(
                icon: Icon(Icons.image,color: Colors.yellow.shade800,),
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                },
                label: Text("Image",style: TextStyle(color: Colors.black),),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    setState(() {
      _imageFile = pickedFile;
    });
  }

  void navigateToPage(String page) {
    if (page == 'Contacts') {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ContactsPage()),
      );
    } else {
      // Handle other pages
    }
  }

  void changeLanguage(String languageCode) {
    Locale newLocale;
    switch (languageCode) {
      case 'en':
        newLocale = Locale('en');
        break;
      case 'hi':
        newLocale = Locale('hi');
        break;
      default:
        newLocale = Locale('en');
    }
    setState(() {
      MyApp.setLocale(context, newLocale);
    });
  }
}
