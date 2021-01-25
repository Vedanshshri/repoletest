import 'package:flutter/material.dart';
import 'package:sec2hand/theme.dart';

class SortPage extends StatefulWidget {
  @override
  _SortPageState createState() => _SortPageState();
}

class _SortPageState extends State<SortPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Filters"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
      ),
      body: Container(
        child: Row(
          children: [
            SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    color: Colors.amber,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 2,
                  ),
                  Container(
                    color: Colors.black,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                  Container(
                    color: Colors.red,
                    width: MediaQuery.of(context).size.width * 0.4,
                    height: MediaQuery.of(context).size.height * 0.1,
                  ),
                ],
              ),
              scrollDirection: Axis.vertical,
            )
          ],
        ),
      ),
    );
  }
}
