part of 'upload_bloc.dart';

abstract class UploadState extends Equatable {
  const UploadState();

  @override
  List<Object> get props => [];
}

class UploadInitial extends UploadState {}

class QuickContentUploadedSuccess extends UploadState {
  final String filename;

  const QuickContentUploadedSuccess(this.filename);

  @override
  List<Object> get props => [filename];
}

class QuickContentUploadedFailure extends UploadState {
  final String filename;

  const QuickContentUploadedFailure(this.filename);

  @override
  List<Object> get props => [filename];
}
