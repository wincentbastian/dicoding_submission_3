part of 'detail_restaurant_bloc.dart';

abstract class DetailRestaurantState extends Equatable {
  const DetailRestaurantState();

  @override
  List<Object> get props => [];
}

class DetailRestaurantInitial extends DetailRestaurantState {}

class OnSuccessGetDetailRestaurant extends DetailRestaurantState {
  final DetailRestaurantModel detailRestaurantModel;

  OnSuccessGetDetailRestaurant(this.detailRestaurantModel);
}

class OnSendReviewSuccess extends DetailRestaurantState {}

class OnSendReviewFailed extends DetailRestaurantState {}
