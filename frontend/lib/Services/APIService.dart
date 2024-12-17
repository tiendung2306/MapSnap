import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:camera/camera.dart';
import 'package:http/http.dart' as http;
import 'package:http_parser/http_parser.dart';
import 'package:mime/mime.dart';

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

    Future<Map<String, dynamic>> CreateVisit (String userId, int startedAt, int endedAt) async {
    final url = Uri.parse('$_baseUrl/visit/{userId}/create-visit'.replaceFirst("{userId}", userId));

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: json.encode({
          "title": "null",
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

    Future<Map<String, dynamic>> DeleteVisit (String visitId) async {
    final url = Uri.parse('$_baseUrl/visit/{visitId}'.replaceFirst("{visitId}", visitId));

    try {
      final response = await http.delete(
        url,
        headers: {'Content-Type': 'application/json'},
      );
      if(response.statusCode == 200)
        return {
          'mess': "Delete success",
        };
      else{
        try{
          return {
            'mess': "Delete failed",
            'data': json.decode(response.body),
          };
        }
        catch(e){
          return {
            'mess': "Delete failed",
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

    Future<Map<String, dynamic>> UploadPicture (String userId, String locationId, String visitId,
        String journeyId, int capturedAt , XFile image) async {
    final url = Uri.parse('$_baseUrl/pictures');

    final File imgFile = File(image.path);
    // Tạo yêu cầu `MultipartRequest`
    final request = http.MultipartRequest('POST', url);

    // Xác định loại MIME của file và thêm vào yêu cầu
    final mimeTypeData = lookupMimeType(imgFile.path)!.split('/');
    final multipartFile = await http.MultipartFile.fromPath(
      'picture',
      imgFile.path,
      contentType: MediaType(mimeTypeData[0], mimeTypeData[1]),
    );

    // Thêm file ảnh vào yêu cầu `multipart`
    request.files.add(multipartFile);
    request.fields["userId"] = userId;
    request.fields["locationId"] = locationId;
    request.fields["visitId"] = visitId;
    request.fields["journeyId"] = journeyId;
    request.fields["capturedAt"] = capturedAt.toString();

    try {
      final response = await request.send();
      if(response.statusCode == 200){
        var completer  = Completer<Map<String, dynamic>>(); // Completer để đợi giá trị trả về

        response.stream.transform(utf8.decoder).listen((value) {
          completer .complete((json.decode(value))[0]);
        });
        Map<String, dynamic> jsonResponse = await completer.future;
        return {
          'mess': "Upload success",
          'data': jsonResponse,
        };
      }

      else{
        try{
          return {
            'mess': "Upload failed",
            'data': null,
          };
        }
        catch(e){
          return {
            'mess': "Upload failed",
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

  Future<Map<String, dynamic>> GetAllHistoryLogs (String userId) async { //need fix
    final url = Uri.parse('$_baseUrl/historylog/{userId}/get-history-logs'.replaceFirst("{userId}", userId));

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},

      );
      if(response.statusCode == 200){
        return {
          'mess': "Get History success",
          'data': json.decode(response.body),
        };
      }
      else{
        try{
          return {
            'mess': "Get History failed",
            'data': json.decode(response.body),
          };
        }
        catch(e){
          return {
            'mess': "Get History failed",
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
