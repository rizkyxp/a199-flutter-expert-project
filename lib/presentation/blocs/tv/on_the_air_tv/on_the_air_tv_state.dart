part of 'on_the_air_tv_bloc.dart';

sealed class OnTheAirTvState extends Equatable {
  const OnTheAirTvState();

  @override
  List<Object> get props => [];
}

final class OnTheAirTvEmpty extends OnTheAirTvState {}

final class OnTheAirTvLoading extends OnTheAirTvState {}

final class OnTheAirTvError extends OnTheAirTvState {
  final String message;

  const OnTheAirTvError(this.message);

  @override
  List<Object> get props => [message];
}

final class OnTheAirTvLoaded extends OnTheAirTvState {
  final List<Tv> tv;

  const OnTheAirTvLoaded(this.tv);

  @override
  List<Object> get props => [tv];
}
