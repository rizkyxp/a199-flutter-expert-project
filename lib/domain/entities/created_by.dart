import 'package:equatable/equatable.dart';

class CreatedBy extends Equatable {
  final int id;
  final String creditId;
  final String name;
  final int gender;
  final String profilePath;

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
