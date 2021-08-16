part of 'favorite_bloc.dart';

abstract class FavoriteState extends Equatable {
  const FavoriteState();

  @override
  List<Object> get props => [];
}

class FavoriteInitial extends FavoriteState {}

class OnLoadedFavorite extends FavoriteState {
  final List<Restaurant> restaurantList;

  OnLoadedFavorite(this.restaurantList);
}
