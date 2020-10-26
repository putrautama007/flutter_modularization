import 'package:dio/dio.dart';

import '../model/api_constant.dart';
import '../model/restaurant_list_model.dart';

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