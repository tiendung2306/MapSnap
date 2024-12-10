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
      if(response.statusCode == 200){
        return {
          'mess': "Get Journey success",
          'data': json.decode(response.body),
        };
      }
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

    Future<Map<String, dynamic>> GetJourneyToday (String userId) async {
    final url = Uri.parse('$_baseUrl/journey/{userId}/get-journeys-today'.replaceFirst("{userId}", userId));

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if(response.statusCode == 200){
        return {
          'mess': "Get Journey success",
          'data': json.decode(response.body),
        };
      }
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

    Future<Map<String, dynamic>> GetVisit (String visitId) async {
    final url = Uri.parse('$_baseUrl/visit/{visitId}'.replaceFirst("{visitId}", visitId));

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if(response.statusCode == 200){
        return {
          'mess': "Get Visit success",
          'data': json.decode(response.body),
        };
      }
      else{
        try{
          return {
            'mess': "Get Visit failed",
            'data': json.decode(response.body),
          };
        }
        catch(e){
          return {
            'mess': "Get Visit failed",
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

    Future<Map<String, dynamic>> GetLocation (String locationId) async {
    final url = Uri.parse('$_baseUrl/location/{locationId}'.replaceFirst("{locationId}", locationId));

    try {
      final response = await http.get(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if(response.statusCode == 200){
        return {
          'mess': "Get Locaton success",
          'data': json.decode(response.body),
        };
      }
      else{
        try{
          return {
            'mess': "Get Locaton failed",
            'data': json.decode(response.body),
          };
        }
        catch(e){
          return {
            'mess': "Get Locaton failed",
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

    Future<Map<String, dynamic>> CreatePositon (String userId, double latitude, double longitude, int createdAt, String positionName) async {
    final url = Uri.parse('$_baseUrl/position/{userId}/create-position'.replaceFirst("{userId}", userId));

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "longitude": longitude,
          "latitude": latitude,
          "createdAt": createdAt,
          "locationId": "60c72b2f5f1b2c001f8e4e39",
          "positionName": positionName
        }),
      );
      if(response.statusCode == 201)
        return {
          'mess': "Create success",
          'data': json.decode(response.body),
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

    Future<Map<String, dynamic>> GetPositionPeriod (String userId, int from, int to) async {
    final url = Uri.parse('$_baseUrl/position/{userId}/get-position'.replaceFirst("{userId}", userId));

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "from": from,
          "to": to
        }),
      );
      if(response.statusCode == 200){
        return {
          'mess': "Get position success",
          'data': json.decode(response.body),
        };
      }
      else{
        try{
          return {
            'mess': "Get position failed",
            'data': json.decode(response.body),
          };
        }
        catch(e){
          return {
            'mess': "Get position failed",
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

    Future<Map<String, dynamic>> GetAllJourney (String userId, String sortType, String sortField, String keyword) async {
    final url = Uri.parse('$_baseUrl/journey/{userId}/get-journeys'.replaceFirst("{userId}", userId));

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "isAutomaticAdded": true,
          "updatedByUser": true,
          "status": "enabled",
          "sortType": sortType,
          "sortField": sortField,
          "searchText": keyword,
        }),
      );
      if(response.statusCode == 200){
        return {
          'mess': "Get Journey success",
          'data': json.decode(response.body),
        };
      }
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

}
