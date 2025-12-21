import 'package:eng_alaa_hammed/core/usecase/usecase.dart';
import 'package:flutter_test/flutter_test.dart';

class TestUseCase extends UseCase<String, int> {
  @override
  Future<String> call({int? param}) async {
    return 'Result: $param';
  }
}

class TestUseCaseWithNoParams extends UseCase<String, NoParams> {
  @override
  Future<String> call({NoParams? param}) async {
    return 'No params result';
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

    test('should be callable using call syntax', () async {
      final result = await useCase(param: 100);
      expect(result, 'Result: 100');
    });
  });

  group('UseCase with NoParams', () {
    late TestUseCaseWithNoParams useCase;

    setUp(() {
      useCase = TestUseCaseWithNoParams();
    });

    test('should work with NoParams', () async {
      final result = await useCase(param: const NoParams());
      expect(result, 'No params result');
    });

    test('should work without passing param', () async {
      final result = await useCase();
      expect(result, 'No params result');
    });
  });

  group('NoParams', () {
    test('should create const instance', () {
      const noParams1 = NoParams();
      const noParams2 = NoParams();
      expect(noParams1.runtimeType, NoParams);
      expect(noParams2.runtimeType, NoParams);
    });

    test('const instances should be identical', () {
      const noParams1 = NoParams();
      const noParams2 = NoParams();
      expect(identical(noParams1, noParams2), true);
    });
  });
}
