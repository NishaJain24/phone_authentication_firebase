import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Container(

      child: Column(
        children: [
          SizedBox(height: 50,),
          Text("Hi Nisha"),
        ],
      ),
    );
  }
}
