import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:just_audio/just_audio.dart';
import '../../../core/services/audio_service.dart';
import 'package:flutter/material.dart';
enum AudioStatus { playing, paused, loading, stopped }

final memorizationAudioControllerProvider =
    StateNotifierProvider<MemorizationAudioController, AudioStatus>((ref) {
      final audioService = ref.watch(audioServiceProvider);
      return MemorizationAudioController(audioService);
    });

class MemorizationAudioController extends StateNotifier<AudioStatus> {
  final AudioService _audioService;
  VoidCallback? _onAudioCompleteCallback;

  MemorizationAudioController(this._audioService) : super(AudioStatus.stopped) {
    _init();
  }

  void _init() {
    _audioService.playerStateStream.listen((playerState) {
      final processingState = playerState.processingState;
      if (processingState == ProcessingState.loading ||
          processingState == ProcessingState.buffering) {
        state = AudioStatus.loading;
      } else if (playerState.playing) {
        state = AudioStatus.playing;
      } else if (processingState == ProcessingState.completed) {
        state = AudioStatus.stopped;
        _audioService.stop();
        _audioService.seek(Duration.zero);
        if (_onAudioCompleteCallback != null) {
          _onAudioCompleteCallback!();
          _onAudioCompleteCallback = null;
        }
      } else if (processingState == ProcessingState.idle) {
        state = AudioStatus.stopped;
      } else {
        state = AudioStatus.paused;
      }
    });
  }


  Future<void> toggleAudio(String? url, BuildContext context, {
    VoidCallback? onComplete,
  }) async {
    if (url == null || url.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('لا يوجد ملف صوتي لهذه الخطة')),
      );
      return;
    }
    if (onComplete != null) {
      _onAudioCompleteCallback = onComplete;
    }
    try {
      if (state == AudioStatus.playing) {
        await _audioService.pause();
      } else {
        await _audioService.play(url);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('فشل تشغيل الصوت. تأكد من الاتصال بالإنترنت.'),
          backgroundColor: Colors.red,
        ),
      );
      state = AudioStatus.stopped;
    }
  }
}
