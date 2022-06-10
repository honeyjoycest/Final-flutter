// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, sized_box_for_whitespace, avoid_print

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_application_10/api/funtion.dart';
import 'package:http/http.dart' as http;

class Homepage extends StatefulWidget {
  const Homepage({Key? key}) : super(key: key);

  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  Createddata obj = Createddata();
  TextEditingController countryController = TextEditingController();
  TextEditingController deathsController = TextEditingController();
  TextEditingController recoveredController = TextEditingController();
  TextEditingController active_caseController = TextEditingController();
  TextEditingController monthController = TextEditingController();
  @override
  void initState() {
    super.initState();
    getdata();
    update(id);
    datadelet(id);

    obj.datacreated(countryController.text, deathsController.text, recoveredController.text, active_caseController.text, monthController);
  }

  List data = [];
  String? id;
  Future getdata() async {
    final responce =
    await http.get(Uri.parse('http://192.168.43.68:8000/api/mp-tracker'));
    if (responce.statusCode == 200) {
      setState(() {
        data = jsonDecode(responce.body);
      });
      print('Add data$data');
    } else {
      print('error');
    }
  }

  Future datadelet(id) async {
    final responce = await http
        .delete(Uri.parse('http://192.168.43.68:8000/api/mp-tracker-delete/$id'));
    print(responce.statusCode);

    if (responce.statusCode == 200) {
      print('DELETE COMPLETE');
    } else {
      print('nOT dELET');
    }
  }

  Future update(id) async {
    final responce = await http
        .put(Uri.parse('http://192.168.43.68:8000/api/mp-tracker/edit/$id'),
        body: jsonEncode({
          "country": countryController.text,
          "deaths":deathsController.text,
          "recovered":recoveredController.text,
          "active_case":active_caseController.text,
          "month":monthController.text,
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',
        });
    print(responce.statusCode);
    if (responce.statusCode == 200) {
      print('Data Update Successfully');
      countryController.clear();
      deathsController.clear();
      recoveredController.clear();
      active_caseController.clear();
      monthController.clear();
    } else {
      print('error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('MonkeyPox Virus Tracker'),
          backgroundColor: Colors.redAccent,
        ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Container(
            child: Column(
              children: [
                TextField(
                  controller: countryController,
                  decoration: InputDecoration(
                    hintText: 'Country',
                  ),
                ),
                TextField(
                  controller: deathsController,
                  decoration: InputDecoration(
                    hintText: 'Deaths',
                  ),
                ),
                TextField(
                  controller: recoveredController,
                  decoration: InputDecoration(
                    hintText: 'Recovered',
                  ),
                ),
                TextField(
                  controller: active_caseController,
                  decoration: InputDecoration(
                    hintText: 'Active_Case',
                  ),
                ),
                TextField(
                  controller: monthController,
                  decoration: InputDecoration(
                    hintText: 'Month',
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    ElevatedButton(
                        onPressed: () {
                          setState(() {
                            obj.datacreated(
                              countryController.text,
                              deathsController.text,
                              recoveredController.text,
                              active_caseController.text,
                              monthController.text,
                            );
                          });
                        },
                        child: Text('Submit')),

                  ],
                ),
                Expanded(
                  child: ListView.builder(
                      itemCount: data.length,
                      itemBuilder: (context, index) {
                        return Container(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Text(data[index]['country']),
                                ],
                              ),
                              Row(
                              children: [
                              Text(data[index]['deaths']),
                              ],
                              ),
                              Row(
                              children: [
                              Text(data[index]['recovered']),
                        ],
                        ),
                              Row(
                              children: [
                              Text(data[index]['active_case']),
                              ],
                              ),
                              Row(
                              children: [
                              Text(data[index]['month']),
                              ],
                              ),

                            Container(
                              width: 150,
                              child: Row(
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        countryController.text =
                                        data[index]['country'];

                                        deathsController.text =
                                        data[index]['deaths'];

                                        recoveredController.text =
                                        data[index]['recovered'];

                                        active_caseController.text =
                                        data[index]['active_case'];

                                        monthController.text =
                                        data[index]['month'];

                                      },
                                      icon: Icon(Icons.edit)),
                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          datadelet(data[index]['id']);
                                        });
                                      },
                                      icon: Icon(Icons.delete)),

                                  IconButton(
                                      onPressed: () {
                                        setState(() {
                                          update(data[index]['id']);
                                        });
                                      },
                                      icon: Icon(Icons.book)),
                                ],
                              ),
                            ),
                                ]
                          ),
                        );
                      }),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}

