import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:restaurant_app/bloc/favorite_bloc/favorite_bloc.dart';
import 'package:restaurant_app/models/restaurant_model.dart';
import 'package:restaurant_app/pages/detail_restaurant_screen.dart';

class FavoriteScreen extends StatefulWidget {
  const FavoriteScreen({Key? key}) : super(key: key);

  @override
  _FavoriteScreenState createState() => _FavoriteScreenState();
}

class _FavoriteScreenState extends State<FavoriteScreen> {
  FavoriteBloc favoriteBloc = FavoriteBloc();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        iconTheme: IconThemeData(
          color: Colors.black,
        ),
        title: Text(
          "Favorit",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
      ),
      body: BlocBuilder(
        bloc: favoriteBloc,
        builder: (context, state) {
          if (state is FavoriteInitial) {
            favoriteBloc.add(OnShowFavorite());
          } else if (state is OnLoadedFavorite) {
            return listFavorite(context, state.restaurantList);
          }
          return CircularProgressIndicator();
        },
      ),
    );
  }

  ListView listFavorite(BuildContext context, List<Restaurant> data) =>
      ListView.builder(
        itemCount: data.length,
        itemBuilder: (context, index) {
          String id = data.elementAt(index).id;
          String name = data.elementAt(index).name;
          String location = data.elementAt(index).city;
          String rating = data.elementAt(index).rating.toString();
          String pictureId = data.elementAt(index).pictureId.toString();
          String imageUrl =
              "https://restaurant-api.dicoding.dev/images/small/$pictureId";
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
                  _popUpMenuButton(id)
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
                        builder: (context) => DetailRestaurantScreen(id: id)));
              },
            ),
          );
        },
      );
  PopupMenuButton<dynamic> _popUpMenuButton(String id) {
    return PopupMenuButton(
      icon: Icon(Icons.more_vert),
      itemBuilder: (context) => <PopupMenuEntry>[
        PopupMenuItem(
          child: ListTile(
            leading: Icon(Icons.favorite),
            title: Text("Remove"),
            onTap: () {
              favoriteBloc.add(OnDeleteFavorite(id));
              Navigator.pop(context);
              ScaffoldMessenger.of(context)
                  .showSnackBar(SnackBar(content: Text("Hapus dari favorit")));
            },
          ),
        )
      ],
    );
  }
}
