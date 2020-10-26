import 'package:equatable/equatable.dart';

abstract class GetListRestaurantEvent extends Equatable {
  const GetListRestaurantEvent();
}

class GetListRestaurant extends GetListRestaurantEvent {
  @override
  List<Object> get props => [];
}