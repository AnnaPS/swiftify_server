// ignore_for_file: prefer_const_constructors

import 'package:api_client/api_client.dart';
import 'package:test/test.dart';

void main() {
  group('Api Exceptions', () {
    group('InternalServerErrorException', () {
      test('toString', () {
        final exception = Exception();
        expect(
          InternalServerErrorException(exception).toString(),
          equals('[InternalServerErrorException] $exception'),
        );
      });
    });
    group('UnauthorizedException', () {
      test('toString', () {
        final exception = Exception();
        expect(
          UnauthorizedException(exception).toString(),
          equals('[UnauthorizedException] $exception'),
        );
      });
    });

    group('BadRequestException', () {
      test('toString', () {
        final exception = Exception();
        expect(
          BadRequestException(exception).toString(),
          equals('[BadRequestException] $exception'),
        );
      });
    });

    group('NetworkException', () {
      test('toString', () {
        final exception = Exception();
        expect(
          NetworkException(exception).toString(),
          equals('[NetworkException] $exception'),
        );
      });
    });

    group('ForbiddenException', () {
      test('toString', () {
        final exception = Exception();
        expect(
          ForbiddenException(exception).toString(),
          equals('[ForbiddenException] $exception'),
        );
      });
    });

    group('NotFoundException', () {
      test('toString', () {
        final exception = Exception();
        expect(
          NotFoundException(exception).toString(),
          equals('[NotFoundException] $exception'),
        );
      });
    });

    group('DeserializationException', () {
      test('emptyResponseBody', () {
        expect(
          DeserializationException.emptyResponseBody().toString(),
          equals('[DeserializationException] Empty response body'),
        );
      });
    });
  });
}
