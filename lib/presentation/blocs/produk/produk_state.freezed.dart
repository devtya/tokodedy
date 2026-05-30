// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'produk_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ProdukState {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProdukState);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProdukState()';
}


}

/// @nodoc
class $ProdukStateCopyWith<$Res>  {
$ProdukStateCopyWith(ProdukState _, $Res Function(ProdukState) __);
}


/// Adds pattern-matching-related methods to [ProdukState].
extension ProdukStatePatterns on ProdukState {
/// A variant of `map` that fallback to returning `orElse`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( _Initial value)?  initial,TResult Function( _Loading value)?  loading,TResult Function( _Loaded value)?  loaded,TResult Function( _Error value)?  error,TResult Function( _OperationSuccess value)?  operationSuccess,required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _OperationSuccess() when operationSuccess != null:
return operationSuccess(_that);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// Callbacks receives the raw object, upcasted.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case final Subclass2 value:
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( _Initial value)  initial,required TResult Function( _Loading value)  loading,required TResult Function( _Loaded value)  loaded,required TResult Function( _Error value)  error,required TResult Function( _OperationSuccess value)  operationSuccess,}){
final _that = this;
switch (_that) {
case _Initial():
return initial(_that);case _Loading():
return loading(_that);case _Loaded():
return loaded(_that);case _Error():
return error(_that);case _OperationSuccess():
return operationSuccess(_that);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `map` that fallback to returning `null`.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case final Subclass value:
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( _Initial value)?  initial,TResult? Function( _Loading value)?  loading,TResult? Function( _Loaded value)?  loaded,TResult? Function( _Error value)?  error,TResult? Function( _OperationSuccess value)?  operationSuccess,}){
final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial(_that);case _Loading() when loading != null:
return loading(_that);case _Loaded() when loaded != null:
return loaded(_that);case _Error() when error != null:
return error(_that);case _OperationSuccess() when operationSuccess != null:
return operationSuccess(_that);case _:
  return null;

}
}
/// A variant of `when` that fallback to an `orElse` callback.
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return orElse();
/// }
/// ```

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function()?  initial,TResult Function()?  loading,TResult Function( List<Produk> produkList,  String? searchQuery)?  loaded,TResult Function( String message)?  error,TResult Function( String message,  String? newId)?  operationSuccess,required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.produkList,_that.searchQuery);case _Error() when error != null:
return error(_that.message);case _OperationSuccess() when operationSuccess != null:
return operationSuccess(_that.message,_that.newId);case _:
  return orElse();

}
}
/// A `switch`-like method, using callbacks.
///
/// As opposed to `map`, this offers destructuring.
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case Subclass2(:final field2):
///     return ...;
/// }
/// ```

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function()  initial,required TResult Function()  loading,required TResult Function( List<Produk> produkList,  String? searchQuery)  loaded,required TResult Function( String message)  error,required TResult Function( String message,  String? newId)  operationSuccess,}) {final _that = this;
switch (_that) {
case _Initial():
return initial();case _Loading():
return loading();case _Loaded():
return loaded(_that.produkList,_that.searchQuery);case _Error():
return error(_that.message);case _OperationSuccess():
return operationSuccess(_that.message,_that.newId);case _:
  throw StateError('Unexpected subclass');

}
}
/// A variant of `when` that fallback to returning `null`
///
/// It is equivalent to doing:
/// ```dart
/// switch (sealedClass) {
///   case Subclass(:final field):
///     return ...;
///   case _:
///     return null;
/// }
/// ```

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function()?  initial,TResult? Function()?  loading,TResult? Function( List<Produk> produkList,  String? searchQuery)?  loaded,TResult? Function( String message)?  error,TResult? Function( String message,  String? newId)?  operationSuccess,}) {final _that = this;
switch (_that) {
case _Initial() when initial != null:
return initial();case _Loading() when loading != null:
return loading();case _Loaded() when loaded != null:
return loaded(_that.produkList,_that.searchQuery);case _Error() when error != null:
return error(_that.message);case _OperationSuccess() when operationSuccess != null:
return operationSuccess(_that.message,_that.newId);case _:
  return null;

}
}

}

/// @nodoc


class _Initial implements ProdukState {
  const _Initial();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Initial);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProdukState.initial()';
}


}




