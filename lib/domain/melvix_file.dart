import 'dart:typed_data';

import 'package:equatable/equatable.dart';

class MelvixFile extends Equatable {
  final Uint8List content;
  final String name;

  const MelvixFile(this.content, this.name);

  @override
  List<Object> get props => [content, name];
}
