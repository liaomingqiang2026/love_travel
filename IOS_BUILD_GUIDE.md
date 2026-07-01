# 🍎 爱旅游 APP - iOS 编译指南

## 📋 前置条件

| 条件 | 说明 |
|------|------|
| **Mac 电脑** | macOS 12+ (Monterey 或更新版本) |
| **Xcode** | 从 App Store 安装最新版 Xcode |
| **Flutter SDK** | 版本 3.0.0+ |
| **Apple ID** | 免费版即可在真机调试，发布需付费开发者账号($99/年) |

---

## 🚀 编译步骤

### 1. 安装 Flutter SDK（如果没有）

```bash
# 下载 Flutter SDK
git clone -b stable https://github.com/flutter/flutter.git
export PATH="$PWD/flutter/bin:$PATH"
flutter precache --ios
```

### 2. 配置项目

```bash
# 解压源码
unzip love_travel_source.zip
cd love_travel_source

# 获取依赖
flutter pub get

# 安装 iOS Pod 依赖
cd ios
pod install
cd ..
```

### 3. 打开 Xcode 配置签名

```bash
# 打开 Xcode 工作区
open ios/Runner.xcworkspace
```

在 Xcode 中：

1. 左侧选择 **Runner** 项目
2. 选择 **Runner** target
3. **Signing & Capabilities** 选项卡
4. 勾选 **Automatically manage signing**
5. 选择你的 **Apple ID** 作为 Team
6. Bundle Identifier 会自动生成（`com.lovetravel.love_travel`）

### 4. 连接真机编译

```bash
# 编译到真机（推荐）
flutter run

# 或直接 Build IPA
flutter build ios
```

---

## 📱 安装到 iPhone

### 方法一：直接运行（推荐）

```bash
flutter run
```

用数据线连接 iPhone → 选择设备 → 运行。Xcode 会自动安装到手机。

### 方法二：导出 IPA

```bash
flutter build ios --release
```

生成路径：
```
build/ios/ipa/love_travel.ipa
```

通过以下方式安装 IPA：
- **TestFlight**（需开发者账号）
- **Apple Configurator 2**
- **侧载工具**：SideStore、AltStore

---

## 📸 功能说明

| 功能 | iOS 支持 | 说明 |
|------|----------|------|
| 行程管理 | ✅ | 编辑、添加、删除、标记完成 |
| 拍照记录 | ✅ | 调用相机 / 相册选取 |
| 费用明细 | ✅ | 预算展示 |
| 出行贴士 | ✅ | 交通/美食/游玩/购物 |
| 备忘录 | ✅ | 本地存储 |
| 数据持久化 | ✅ | SharedPreferences |

---

## 🔧 常见问题

### Q: pod install 失败怎么办？
```bash
cd ios
pod repo update
pod install --repo-update
```

### Q: 证书签名错误？
在 Xcode → Signing & Capabilities 中重新选择 Team，确保 Apple ID 已添加。

### Q: Flutter 版本不兼容？
```bash
flutter upgrade
```

---

## 📦 文件说明

```
love_travel_source/
├── lib/                    # Dart 源码
│   ├── main.dart           # 入口文件
│   ├── models/             # 数据模型
│   └── screens/            # 页面
├── android/                # Android 项目
├── ios/                    # iOS 项目（已配置好）
│   ├── Podfile             # CocoaPods 配置
│   ├── Runner/             # iOS 源码
│   │   └── Info.plist      # 已配置相机权限
│   └── Runner.xcworkspace  # Xcode 工作区
└── pubspec.yaml            # 依赖配置
```

---

> **提示**：第一次编译需要下载依赖，保持网络通畅。如有任何问题，随时联系我！
