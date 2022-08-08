import 'dart:io';
import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:netflix_gallery/domain/melvix_file.dart';

import '../service/config_service.dart';
import '../service/firestore_service.dart';
import '../service/storage_service.dart';

part 'upload_event.dart';
part 'upload_state.dart';

class UploadBloc extends Bloc<UploadEvent, UploadState> {
  final StorageService storageService;
  final FirestoreService firestoreService;
  final ConfigService configService;

  UploadBloc(this.storageService, this.firestoreService, this.configService)
      : super(UploadInitial()) {
    on<UploadEvent>((event, emit) {});
    on<UploadQuickContentEvent>((event, emit) async {
      var files = await selectFiles();
      for (var element in files) {
        try {
          await storageService.uploadQuickContent(
              element, configService.getQuickContentRef().storagePath);
          emit(QuickContentUploadedSuccess(element.name));
        } on StorageUploadError {
          emit(QuickContentUploadedFailure(element.name));
        }
      }
    });
  }

  Future<List<MelvixFile>> selectFiles() async {
    FilePickerResult? result = await FilePicker.platform.pickFiles();

    if (result != null) {
      return result.files
          .where((e) => e.bytes != null)
          .map((e) => MelvixFile(e.bytes!, e.name))
          .toList();
    }

    return List.empty();
  }
}
