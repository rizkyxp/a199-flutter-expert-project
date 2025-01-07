import 'package:equatable/equatable.dart';

class LastEpisodeToAir extends Equatable {
  int id;
  String name;
  String overview;
  double voteAverage;
  int voteCount;
  String airDate;
  int episodeNumber;
  String productionCode;
  int runtime;
  int seasonNumber;
  int showId;
  String stillPath;

  LastEpisodeToAir({
    required this.id,
    required this.name,
    required this.overview,
    required this.voteAverage,
    required this.voteCount,
    required this.airDate,
    required this.episodeNumber,
    required this.productionCode,
    required this.runtime,
    required this.seasonNumber,
    required this.showId,
    required this.stillPath,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        overview,
        voteAverage,
        voteCount,
        airDate,
        episodeNumber,
        productionCode,
        runtime,
        seasonNumber,
        showId,
        stillPath
      ];
}
