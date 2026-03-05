# 和为 10 消除游戏

一款休闲消除类 Flutter 游戏

## 🎮 在线试玩

**网页版 Demo**: https://hunk-zhurui.github.io/sum10-game/js-demo/

> 可直接在浏览器中试玩，无需安装！

## 游戏规则

- 10x16 网格，共 160 个数字方块（1-9）
- 滑动选择相邻数字
- 数字之和为 10 即可消除
- 支持穿透空位连接（包括对角线）
- 限时 60 秒，时间到后根据消除数量计分

## 项目结构

```
lib/
├── main.dart              # 应用入口
├── core/                  # 核心游戏逻辑
│   ├── game_engine.dart   # 游戏引擎
│   └── grid.dart          # 网格管理
├── models/                # 数据模型
│   ├── cell.dart          # 方块模型
│   └── game_state.dart    # 游戏状态
├── ui/                    # UI 界面
│   ├── screens/           # 页面
│   ├── widgets/           # 组件
│   └── theme/             # 主题样式
├── services/              # 服务
│   ├── audio_service.dart # 音效
│   └── storage_service.dart # 存档
└── js-demo/               # 网页版 Demo
    └── index.html         # HTML 单文件版本
```

## 开发进度

- [x] 项目初始化
- [x] 第 1 步：项目结构搭建
- [x] 第 2 步：核心游戏逻辑
- [x] 第 3 步：UI 界面和动画
- [ ] 第 4 步：游戏功能（音效、存档）
- [ ] 第 5 步：打包测试

## 运行项目

### Flutter 版本

```bash
cd sum10_game
flutter run
```

### 网页版 Demo

直接在浏览器打开：
```
js-demo/index.html
```

或访问在线版本：https://hunk-zhurui.github.io/sum10-game/js-demo/

## 功能特性

### 核心玩法
- ✅ 10x16 网格布局
- ✅ 滑动选择方块
- ✅ 和为 10 自动消除
- ✅ 空位穿透连接（包括对角线）
- ✅ 60 秒倒计时
- ✅ 分数计算

### UI/UX
- ✅ 渐变背景主题
- ✅ 数字颜色区分（1-9 各有颜色）
- ✅ 选中效果（紫色高亮）
- ✅ 消除动画
- ✅ 连击特效
- ✅ 时间警告（最后 10 秒闪烁）
- ✅ 新手引导教程

### 系统功能
- ✅ 音效系统（点击/消除/连击）
- ✅ 存档服务（最高分/游戏次数）
- ✅ 静音开关
- ✅ 游戏结束结算界面

## 打包发布

### iOS
```bash
flutter build ios
```

### Android
```bash
flutter build apk
```

### Web
```bash
flutter build web
```

## 技术栈

- **Flutter**: 3.24.0
- **Dart**: 3.5.0
- **平台**: iOS, Android, Web

## 开发计划

### 第 4 步：游戏功能
- [ ] 完整音效系统（需要音频文件）
- [ ] 本地存储实现
- [ ] 难度选项（简单/普通/困难）
- [ ] 计分排行榜

### 第 5 步：打包测试
- [ ] iOS TestFlight 测试
- [ ] Android 内测分发
- [ ] Web 版本部署
- [ ] Bug 修复和优化

## 截图

### 主界面
![主界面](screenshots/home.png)

### 游戏界面
![游戏界面](screenshots/game.png)

### 结束界面
![结束界面](screenshots/gameover.png)

> 截图待添加

## 贡献

欢迎提交 Issue 和 Pull Request！

## 许可证

MIT License

## 相关链接

- [GitHub 仓库](https://github.com/Hunk-zhurui/sum10-game)
- [网页版 Demo](https://hunk-zhurui.github.io/sum10-game/js-demo/)
- [Flutter 官网](https://flutter.dev)
