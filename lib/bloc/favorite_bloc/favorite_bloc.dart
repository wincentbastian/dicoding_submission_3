import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/helper/database_helper.dart';
import 'package:restaurant_app/models/restaurant_model.dart';

part 'favorite_event.dart';
part 'favorite_state.dart';

class FavoriteBloc extends Bloc<FavoriteEvent, FavoriteState> {
  FavoriteBloc() : super(FavoriteInitial());

  @override
  Stream<FavoriteState> mapEventToState(
    FavoriteEvent event,
  ) async* {
    if (event is OnShowFavorite) {
      List<Restaurant> data = await DatabaseHelper().showFavorite();
      data.forEach((element) {});
      yield OnLoadedFavorite(data);
    } else if (event is OnDeleteFavorite) {
      String id = event.id;
      await DatabaseHelper().deleteFavorite(id);
      yield FavoriteInitial();
    }
  }
}
