import 'dart:math';
import '../models/cell.dart';

/// 网格管理类
/// 管理 10x16 的游戏网格
class GameGrid {
  static const int rows = 16;
  static const int cols = 10;
  static const int totalCells = rows * cols;

  List<List<GameCell>> _grid = [];

  GameGrid() {
    init();
  }

  /// 初始化网格
  void init() {
    _grid = [];
    for (int r = 0; r < rows; r++) {
      List<GameCell> row = [];
      for (int c = 0; c < cols; c++) {
        row.add(GameCell(
          row: r,
          col: c,
          value: _generateNumber(),
        ));
      }
      _grid.add(row);
    }
    _ensureInitialMatches();
  }

  /// 生成随机数字 (1-9)，5 的概率更高
  int _generateNumber() {
    final weights = [1, 2, 3, 4, 5, 5, 4, 3, 2];
    final total = weights.reduce((a, b) => a + b);
    var rand = Random().nextInt(total);
    for (int i = 0; i < weights.length; i++) {
      rand -= weights[i];
      if (rand <= 0) return i + 1;
    }
    return 5;
  }

  /// 确保开局有一些可消除组合
  void _ensureInitialMatches() {
    final random = Random();
    for (int r = 0; r < rows; r++) {
      for (int c = 0; c < cols - 1; c++) {
        if (random.nextDouble() < 0.3) {
          final num1 = random.nextInt(9) + 1;
          final num2 = 10 - num1;
          if (num2 >= 1 && num2 <= 9) {
            _grid[r][c] = GameCell(row: r, col: c, value: num1);
            if (c + 1 < cols) {
              _grid[r][c + 1] = GameCell(row: r, col: c + 1, value: num2);
            }
          }
        }
      }
    }
  }

  /// 获取指定位置的方块
  GameCell? getCell(int row, int col) {
    if (row < 0 || row >= rows || col < 0 || col >= cols) return null;
    return _grid[row][col];
  }

  /// 获取所有方块
  List<List<GameCell>> get grid => _grid;

  /// 获取所有未消除的方块
  List<GameCell> get activeCells {
    List<GameCell> cells = [];
    for (var row in _grid) {
      for (var cell in row) {
        if (!cell.isEliminated) {
          cells.add(cell);
        }
      }
    }
    return cells;
  }

  /// 消除方块
  void eliminateCells(List<GameCell> cells) {
    for (var cell in cells) {
      _grid[cell.row][cell.col] = cell.withEliminated(true);
    }
  }

  /// 检查是否可以穿透空位连接
  bool canConnect(GameCell from, GameCell to) {
    final dr = (from.row - to.row).abs();
    final dc = (from.col - to.col).abs();

    // 直接相邻
    if ((dr == 1 && dc == 0) || (dr == 0 && dc == 1)) {
      return true;
    }

    // 对角线相邻
    if (dr == 1 && dc == 1) {
      final path1 = _grid[from.row][to.col].isEliminated;
      final path2 = _grid[to.row][from.col].isEliminated;
      return path1 || path2;
    }

    // BFS 查找路径
    return _hasPath(from, to);
  }

  /// BFS 查找是否存在路径
  bool _hasPath(GameCell from, GameCell to) {
    final visited = <String>{};
    final queue = <GameCell>[from];
    visited.add('${from.row}_${from.col}');

    const directions = [
      [-1, 0], [1, 0], [0, -1], [0, 1], // 上下左右
      [-1, -1], [-1, 1], [1, -1], [1, 1] // 对角线
    ];

    while (queue.isNotEmpty) {
      final curr = queue.removeAt(0);

      for (var dir in directions) {
        final nr = curr.row + dir[0];
        final nc = curr.col + dir[1];

        if (nr < 0 || nr >= rows || nc < 0 || nc >= cols) continue;

        final key = '${nr}_$nc';
        if (visited.contains(key)) continue;

        // 到达目标
        if (nr == to.row && nc == to.col) {
          return true;
        }

        // 空位可以穿过
        if (_grid[nr][nc].isEliminated) {
          visited.add(key);
          queue.add(_grid[nr][nc]);
        }
      }
    }

    return false;
  }

  /// 检查选中的方块是否连通
  bool areConnected(List<GameCell> cells) {
    if (cells.length < 2) return cells.length == 1;

    final visited = <String>{};
    final queue = <GameCell>[cells[0]];
    visited.add('${cells[0].row}_${cells[0].col}');

    while (queue.isNotEmpty) {
      final curr = queue.removeAt(0);
      for (var cell in cells) {
        final key = '${cell.row}_${cell.col}';
        if (visited.contains(key)) continue;

        if (canConnect(curr, cell)) {
          visited.add(key);
          queue.add(cell);
        }
      }
    }

    return visited.length == cells.length;
  }

  /// 重置网格
  void reset() {
    init();
  }
}
