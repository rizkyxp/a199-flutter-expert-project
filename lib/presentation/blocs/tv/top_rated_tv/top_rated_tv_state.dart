part of 'top_rated_tv_bloc.dart';

sealed class TopRatedTvState extends Equatable {
  const TopRatedTvState();

  @override
  List<Object> get props => [];
}

final class TopRatedTvEmpty extends TopRatedTvState {}

final class TopRatedTvLoading extends TopRatedTvState {}

final class TopRatedTvError extends TopRatedTvState {
  final String message;

  const TopRatedTvError(this.message);

  @override
  List<Object> get props => [message];
}

final class TopRatedTvLoaded extends TopRatedTvState {
  final List<Tv> tv;

  const TopRatedTvLoaded(this.tv);

  @override
  List<Object> get props => [tv];
}
