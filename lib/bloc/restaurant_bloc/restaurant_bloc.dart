import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';
import 'package:restaurant_app/helper/connection_repositories.dart';
import 'package:restaurant_app/helper/database_helper.dart';
import 'package:restaurant_app/models/restaurant_model.dart';
import 'package:restaurant_app/models/search_restaurant_model.dart';

part 'restaurant_event.dart';
part 'restaurant_state.dart';

class RestaurantBloc extends Bloc<RestaurantEvent, RestaurantState> {
  RestaurantBloc() : super(RestaurantInitial());

  @override
  Stream<RestaurantState> mapEventToState(
    RestaurantEvent event,
  ) async* {
    if (event is OnGetListRestaurant) {
      yield OnLoadingGetData();
      RestaurantModel data = await ConnectionRepositories().getListRestaurant();
      var listRestaurant = [];
      data.restaurants.forEach((element) {
        listRestaurant.add(element);
      });
      yield OnSuccessGetData(listRestaurant);
    } else if (event is OnSearchRestaurant) {
      String searchValue = event.searchValue;
      var result = [];
      SearchRestaurantModel data =
          await ConnectionRepositories().getSearchRestaurant(searchValue);
      data.restaurants.forEach((element) {
        result.add(element);
      });
      yield OnSearchResultSuccess(result);
    } else if (event is OnAddFavorite) {
      await DatabaseHelper().addFavorite(event.restaurant);
    }
  }
}
