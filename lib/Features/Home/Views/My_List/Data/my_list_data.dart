import 'package:uremz100/Utils/app_images.dart';
import '../Model/my_list_model.dart';

class MyListData {
  static final List<MovieItem> recentlyWatchedData = [
    MovieItem(
      id: '1',
      title: 'Spider-Man',
      subtitle: 'Hiden Identity',
      image: AppImages.move_1,
      badge: 'Exclusive',
      views: '12.1M',
    ),
    MovieItem(
      id: '2',
      title: 'Crimson Chars',
      subtitle: 'Revenge',
      image: AppImages.move_2,
      badge: 'Exclusive',
      views: '3.1M',
    ),
    MovieItem(
      id: '3',
      title: 'Glass In Cinemas',
      subtitle: 'Age Gap',
      image: AppImages.move_3,
      views: '12.1M',
    ),
  ];

  static final List<MovieItem> myCollectionData = [
    MovieItem(
      id: '4',
      title: 'Sicario',
      subtitle: 'Hiden Identity',
      image: AppImages.move_4,
      badge: 'New',
      views: '12.1M',
    ),
    MovieItem(
      id: '5',
      title: 'Crimson Chars',
      subtitle: 'Age Gap',
      image: AppImages.move_5,
      badge: 'New',
      views: '3.1M',
    ),
    MovieItem(
      id: '6',
      title: 'Spider-Man Brand',
      subtitle: 'New Day',
      image: AppImages.move_6,
      badge: 'New',
      views: '12.1M',
    ),
    MovieItem(
      id: '7',
      title: 'Crimson Chars',
      subtitle: 'Age Gap',
      image: AppImages.move_1,
      views: '12.1M',
    ),
    MovieItem(
      id: '8',
      title: 'Crimson Chars',
      subtitle: 'Age Gap',
      image: AppImages.move_2,
      views: '3.1M',
    ),
    MovieItem(
      id: '9',
      title: 'Spider-Man Brand',
      subtitle: 'New Day',
      image: AppImages.move_3,
      views: '12.1M',
    ),
    MovieItem(
      id: '10',
      title: 'Crimson Chars',
      subtitle: 'Exclusive',
      image: AppImages.move_4,
      badge: 'VIP',
      views: '3.1M',
    ),
    MovieItem(
      id: '11',
      title: 'Crimson Chars',
      subtitle: 'Revenge',
      image: AppImages.move_5,
      badge: 'VIP',
      views: '5.1M',
    ),
    MovieItem(
      id: '12',
      title: 'Mega',
      subtitle: 'New Day',
      image: AppImages.move_6,
      badge: 'VIP',
      views: '12.1M',
    ),
  ];
}
