part of 'user_cubit.dart';

@immutable
abstract class UserState {}

class UserInitial extends UserState {}

class UserNull extends UserState {}

class UserLoading extends UserState {}

class UserError extends UserState {}

class UserFull extends UserState {
  MyUser user;
  UserFull({
    required this.user,
  });
}
