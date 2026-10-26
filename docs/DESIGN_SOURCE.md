# Pixso 设计来源与还原说明

- 读取日期：2026-10-26。
- 文档：**Chief's Food App UI Kit**。
- 页面：`xd page`（`0:1`），同时包含浅色、深色两套 UI；另有 `Components` 页面。
- 原始画板：375 × 812。
- 读取方式：Pixso MCP 的 `get_design_context`、`query_nodes`、`get_nodes`、`export_node_image`。未改动原设计。
- 设计原图保存在 `docs/reference/`；运行截图保存在 `docs/screenshots/`，两者明确区分。

## 设计参数

| 项目 | 实现 |
| --- | --- |
| 品牌色 | `#FFA000` |
| 浅色背景 | `#FCFCFC`，白色卡片 |
| 深色背景 | `#262626`，`#303030` 卡片 |
| 字体 | 本地 Poppins Regular / Medium / SemiBold |
| 页面边距 | 20 逻辑像素 |
| 卡片圆角 | 14 逻辑像素 |
| 主按钮 | 50 高，胶囊形，黑色或橙色 |
| 导航 | 首页、菜单、购物车、个人中心四个入口 |

## 主要设计节点

| 页面 | 浅色节点 | 深色节点 | 本地参考图 |
| --- | --- | --- | --- |
| 首页 | `0:28` | `0:75` | `reference/home.png` |
| 菜单 | `0:2015` | `0:2080` | `reference/menu.png` |
| 搜索 | `0:123` | `0:193` | `reference/search.png` |
| 筛选 | `0:263` | `0:336` | `reference/filter.png` |
| 登录 | `0:827` | `0:865` | `reference/login.png` |
| 引导 | `0:1049` | `0:1118` | `reference/onboarding.png` |
| 餐品详情（原名 Cart） | `0:2956` | `0:3005` | `reference/detail.png` |
| 购物车（原名 Add to Cart） | `0:3054` | `0:3126` | `reference/cart.png` |
| 我的订单 | `0:2146` | `0:2228` | `reference/orders.png` |
| 地址结账 | `0:3274` | `0:3292` | `reference/checkout.png` |
| 支付 | `0:3198` | `0:3236` | `reference/payment.png` |
| 下单成功 | `0:3310` | `0:3348` | `reference/confirm.png` |
| 配送跟踪 | `0:3380` | `0:3540` | `reference/track.png` |
| 收货 | `0:409` | `0:618` | `reference/received.png` |
| 评分 | `0:2419` | `0:2451` | `reference/rate.png` |
| 个人中心 | `0:2598` | `0:2645` | `reference/profile.png` |
| 个人资料 | `0:2692` | `0:2713` | `reference/personal.png` |

## 导出的原始素材

| 文件 | Pixso 节点 |
| --- | --- |
| `assets/images/noodles.png` | `0:70` |
| `assets/images/chicken.png` | `0:2044` |
| `assets/images/salad.png` | `0:2069` |
| `assets/images/tandoori.png` | `0:2056` |
| `assets/images/salmon.png` | `0:2079` |
| `assets/images/cola.png` | `0:3085` |
| `assets/images/fries.png` | `0:3102` |
| `assets/images/avatar.png` | `0:2609` |
| `assets/images/onboarding.png` | `0:1100` |

图片保持为本地资产，因此首屏和截图不依赖图片服务器。字体来自 Google Fonts 的 Poppins 源文件，许可见 `assets/fonts/OFL.txt`。设计素材的权利归原作者，交付不新增素材授权。

## 对原稿的必要整理

原稿部分文字的行高或坐标异常，出现标题重叠、表单越出画板、按钮位于导航下方等问题。实现时保留色彩、字体、素材和内容层级，同时将这些区域恢复为正常可读的布局。首页购买按钮固定在导航上方；表单和长内容可以滚动。

图标采用 Flutter 内置 Material 图标；地图采用 `CustomPainter` 重绘模拟道路；成功页、礼物图标与启动标志使用原生图标。没有把整张设计截图当成可交互页面，也没有接入真实地图、社交登录、短信、支付或摄像头。

原稿多个验证、成功提示画板合并为可复用页面；错误提示通过表单状态展示。个人中心中缺少详情的安全、权限和设置入口补齐为实际可访问的说明或设置页。三页引导复用同一张原稿食物图并调整构图，保持视觉一致。
