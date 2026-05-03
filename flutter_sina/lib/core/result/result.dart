/// Result wrapper for handling success and failure states
/// Provides a cleaner way to handle async operations
abstract class Result<T> {
  /// Constructor
  const Result();

  /// Check if result is success
  bool get isSuccess => this is Success<T>;

  /// Check if result is error
  bool get isError => this is Error<T>;

  /// Get the data (throws if error)
  T get data {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    throw Exception('Cannot get data from error result');
  }

  /// Get the error (throws if success)
  Exception get error {
    if (this is Error<T>) {
      return (this as Error<T>).exception;
    }
    throw Exception('Cannot get error from success result');
  }

  /// Map result to another type
  Result<R> map<R>(R Function(T data) mapper) {
    if (this is Success<T>) {
      try {
        final R mappedData = mapper((this as Success<T>).data);
        return Success<R>(mappedData);
      } catch (e) {
        return Error<R>(Exception('Mapping failed: $e'));
      }
    }
    return Error<R>((this as Error<T>).exception);
  }

  /// Flat map result (for chaining operations)
  Future<Result<R>> flatMapAsync<R>(
    Future<Result<R>> Function(T data) mapper,
  ) async {
    if (this is Success<T>) {
      return mapper((this as Success<T>).data);
    }
    return Error<R>((this as Error<T>).exception);
  }

  /// Execute callback on success
  Result<T> onSuccess(void Function(T data) callback) {
    if (this is Success<T>) {
      callback((this as Success<T>).data);
    }
    return this;
  }

  /// Execute callback on error
  Result<T> onError(void Function(Exception error) callback) {
    if (this is Error<T>) {
      callback((this as Error<T>).exception);
    }
    return this;
  }

  /// Get data or default value
  T getOrElse(T Function(Exception error) defaultValue) {
    if (this is Success<T>) {
      return (this as Success<T>).data;
    }
    return defaultValue((this as Error<T>).exception);
  }
}

/// Success result wrapper
class Success<T> extends Result<T> {
  /// The successful data
  @override
  final T data;

  /// Constructor
  const Success(this.data);

  @override
  String toString() => 'Success(data: $data)';
}

/// Error result wrapper
class Error<T> extends Result<T> {
  /// The exception that occurred
  final Exception exception;

  /// Constructor
  const Error(this.exception);

  @override
  String toString() => 'Error(exception: $exception)';
}

/// Extension for easier Result creation
extension ResultExtension<T> on T {
  /// Wrap value in success result
  Result<T> toSuccess() => Success<T>(this);

  /// Wrap exception in error result
  Result<T> toError() => Error<T>(this as Exception);
}

