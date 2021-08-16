part of 'restaurant_bloc.dart';

@immutable
abstract class RestaurantState {}

class RestaurantInitial extends RestaurantState {}

class OnLoadingGetData extends RestaurantState {}

class OnSuccessGetData extends RestaurantState {
  final List<dynamic> listRestaurant;

  OnSuccessGetData(this.listRestaurant);
}

class OnSearchResultSuccess extends RestaurantState {
  final List<dynamic> listRestaurant;

  OnSearchResultSuccess(this.listRestaurant);
}

class OnSearchResultNull extends RestaurantState {}
