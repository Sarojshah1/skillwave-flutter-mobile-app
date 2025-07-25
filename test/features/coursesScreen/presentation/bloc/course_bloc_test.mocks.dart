// Mocks generated by Mockito 5.4.6 from annotations
// in skillwave/test/features/coursesScreen/presentation/bloc/course_bloc_test.dart.
// Do not manually edit this file.

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'dart:async' as _i5;

import 'package:mockito/mockito.dart' as _i1;
import 'package:skillwave/cores/network/models/skillwave_response.dart' as _i3;
import 'package:skillwave/features/coursesScreen/domain/entity/course_entity.dart'
    as _i6;
import 'package:skillwave/features/coursesScreen/domain/repository/course_repository.dart'
    as _i2;
import 'package:skillwave/features/coursesScreen/domain/usecase/create_payment_usecase.dart'
    as _i8;
import 'package:skillwave/features/coursesScreen/domain/usecase/get_course_by_id_usecase.dart'
    as _i7;
import 'package:skillwave/features/coursesScreen/domain/usecase/get_courses_usecase.dart'
    as _i4;

// ignore_for_file: type=lint
// ignore_for_file: avoid_redundant_argument_values
// ignore_for_file: avoid_setters_without_getters
// ignore_for_file: comment_references
// ignore_for_file: deprecated_member_use
// ignore_for_file: deprecated_member_use_from_same_package
// ignore_for_file: implementation_imports
// ignore_for_file: invalid_use_of_visible_for_testing_member
// ignore_for_file: must_be_immutable
// ignore_for_file: prefer_const_constructors
// ignore_for_file: unnecessary_parenthesis
// ignore_for_file: camel_case_types
// ignore_for_file: subtype_of_sealed_class

class _FakeCourseRepository_0 extends _i1.SmartFake
    implements _i2.CourseRepository {
  _FakeCourseRepository_0(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

class _FakeSkillWaveResponse_1<T> extends _i1.SmartFake
    implements _i3.SkillWaveResponse<T> {
  _FakeSkillWaveResponse_1(Object parent, Invocation parentInvocation)
    : super(parent, parentInvocation);
}

/// A class which mocks [GetCoursesUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetCoursesUseCase extends _i1.Mock implements _i4.GetCoursesUseCase {
  MockGetCoursesUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.CourseRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeCourseRepository_0(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i2.CourseRepository);

  @override
  _i5.Future<_i3.SkillWaveResponse<List<_i6.CourseEntity>>> call({
    required int? page,
    required int? limit,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#call, [], {#page: page, #limit: limit}),
            returnValue:
                _i5.Future<_i3.SkillWaveResponse<List<_i6.CourseEntity>>>.value(
                  _FakeSkillWaveResponse_1<List<_i6.CourseEntity>>(
                    this,
                    Invocation.method(#call, [], {#page: page, #limit: limit}),
                  ),
                ),
          )
          as _i5.Future<_i3.SkillWaveResponse<List<_i6.CourseEntity>>>);
}

/// A class which mocks [GetCourseByIdUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockGetCourseByIdUseCase extends _i1.Mock
    implements _i7.GetCourseByIdUseCase {
  MockGetCourseByIdUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.CourseRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeCourseRepository_0(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i2.CourseRepository);

  @override
  _i5.Future<_i3.SkillWaveResponse<_i6.CourseEntity>> call(String? courseId) =>
      (super.noSuchMethod(
            Invocation.method(#call, [courseId]),
            returnValue:
                _i5.Future<_i3.SkillWaveResponse<_i6.CourseEntity>>.value(
                  _FakeSkillWaveResponse_1<_i6.CourseEntity>(
                    this,
                    Invocation.method(#call, [courseId]),
                  ),
                ),
          )
          as _i5.Future<_i3.SkillWaveResponse<_i6.CourseEntity>>);
}

/// A class which mocks [CreatePaymentUseCase].
///
/// See the documentation for Mockito's code generation for more information.
class MockCreatePaymentUseCase extends _i1.Mock
    implements _i8.CreatePaymentUseCase {
  MockCreatePaymentUseCase() {
    _i1.throwOnMissingStub(this);
  }

  @override
  _i2.CourseRepository get repository =>
      (super.noSuchMethod(
            Invocation.getter(#repository),
            returnValue: _FakeCourseRepository_0(
              this,
              Invocation.getter(#repository),
            ),
          )
          as _i2.CourseRepository);

  @override
  _i5.Future<_i3.SkillWaveResponse<bool>> call({
    required String? courseId,
    required int? amount,
    required String? paymentMethod,
    required String? status,
  }) =>
      (super.noSuchMethod(
            Invocation.method(#call, [], {
              #courseId: courseId,
              #amount: amount,
              #paymentMethod: paymentMethod,
              #status: status,
            }),
            returnValue: _i5.Future<_i3.SkillWaveResponse<bool>>.value(
              _FakeSkillWaveResponse_1<bool>(
                this,
                Invocation.method(#call, [], {
                  #courseId: courseId,
                  #amount: amount,
                  #paymentMethod: paymentMethod,
                  #status: status,
                }),
              ),
            ),
          )
          as _i5.Future<_i3.SkillWaveResponse<bool>>);
}
