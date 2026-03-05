# 和为 10 消除游戏

一款休闲消除类 Flutter 游戏

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
│   ├── grid.dart          # 网格管理
│   ├── selection.dart     # 选择逻辑
│   └── rules.dart         # 游戏规则
├── models/                # 数据模型
│   ├── cell.dart          # 方块模型
│   ├── game_state.dart    # 游戏状态
│   └── score.dart         # 分数记录
├── ui/                    # UI 界面
│   ├── screens/           # 页面
│   │   ├── home_screen.dart      # 主页面
│   │   ├── game_screen.dart      # 游戏页面
│   │   └── game_over_screen.dart # 结束页面
│   ├── widgets/           # 组件
│   │   ├── game_grid.dart        # 游戏网格
│   │   ├── game_cell.dart        # 游戏方块
│   │   ├── score_board.dart      # 计分板
│   │   └── timer_widget.dart     # 倒计时
│   └── theme/           # 主题样式
│       ├── app_theme.dart        # 应用主题
│       └── colors.dart           # 颜色定义
└── services/            # 服务
    ├── audio_service.dart        # 音效
    └── storage_service.dart      # 存档
```

## 开发进度

- [x] 项目初始化
- [ ] 第 1 步：项目结构搭建
- [ ] 第 2 步：核心游戏逻辑
- [ ] 第 3 步：UI 界面
- [ ] 第 4 步：游戏功能
- [ ] 第 5 步：打包测试

## 运行项目

```bash
cd sum10_game
flutter run
```

## 打包发布

### iOS
```bash
flutter build ios
```

### Android
```bash
flutter build apk
```

## 许可证

MIT License
