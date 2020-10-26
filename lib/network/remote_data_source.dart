import 'package:dio/dio.dart';
import 'package:flutter_modularization/network/api_constant.dart';
import 'package:flutter_modularization/network/restaurant_list_model.dart';

abstract class RemoteDataSource {
  Future<RestaurantListModel> getRestaurantList();
}

class RemoteDataSourceImpl extends RemoteDataSource {
  Dio dio;

  RemoteDataSourceImpl({this.dio});

  @override
  Future<RestaurantListModel> getRestaurantList() async {
    try {
      Response _response = await dio.get(ApiConstant.listRestaurant);
      return RestaurantListModel.fromJson(_response.data);
    } on DioError catch (e) {
      return RestaurantListModel.fromJson(e.response.data);
    }
  }
}