import 'package:flutter/material.dart';

import '../../state-city-data.dart';

/*
F1() {
  return Card(
    elevation: 5,
    child: Container(
      width: MediaQuery.of(context).size.width,
      child: Column(
        children: [
          Container(
            child: Text(
              "Select the Brand",
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
            ),
          ),
          DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              value: sortvar,
              //icon: Icon(Icons.arrow_downward),
              iconSize: 24,
              elevation: 16,
              style: TextStyle(color: Colors.black),
              underline: Container(
                width: MediaQuery.of(context).size.width,
                height: 2,
                color: Colors.grey,
              ),
              onChanged: (String newValue) {
                setState(() {
                  sortvar = newValue;
                });
              },
              items: brandListAll['mobile']
                  .map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    ),
  );
}

Widget Drop() {
  Visibility(
    visible: brand == "Redmi" ? true : false,
    child: Card(
      elevation: 5,
      child: Container(
        width: MediaQuery.of(context).size.width,
        child: Column(
          children: [
            Container(
              child: Text(
                "Select the Model",
                style: TextStyle(
                    color: Colors.black,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
            DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                value: model,
                //icon: Icon(Icons.arrow_downward),
                iconSize: 24,
                elevation: 16,
                style: TextStyle(color: Colors.black),
                underline: Container(
                  width: MediaQuery.of(context).size.width,
                  height: 2,
                  color: Colors.grey,
                ),
                onChanged: (String newValue) {
                  setState(() {
                    model = newValue;
                  });
                },
                items: model_phones["Redmi"]
                    .map<DropdownMenuItem<String>>((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}
*/
/* Card(
            elevation: 5,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "Select the Model",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: model,
                      //icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 2,
                        color: Colors.grey,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          model = newValue;
                        });
                      },
                      items: model_phones[brand]
                          .map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Card(
            elevation: 5,
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  Container(
                    child: Text(
                      "RAM",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  DropdownButtonHideUnderline(
                    child: DropdownButton<String>(
                      value: ram,
                      //icon: Icon(Icons.arrow_downward),
                      iconSize: 24,
                      elevation: 16,
                      style: TextStyle(color: Colors.black),
                      underline: Container(
                        width: MediaQuery.of(context).size.width,
                        height: 2,
                        color: Colors.grey,
                      ),
                      onChanged: (String newValue) {
                        setState(() {
                          ram = newValue;
                        });
                      },
                      items: [
                        '1 GB ',
                        '2 GB',
                        '3 GB',
                        '4 GB',
                        '5 GB',
                        '6 GB',
                        '7 GB',
                        '8 GB',
                      ].map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          child: Text(value),
                        );
                      }).toList(),
                    ),
                  ),
                ],
              ),
            ),
          ),*/
