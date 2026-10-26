# 验证与截图说明

## 环境

- 验证日期：2026-10-26，日本时间。
- Flutter 3.47.7 stable，Dart 3.13.5。
- Windows 11，Android SDK 已安装；Android 模拟器 `flutter_emulator`。
- 实测设备：Android 15 / API 35 / x86_64，设备 ID `emulator-5554`。
- 截图：1080 × 2340 像素，density 440，逻辑视口约 392.7 × 850.9。

## 自动验证范围

| 验证 | 内容 |
| --- | --- |
| `flutter analyze` | 项目静态检查 |
| `flutter test` | 77 项测试：2 项业务状态测试、37 路由 × 2 种尺寸、1 项登录校验 |
| 小屏布局 | 375 × 812、320 × 640 逻辑像素，捕获渲染异常和溢出 |
| 业务状态 | 数量合并与上限、移除、折扣计算、订单快照、空购物车保护、保存与恢复 |
| Android 集成测试 | 通过真实点击完成选餐、加购、地址校验、下单、跟踪、收货 |
| 页面截图 | 37 个页面 × 浅色／深色，以及 5 种额外状态 × 两种主题 |

最终结果：静态检查 **No issues found**；77 项测试全部通过；Android 集成测试通过，输出 **84 张**截图，结果摘要见 `integration-result.json`。`flutter build apk --release` 已成功，已将 APK 安装到模拟器并检查启动。

集成测试先运行真实点单流程，再设置固定演示数据生成截图：订单号 `456723`、鸡肉沙拉 2 份、可乐 2 份、薯条 1 份，小计 `$32.12`，三文鱼已收藏。使用 mock preferences 避免为用户的真实本地数据写入截图样例。

额外截图包括登录输入错误、验证码错误、空购物车、搜索无结果和添加支付方式弹层。截图取自模拟器中运行的 Flutter 界面，并非 Pixso 导出图或静态页面贴图。原稿参考图单独保存在 `reference/`。

截图覆盖的是页面在当前手机视口内的显示。长内容可以滚动；文档没有将滚动页面拼接为伪造的长屏截图。

## 复现

本项目路径中有英文单引号。当前 Flutter 测试工具生成临时 Dart 文件时未正确处理这种路径，可用 Windows 临时盘符映射后运行。`Q:` 必须为空闲盘符；若已映射至本项目，直接进入即可。

```powershell
subst Q: "C:\Users\liuyu\Desktop\Chief'sFood"
Set-Location Q:\
flutter pub get
flutter analyze
flutter test
flutter emulators --launch flutter_emulator
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d emulator-5554
```

已在 `android/gradle.properties` 关闭 Kotlin incremental 编译，避免映射盘符与 C 盘 Pub 缓存之间的路径根不一致。普通 Android 构建也可直接在原目录进行。

截图由 `test_driver/integration_test.dart` 保存到 `docs/screenshots/`。`docs/integration-result.json` 保存通过状态和截图数；测试响应中的大量图片字节不会再额外写入大型 JSON 文件。

## 视觉复核

人工读取了首页、菜单、餐品详情、购物车、结账、跟踪、登录和深色首页的实际截图。根据复核调整了首页购买按钮的位置，使其在底部导航上方固定显示；修复了表单、标题行和金额行在小屏幕上的溢出，并修复卡片中列表项的 Material 点击反馈层级。

最终以自动测试和模拟器端结果为准；构建日志位于 `docs/unit-test.log`、`docs/integration-test.log`（日志默认不纳入版本控制）。

## 范围与限制

本次以 Android 模拟器作为实际运行环境。iOS 源工程已生成，需在 macOS / Xcode 上构建与验证；Web 源工程可使用 Flutter Web 运行。未把其他平台描述为经过手机实机验收。

账户、支付、扫码、配送与评价均为明确标识的本地演示，没有真实交易或外部服务调用。正式发布仍需配置正式签名、真实服务和素材授权。交付 APK 是用于体验的演示构建。
