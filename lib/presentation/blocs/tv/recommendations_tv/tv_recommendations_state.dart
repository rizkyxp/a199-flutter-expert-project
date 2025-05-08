part of 'tv_recommendations_bloc.dart';

sealed class TvRecommendationsState extends Equatable {
  const TvRecommendationsState();

  @override
  List<Object> get props => [];
}

final class TvRecommendationsEmpty extends TvRecommendationsState {}

final class TvRecommendationsLoading extends TvRecommendationsState {}

final class TvRecommendationsError extends TvRecommendationsState {
  final String message;

  const TvRecommendationsError(this.message);

  @override
  List<Object> get props => [message];
}

final class TvRecommendationsLoaded extends TvRecommendationsState {
  final List<Tv> tv;

  const TvRecommendationsLoaded(this.tv);

  @override
  List<Object> get props => [tv];
}
