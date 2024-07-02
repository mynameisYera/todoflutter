import 'package:flutter/material.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(width: 350, height: 200,child: Text('Hello welcome to TODOApp',textAlign: TextAlign.center, style: TextStyle(fontSize: 40),)),
            ],
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(onPressed: (){
                Navigator.restorablePopAndPushNamed(context, '/todo');
              }, child: Text('Lets go'),)
            ],
          )
        
        ],
        
      ),
    );
  }
}