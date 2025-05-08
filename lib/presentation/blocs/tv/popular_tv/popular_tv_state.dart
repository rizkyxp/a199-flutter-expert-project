part of 'popular_tv_bloc.dart';

sealed class PopularTvState extends Equatable {
  const PopularTvState();

  @override
  List<Object> get props => [];
}

final class PopularTvEmpty extends PopularTvState {}

final class PopularTvLoading extends PopularTvState {}

final class PopularTvError extends PopularTvState {
  final String message;

  const PopularTvError(this.message);

  @override
  List<Object> get props => [message];
}

final class PopularTvLoaded extends PopularTvState {
  final List<Tv> tv;

  const PopularTvLoaded(this.tv);

  @override
  List<Object> get props => [tv];
}
