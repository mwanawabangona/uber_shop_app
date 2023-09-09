import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body:SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: Row(
          children: [
            Container(
              width: 100,
              color: Colors.red,
              height: 100,
              child: Text('hello',style: TextStyle(color: Colors.white),)
            ),
            SizedBox(width: 10,),
            Container(
              width: 100,
              color: Colors.blue,
              height: 100,
            ),
            SizedBox(width: 10),
            Container(
              width: 100,
              color: Colors.green,
              height: 100,
            ),
            SizedBox(width: 10),
            Container(
              width: 100,
              color: Colors.yellow,
              height: 100,
            ),
            SizedBox(width: 10),
            Center(
              child: Container(
                width: 100,
                color: Colors.pink,
                height: 100,
              ),
            ),
            // Expanded(
            //   child: Container(
            //     color: Colors.blue,
            //   ),
            // ),
      
          ],
        ),
      ),
    );
  }
}