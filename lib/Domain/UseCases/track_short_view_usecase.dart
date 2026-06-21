import 'package:uremz100/Data/Repositories/shorts_repository.dart';

class TrackShortViewUseCase {
  final ShortsRepository _repository;

  TrackShortViewUseCase(this._repository);

  Future<bool> execute(String shortId) async {
    return await _repository.trackView(shortId);
  }
}
