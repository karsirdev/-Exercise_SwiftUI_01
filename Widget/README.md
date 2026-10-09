# Widget

Ứng dụng iOS (SwiftUI) có **Home Screen Widget** hiển thị dữ liệu từ app. App và widget trao đổi dữ liệu qua **App Group**; khi dữ liệu trong app đổi, widget được yêu cầu cập nhật ngay.

## Yêu cầu bài toán

| Mã | Yêu cầu | Được đáp ứng ở |
|----|---------|----------------|
| FR1 | Widget cỡ small (medium nếu muốn) | `MyWidget.swift` (`supportedFamilies`) |
| FR2 | `TimelineProvider` cung cấp entry | `TimeLineProvider.swift` |
| FR3 | Dữ liệu chia sẻ từ app qua App Group | `SharedData.swift` |
| FR4 | Nhấn widget mở app | `WidgetEntryView.swift` (`.widgetURL`) |
| NFR1 | Timeline cập nhật ít nhất mỗi giờ | `TimeLineProvider.swift` (`.after(+1 giờ)`) |
| NFR2 | Có placeholder khi chưa có dữ liệu | `placeholder(in:)` và nhánh `data == nil` trong `WidgetEntryView.swift` |
| AC1 | Widget hiện đúng dữ liệu trên Home Screen | Widget đọc `SharedData.load()` |
| AC2 | Đổi dữ liệu trong app thì widget cập nhật | `WidgetService.update` gọi `reloadTimelines` |

## Yêu cầu môi trường

- Xcode 16 trở lên
- iOS 17 trở lên (do dùng `containerBackground`)
- Tài khoản Apple Developer (hoặc Personal Team) để bật App Groups

## Cấu trúc project

```
Widget/                          # Target app chính ("Widget")
├── WidgetApp.swift              # Entry point của app
├── ContentView.swift            # Giao diện nhập và lưu dữ liệu
├── Services/
│   └── WidgetService.swift      # Lưu dữ liệu và yêu cầu widget reload
└── Assets.xcassets

MyWidget/                        # Code của widget (target WidgetExtentionExtension)
├── MyWidget.swift               # @main, khai báo widget
├── TimeLineProvider.swift       # Provider + DataEntry
└── WidgetEntryView.swift        # Giao diện widget

Shared/                          # Dùng chung, tick cả 2 target
└── SharedData.swift             # AppGroup, model SharedData, lưu/đọc dữ liệu

WidgetExtention/                 # Cấu hình của widget extension
├── Info.plist
└── Assets.xcassets
```

## Cách app và widget giao tiếp

App và widget là hai tiến trình riêng, không gọi code của nhau. Chúng chia sẻ dữ liệu qua `UserDefaults` của App Group:

```
 App (ContentView)
     │  bấm "Lưu và cập nhật widget"
     ▼
 WidgetService.update(data)
     ├─ data.save()  ──────────►  UserDefaults(suiteName: App Group)
     └─ WidgetCenter.reloadTimelines(ofKind:)
                                         │
                                         ▼
 Widget: Provider.getTimeline ──► SharedData.load() ──► WidgetEntryView
```

## Cài đặt

1. Mở `Widget.xcodeproj` bằng Xcode.
2. Bật **App Groups** cho cả hai target (**Signing & Capabilities** > **+ Capability** > **App Groups**):
   - `Widget` (app)
   - `WidgetExtentionExtension` (widget)
3. Thêm cùng một group ID ở cả hai target. Mặc định trong code là `group.Nguyencaovu.Widget`. Nếu đổi ID, sửa lại hằng số `AppGroup.id` trong `SharedData.swift`.
4. Kiểm tra **Target Membership**:
   - `MyWidget/` và `WidgetExtention/`: chỉ target `WidgetExtentionExtension`
   - `Shared/`: cả hai target
   - `Widget/`: chỉ target `Widget`

## Chạy thử

1. Chạy scheme `WidgetExtentionExtension` trên simulator, nhấn giữ Home Screen, thêm widget. Widget hiển thị "Chưa có dữ liệu".
2. Chạy scheme `Widget` (app), nhập tiêu đề và giá trị, bấm **Lưu và cập nhật widget**.
3. Về Home Screen, widget phải hiện dữ liệu vừa nhập. Nhấn vào widget sẽ mở app.

## Giải thích từng file

### `Shared/SharedData.swift`

Chứa mọi thứ cả app và widget cùng cần biết.

- `AppGroup`: hai hằng số dùng chung.
  - `id`: tên App Group, phải khớp với App Group đã bật ở cả hai target.
  - `widgetKind`: tên định danh của widget, dùng khi reload đúng widget.
