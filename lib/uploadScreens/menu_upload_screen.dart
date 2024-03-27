import 'dart:io';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as storageRef;
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:lapo_try/global/global.dart';
import 'package:lapo_try/mainScreen/home_screen.dart';
import 'package:lapo_try/widgets/error_dialog.dart';
import 'package:lapo_try/widgets/progress_bar.dart';

class MenusUploadScreen extends StatefulWidget {
  const MenusUploadScreen({super.key});

  @override
  State<MenusUploadScreen> createState() => _MenusUploadScreenState();
}

class _MenusUploadScreenState extends State<MenusUploadScreen> 
{
  XFile? imageXFile;
  final ImagePicker _picker = ImagePicker();

  TextEditingController shortInfoController = TextEditingController();
  TextEditingController titleInfoController = TextEditingController();

  bool uploading = false;
  String uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();


  defaultScreen()
  {

    return Scaffold(
       appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                 Colors.cyan,
                  Color.fromARGB(255, 175, 0, 0),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
            ),
          ),
        title: const Text(
          "Add New Menu",
          style: TextStyle(fontSize: 30, fontFamily: "Lobster", color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: ()
          {
            Navigator.push(context, MaterialPageRoute(builder: (c)=> const HomeScreen()));
          },
        ),    
      ),
           body: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                 Colors.white70,
                  Color.fromARGB(255, 175, 0, 0),
                ],
                begin: FractionalOffset(1.0, 0.25),
                end: FractionalOffset(1.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
            ),
             child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.food_bank_sharp, color: Colors.grey, size: 200.0,),
                  ElevatedButton(
                     style: ButtonStyle(
                      backgroundColor: MaterialStateProperty.all<Color>(Colors.lightGreen),
                      shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      ),
                    child: const Text(
                      "Add New Menu",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                      ),
                    ),
                    onPressed: ()
                    {
                      takeImage(context);
                    },
                  ),
                ],
              ),
             ),
           ),
    );
  }

  takeImage(mContext)
  {
    return showDialog(
      context: mContext,
      builder: (context)
      {
        return SimpleDialog(
          title: const Text("Menu Image", style: TextStyle(color: Colors.green, fontWeight: FontWeight.bold),),
          children: [
            SimpleDialogOption(
              onPressed: captureImageWithCamera,
              child: const Text(
                 "Capture with Camera",
                 style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 16),
                ),
            ),
             SimpleDialogOption(
              onPressed: pickImageFromGallery,
              child: const Text(
                 "Select from Gallery",
                 style: TextStyle(color: Colors.blueGrey, fontWeight: FontWeight.bold, fontSize: 16),
                ),
            ),
             SimpleDialogOption(
              child: const Text(
                 "Cancel",
                 style: TextStyle(color: Colors.red, fontWeight: FontWeight.bold, fontSize: 16),
                ),
                onPressed: () => Navigator.pop(context),
            ),
          ],
        );
      },
    );
  }

  captureImageWithCamera() async
  {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.camera,
      maxHeight: 720,
      maxWidth: 1280,
      );

      setState(() {
        imageXFile;
      });

  }

  pickImageFromGallery() async
  {
    Navigator.pop(context);

    imageXFile = await _picker.pickImage(
      source: ImageSource.gallery,
      maxHeight: 720,
      maxWidth: 1280,
      );

      setState(() {
        imageXFile;
      });
  }


  menusUploadFormScreen()
  {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: LinearGradient(
                colors: [
                 Colors.cyan,
                  Color.fromARGB(255, 175, 0, 0),
                ],
                begin: FractionalOffset(0.0, 0.0),
                end: FractionalOffset(0.0, 0.0),
                stops: [0.0, 1.0],
                tileMode: TileMode.clamp,
              )
            ),
          ),
        title: const Text(
          "Uploading New Menu",
          style: TextStyle(fontSize: 20, fontFamily: "Lobster", color: Colors.white),
        ),
        centerTitle: true,
        automaticallyImplyLeading: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white,),
          onPressed: ()
          {
            clearMenusUploadForm();
          },
        ),
        actions: [
          TextButton(
            child: const Text(
              "Add",
              style: TextStyle(
                color: Colors.white, 
                fontWeight: FontWeight.bold,
                fontSize: 18,
                fontFamily: "Varela",
                ),

            ),
            
            onPressed: uploading ? null : ()=> validateUploadForm(),
            
          ),
        ],
      ),
      body: ListView(
        children: [
          uploading == true ? LinearProgress() : const Text(""),
          Container(
            height: 230,
            width: MediaQuery.of(context).size.width * 0.8,
            child: Center(
              child: AspectRatio(
                  aspectRatio: 16/9,
                  child: Container(
                    decoration: BoxDecoration(
                      image: DecorationImage(
                        image: FileImage(
                          File(imageXFile!.path)
                          ),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
              ),
              ),
          ),
          ListTile(
            leading: const Icon(Icons.perm_device_information, color: Colors.blue),
            title: Container(
                width: 250,
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: titleInfoController,
                  decoration: const InputDecoration(
                    hintText: "Menu Name",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
            ),
          ),
          const Divider(
            color: Color.fromARGB(59, 121, 85, 72),
            thickness: 2,
          ),

          ListTile(
            leading: const Icon(Icons.book, color: Colors.blue),
            title: Container(
                width: 250,
                child: TextField(
                  style: const TextStyle(color: Colors.black),
                  controller: shortInfoController,
                  decoration: const InputDecoration(
                    hintText: "Menu Information",
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                  ),
                ),
            ),
          ),
          const Divider(
            color: Color.fromARGB(59, 121, 85, 72),
            thickness: 2,
          ),
        ],
      ),
    );
  }

  clearMenusUploadForm()
  {
    setState(() {
      titleInfoController.clear();
      shortInfoController.clear();
      imageXFile = null;
    });

  }  

  validateUploadForm() async
  { 
    if(imageXFile != null)
    {
      if(shortInfoController.text.isNotEmpty && titleInfoController.text.isNotEmpty)
      {
        setState(() {
          uploading = true;
         });

        //Upload image
        String downloadUrl = await uploadImage(File(imageXFile!.path));
        //Save info to firestore
        saveInfo(downloadUrl);

      }
      else
      {
        showDialog(
        context: context,
        builder: (c)
        {
          return ErrorDialog(
            message: "Please fill up the Menu Name & Menu Information",
          );
        }
      );
      }
    }
    else{
      showDialog(
        context: context,
        builder: (c)
        {
          return ErrorDialog(
            message: "Please choose an image for Menu",
          );
        }
      );
    }
  }

  saveInfo(String downloadUrl)
  {
    final ref = FirebaseFirestore.instance
        .collection("sellers")
        .doc(sharedPreferences!.getString("uid"))
        .collection("menus");

    ref.doc(uniqueIdName).set({
      "menuID": uniqueIdName,
      "sellerUID": sharedPreferences!.getString("uid"),
      "menuTitle": titleInfoController.text.toString(),
      "menuInfo": shortInfoController.text.toString(),
      "publishedDate": DateTime.now(),
      "status": "available",
      "thumbnailUrl": downloadUrl,
    });

    clearMenusUploadForm();
    
    setState(() {
      uniqueIdName = DateTime.now().microsecondsSinceEpoch.toString();
      uploading = false;
    });

  }


  uploadImage(mImageFile) async
  {
    storageRef.Reference reference = storageRef.FirebaseStorage
        .instance
        .ref()
        .child("menus");

        storageRef.UploadTask uploadTask = reference.child(uniqueIdName + ".jpg").putFile(mImageFile);

        storageRef.TaskSnapshot taskSnapshot = await uploadTask.whenComplete(() {});

        String downloadUrl = await taskSnapshot.ref.getDownloadURL();

        return downloadUrl;
  }


  @override
  Widget build(BuildContext context) 
  {
    return imageXFile == null ?defaultScreen() : menusUploadFormScreen();
  }
}