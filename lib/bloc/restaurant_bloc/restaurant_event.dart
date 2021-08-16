part of 'restaurant_bloc.dart';

@immutable
abstract class RestaurantEvent extends Equatable {
  const RestaurantEvent();

  @override
  List<Object> get props => [];
}

class OnGetListRestaurant extends RestaurantEvent {
  const OnGetListRestaurant();
}

class OnLoadPage extends RestaurantEvent {
  const OnLoadPage();
}

class OnSearchRestaurant extends RestaurantEvent {
  final String searchValue;
  const OnSearchRestaurant(this.searchValue);
}

class OnAddFavorite extends RestaurantEvent {
  final dynamic restaurant;

  OnAddFavorite(this.restaurant);
}
