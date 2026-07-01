# ❤️ 爱旅游 APP

重庆5日全家行 · 旅行助手

| 平台 | 状态 |
|------|------|
| Android / 鸿蒙 | ✅ 可直接安装 APK |
| iOS (iPhone) | ⚡ 需 GitHub Actions 云编译或 Mac 本地编译 |

---

## 🚀 快速开始

### Android / 鸿蒙
直接下载 `爱旅游APP.apk` 安装即可。

### iOS 编译方法

<details>
<summary><b>方法一：GitHub Actions 云编译（推荐，无需 Mac）</b></summary>

1. **Fork 或推送** 本仓库到你的 GitHub 账号
2. 进入仓库 → **Actions** 标签页
3. 在左侧选择 **「编译爱旅游 iOS (IPA)」**
4. 点击 **「Run workflow」** → 绿色按钮
5. 等待约 10-15 分钟编译完成
6. 编译完成后，在 Actions 页面点击本次运行记录
7. 下方 **Artifacts** 区域下载 `爱旅游APP-iOS.zip`
8. 解压得到 `.ipa` 文件

> ⚠️ IPA 未签名，需要用 Apple ID 签名后才能安装到 iPhone
</details>

<details>
<summary><b>方法二：Mac 本地编译</b></summary>

```bash
# 1. 克隆项目
git clone https://github.com/你的账号/love_travel.git
cd love_travel

# 2. 获取依赖
flutter pub get
cd ios && pod install && cd ..

# 3. 打开 Xcode 配置签名
open ios/Runner.xcworkspace
# → 选择 Runner → Signing & Capabilities → 选你的 Apple ID

# 4. 编译运行
flutter run                    # 直接安装到 iPhone
flutter build ios --release    # 生成 IPA
```
</details>

---

## 📱 功能

| 功能 | 说明 |
|------|------|
| 🏠 首页看板 | 倒计时、今日行程、统计进度 |
| 📋 行程管理 | 5天切换、编辑/添加/删除、标记完成 |
| 📸 拍照记录 | 拍照、相册选取、全屏查看 |
| 💰 费用明细 | 住宿/门票/餐饮/交通/杂费 |
| 💡 出行贴士 | 交通/美食/游玩/购物 |
| 📝 备忘录 | 自动保存 |
