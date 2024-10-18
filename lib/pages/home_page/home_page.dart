import 'package:chinchin/controllers/coin_controller.dart';
import 'package:chinchin/pages/login/login.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:get/get.dart';

class HomePage extends StatelessWidget {
  final CoinController controller = Get.put(CoinController());
  @override
  Widget build(BuildContext context) {
    // Get the current user
    User? user = FirebaseAuth.instance.currentUser;

    // Fetch user data from Firestore
    final firestore = FirebaseFirestore.instance;
    final userDataFuture = firestore.collection('users').doc(user?.uid).get();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Crypto Market'),
        actions: [
          Builder(
            builder: (BuildContext context) {
              return IconButton(
                icon: CircleAvatar(
                  backgroundColor: Color(0xff14c6a4),
                  child: Icon(Icons.person, color: Colors.white),
                ),
                onPressed: () {
                  Scaffold.of(context).openEndDrawer();
                },
              );
            },
          ),
        ],
      ),
      endDrawer: FutureBuilder(
        future: userDataFuture,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final userData = snapshot.data as DocumentSnapshot;
            return _buildDrawer(context, userData);
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          physics: ScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Obx(
                () => controller.isLoading.value
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ListView.builder(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: 10,
                        itemBuilder: (BuildContext context, int index) {
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Container(
                              width: MediaQuery.sizeOf(context).width,
                              height: 60,
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Container(
                                    width: 60,
                                    height: 60,
                                    child: Padding(
                                      padding: EdgeInsets.all(10),
                                      child: Image.network(
                                          controller.coinlist[index].image),
                                    ),
                                  ),
                                  const SizedBox(
                                    width: 20,
                                  ),
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        controller.coinlist[index].name,
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        '${controller.coinlist[index].priceChangePercentage24H.toStringAsFixed(2)}%',
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Spacer(),
                                  Column(
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        '\$${controller.coinlist[index].currentPrice}',
                                        style: TextStyle(
                                          fontSize: 18,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      Text(
                                        controller.coinlist[index].symbol
                                            .toUpperCase(),
                                        style: TextStyle(
                                          fontSize: 18,
                                          color: Colors.grey,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                    ],
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
        ),
      ),
    );
  }

  Widget _buildDrawer(BuildContext context, DocumentSnapshot userData) {
    return Drawer(
      child: Column(
        children: [
          UserAccountsDrawerHeader(
            accountName: Text(userData['name'] ?? 'User  Name'),
            accountEmail: Text(userData['email'] ?? 'user@example.com'),
            decoration: BoxDecoration(
              color: Color.fromARGB(255, 14, 134, 112),
            ),
            currentAccountPicture: CircleAvatar(
              backgroundColor: Color(0xff14c6a4),
              child: Icon(Icons.person, color: Colors.white),
            ),
          ),
          ListTile(
            title: Text('Hello, ${userData['name'] ?? 'User '}!'),
          ),
          Spacer(),
          ListTile(
            leading: Icon(Icons.logout),
            title: const Text('Log Out'),
            onTap: () {
              _logout(context);
            },
          ),
        ],
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => LoginPage()),
    );
  }
}
