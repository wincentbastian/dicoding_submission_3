import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:restaurant_app/models/detail_restaurant_model.dart';

import 'fetch_restaurant_test.mocks.dart';

// Generate a MockClient using the Mockito package.
// Create new instances of this class in each test.
@GenerateMocks([http.Client])
void main() {
  group("fetchRestaurant", () {
    test('return restaurant if http call completes success', () async {
      final client = MockClient();
      when(client.get(Uri.parse(
              "https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867")))
          .thenAnswer((realInvocation) async => http.Response(
              '{"error":false,"message":"success","restaurant":{"id":"rqdv5juczeskfw1e867","name":"Melting Pot","description":"Lorem ipsum dolor sit amet, consectetuer adipiscing elit. Aenean commodo ligula eget dolor. Aenean massa. Cum sociis natoque penatibus et magnis dis parturient montes, nascetur ridiculus mus. Donec quam felis, ultricies nec, pellentesque eu, pretium quis, sem. Nulla consequat massa quis enim. Donec pede justo, fringilla vel, aliquet nec, vulputate eget, arcu. In enim justo, rhoncus ut, imperdiet a, venenatis vitae, justo. Nullam dictum felis eu pede mollis pretium. Integer tincidunt. Cras dapibus. Vivamus elementum semper nisi. Aenean vulputate eleifend tellus. Aenean leo ligula, porttitor eu, consequat vitae, eleifend ac, enim. Aliquam lorem ante, dapibus in, viverra quis, feugiat a, tellus. Phasellus viverra nulla ut metus varius laoreet.","city":"Medan","address":"Jln. Pandeglang no 19","pictureId":"14","categories":[{"name":"Italia"},{"name":"Modern"}],"menus":{"foods":[{"name":"Paket rosemary"},{"name":"Toastie salmon"},{"name":"Bebek crepes"},{"name":"Salad lengkeng"}],"drinks":[{"name":"Es krim"},{"name":"Sirup"},{"name":"Jus apel"},{"name":"Jus jeruk"},{"name":"Coklat panas"},{"name":"Air"},{"name":"Es kopi"},{"name":"Jus alpukat"},{"name":"Jus mangga"},{"name":"Teh manis"},{"name":"Kopi espresso"},{"name":"Minuman soda"},{"name":"Jus tomat"}]},"rating":4.2,"customerReviews":[{"name":"Ahmad","review":"Tidak rekomendasi untuk pelajar!","date":"13 November 2019"},{"name":"test","review":"halo","date":"14 Agustus 2021"},{"name":"test","review":"aa","date":"14 Agustus 2021"},{"name":"Alea","review":"Keren!","date":"14 Agustus 2021"},{"name":"a","review":"test","date":"14 Agustus 2021"},{"name":"bcb","review":"ryyr","date":"14 Agustus 2021"},{"name":"ASFadfafa","review":"adfadfaf","date":"14 Agustus 2021"},{"name":"test","review":"ok","date":"14 Agustus 2021"},{"name":"ok","review":"sip","date":"14 Agustus 2021"}]}}',
              200));
      expect(await getDetailRestaurant(client), isA<DetailRestaurantModel>());
    });

    test('throws an exception if the http call completes with an error', () {
      final client = MockClient();

      // Use Mockito to return an unsuccessful response when it calls the
      // provided http.Client.
      when(client.get(Uri.parse(
              'https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867')))
          .thenAnswer((_) async => http.Response('Not Found', 404));

      expect(getDetailRestaurant(client), throwsException);
    });
  });
}

Future<DetailRestaurantModel> getDetailRestaurant(http.Client client) async {
  final response = await client.get(Uri.parse(
      "https://restaurant-api.dicoding.dev/detail/rqdv5juczeskfw1e867"));

  if (response.statusCode == 200) {
    return DetailRestaurantModel.fromJson(json.decode(response.body));
  } else {
    throw Exception("Failed to get data");
  }
}
