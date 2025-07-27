import 'package:video_player/video_player.dart';

//bool _isMuted = true;

class VideoControllerManager {
  static final VideoControllerManager _instance = VideoControllerManager._internal();

  factory VideoControllerManager() => _instance;

  VideoControllerManager._internal();

  final Map<String, VideoPlayerController> _controllers = {};
  final List<String> _usageOrder = [];

  final int _maxActiveControllers = 2;

  Future<VideoPlayerController> getController(String url, bool isMuted) async {
    if (_controllers.containsKey(url)) {
      _markUsed(url);
      return _controllers[url]!;
    }

    // Remove least recently used if exceeding max
    if (_controllers.length >= _maxActiveControllers) {
      final oldestKey = _usageOrder.removeAt(0);
      await _controllers[oldestKey]?.dispose();
      _controllers.remove(oldestKey);
    }

    final controller = VideoPlayerController.networkUrl(Uri.parse(url));
    await controller.initialize();
    controller.setLooping(true);
    controller.setVolume(isMuted ? 0.0 : 1.0);

    _controllers[url] = controller;
    _markUsed(url);

    return controller;
  }

  void _markUsed(String url) {
    _usageOrder.remove(url);
    _usageOrder.add(url);
  }

  // void pauseAllExcept(String url) {
  //   _controllers.forEach((key, controller) {
  //     if (key != url && controller.value.isInitialized) {
  //       controller.pause();
  //     }
  //   });
  // }

  void pauseAllExcept(String url) {
    _controllers.forEach((key, controller) {
      if (key != url && controller.value.isInitialized) {
        try {
          controller.pause();
        } catch (_) {
          print("Already Paused|||||||||||||||||||||");

          // ignore if disposed
        }
      }
    });
  }


  Future<void> disposeController(String url) async {
    if (_controllers.containsKey(url)) {
      final controller = _controllers[url];
      if (controller != null) {
        try {
          await controller.pause();
          await controller.dispose();
        } catch (_) {
          print("Already Disposed|||||||||||||||||||||");
          // controller might already be disposed
        }
      }
      _controllers.remove(url);
      _usageOrder.remove(url);
    }
  }

  Future<void> disposeAll() async {
    for (final controller in _controllers.values) {
      await controller.dispose();
    }
    _controllers.clear();
    _usageOrder.clear();
  }
}


class VideoMuteManager {
  static final VideoMuteManager _instance = VideoMuteManager._internal();
  factory VideoMuteManager() => _instance;
  VideoMuteManager._internal();

  bool _globalMuted = true;
  final List<void Function(bool)> _listeners = [];

  bool get isMuted => _globalMuted;

  void toggleMuteAll(bool mute) {
    _globalMuted = mute;
    for (var listener in _listeners) {
      listener(mute);
    }
  }

  void addListener(void Function(bool) listener) {
    _listeners.add(listener);
  }

  void removeListener(void Function(bool) listener) {
    _listeners.remove(listener);
  }
}

