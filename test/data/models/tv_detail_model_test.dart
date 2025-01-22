import 'package:ditonton/data/models/tv_detail_model.dart';
import 'package:ditonton/domain/entities/tv_detail.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  final tTvDetailModel = TvDetailResponse(
    adult: false,
    backdropPath: 'backdropPath',
    episodeRunTime: [],
    firstAirDate: 'firstAirDate',
    genres: [],
    homepage: 'homepage',
    id: 1,
    inProduction: false,
    languages: [],
    lastAirDate: 'lastAirDate',
    name: 'name',
    nextEpisodeToAir: 'nextEpisodeToAir',
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
    originCountry: [],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    status: 'status',
    tagline: 'tagline',
    type: 'type',
    voteAverage: 1,
    voteCount: 1,
  );

  final tTvDeatil = TvDetail(
    adult: false,
    backdropPath: 'backdropPath',
    episodeRunTime: [],
    firstAirDate: 'firstAirDate',
    genres: [],
    homepage: 'homepage',
    id: 1,
    inProduction: false,
    languages: [],
    lastAirDate: 'lastAirDate',
    name: 'name',
    nextEpisodeToAir: 'nextEpisodeToAir',
    numberOfEpisodes: 1,
    numberOfSeasons: 1,
    originCountry: [],
    originalLanguage: 'originalLanguage',
    originalName: 'originalName',
    overview: 'overview',
    popularity: 1,
    posterPath: 'posterPath',
    status: 'status',
    tagline: 'tagline',
    type: 'type',
    voteAverage: 1,
    voteCount: 1,
  );

  test('should be a subclass of TvDetail entity', () async {
    final result = tTvDetailModel.toEntity();
    expect(result, tTvDeatil);
  });
}
