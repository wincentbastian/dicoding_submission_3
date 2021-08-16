import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:restaurant_app/helper/connection_repositories.dart';
import 'package:restaurant_app/models/detail_restaurant_model.dart';

part 'detail_restaurant_event.dart';
part 'detail_restaurant_state.dart';

class DetailRestaurantBloc
    extends Bloc<DetailRestaurantEvent, DetailRestaurantState> {
  DetailRestaurantBloc() : super(DetailRestaurantInitial());

  @override
  Stream<DetailRestaurantState> mapEventToState(
    DetailRestaurantEvent event,
  ) async* {
    if (event is OnGetDetailRestaurant) {
      String id = event.id;
      DetailRestaurantModel data =
          await ConnectionRepositories().getDetailRestaurant(id);
      yield OnSuccessGetDetailRestaurant(data);
    } else if (event is OnSendReview) {
      String id = event.id;
      String name = event.name;
      String review = event.review;
      await ConnectionRepositories().postReviewRestaurant(id, name, review);
      yield DetailRestaurantInitial();
    }
  }
}
