import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'storage_service.dart';

/// 音效服务
/// 管理游戏音效播放
class AudioService {
  static final AudioService _instance = AudioService._internal();
  factory AudioService() => _instance;
  AudioService._internal();

  final AudioPlayer _bgmPlayer = AudioPlayer();
  final AudioPlayer _sfxPlayer = AudioPlayer();
  bool _isMuted = false;

  /// 是否静音
  bool get isMuted => _isMuted;

  /// 初始化
  Future<void> init() async {
    final storage = StorageService();
    _isMuted = storage.isMuted;
    
    // 设置音量
    await _bgmPlayer.setVolume(_isMuted ? 0 : 0.5);
    await _sfxPlayer.setVolume(_isMuted ? 0 : 1.0);
    
    debugPrint('🎵 音效服务初始化完成');
  }

  /// 设置静音
  Future<void> setMuted(bool muted) async {
    _isMuted = muted;
    await _bgmPlayer.setVolume(muted ? 0 : 0.5);
    await _sfxPlayer.setVolume(muted ? 0 : 1.0);
    
    // 保存到设置
    final storage = StorageService();
    await storage.setMuted(muted);
    
    debugPrint('🔇 静音：$muted');
  }

  /// 播放点击音效
  Future<void> playTap() async {
    if (_isMuted) return;
    // TODO: 播放实际音效文件
    // await _sfxPlayer.play(AssetSource('sounds/tap.wav'));
    debugPrint('🎵 点击音效');
  }

  /// 播放消除音效
  Future<void> playEliminate({int count = 1}) async {
    if (_isMuted) return;
    // TODO: 播放实际音效文件
    // await _sfxPlayer.play(AssetSource('sounds/eliminate.wav'));
    debugPrint('🎵 消除音效 (x$count)');
  }

  /// 播放连击音效
  Future<void> playCombo({int level = 1}) async {
    if (_isMuted) return;
    // TODO: 播放实际音效文件
    // await _sfxPlayer.play(AssetSource('sounds/combo_$level.wav'));
    debugPrint('🎵 连击音效 Lv.$level');
  }

  /// 播放时间警告音效
  Future<void> playTimeWarning() async {
    if (_isMuted) return;
    // TODO: 播放实际音效文件
    // await _sfxPlayer.play(AssetSource('sounds/warning.wav'));
    debugPrint('🎵 时间警告');
  }

  /// 播放游戏结束音效
  Future<void> playGameOver({bool isWin = false}) async {
    if (_isMuted) return;
    // TODO: 播放实际音效文件
    // await _sfxPlayer.play(AssetSource('sounds/${isWin ? 'win' : 'lose'}.wav'));
    debugPrint('🎵 游戏结束 ${isWin ? "胜利" : "失败"}');
  }

  /// 播放背景音乐
  Future<void> playBGM() async {
    if (_isMuted) return;
    // TODO: 播放实际背景音乐文件
    // await _bgmPlayer.play(AssetSource('music/bgm.mp3'), mode: PlayerMode.loop);
    debugPrint('🎵 背景音乐开始');
  }

  /// 停止背景音乐
  Future<void> stopBGM() async {
    await _bgmPlayer.stop();
    debugPrint('🎵 背景音乐停止');
  }

  /// 暂停背景音乐
  Future<void> pauseBGM() async {
    await _bgmPlayer.pause();
  }

  /// 继续背景音乐
  Future<void> resumeBGM() async {
    await _bgmPlayer.resume();
  }

  /// 释放资源
  Future<void> dispose() async {
    await _bgmPlayer.dispose();
    await _sfxPlayer.dispose();
  }
}
