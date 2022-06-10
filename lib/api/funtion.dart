import 'dart:convert';

import 'package:http/http.dart' as http;



class Createddata {



  Future datacreated(countrytext,deathstext,recoveredtext,active_casetext, monthtext) async {
    final response =
    await http.post(Uri.parse('http://192.168.43.68:8000/api/mp-tracker/store'),
        body: jsonEncode({
          "country":countrytext,
          "deaths":deathstext,
          "recovered":recoveredtext,
          "active_case":active_casetext,
          "month":monthtext,
        }),
        headers: {
          'Content-type': 'application/json',
          'Accept': 'application/json',

        });
    print(response.statusCode);
    if (response.statusCode == 200) {

      print('Data Created Successfully');
      print(response.body);
    } else {
      print('error');
    }
  }

}

