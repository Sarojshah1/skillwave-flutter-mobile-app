import 'dart:async';

import 'package:skillwave/cores/failure/failure.dart';

class SkillWaveResponse<T> {
  final T? value;
  final Failure? failure;

  SkillWaveResponse.success(this.value) : failure = null;
  SkillWaveResponse.failure(this.failure) : value = null;

  bool get isSuccess => failure == null;

  R fold<R>(R Function(Failure failure) onFailure, R Function(T? value) onSuccess) {
    return failure != null ? onFailure(failure!) : onSuccess(value);
  }

  Future<R> foldAsync<R>(
      FutureOr<R> Function(Failure failure) onFailure,
      FutureOr<R> Function(T? value) onSuccess,
      ) async {
    if (failure != null) return await onFailure(failure!);
    return await onSuccess(value);
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'SkillWaveResponse.success(value: $value)';
    } else {
      return 'SkillWaveResponse.failure(failure: $failure)';
    }
  }
}
