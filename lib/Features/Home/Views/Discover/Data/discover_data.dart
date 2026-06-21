import 'package:uremz100/Utils/app_images.dart';
import '../Models/discrive_models.dart';

class DiscoverData {
  static final List<String> categories = ['Popular', 'New', 'VIP', 'Ranking'];

  static final List<DiscoverMovie> allMovies = [
    DiscoverMovie(
      id: '1',
      title: 'Spider-Man',
      subtitle: 'Hiden Identity',
      image: AppImages.move_1,
      views: '5.3M',
      categories: ['Popular', 'New'],
    ),
    DiscoverMovie(
      id: '2',
      title: 'Crimson Chars',
      subtitle: 'Revenge',
      image: AppImages.move_2,
      badge: 'Exclusive',
      views: '3.1M',
      categories: ['Popular', 'VIP'],
      isVip: true,
    ),
    DiscoverMovie(
      id: '3',
      title: 'Glass in Cinemas',
      subtitle: 'Age Gap',
      image: AppImages.move_3,
      views: '12.1M',
      categories: ['Popular', 'New'],
    ),
    DiscoverMovie(
      id: '4',
      title: 'Spider-Man Brand',
      subtitle: 'Age Gap',
      image: AppImages.move_4,
      views: '127k',
      categories: ['Popular'],
    ),
    DiscoverMovie(
      id: '5',
      title: 'Wednesday Chars',
      subtitle: 'Exclusive',
      image: AppImages.move_5,
      views: '7.1M',
      categories: ['VIP'],
      isVip: true,
    ),
    DiscoverMovie(
      id: '6',
      title: 'The Originals Most',
      subtitle: 'Popular Series',
      image: AppImages.move_1,
      views: '225k',
      badge: 'New',
      categories: ['Popular'],
    ),
    DiscoverMovie(
      id: '7',
      title: 'Game Of Thrones',
      subtitle: 'New Series',
      image: AppImages.move_2,
      badge: 'New',
      views: '11.3M',
      categories: ['Popular'],
    ),
    DiscoverMovie(
      id: '8',
      title: 'Avatar The Way Of Water',
      subtitle: 'Action',
      image: AppImages.move_3,
      views: '307k',
      categories: ['Popular'],
    ),
    DiscoverMovie(
      id: '9',
      title: 'The Expandable 3',
      subtitle: 'Sylvastar stalone',
      image: AppImages.move_4,
      views: '225k',
      categories: ['Popular'],
    ),
    DiscoverMovie(
      id: '10',
      title: 'Poeta Los Adioses',
      subtitle: 'Castellano',
      image: AppImages.move_5,
      views: '224k',
      categories: ['Popular'],
    ),
    DiscoverMovie(
      id: '11',
      title: 'Avatar The Way Of Water',
      subtitle: 'Action',
      image: AppImages.move_3,
      views: '150k',
      categories: ['Popular'],
    ),
  ];

  static final List<BonusItem> dailyBonus = [
    BonusItem(coins: 10, time: 'Day 1'),
    BonusItem(coins: 15, time: 'Day 2'),
    BonusItem(coins: 20, time: 'Day 3'),
    BonusItem(coins: 30, time: 'Day 4'),
    BonusItem(coins: 40, time: 'Day 5'),
    BonusItem(coins: 50, time: 'Day 6'),
    BonusItem(coins: 100, time: 'Day 7'),
  ];
}
