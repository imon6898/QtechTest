import 'package:flutter/material.dart';

class CustomCard extends StatelessWidget {
  final String line1;
  final String line2;
  final String line3;
  final String line4;
  final String line5;

  const CustomCard({
    Key? key,
    required this.line1,
    required this.line2,
    required this.line3,
    required this.line4,
    required this.line5,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;

    return Container(
      width: screenWidth,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        color: Colors.white,
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "From",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                line1,
                style: TextStyle(color: Colors.black),
              ),

              SizedBox(height: 5,),
              Text(
                "To",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                line2,
                style: TextStyle(color: Colors.black),
              ),

              SizedBox(height: 5,),
              Text(
                "Time",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                line3,
                style: TextStyle(color: Colors.black),
              ),

              SizedBox(height: 10,),
              Text(
                "Subject",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                line4,
                style: TextStyle(color: Colors.black),
              ),

              SizedBox(height: 10,),
              Text(
                "Details",
                style: TextStyle(color: Colors.black),
              ),
              Text(
                line5,
                style: TextStyle(color: Colors.black),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
