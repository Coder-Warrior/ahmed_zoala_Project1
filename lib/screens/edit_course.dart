import 'dart:io';
import 'dart:math';

import 'package:ahmed_zoala_shop/providers/theme.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' show basename;
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

class EditCourse extends StatefulWidget {
  List myUrl;
  EditCourse({super.key, required this.myUrl});

  @override
  State<EditCourse> createState() => _EditCourseState();
}

class _EditCourseState extends State<EditCourse> {
  File? imgPath;
  String? imgName;
  String? imp;

  final course_nameController = TextEditingController();
  final course_titleController = TextEditingController();
  final course_linkController = TextEditingController();

  bool isLoading = false;

 uploadImage2Screen(ImageSource source) async {
    final pickedImg = await ImagePicker().pickImage(source: source);
    try {
      if (pickedImg != null) {
        setState(() {
          imgPath = File(pickedImg.path);
          imgName = basename(pickedImg.path);
          int random = Random().nextInt(99999);
          imgName = "$random$imgName";
          print(imgName);
          imp = pickedImg.path;
        });
      } else {
        print("NO img selected");
      }
    } catch (e) {
      print("Error => $e");
    }

    if (!mounted) return;
    Navigator.pop(context);
  }

  showmodel() {
    return showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(22),
          height: 170,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: () async {
                  await uploadImage2Screen(ImageSource.camera);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.camera,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Camera",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
              SizedBox(
                height: 22,
              ),
              GestureDetector(
                onTap: () {
                  uploadImage2Screen(ImageSource.gallery);
                },
                child: Row(
                  children: [
                    Icon(
                      Icons.photo_outlined,
                      size: 30,
                    ),
                    SizedBox(
                      width: 11,
                    ),
                    Text(
                      "From Gallery",
                      style: TextStyle(fontSize: 20),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

getImgURL({
  required String imgName,
  required String folderName,
  required File imgPath,
}) async {
  ListResult storageRef = await FirebaseStorage.instance.ref("$folderName/").listAll();
  storageRef.items.forEach(
    (element) async {
       String urly = await element.getDownloadURL();
       if (widget.myUrl[0] == urly) {
      UploadTask uploadTask = element.putFile(imgPath);
      TaskSnapshot snap = await uploadTask;
         // Get img url
    String urll = await snap.ref.getDownloadURL();

    await FirebaseFirestore.instance.collection('courses').doc(widget.myUrl[1]).update({'courseImg': urll});
    return;
}
    }
  );
  return null;
}

  @override
  Widget build(BuildContext context) {
  final thet = Provider.of<Themey>(context);
    return Scaffold(
      backgroundColor: thet.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : Colors.white,
      appBar: AppBar(
      backgroundColor: thet.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : Colors.white,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back,
            color: thet.mode == 'Dark' ? Colors.white : Colors.black
          )
        ),
        title: Text('Edit Course', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            children: [
              SizedBox(height: 33),
              Stack(
                children: [
        
              imgPath != null ? Container(
                 width: MediaQuery.of(context).size.width - 60,
                 child: Image.file(
                        imgPath!,
                        width: MediaQuery.of(context).size.width - 60,
                        height: 200,
                        fit: BoxFit.cover,
                    ),
                 height: 200,
                  decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(7)
                )
              ) : Container(
                 width: MediaQuery.of(context).size.width - 60,
                 child: Image.network(
                        widget.myUrl[0],
                        width: MediaQuery.of(context).size.width - 60,
                        height: 200,
                        fit: BoxFit.cover,
                    ),
                 height: 200,
                  decoration: BoxDecoration(
                 borderRadius: BorderRadius.circular(7)
                )
              ),
        
              Positioned(
                            left: 285,
                            bottom: 0,
                            child: IconButton(
                              onPressed: () {
                                // uploadImage2Screen();
                                showmodel();
                              },
                              icon: const Icon(Icons.add_a_photo),
                              color: Color.fromARGB(255, 94, 115, 128),
                            ),
                          ),
        
                ],
              ),
        
             Padding(
              padding: EdgeInsets.all(33),
              child: Column(
                children: [
        
              TextField(
              controller: course_nameController,
              decoration: InputDecoration(
                hintText: 'Enter Your Course Name',
                hintStyle: TextStyle(color: thet.mode == 'Dark' ? Colors.white : Colors.black),
                fillColor: Color.fromARGB(125, 78, 91, 110),
              ),
             ),
        
             SizedBox(height: 20),
        
              TextField(
              controller: course_titleController,
              decoration: InputDecoration(
                hintText: 'Enter Your Course Title',
                hintStyle: TextStyle(color: thet.mode == 'Dark' ? Colors.white : Colors.black),
                fillColor: Color.fromARGB(125, 78, 91, 110),
              ),
             ),
        
             SizedBox(height: 20),
        
              TextField(
              controller: course_linkController,
              decoration: InputDecoration(
                hintText: 'Enter Your Course Link',
                hintStyle: TextStyle(color: thet.mode == 'Dark' ? Colors.white : Colors.black),
                fillColor: Color.fromARGB(125, 78, 91, 110),
              ),
             ),
        
             SizedBox(height: 20),
        
            ElevatedButton(
              onPressed: () async {
                if (imgPath != null) {

                 setState(() {
                  isLoading = true;
                });

                await getImgURL(imgName: imgName!, folderName: 'Images', imgPath: imgPath!);

                if (course_nameController.text.length > 0) {
                  await FirebaseFirestore.instance.collection('courses').doc(widget.myUrl[1]).update({'courseName': course_nameController.text});
                }

                if (course_titleController.text.length > 0) {
                  await FirebaseFirestore.instance.collection('courses').doc(widget.myUrl[1]).update({'courseTitle': course_titleController.text});
                }

                if (course_linkController.text.length > 0) {
                  await FirebaseFirestore.instance.collection('courses').doc(widget.myUrl[1]).update({'courseLink': course_linkController.text});
                }

                print('Course Editied <3');

                 setState(() {
                  isLoading = false;
                });
                Navigator.pop(context);

                } else {
                 setState(() {
                  isLoading = true;
                });
                if (course_nameController.text.length > 0) {
                  await FirebaseFirestore.instance.collection('courses').doc(widget.myUrl[1]).update({'courseName': course_nameController.text});
                }

                if (course_titleController.text.length > 0) {
                  await FirebaseFirestore.instance.collection('courses').doc(widget.myUrl[1]).update({'courseTitle': course_titleController.text});
                }

                if (course_linkController.text.length > 0) {
                  await FirebaseFirestore.instance.collection('courses').doc(widget.myUrl[1]).update({'courseLink': course_linkController.text});
                }
                Navigator.pop(context);
                 setState(() {
                  isLoading = false;
                });
                }
              }, 
              child: isLoading ? CircularProgressIndicator(color: Colors.white) : Text('Edit Course', style: TextStyle(color: Colors.white)),
              style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(Color.fromARGB(125, 78, 91, 110))
              ),
              
              )
        
                ]
              )
             )
        
            ]
          ),
        ),
      )
    );
  }
}