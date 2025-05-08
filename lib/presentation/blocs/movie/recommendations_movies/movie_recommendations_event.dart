part of 'movie_recommendations_bloc.dart';

sealed class MovieRecommendationsEvent extends Equatable {
  const MovieRecommendationsEvent();

  @override
  List<Object> get props => [];
}

class FetchMovieRecommendations extends MovieRecommendationsEvent {
  final int id;

  const FetchMovieRecommendations(this.id);

  @override
  List<Object> get props => [id];
}
