import 'package:uremz100/Data/Repositories/shorts_repository.dart';

class AddToCollectionUseCase {
  final ShortsRepository _repository;

  AddToCollectionUseCase(this._repository);

  Future<bool> execute(String itemId) async {
    return await _repository.addToCollection(itemId);
  }
}
