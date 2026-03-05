/// 方块模型
/// 代表网格中的一个数字方块
class GameCell {
  final int row;          // 行
  final int col;          // 列
  final int value;        // 数字值 (1-9)
  final bool isSelected;  // 是否被选中
  final bool isEliminated; // 是否已消除

  const GameCell({
    required this.row,
    required this.col,
    required this.value,
    this.isSelected = false,
    this.isEliminated = false,
  });

  /// 创建已选中的方块
  GameCell withSelected(bool selected) {
    return GameCell(
      row: row,
      col: col,
      value: value,
      isSelected: selected,
      isEliminated: isEliminated,
    );
  }

  /// 创建已消除的方块
  GameCell withEliminated(bool eliminated) {
    return GameCell(
      row: row,
      col: col,
      value: value,
      isSelected: isSelected,
      isEliminated: eliminated,
    );
  }

  /// 获取唯一标识
  String get id => '${row}_$col';

  /// 复制一份
  GameCell copy() {
    return GameCell(
      row: row,
      col: col,
      value: value,
      isSelected: isSelected,
      isEliminated: isEliminated,
    );
  }

  @override
  String toString() {
    return 'GameCell($row,$col): $value${isSelected ? " [选中]" : ""}${isEliminated ? " [消除]" : ""}';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GameCell &&
        other.row == row &&
        other.col == col &&
        other.value == value;
  }

  @override
  int get hashCode => row.hashCode ^ col.hashCode ^ value.hashCode;
}
