import 'package:equatable/equatable.dart';

class SpokenLanguage extends Equatable {
  String englishName;
  String iso6391;
  String name;

  SpokenLanguage({
    required this.englishName,
    required this.iso6391,
    required this.name,
  });

  @override
  List<Object?> get props => [
        englishName,
        iso6391,
        name,
      ];
}
