import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:palette_generator/palette_generator.dart';

class ColorGeneratorCubit extends Cubit<Color> {
  ColorGeneratorCubit() : super(Colors.white);

  Future generateFromImage(Image image) async =>
      emit(await generateFromImage(image));

  Future<Color> generateColorFromImage(Image image) async {
    var paletteGenerator =
        await PaletteGenerator.fromImageProvider(image.image);

    var color = paletteGenerator.dominantColor?.color;

    return color ?? Colors.white;
  }
}
