import 'package:flutter/foundation.dart';
import 'package:flutter_modularization/data/datasource/remote_data_source.dart';
import 'package:flutter_modularization/data/model/api_constant.dart';
import 'package:flutter_modularization/domain/entity/restaurant_list_entity.dart';
import 'package:flutter_modularization/domain/repository/restaurant_repository.dart';

class RestaurantRepositoryIml extends RestaurantRepository {
  RemoteDataSource remoteDataSource;

  RestaurantRepositoryIml({@required this.remoteDataSource});

  @override
  Future<RestaurantListEntity> getListRestaurant() async {
    List<RestaurantEntity> listRestaurant = List<RestaurantEntity>();
    var restaurantData = await remoteDataSource.getRestaurantList();
    restaurantData.restaurants.forEach((restaurant) {
      var restaurantEntity = RestaurantEntity(
          id: restaurant.id,
          name: restaurant.name,
          description: restaurant.description,
          pictureId:
              "${ApiConstant.smallImageResolution}${restaurant.pictureId}",
          city: restaurant.city,
          rating: restaurant.rating.toString());
      listRestaurant.add(restaurantEntity);
    });

    var restaurantListEntity = RestaurantListEntity(
      error: restaurantData.error,
      message: restaurantData.message ?? "",
      restaurants: listRestaurant,
    );

    return restaurantListEntity;
  }
}
