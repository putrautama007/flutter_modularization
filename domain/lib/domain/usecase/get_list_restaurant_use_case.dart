import 'package:flutter/foundation.dart';

import '../entity/restaurant_list_entity.dart';
import '../repository/restaurant_repository.dart';

abstract class GetListRestaurantUseCase {
  Future<RestaurantListEntity> getListRestaurant();
}

class GetListRestaurantUseCaseImpl extends GetListRestaurantUseCase {
  RestaurantRepository restaurantRepository;

  GetListRestaurantUseCaseImpl({@required this.restaurantRepository});

  @override
  Future<RestaurantListEntity> getListRestaurant() =>
      restaurantRepository.getListRestaurant();
}