- `SharedData`: model dữ liệu, tuân thủ `Codable` để chuyển thành JSON.
  - `title`, `value`, `updatedAt`: nội dung hiển thị.
  - `save()`: mã hóa thành `Data` rồi ghi vào `UserDefaults` của App Group.
  - `load()`: đọc `Data` từ App Group và giải mã. Trả về `nil` nếu chưa có dữ liệu, đây là tín hiệu để widget hiện trạng thái trống.
  - `sample`: dữ liệu mẫu cho placeholder, snapshot và preview.

Dùng `UserDefaults(suiteName:)` thay vì `UserDefaults.standard`, vì `standard` là của riêng từng tiến trình nên widget sẽ không đọc được.

### `MyWidget/TimeLineProvider.swift`

- `DataEntry`: một "khung hình" của widget tại thời điểm `date`, mang theo `data` (có thể `nil`). Phải tuân thủ `TimelineEntry`.
- `Provider`: cung cấp entry cho hệ thống, gồm 3 hàm:
  - `placeholder(in:)`: entry mẫu để iOS hiển thị khi chưa sẵn sàng (NFR2).
  - `getSnapshot(in:completion:)`: entry dùng khi widget hiện trong gallery lúc chọn widget. Nếu chưa có dữ liệu thật thì dùng dữ liệu mẫu.
  - `getTimeline(in:completion:)`: đọc dữ liệu hiện tại, tạo một entry, và đặt policy `.after(+1 giờ)` để hệ thống làm mới sau khoảng 1 giờ (NFR1). iOS không đảm bảo đúng từng phút, nên đây là mốc sớm nhất mong muốn, không phải giờ chính xác.

### `MyWidget/WidgetEntryView.swift`

Giao diện widget, nhận một `DataEntry`.

- Có dữ liệu: hiện `title`, `value` và giờ cập nhật.
- Không có dữ liệu: hiện "Chưa có dữ liệu" (NFR2).
- `.widgetURL(URL(string: "mywidget://open"))`: khi nhấn widget, iOS mở app (FR4).

### `MyWidget/MyWidget.swift`

Khai báo widget với `@main`. Đây là file duy nhất trong widget target được có `@main`.

- `StaticConfiguration`: widget không cho người dùng cấu hình.
- `kind`: lấy từ `AppGroup.widgetKind`, để app reload đúng widget này.
- `.containerBackground(.fill.tertiary, for: .widget)`: nền widget, bắt buộc từ iOS 17.
- `.supportedFamilies([.systemSmall, .systemMedium])`: hỗ trợ cỡ small và medium (FR1).
- `#Preview`: xem trước trong Xcode với hai trường hợp: có dữ liệu và trống.

### `Widget/Services/WidgetService.swift`

Chỉ nằm ở target app. Hàm `update(_:)` làm hai việc theo thứ tự:

1. `data.save()`: ghi dữ liệu mới vào App Group.
2. `WidgetCenter.shared.reloadTimelines(ofKind:)`: yêu cầu hệ thống làm mới widget (AC2).

Phải ghi trước rồi mới reload, nếu đảo lại widget có thể đọc phải dữ liệu cũ.

### `Widget/ContentView.swift`

Giao diện app, dạng `Form` với hai ô nhập (`title`, `value`) và một nút. Khi bấm nút, tạo `SharedData` mới với `updatedAt: .now` và gọi `WidgetService.update`. Khi view xuất hiện (`onAppear`), nạp lại dữ liệu đã lưu để hiện trong ô nhập.

### `Widget/WidgetApp.swift`

Entry point của app (`@main`), hiển thị `ContentView`. Nếu muốn điều hướng theo URL khi nhấn widget, thêm `.onOpenURL { url in ... }` vào `ContentView()`. Với FR4, việc mở app chỉ cần `.widgetURL`, `onOpenURL` là tùy chọn.

### `WidgetExtention/Info.plist` và `Assets.xcassets`

Cấu hình của widget extension (`NSExtensionPointIdentifier = com.apple.widgetkit-extension`) và tài nguyên của nó. Giữ lại, target đang trỏ tới `Info.plist`.

## Lỗi thường gặp

| Triệu chứng | Nguyên nhân thường gặp |
|-------------|------------------------|
| Widget luôn trống | App Group ID ở code, app target, widget target không khớp nhau |
| `Cannot find 'SharedData' / 'AppGroup' in scope` | `Shared/` chưa tick Target Membership đủ 2 target |
| Lỗi nhiều `@main` hoặc redeclaration | Chưa xóa các file template trong `WidgetExtention/` |
| Lỗi `containerBackground` | Deployment Target thấp hơn iOS 17 |
| Widget không cập nhật ngay | Chưa gọi `reloadTimelines` sau khi ghi dữ liệu |
| Timeline không đúng giờ | iOS tự cân đối ngân sách cập nhật, không đảm bảo đúng từng phút |
