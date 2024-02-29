import 'package:ahmed_zoala_shop/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class CourseInfo extends StatefulWidget {
  Map<String, dynamic> data;
  CourseInfo({super.key, required this.data});

  @override
  State<CourseInfo> createState() => _CourseInfoState();
}

class _CourseInfoState extends State<CourseInfo> {
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
        title: Text('About Course', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
      ),
      body: SingleChildScrollView(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: 67),
                child: Column(
                children: [
        Container(
          width: MediaQuery.of(context).size.width - 30,
          child: ClipRRect( // لتطبيق حواف منحنية على الصورة
            borderRadius: BorderRadius.circular(5),
            child: Image.network(widget.data['courseImg']),
          ),
        ),
                  Container(
                      width: MediaQuery.of(context).size.width - 30,
                      margin: EdgeInsets.only(top: 5),
                      child: Text(widget.data['courseName'],
                          style: TextStyle(
                              fontSize: 23, fontWeight: FontWeight.bold,
                               color: thet.mode == 'Dark' ? Colors.white : Colors.black
                              ),
                          )),
                  Container(
                      width: MediaQuery.of(context).size.width - 30,
                      margin: EdgeInsets.only(top: 5),
                      child: Text(widget.data['courseTitle'],
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold,
                              color: thet.mode == 'Dark' ? Colors.white : Colors.black
                              ),
                              ))
                ]),
              ),
          
              Text(
                'Course Link: ',
                style: TextStyle(
                  fontSize: 27,
                  fontWeight: FontWeight.bold,
                  color: thet.mode == 'Dark' ? Colors.white : Colors.black
                ),
              ),
              
            launchButton(
              title: 'Course Link',
              icon: Icons.language,
              onPressed: () {
                launcher.launchUrl(
                  Uri.parse(widget.data['courseLink']),
                  mode: launcher.LaunchMode.externalApplication,
                );
              },
              thet: thet
            ),
          
            launchButton(
              title: 'للتواصل مع صاحب الكورس',
              icon: Icons.language,
              onPressed: () {
                launcher.launchUrl(
                  Uri.parse('https://t.me/Ahmedzoala'),
                  mode: launcher.LaunchMode.externalApplication,
                );
              },
              thet: thet
            ),

            launchButton(
              title: 'اذا لم ينجح رابط التواصل ستجد كل الروابط في يوتيوب',
              icon: Icons.language,
              onPressed: () {
                launcher.launchUrl(
                  Uri.parse('https://www.youtube.com/channel/UCgYZ-65ZfFZFtEpQrEcV_dg'),
                  mode: launcher.LaunchMode.externalApplication,
                );
              },
              thet: thet
            ),

            ],
          ),
        ),
      ),
    );
  }

 Widget launchButton({
    required String title,
    required IconData icon,
    required Function() onPressed,
    required thet
  }) {
    return Container(
      height: 45,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ButtonStyle (
          backgroundColor: MaterialStateProperty.all(Colors.transparent),
          elevation: MaterialStateProperty.all(0),
        ),
        onPressed: onPressed,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              title,
              style: TextStyle(fontSize: 16.2, color: thet.mode == 'Dark' ? Colors.white : Colors.black, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
            ),
          ],
        ),
      ),
    );
  }

}