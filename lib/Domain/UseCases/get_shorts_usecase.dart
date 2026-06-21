import 'package:uremz100/Data/Models/shorts_response_model.dart';
import 'package:uremz100/Data/Repositories/shorts_repository.dart';

class GetShortsUseCase {
  final ShortsRepository _repository;

  GetShortsUseCase(this._repository);

  Future<ShortsResponse> execute({int limit = 5, String? cursor}) async {
    return await _repository.getShorts(limit: limit, cursor: cursor);
  }
}
