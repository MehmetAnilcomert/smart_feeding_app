// lib/enums/feed_error_type.dart
import 'package:flutter/material.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

enum FeedErrorType {
  deviceNotReachable(1),
  generalError(2),
  timeoutError(3),
  invalidTimeRange(4);

  const FeedErrorType(this.code);

  final int code;

  /// Error code'dan enum'a dönüştürme
  static FeedErrorType fromCode(int code) {
    return FeedErrorType.values.firstWhere(
      (type) => type.code == code,
      orElse: () => FeedErrorType.generalError,
    );
  }

  /// Her hata türü için ikon
  IconData get icon {
    switch (this) {
      case FeedErrorType.deviceNotReachable:
        return Icons.wifi_off;
      case FeedErrorType.timeoutError:
        return Icons.access_time;
      case FeedErrorType.invalidTimeRange:
        return Icons.schedule_outlined;
      case FeedErrorType.generalError:
        return Icons.error;
    }
  }

  /// Her hata türü için başlık
  String getTitle(BuildContext context) {
    switch (this) {
      case FeedErrorType.deviceNotReachable:
        return S.of(context).connection_error_title;
      case FeedErrorType.timeoutError:
        return S.of(context).timeout_error_title;
      case FeedErrorType.invalidTimeRange:
        return S.of(context).validation_error_title;
      case FeedErrorType.generalError:
        return S.of(context).error;
    }
  }

  /// Her hata türü için mesaj
  String getMessage(BuildContext context) {
    switch (this) {
      case FeedErrorType.deviceNotReachable:
        return S.of(context).device_not_reachable_message;
      case FeedErrorType.timeoutError:
        return S.of(context).timeout_error_message;
      case FeedErrorType.invalidTimeRange:
        return S.of(context).invalid_time_range_message;
      case FeedErrorType.generalError:
        return S.of(context).general_error_message;
    }
  }

  /// Her hata türü için renk
  Color getColor(BuildContext context) {
    switch (this) {
      case FeedErrorType.deviceNotReachable:
        return Colors.orange;
      case FeedErrorType.timeoutError:
        return Colors.amber;
      case FeedErrorType.invalidTimeRange:
        return Colors.blue;
      case FeedErrorType.generalError:
        return Theme.of(context).colorScheme.error;
    }
  }
}