/// @nodoc


class _Loading implements ProdukState {
  const _Loading();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loading);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ProdukState.loading()';
}


}




/// @nodoc


class _Loaded implements ProdukState {
  const _Loaded(final  List<Produk> produkList, {this.searchQuery}): _produkList = produkList;
  

 final  List<Produk> _produkList;
 List<Produk> get produkList {
  if (_produkList is EqualUnmodifiableListView) return _produkList;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_produkList);
}

 final  String? searchQuery;

/// Create a copy of ProdukState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LoadedCopyWith<_Loaded> get copyWith => __$LoadedCopyWithImpl<_Loaded>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Loaded&&const DeepCollectionEquality().equals(other._produkList, _produkList)&&(identical(other.searchQuery, searchQuery) || other.searchQuery == searchQuery));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(_produkList),searchQuery);

@override
String toString() {
  return 'ProdukState.loaded(produkList: $produkList, searchQuery: $searchQuery)';
}


}

/// @nodoc
abstract mixin class _$LoadedCopyWith<$Res> implements $ProdukStateCopyWith<$Res> {
  factory _$LoadedCopyWith(_Loaded value, $Res Function(_Loaded) _then) = __$LoadedCopyWithImpl;
@useResult
$Res call({
 List<Produk> produkList, String? searchQuery
});




}
/// @nodoc
class __$LoadedCopyWithImpl<$Res>
    implements _$LoadedCopyWith<$Res> {
  __$LoadedCopyWithImpl(this._self, this._then);

  final _Loaded _self;
  final $Res Function(_Loaded) _then;

/// Create a copy of ProdukState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? produkList = null,Object? searchQuery = freezed,}) {
  return _then(_Loaded(
null == produkList ? _self._produkList : produkList // ignore: cast_nullable_to_non_nullable
as List<Produk>,searchQuery: freezed == searchQuery ? _self.searchQuery : searchQuery // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

/// @nodoc


class _Error implements ProdukState {
  const _Error(this.message);
  

 final  String message;

/// Create a copy of ProdukState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ErrorCopyWith<_Error> get copyWith => __$ErrorCopyWithImpl<_Error>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _Error&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'ProdukState.error(message: $message)';
}


}

/// @nodoc
abstract mixin class _$ErrorCopyWith<$Res> implements $ProdukStateCopyWith<$Res> {
  factory _$ErrorCopyWith(_Error value, $Res Function(_Error) _then) = __$ErrorCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class __$ErrorCopyWithImpl<$Res>
    implements _$ErrorCopyWith<$Res> {
  __$ErrorCopyWithImpl(this._self, this._then);

  final _Error _self;
  final $Res Function(_Error) _then;

/// Create a copy of ProdukState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(_Error(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class _OperationSuccess implements ProdukState {
  const _OperationSuccess(this.message, {this.newId});
  

 final  String message;
 final  String? newId;

/// Create a copy of ProdukState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OperationSuccessCopyWith<_OperationSuccess> get copyWith => __$OperationSuccessCopyWithImpl<_OperationSuccess>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _OperationSuccess&&(identical(other.message, message) || other.message == message)&&(identical(other.newId, newId) || other.newId == newId));
}


@override
int get hashCode => Object.hash(runtimeType,message,newId);

@override
String toString() {
  return 'ProdukState.operationSuccess(message: $message, newId: $newId)';
}


}

/// @nodoc
abstract mixin class _$OperationSuccessCopyWith<$Res> implements $ProdukStateCopyWith<$Res> {
  factory _$OperationSuccessCopyWith(_OperationSuccess value, $Res Function(_OperationSuccess) _then) = __$OperationSuccessCopyWithImpl;
@useResult
$Res call({
 String message, String? newId
});




}
/// @nodoc
class __$OperationSuccessCopyWithImpl<$Res>
    implements _$OperationSuccessCopyWith<$Res> {
  __$OperationSuccessCopyWithImpl(this._self, this._then);

  final _OperationSuccess _self;
  final $Res Function(_OperationSuccess) _then;

/// Create a copy of ProdukState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,Object? newId = freezed,}) {
  return _then(_OperationSuccess(
null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,newId: freezed == newId ? _self.newId : newId // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
