import 'package:uremz100/Data/Models/bulk_remove_collection_response_model.dart';
import 'package:uremz100/Data/Repositories/my_list_repository.dart';

class RemoveBulkCollectionUseCase {
  final MyListRepository _repository;

  RemoveBulkCollectionUseCase(this._repository);

  Future<BulkRemoveCollectionResponse> execute(List<String> itemIds) async {
    return await _repository.removeBulkCollection(itemIds);
  }
}
