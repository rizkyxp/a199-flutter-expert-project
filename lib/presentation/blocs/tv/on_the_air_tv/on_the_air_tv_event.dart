part of 'on_the_air_tv_bloc.dart';

sealed class OnTheAirTvEvent extends Equatable {
  const OnTheAirTvEvent();

  @override
  List<Object> get props => [];
}

class FetchOnTheAirTv extends OnTheAirTvEvent {}
