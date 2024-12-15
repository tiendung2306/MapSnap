import 'dart:io';
import 'package:dio/dio.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

Future<void> downloadImage(String imageUrl) async {
  try {


    // Đường dẫn thư mục "Downloads".
    final savedDir = Directory('/storage/emulated/0/Download');
    if (!await savedDir.exists()) {
      await savedDir.create(recursive: true);
    }

    // Tạo tên file duy nhất dựa trên thời gian.
    final timestamp = DateTime.now().millisecondsSinceEpoch;
    final savedPath = '${savedDir.path}/DownloadedImage_$timestamp.jpg';

    // Tải ảnh và lưu file.
    final dio = Dio();
    await dio.download(imageUrl, savedPath);

    print('Ảnh đã được lưu vào thư mục Downloads: $savedPath');

    // Gửi thông báo hệ thống để nhận diện tệp mới.
    final result = await File(savedPath).exists();
    if (result) {
      await Process.run(
        'am',
        ['broadcast', '-a', 'android.intent.action.MEDIA_SCANNER_SCAN_FILE', '-d', 'file://$savedPath'],
      );
    }
  } catch (e) {
    print('Có lỗi xảy ra: $e');
  }
}
