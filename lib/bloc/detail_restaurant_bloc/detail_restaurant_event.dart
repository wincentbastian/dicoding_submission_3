part of 'detail_restaurant_bloc.dart';

abstract class DetailRestaurantEvent extends Equatable {
  const DetailRestaurantEvent();

  @override
  List<Object> get props => [];
}

class OnGetDetailRestaurant extends DetailRestaurantEvent {
  final String id;

  const OnGetDetailRestaurant(this.id);
}

class OnSendReview extends DetailRestaurantEvent {
  final String id;
  final String name;
  final String review;

  const OnSendReview(this.id, this.name, this.review);
}
