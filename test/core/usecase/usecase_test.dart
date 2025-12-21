import 'package:eng_alaa_hammed/core/usecase/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class TestUseCase extends UseCase<String, int> {
  @override
  Future<String> call({int? param}) async {
    return 'Result: $param';
  }
}

void main() {
  group('UseCase', () {
    late TestUseCase useCase;

    setUp(() {
      useCase = TestUseCase();
    });

    test('should be callable with parameter', () async {
      final result = await useCase.call(param: 42);
      expect(result, 'Result: 42');
    });

    test('should handle null parameter', () async {
      final result = await useCase.call();
      expect(result, 'Result: null');
    });
  });

  group('NoParams', () {
    test('should create const instance', () {
      const noParams1 = NoParams();
      const noParams2 = NoParams();
      expect(noParams1.runtimeType, NoParams);
      expect(noParams2.runtimeType, NoParams);
    });
  });
}
