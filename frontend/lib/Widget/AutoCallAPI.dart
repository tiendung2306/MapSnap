import 'dart:async';
Timer? refreshTimer;

void autoCallAPI() {
  const Duration interval = Duration(seconds: 30); // Gọi lại sau mỗi 30 giây

  refreshTimer?.cancel(); // Hủy bỏ timer cũ nếu có
  refreshTimer = Timer.periodic(interval, (Timer timer) async {
    print("Gọi lại API...");
  },);
}
