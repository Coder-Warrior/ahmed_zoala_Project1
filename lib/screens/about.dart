import 'dart:ffi';

import 'package:ahmed_zoala_shop/providers/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher_string.dart';
import 'package:url_launcher/url_launcher.dart' as launcher;

class AboutZoala extends StatefulWidget {
  const AboutZoala({super.key});

  @override
  State<AboutZoala> createState() => _AboutZoalaState();
}

class _AboutZoalaState extends State<AboutZoala> {
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
        title: Text('About Me', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
      ),

      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 60),
               ClipRRect(
                // لتطبيق حواف منحنية على الصورة
                borderRadius: BorderRadius.circular(5),
                child: Image.asset('assets/imgs/160735068_f798_2.jpg'),
              ),
              SizedBox(height: 6),
              Container(
                margin: EdgeInsets.only(left: 10),
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Text("INSTRUCTOR: ", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold, color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
              ),
              Container(
                alignment: Alignment.center,
                width: MediaQuery.of(context).size.width,
                child: Text("Ahmed_Zoala", style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: thet.mode == 'Dark' ? Colors.white : Colors.black)),
              ),
              SizedBox(height: 10),
              Padding(
                padding: EdgeInsets.all(8.0),
                child: Container(
                  alignment: Alignment.center,
                  width: MediaQuery.of(context).size.width,
                  child: Text(" انا احمد لدي قناه علي اليوتيوب تسمي hackingchannal ومدونه بلوجر hackingchannal وهيا متمرسه في مجال امن المعلوماتلدي 22 عام احب العمل الحر بدون قيود اقدم دورات تدريبيه عن امن المعلومات واساسيات امن المعلومات والحقائق عنه وسوف اقوم بتعليمك كل شئ يختص في هذا المجال من الصفر باذن الله مدام تعليم ذاتي ليس غرضه الضرر ", style: TextStyle(fontSize: 17, fontWeight: FontWeight.bold, color: thet.mode == 'Dark' ? Colors.white : Colors.black), textDirection: TextDirection.rtl,),
                ),
              ),

              SizedBox(height: 10),

            launchButton(
              title: 'Telegram',
              icon: Icons.language,
              onPressed: () {
                launcher.launchUrl(
                  Uri.parse('https://t.me/Ahmedzoala'),
                  mode: launcher.LaunchMode.externalApplication,
                );
              },
              colory: Colors.lightBlue
            ),

            SizedBox(height: 10),

            launchButton(
              title: 'Youtube',
              icon: Icons.language,
              onPressed: () {
                launcher.launchUrl(
                  Uri.parse('https://www.youtube.com/channel/UCgYZ-65ZfFZFtEpQrEcV_dg'),
                  mode: launcher.LaunchMode.externalApplication,
                );
              },
              colory: Colors.red
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
    required final colory
  }) {
    return Container(
      height: 45,
      width: 150,
      margin: const EdgeInsets.symmetric(vertical: 10),
      child: ElevatedButton(
        style: ButtonStyle (
          backgroundColor: MaterialStateProperty.all(colory),
          elevation: MaterialStateProperty.all(0),
          shape: MaterialStateProperty.all(RoundedRectangleBorder(borderRadius: BorderRadius.circular(7))),
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: const TextStyle(fontSize: 16.2, color: Colors.white, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

}