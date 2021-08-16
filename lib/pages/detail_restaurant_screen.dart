import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/bloc/detail_restaurant_bloc/detail_restaurant_bloc.dart';
import 'package:restaurant_app/models/detail_restaurant_model.dart';

class DetailRestaurantScreen extends StatefulWidget {
  const DetailRestaurantScreen({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;

  @override
  _DetailRestaurantScreenState createState() => _DetailRestaurantScreenState();
}

class _DetailRestaurantScreenState extends State<DetailRestaurantScreen> {
  DetailRestaurantBloc detailRestaurantBloc = DetailRestaurantBloc();
  TextEditingController _nameController = TextEditingController();
  TextEditingController _reviewController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder(
        bloc: detailRestaurantBloc,
        builder: (context, state) {
          if (state is DetailRestaurantInitial) {
            detailRestaurantBloc.add(OnGetDetailRestaurant(widget.id));
          } else if (state is OnSuccessGetDetailRestaurant) {
            return buildPage(context, state.detailRestaurantModel);
          } else if (state is OnSendReviewSuccess) {
            final snackBar = SnackBar(content: Text("Review Berhasil Dikirim"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          } else if (state is OnSendReviewFailed) {
            final snackBar = SnackBar(content: Text("Terjadi Kesalahan"));
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
          return Center();
        },
      ),
    );
  }

  NestedScrollView buildPage(BuildContext context, DetailRestaurantModel data) {
    String pictureId = data.restaurant.pictureId;
    String name = data.restaurant.name;
    String location = data.restaurant.city;
    String description = data.restaurant.description;
    String rating = data.restaurant.rating.toString();
    return NestedScrollView(
      headerSliverBuilder: (context, isScrolled) {
        return [
          SliverAppBar(
            pinned: true,
            elevation: 0,
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(
              color: Colors.black,
            ),
            expandedHeight: 200,
            flexibleSpace: FlexibleSpaceBar(
              background: Hero(
                tag:
                    "https://restaurant-api.dicoding.dev/images/small/$pictureId",
                child: Image.network(
                  "https://restaurant-api.dicoding.dev/images/small/$pictureId",
                  fit: BoxFit.fitWidth,
                ),
              ),
              title: Text(name),
              titlePadding: const EdgeInsets.only(left: 16, bottom: 16),
            ),
            actions: [
              IconButton(
                  onPressed: () {
                    _onCallBottomSheet(context, data);
                  },
                  icon: Icon(Icons.reviews))
            ],
          )
        ];
      },
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(description),
            SizedBox(
              height: 24,
            ),
            Row(
              children: [
                Container(
                  child: Row(
                    children: [
                      Container(
                        child: Icon(
                          Icons.place,
                          size: 24,
                        ),
                      ),
                      Text(location)
                    ],
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(left: 24),
                  child: Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 24,
                      ),
                      Text(rating)
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(
              height: 24,
            ),
            Padding(
              padding: const EdgeInsets.only(left: 5),
              child: Text(
                "Menu",
                style: TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Expanded(
              child: DefaultTabController(
                  length: 2,
                  child: Scaffold(
                    appBar: PreferredSize(
                      preferredSize: Size.fromHeight(20),
                      child: Container(
                        color: Colors.grey[50],
                        child: SafeArea(
                          child: Column(
                            children: [
                              Expanded(child: Container()),
                              TabBar(tabs: [
                                Text(
                                  "Makanan",
                                  style: TextStyle(color: Colors.black),
                                ),
                                Text(
                                  "Minuman",
                                  style: TextStyle(color: Colors.black),
                                )
                              ])
                            ],
                          ),
                        ),
                      ),
                    ),
                    body: TabBarView(children: [
                      ListView.builder(
                        itemCount: data.restaurant.menus.foods.length,
                        itemBuilder: (context, index) {
                          String foodName =
                              data.restaurant.menus.foods.elementAt(index).name;
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                foodName,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          );
                        },
                      ),
                      ListView.builder(
                        itemCount: data.restaurant.menus.drinks.length,
                        itemBuilder: (context, index) {
                          String drinkName = data.restaurant.menus.drinks
                              .elementAt(index)
                              .name;
                          return Container(
                            decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(8)),
                            margin: const EdgeInsets.symmetric(vertical: 8),
                            child: ListTile(
                              title: Text(
                                drinkName,
                                style: TextStyle(fontSize: 15),
                              ),
                            ),
                          );
                        },
                      ),
                    ]),
                  )),
            ),
            SizedBox(
              height: 24,
            ),
          ],
        ),
      ),
    );
  }

  void _onCallBottomSheet(BuildContext context, DetailRestaurantModel data) {
    showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return DraggableScrollableSheet(
              minChildSize: 0.4,
              initialChildSize: 0.4,
              maxChildSize: 0.8,
              builder: (context, scrollController) => Container(
                    decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius:
                            BorderRadius.vertical(top: Radius.circular(15))),
                    padding: EdgeInsets.only(top: 10),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 5),
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Review",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      _onAddReviewBottomSheet(context);
                                    },
                                    icon: Icon(Icons.comment))
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          child: ListView.builder(
                            itemCount: data.restaurant.customerReviews.length,
                            itemBuilder: (context, index) {
                              String name = data.restaurant.customerReviews
                                  .elementAt(index)
                                  .name;
                              String review = data.restaurant.customerReviews
                                  .elementAt(index)
                                  .review;
                              String date = data.restaurant.customerReviews
                                  .elementAt(index)
                                  .date;
                              return Container(
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    borderRadius: BorderRadius.circular(8)),
                                margin: const EdgeInsets.symmetric(vertical: 8),
                                child: ListTile(
                                  title: Text(
                                    review,
                                    style: TextStyle(fontSize: 15),
                                  ),
                                  subtitle: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        name,
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        date,
                                        style: TextStyle(fontSize: 12),
                                      )
                                    ],
                                  ),
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ));
        });
  }

  void _onAddReviewBottomSheet(BuildContext context) {
    showModalBottomSheet(
        enableDrag: true,
        isScrollControlled: true,
        backgroundColor: Colors.transparent,
        context: context,
        builder: (BuildContext context) {
          return Padding(
            padding: MediaQuery.of(context).viewInsets,
            child: DraggableScrollableSheet(
                minChildSize: 0.4,
                initialChildSize: 0.4,
                maxChildSize: 0.8,
                builder: (context, scrollController) => Container(
                      decoration: const BoxDecoration(
                          color: Colors.white,
                          borderRadius:
                              BorderRadius.vertical(top: Radius.circular(15))),
                      padding: EdgeInsets.only(top: 10),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 24, vertical: 4),
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Review Anda",
                                  style: TextStyle(
                                    fontSize: 28,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                                IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                      detailRestaurantBloc.add(OnSendReview(
                                          widget.id,
                                          _nameController.text,
                                          _reviewController.text));
                                    },
                                    icon: Icon(Icons.check))
                              ],
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _nameController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                labelText: "Review",
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                              ),
                            ),
                            SizedBox(
                              height: 8,
                            ),
                            TextFormField(
                              controller: _reviewController,
                              decoration: InputDecoration(
                                focusedBorder: OutlineInputBorder(
                                    borderSide:
                                        BorderSide(color: Colors.black)),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 5),
                                labelText: "Nama",
                                labelStyle: TextStyle(color: Colors.black),
                                border: OutlineInputBorder(),
                              ),
                            ),
                          ],
                        ),
                      ),
                    )),
          );
        });
  }
}
