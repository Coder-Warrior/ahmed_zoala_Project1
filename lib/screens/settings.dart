import 'package:ahmed_zoala_shop/providers/theme.dart';
import 'package:ahmed_zoala_shop/screens/name_edit.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class UserSettings extends StatefulWidget {
  const UserSettings({super.key});

  @override
  State<UserSettings> createState() => _UserSettingsState();
}

class _UserSettingsState extends State<UserSettings> {
  @override
  Widget build(BuildContext context) {
  final safetyFirst = Provider.of<Themey>(context);
    return Scaffold(
      backgroundColor: safetyFirst.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : null,
      appBar: AppBar(
      backgroundColor: safetyFirst.mode == 'Dark' ? Color.fromARGB(255, 47, 51, 54) : null,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: Icon(Icons.arrow_back, color: safetyFirst.mode == 'Dark' ? Colors.white : Colors.black)
        ),
        title: Text('App Settings', style: TextStyle(fontSize: 27, fontWeight: FontWeight.bold, color: safetyFirst.mode == 'Dark' ? Colors.white : Colors.black)),
      ),

      body: Center(
        child: Column(
          children: [
            SizedBox(height: 63),
            ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UserEdit()
                )
              );
            },
            child: Text('Edit Your Name', style: TextStyle(fontSize: 20, color: safetyFirst.mode == 'Dark' ? Colors.white : Colors.blueGrey)),
                        style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(safetyFirst.mode == 'Dark' ? Colors.transparent : Colors.white)
            )
          ),
            SizedBox(height: 25),
           ElevatedButton(
            onPressed: () {
              if (safetyFirst.mode == "Dark") {
                  safetyFirst.changeToLight();
              } else {
                  safetyFirst.changeToDark();
              }
            },
            child: Text(safetyFirst.mode == "Dark" ? 'Light Mode' : 'Dark Mode', style: TextStyle(fontSize: 20, color: safetyFirst.mode == 'Dark' ? Colors.white : Colors.blueGrey)),
            style: ButtonStyle(
              backgroundColor: MaterialStateProperty.all(safetyFirst.mode == 'Dark' ? Colors.transparent : Colors.white)
            )
          ),
          ],
        ),
      )

    );
  }
}