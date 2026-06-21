import 'package:uremz100/Data/Models/search_response_model.dart';
import 'package:uremz100/Data/Repositories/search_repository.dart';
import 'package:uremz100/core/network/api_response.dart';

class SearchContentUseCase {
  final SearchRepository _repository;

  SearchContentUseCase(this._repository);

  Future<ApiResponse<SearchResponseModel>> execute(String searchTerm) async {
    return await _repository.searchContents(searchTerm);
  }
}
