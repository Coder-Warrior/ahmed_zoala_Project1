import 'package:ahmed_zoala_shop/firebase_options.dart';
import 'package:ahmed_zoala_shop/providers/blockSafety.dart';
import 'package:ahmed_zoala_shop/providers/theme.dart';
import 'package:ahmed_zoala_shop/providers/usernameProvider.dart';
import 'package:ahmed_zoala_shop/screens/home.dart';
import 'package:ahmed_zoala_shop/screens/register.dart';
import 'package:ahmed_zoala_shop/screens/sign_in.dart';
import 'package:ahmed_zoala_shop/shared/snackbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

 Future<void> main() async {
    WidgetsFlutterBinding.ensureInitialized();
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
     );
    runApp(const MyApp());
 }

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final themee = Provider.of<Themey>(context);
    return  MultiProvider(
        providers: [
        ChangeNotifierProvider(create: (_) => Themey()),
        ChangeNotifierProvider(create: (_) => BlockSafety()),
        ChangeNotifierProvider(create: (_) => UsernameProvider())
      ],
      child: MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: themee.mode == "Dark" ? ThemeData.dark() : null,
      home: StreamBuilder(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {return Center(child: CircularProgressIndicator(color: Colors.white,));} 
        else if (snapshot.hasError) {return showSnackBar(context, "Something went wrong");}
        else if (snapshot.hasData) {return Home();}
        else { return Login();}
      },
       ),
       ),
    );
  }
}
