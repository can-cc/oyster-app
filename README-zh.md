# oyster

A new Flutter project.

## Getting Started

For help getting started with Flutter, view our online
[documentation](https://flutter.io/).


## 生成 app 图标
[flutter_launcher_icons](https://pub.dev/packages/flutter_launcher_icons).


``` yaml
dev_dependencies:
  flutter_launcher_icons: "^0.7.2"

flutter_icons:
  image_path: "assets/logo.png"
  android: "launcher_icon"
  ios: true

```


## 发布
(https://flutter.dev/docs/deployment/ios)[https://flutter.dev/docs/deployment/ios]
### iOS

运行 `flutter build ios --release` 可以打包，也可以在 xcode 上直接安装，在 xcode 上直接安装的时候需要在左上角的选项上选择正确的 schema 为 Release
