import '../../../utils/state_enum.dart';
import '../../../domain/entities/tv.dart';
import '../../../domain/usecases/tv/get_on_the_air_tv.dart';
import 'package:flutter/material.dart';

class OnTheAirTvNotifier extends ChangeNotifier {
  final GetOnTheAirTv getOnTheAirTv;

  OnTheAirTvNotifier({required this.getOnTheAirTv});

  RequestState _state = RequestState.empty;
  RequestState get state => _state;

  List<Tv> _listTv = [];
  List<Tv> get listTv => _listTv;

  String _message = '';
  String get message => _message;

  Future<void> fetchOnTheAirTv() async {
    _state = RequestState.loading;
    notifyListeners();

    final result = await getOnTheAirTv.execute();
    result.fold(
      (failure) {
        _message = failure.message;
        _state = RequestState.error;
        notifyListeners();
      },
      (tvData) {
        _state = RequestState.loaded;
        _listTv = tvData;
        notifyListeners();
      },
    );
  }
}
