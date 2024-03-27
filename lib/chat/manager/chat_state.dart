part of 'chat_cubit.dart';

@immutable
abstract class ChatState {}

class ChatInitial extends ChatState {}

class GetAllMessagesSuccessfully extends ChatState {}

class DeleteRecord extends ChatState {}

class ChangeIsPlaying extends ChatState {}
