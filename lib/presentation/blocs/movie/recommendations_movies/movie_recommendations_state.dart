part of 'movie_recommendations_bloc.dart';

sealed class MovieRecommendationsState extends Equatable {
  const MovieRecommendationsState();

  @override
  List<Object> get props => [];
}

final class MovieRecommendationsEmpty extends MovieRecommendationsState {}

final class MovieRecommendationsLoading extends MovieRecommendationsState {}

final class MovieRecommendationsError extends MovieRecommendationsState {
  final String message;

  const MovieRecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}

class MovieRecommendationsLoaded extends MovieRecommendationsState {
  final List<Movie> movie;

  const MovieRecommendationsLoaded(this.movie);

  @override
  List<Object> get props => [movie];
}
