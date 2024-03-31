import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

class URLS {
  // static const String BASE_URL = 'https://gopauatservices.isa.ae/api';

  // static const String BASE_URL = 'https://gopaservices.isa.ae/api';
  static const String BASE_URL = 'http://demo.prospectatech.com/GOPAMOB/api';

  // static const String BASE_URL = 'https://gopaservices.isa.ae/api';
  // static const String BASE_URL = ' http://demo.prospectatech.com/GOPA/MOB/api';

  // 'https://gopaservices.isa.ae/api';
  // 'https://gopauatservices.isa.ae/api';
  // http://demo.prospectatech.com/GOPAMOB/api

  // static const String BASE_URL1 = 'https://gopaservices.isa.ae';
  // static const String BASE_URL1 = 'https://gopauatservices.isa.ae';
  static const String BASE_URL1 = 'https://portal.dpsnad.org.in';

  // static const String BASE_URL1 = 'https://gopaservices.isa.ae';
  // static const String BASE_URL1 = 'https://gopauatservices.isa.ae';
  // static const String BASE_URL1 = 'http://demo.prospectatech.com/GOPAMOB';

  // 'https://gopaservices.isa.ae';
  // 'https://gopauatservices.isa.ae';
  // http://demo.prospectatech.com/GOPAMOB
}

/*
class Headers {
  // static String token = "";
  // var setList = await SharedPreferences.getInstance().getString('token');
  loadJson() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    print(prefs.getString('token'));
    var token = "Bearer "+prefs.getString('token');
    const Map<String, String> headers = {"Content-type": "application/json", "Authorization":token};
  }
}
*/

class Headers1 {
  static const Map<String, String> headers1 = {
    "Content-type": "application/json"
  };
}

class ApiService {
  static Future login(username, password) async {
    try {
      final response = await http.post(
        Uri.parse('${URLS.BASE_URL1}/site/appUserlogin'),
        headers: {
          "Content-Type": "application/x-www-form-urlencoded",
        },
        encoding: Encoding.getByName('utf-8'),
        body: {
          "username": username,
          "password": password,
        },
      );
      return response;
    } catch (e) {
      return e;
    }
  }

  static Future post(url, body, token) async {
    try {
      final response = await http.post(Uri.parse('${URLS.BASE_URL}/$url'),
          headers: {
            "Content-type": "application/json",
            "Authorization": "Bearer " + token
          },
          body: body);
      return response;
    } catch (e) {
      return e;
    }
  }

  static Future postAttachment(url, body, token) async {
    try {
      final response = await http.post(Uri.parse('${URLS.BASE_URL}/$url'),
          headers: {
            "Content-Type": "multipart/form-data",
            "Authorization": "Bearer " + token
          },
          body: body);
      return response;
    } catch (e) {
      return e;
    }
  }

  static Future get(url, token) async {
    try {
      final response = await http.get(Uri.parse('${URLS.BASE_URL1}/$url'),
          headers: {
            "Content-type": "application/json",
            // "Authorization": "Bearer " + token
          });
      return response;
    } catch (e) {
      return e;
    }
  }
}
