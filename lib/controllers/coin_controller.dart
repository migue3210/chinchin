import 'package:chinchin/models/coin_model.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class CoinController extends GetxController {
  RxBool isLoading = true.obs;
  RxList<Coin> coinlist = <Coin>[].obs;

  @override
  onInit() {
    super.onInit();
    fetchCoins();
  }

  fetchCoins() async {
    try {
      isLoading(true);
      var response = await http.get(Uri.parse(
          'https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&x_cg_demo_api_key=CG-xbbRgJQtXQRNU8SLdz45RBjA'));
      List<Coin> coins = coinFromJson(response.body);
      coinlist.value = coins;
    } finally {
      isLoading(false);
    }
  }
}
