# Chief’s Food · Flutter App

根据 Pixso **Chief's Food App UI Kit** 开发的餐饮点单应用，保留橙色主色、Poppins 字体、原稿餐品素材和浅色／深色视觉体系。已实现 37 个页面路由，覆盖账户引导、选餐、下单、配送演示及个人中心。

这是可以实际操作、保存本地数据的 UI 演示版。账户验证、支付、扫码和配送均在界面中明确标为本地演示，不会产生真实交易。

## 主要界面

下面图片来自 Android 模拟器中运行的 App。完整的 **84 张截图**请查看 [全部页面截图](docs/SCREENSHOTS.md)。

| 今日推荐 | 餐品菜单 | 餐品详情 |
| --- | --- | --- |
| <img src="docs/screenshots/light_home.png" width="240" alt="首页推荐与固定购买按钮"> | <img src="docs/screenshots/light_menu.png" width="240" alt="菜单分类与收藏"> | <img src="docs/screenshots/light_detail.png" width="240" alt="餐品详情与配料"> |

| 购物车 | 配送跟踪 | 个人中心 |
| --- | --- | --- |
| <img src="docs/screenshots/light_cart.png" width="240" alt="购物车数量与总额"> | <img src="docs/screenshots/light_track.png" width="240" alt="模拟配送地图"> | <img src="docs/screenshots/light_profile.png" width="240" alt="个人中心入口"> |

| 深色首页 | 深色菜单 | 深色结账 |
| --- | --- | --- |
| <img src="docs/screenshots/dark_home.png" width="240" alt="深色首页"> | <img src="docs/screenshots/dark_menu.png" width="240" alt="深色菜单"> | <img src="docs/screenshots/dark_payment.png" width="240" alt="深色支付演示"> |

## 已实现内容

- **引导与账户**：品牌启动页、三步引导、登录、注册、找回密码、选择验证方式、验证码、重置密码和成功页。
- **选餐**：今日推荐切换、菜单分类、收藏、餐品详情、数量、配料、搜索与价格／分类筛选。
- **订单**：购物车加减与移除、折扣码、金额联动、地址校验、模拟支付、成功提示、模拟路线、收货、满意度、评分及历史摘要。
- **个人中心**：资料保存、收藏列表、模拟支付方式弹层与扫码、安全与权限说明、通知、浅色／深色设置。
- **本地保存**：主题、资料、地址、收藏、购物车、历史订单与收货状态。
- **状态覆盖**：登录校验错误、验证码错误、空购物车、搜索无结果、添加支付方式弹层。

## 快速运行

本次使用 Flutter **3.47.7**、Dart **3.13.5**，Android 模拟器已实测。

```powershell
flutter pub get
flutter run -d emulator-5554
```

首次使用从启动和引导进入；登录页选择 **Try the demo** 即可直接体验。也可以输入合法格式邮箱与至少 6 位密码走本地登录演示。验证码固定为 **1234**。购物车优惠码为 **CHIEF10**，提供 10% 演示折扣。

模拟器未启动时：

```powershell
flutter emulators --launch flutter_emulator
flutter devices
```

项目目录含英文单引号，当前 Flutter 测试工具对该路径有兼容问题。测试时使用空闲盘符映射；本次已使用 `Q:` 指向原目录，源文件不会搬走或复制：

```powershell
# Q: 为空闲盘符时只需映射一次；已经指向本项目时跳过这一行。
subst Q: "C:\Users\liuyu\Desktop\Chief'sFood"
Set-Location Q:\
flutter pub get
flutter analyze
flutter test
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_test.dart -d emulator-5554
```

如果更换电脑或目录，可以直接把项目放到不含单引号的路径中。

## 项目结构与架构

```text
lib/
├── main.dart                         初始化
├── app.dart                          应用入口与路由表
├── core/                             共享业务状态、主题
├── data/                             模型、静态餐品、本地存储
├── shared/                           页面骨架、按钮、卡片、表单等
└── features/
    ├── auth/                         引导与账户
    ├── discover/                     首页、菜单、搜索、详情
    ├── orders/                       购物车、结账、配送、评价
    └── profile/                      资料、支付方式、设置
```

采用按功能组织的轻量分层：**页面 → AppState → LocalRepository → SharedPreferences**。状态更新由 Flutter 自带的 `ChangeNotifier` 和 `InheritedNotifier` 通知页面；路由由 `Navigator` 管理。

生产依赖只有 `shared_preferences`。登录与注册等共用表单页面、三种成功结果共用成功页、购物车与历史共用订单页，浅色／深色通过主题切换，避免复制整套页面。金额使用整数美分，避免浮点误差。

详细说明见 [项目结构与架构](docs/ARCHITECTURE.md)。

## 构建与交付

```powershell
flutter build apk --release
```

Android 体验安装包：[`dist/chiefs-food-demo.apk`](dist/chiefs-food-demo.apk)。构建输出原件位于 `build/app/outputs/flutter-apk/app-release.apk`。演示包使用本地调试签名；不作为商店正式发行包。

iOS 源工程已包含，需要 macOS / Xcode 构建；Web 入口已包含，可用 `flutter run -d chrome` 进行开发预览。具体平台验证范围见验证文档。

## 文档索引

| 文档 | 内容 |
| --- | --- |
| [项目结构与架构](docs/ARCHITECTURE.md) | 完整目录、分层、数据流、状态、金额、代码复用、扩展位置 |
| [全部页面截图](docs/SCREENSHOTS.md) | 37 页面 × 2 主题，加 10 张异常／弹层状态，共 84 张 |
| [Pixso 设计来源](docs/DESIGN_SOURCE.md) | 主要节点 ID、素材来源、设计参数、原稿修正说明 |
| [验证记录](docs/VALIDATION.md) | 测试环境、77 项测试、模拟器完整流程、截图复现 |

已完成代码复用与清理。原稿中重叠文字、越界表单及导航遮挡按钮已调整为可正常操作的布局。当前不包含真实后端账户、支付、实时 GPS、短信和评价上传；边界和后续接入点已在架构文档列明。
