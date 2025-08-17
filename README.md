# ATGT VN — Demo chạy thử nhanh

## 1) Tạo project Flutter & chép file
```bash
flutter --version   # cần Dart >= 3.2.0
flutter create atgt_vn
cd atgt_vn
```

Ghi đè `pubspec.yaml` bằng file trong gói này, rồi chép toàn bộ thư mục `lib/` vào dự án.

## 2) Cấp quyền (Android/iOS)

### Android — `android/app/src/main/AndroidManifest.xml`
Thêm vào trong thẻ `<manifest>`:
```xml
<uses-permission android:name="android.permission.INTERNET"/>
<uses-permission android:name="android.permission.ACCESS_FINE_LOCATION"/>
<uses-permission android:name="android.permission.ACCESS_COARSE_LOCATION"/>
<!-- Tuỳ chọn cho chạy nền khi dẫn đường dài -->
<!-- <uses-permission android:name="android.permission.ACCESS_BACKGROUND_LOCATION"/> -->
```

Và đảm bảo trong `<application>` có `android:usesCleartextTraffic="false"` (mặc định), vì chúng ta dùng HTTPS map tiles.

### iOS — `ios/Runner/Info.plist`
Thêm các khóa:
```xml
<key>NSLocationWhenInUseUsageDescription</key>
<string>Ứng dụng cần vị trí để hiển thị tốc độ và cảnh báo an toàn.</string>
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>Cho phép truy cập vị trí để dẫn đường liên tục (tuỳ chọn).</string>
```

## 3) Cài gói & chạy
```bash
flutter pub get
flutter run
```

Mở app, bấm **Bắt đầu**, cấp quyền Location. Khi bạn di chuyển, tốc độ sẽ thay đổi và ứng dụng sẽ đọc giới hạn tốc độ (dựa vào dữ liệu demo).

> Lưu ý: Dữ liệu demo (`lib/data/demo_rules.geojson`) chỉ là ví dụ minh hoạ khu vực TP.HCM. Ngoài vùng đó có thể không khớp.

## 4) Gợi ý kiểm thử
- Thử trên thiết bị thật để có GPS chính xác.
- Quan sát cảnh báo giọng nói khi vượt giới hạn +3 km/h.
- Kiểm tra mức tiêu thụ pin khi để màn hình tắt/mở.

## 5) Các bước tiếp theo
- Tích hợp dữ liệu giới hạn tốc độ thật (OSM, nguồn địa phương).
- Cải thiện map-matching và cảnh báo biển báo.
