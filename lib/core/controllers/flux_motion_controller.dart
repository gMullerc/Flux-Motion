import 'package:flutter/foundation.dart';

/// Controls the playback of one attached Flux Motion widget.
///
/// A controller can be attached to only one widget at a time. Playback methods
/// are safe to call while detached and become no-ops until a widget attaches.
class FluxMotionController {
  /// Creates a controller that can be passed to a Flux Motion widget.
  FluxMotionController();

  Object? _owner;
  VoidCallback? _play;
  VoidCallback? _stop;
  VoidCallback? _reset;
  VoidCallback? _replay;

  /// Whether this controller is currently attached to a mounted widget.
  bool get isAttached => _owner != null;

  /// Starts the motion using the trigger configured by the attached widget.
  void play() => _play?.call();

  /// Stops playback at its current frame.
  void stop() => _stop?.call();

  /// Stops playback and returns the motion to its initial frame.
  ///
  /// Calling this method does not start the motion again.
  void reset() => _reset?.call();

  /// Returns the motion to its initial frame and starts it from the beginning.
  void replay() => _replay?.call();

  /// Attaches widget-owned playback callbacks to this controller.
  ///
  /// This method is reserved for Flux Motion widgets. Attaching a second owner
  /// before the first one detaches throws a [StateError].
  void attach({
    required Object owner,
    required VoidCallback play,
    required VoidCallback stop,
    required VoidCallback reset,
    required VoidCallback replay,
  }) {
    if (_owner != null && !identical(_owner, owner)) {
      throw StateError(
        'A FluxMotionController can only be attached to one widget at a time.',
      );
    }

    _owner = owner;
    _play = play;
    _stop = stop;
    _reset = reset;
    _replay = replay;
  }

  /// Detaches callbacks owned by [owner].
  ///
  /// Calls from stale widget owners are ignored so that they cannot detach a
  /// newer valid binding.
  void detach(Object owner) {
    if (!identical(_owner, owner)) {
      return;
    }

    _owner = null;
    _play = null;
    _stop = null;
    _reset = null;
    _replay = null;
  }
}
