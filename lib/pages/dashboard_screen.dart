import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/bloc/restaurant_bloc/restaurant_bloc.dart';
import 'package:restaurant_app/pages/detail_restaurant_screen.dart';
import 'package:restaurant_app/pages/favorite_screen.dart';
import 'package:restaurant_app/pages/setting_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  _DashboardScreenState createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  List<dynamic> _allRestaurant = [];
  bool _validate = false;

  RestaurantBloc restaurantBloc = RestaurantBloc();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            "Indonesia",
            style: TextStyle(color: Colors.black),
          ),
          backgroundColor: Colors.white,
          elevation: 0,
          leading: Icon(
            Icons.my_location,
            color: Colors.black,
          ),
          actions: [
            IconButton(
              color: Colors.black,
              onPressed: () async {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => FavoriteScreen()));
              },
              icon: Icon(Icons.favorite),
            ),
            IconButton(
              onPressed: () {
                Navigator.push(context,
                    MaterialPageRoute(builder: (context) => SettingScreen()));
              },
              icon: Icon(Icons.settings),
              color: Colors.black,
            )
          ],
        ),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Ayo Cari",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
                key: Key("Cari"),
              ),
              Text(
                "Restoran Disini",
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 30),
              ),
              SizedBox(
                height: 24,
              ),
              TextFormField(
                key: Key("search"),
                onChanged: (text) {
                  _search(text);
                },
                decoration: InputDecoration(
                  errorText: _validate ? "Restoran Tidak ditemukan" : null,
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.black)),
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                  labelText: "Pencarian",
                  labelStyle: TextStyle(color: Colors.black),
                  border: OutlineInputBorder(),
                ),
              ),
              SizedBox(
                height: 8,
              ),
              BlocBuilder(
                bloc: restaurantBloc,
                builder: (context, state) {
                  if (state is RestaurantInitial) {
                    restaurantBloc.add(OnGetListRestaurant());
                  } else if (state is OnSuccessGetData) {
                    _allRestaurant = state.listRestaurant;
                    return listRestaurant(context, state.listRestaurant);
                  } else if (state is OnSearchResultSuccess) {
                    return listRestaurant(context, state.listRestaurant);
                  } else if (state is OnSearchResultNull) {
                    return CircularProgressIndicator();
                  }
                  return Center(child: CircularProgressIndicator());
                },
              ),
            ],
          ),
        ));
  }

  Expanded listRestaurant(BuildContext context, List<dynamic> data) {
    return Expanded(
      child: ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          String id = data.elementAt(index).id;
          String name = data.elementAt(index).name;
          String location = data.elementAt(index).city;
          String rating = data.elementAt(index).rating.toString();
          String pictureId = data.elementAt(index).pictureId.toString();
          String imageUrl =
              "https://restaurant-api.dicoding.dev/images/small/$pictureId";
          dynamic restaurantDetail = data.elementAt(index);
          return Container(
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(8)),
            margin: const EdgeInsets.symmetric(vertical: 8),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      name,
                      style: TextStyle(fontSize: 15),
                    ),
                  ),
                  _popUpMenuButton(restaurantDetail)
                ],
              ),
              subtitle: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.place,
                        size: 18,
                      ),
                      Text(
                        location,
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                  Row(
                    children: [
                      Icon(
                        Icons.star,
                        size: 18,
                      ),
                      Text(
                        rating,
                        style: TextStyle(fontSize: 12),
                      )
                    ],
                  ),
                ],
              ),
              isThreeLine: true,
              leading: Hero(
                tag: imageUrl,
                child: SizedBox(
                  child: Image.network(
                    imageUrl,
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => DetailRestaurantScreen(
                              id: id,
                            )));
              },
            ),
          );
        },
      ),
    );
  }

  PopupMenuButton<dynamic> _popUpMenuButton(dynamic restaurantDetail) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.favorite),
            title: Text("Favorit"),
            onTap: () {
              restaurantBloc.add(OnAddFavorite(restaurantDetail));
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Tambah jadi favorit")));
            },
          ),
        )
      ],
    );
  }

  void _search(String searchValue) {
    List<dynamic> result = [];
    bool status = false;
    if (searchValue.isEmpty) {
      result = _allRestaurant;
    } else {
      result = _allRestaurant
          .where((element) =>
              element.name.toLowerCase().contains(searchValue.toLowerCase()))
          .toList();
    }
    if (result.isEmpty) {
      status = true;
    }

    setState(() {
      _validate = status;
    });

    restaurantBloc.add(OnSearchRestaurant(searchValue));
  }
}
