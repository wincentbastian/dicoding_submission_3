import 'dart:convert';

import 'package:restaurant_app/models/detail_restaurant_model.dart';
import 'package:restaurant_app/models/restaurant_model.dart';
import 'package:http/http.dart' as http;
import 'package:restaurant_app/models/search_restaurant_model.dart';

class ConnectionRepositories {
  final String _baseUrl = "https://restaurant-api.dicoding.dev";

  Future<RestaurantModel> getListRestaurant() async {
    final response = await http.get(Uri.parse(_baseUrl + "/list"));

    if (response.statusCode == 200) {
      return RestaurantModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to get data");
    }
  }

  Future<SearchRestaurantModel> getSearchRestaurant(String searchValue) async {
    final response =
        await http.get(Uri.parse(_baseUrl + "/search?q=$searchValue"));
    if (response.statusCode == 200) {
      return SearchRestaurantModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Data not found");
    }
  }

  Future<DetailRestaurantModel> getDetailRestaurant(String id) async {
    final response = await http.get(Uri.parse(_baseUrl + "/detail/$id"));

    if (response.statusCode == 200) {
      return DetailRestaurantModel.fromJson(json.decode(response.body));
    } else {
      throw Exception("Failed to get data");
    }
  }

  Future<bool> postReviewRestaurant(
      String id, String name, String review) async {
    var body = {
      "id": id,
      "name": name,
      "review": review,
    };
    final response = await http.post(Uri.parse(_baseUrl + "/review"),
        headers: {
          "Accept": "application/json",
          "Content-Type": "application/json",
          "X-Auth-Token": "12345",
        },
        body: json.encode(body),
        encoding: Encoding.getByName("utf-8"));
    print(body);

    if (response.statusCode == 200) {
      return true;
    } else {
      return false;
    }
  }
}
