part of 'home_cubit.dart';

@immutable
abstract class HomeState {}

class HomeInitial extends HomeState {}
class GetUsers extends HomeState {}
class ChangeName extends HomeState {}
class ChangePhone extends HomeState {}
class GetMYData extends HomeState {}
class ChangeImage extends HomeState {}
class GetAllUsersSuccessfully extends HomeState {}
