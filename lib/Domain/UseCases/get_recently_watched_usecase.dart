import 'package:uremz100/Data/Models/recently_watched_model.dart';
import 'package:uremz100/Data/Repositories/my_list_repository.dart';

class GetRecentlyWatchedUseCase {
  final MyListRepository _repository;

  GetRecentlyWatchedUseCase(this._repository);

  Future<RecentlyWatchedResponse> execute() async {
    return await _repository.getRecentlyWatched();
  }
}
