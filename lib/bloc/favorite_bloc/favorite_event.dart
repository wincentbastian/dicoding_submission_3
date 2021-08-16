part of 'favorite_bloc.dart';

abstract class FavoriteEvent extends Equatable {
  const FavoriteEvent();

  @override
  List<Object> get props => [];
}

class OnShowFavorite extends FavoriteEvent {
  const OnShowFavorite();
}

class OnDeleteFavorite extends FavoriteEvent {
  final String id;
  const OnDeleteFavorite(this.id);
}
