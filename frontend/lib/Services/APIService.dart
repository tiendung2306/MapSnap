import 'dart:convert';
import 'package:http/http.dart' as http;

class ApiService {
  final _baseUrl = 'http://10.0.2.2:3000/v1';

    Future<Map<String, dynamic>> CreateJourney (String userId, String title) async {
    final url = Uri.parse('$_baseUrl/journey/{userId}/create-journey'.replaceFirst("{userId}", userId));

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "title": title,
          "startedAt": 1731072409,
          "endedAt": 1731072409,
          "updatedAt": 1731072409,
          "status": "enabled",
          "updatedByUser": true,
          "isAutomaticAdded": true
        }),
      );
      if(response.statusCode == 200)
        return {
          'mess': "Create success",
        };
      else{
        try{
          return {
            'mess': "Create failed",
            'data': json.decode(response.body),
          };
        }
        catch(e){
          return {
            'mess': "Create failed",
            'data': null,
          };
        }
      }
    } catch (e) {
      print('Error: $e');
      return {
        'mess': 'Connection error',
      };
    }
  }

    Future<Map<String, dynamic>> GetJourney (String journeyId) async {
    final url = Uri.parse('$_baseUrl/journey/{journeyId}'.replaceFirst("{journeyId}", journeyId));

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if(response.statusCode == 200)
        return {
          'mess': "Get Journey success",
        };
      else{
        try{
          return {
            'mess': "Get Journey failed",
            'data': json.decode(response.body),
          };
        }
        catch(e){
          return {
            'mess': "Get Journey failed",
            'data': null,
          };
        }
      }
    } catch (e) {
      print('Error: $e');
      return {
        'mess': 'Connection error',
      };
    }
  }

    Future<Map<String, dynamic>> CreateVisit (String userId, String title) async {
    final url = Uri.parse('$_baseUrl/visit/{userId}/create-visit'.replaceFirst("{userId}", userId));

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "title": title,
          "startedAt": 1731072409,
          "endedAt": 1731072409,
          "updatedAt": 1731072409,
          "status": "enabled",
          "updatedByUser": true,
          "isAutomaticAdded": true
        }),
      );
      if(response.statusCode == 200)
        return {
          'mess': "Create success",
        };
      else{
        try{
          return {
            'mess': "Create failed",
            'data': json.decode(response.body),
          };
        }
        catch(e){
          return {
            'mess': "Create failed",
            'data': null,
          };
        }
      }
    } catch (e) {
      print('Error: $e');
      return {
        'mess': 'Connection error',
      };
    }
  }

}
