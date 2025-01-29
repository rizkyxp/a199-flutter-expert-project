import 'package:dartz/dartz.dart';
import '../../../utils/failure.dart';
import '../../entities/tv.dart';
import '../../repositories/tv_repository.dart';

class GetTvRecommendation {
  final TvRepository repository;

  GetTvRecommendation(this.repository);

  Future<Either<Failure, List<Tv>>> execute(int id) {
    return repository.getTvRecommendation(id);
  }
}
