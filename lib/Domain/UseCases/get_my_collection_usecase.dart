import 'package:uremz100/Data/Models/my_collection_model.dart';
import 'package:uremz100/Data/Repositories/my_list_repository.dart';

class GetMyCollectionUseCase {
  final MyListRepository _repository;

  GetMyCollectionUseCase(this._repository);

  Future<MyCollectionResponse> execute({
    required int page,
    int limit = 10,
  }) async {
    return await _repository.getMyCollection(page: page, limit: limit);
  }
}
