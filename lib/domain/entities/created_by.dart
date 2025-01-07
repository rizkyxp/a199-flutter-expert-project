import 'package:equatable/equatable.dart';

class CreatedBy extends Equatable {
  int id;
  String creditId;
  String name;
  int gender;
  String profilePath;

  CreatedBy({
    required this.id,
    required this.creditId,
    required this.name,
    required this.gender,
    required this.profilePath,
  });

  @override
  List<Object?> get props => [id, creditId, name, gender, profilePath];
}
