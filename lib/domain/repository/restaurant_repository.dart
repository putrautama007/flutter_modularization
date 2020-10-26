import 'package:flutter_modularization/domain/entity/restaurant_list_entity.dart';

abstract class RestaurantRepository {
  Future<RestaurantListEntity> getListRestaurant();
}
