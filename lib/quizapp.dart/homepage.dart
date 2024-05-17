import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intelligentsia1/quizapp.dart/categories.dart';
import 'package:intelligentsia1/quizapp.dart/leaderboard.dart';
import 'package:intelligentsia1/quizapp.dart/login.dart';

class HomePage extends StatelessWidget {
   HomePage({Key? key}) : super(key: key);

  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: const Text(
          "INTELLIGENTSIA",
          style: TextStyle(color: Color.fromARGB(255, 107, 143, 125)),
        ),
        actions: [
          IconButton(
            onPressed: () => _scaffoldKey.currentState?.openEndDrawer(), 
            icon: const Icon(
              Icons.person_3_rounded,
              color: Color.fromARGB(255, 107, 143, 125),
            ),
          )
        ],
      ),
      endDrawer: Drawer(
        child: ListView(
          padding: const EdgeInsets.all(1.0),
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(255, 192, 207, 178),
              ),
              child: Image(image: AssetImage("pictures/pro.png")),
            ),
            const SizedBox(height: 30),
            buildDrawerItem(
              icon: Icons.leaderboard_rounded,
              title: "LeaderBoard",
              onTap: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => const LeaderboardPage())),
            ),
            const SizedBox(height: 30),
            buildDrawerItem(
              icon: Icons.logout_rounded,
              title: "Logout",
              onTap: () => showDialog(
                context: context,
                builder: (_) => AlertDialog(
                  title: const Text("Are You Sure want to Logout ?",
                      textAlign: TextAlign.start),
                  content: Container(
                    height: 150,
                    width: 200,
                    padding: const EdgeInsets.all(16.0),
                    decoration:
                        BoxDecoration(borderRadius: BorderRadius.circular(20)),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        ElevatedButton(
                            onPressed: () => Navigator.pop(context),
                            child: const Text("Cancel")),
                        const SizedBox(width: 25),
                        ElevatedButton(
                          onPressed: () => Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (_) => const LoginScreen())),
                          child: const Text("Yes"),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child:
                SvgPicture.asset('pictures/hi.svg.svg', height: 200, width: 80),
          ),
          const SizedBox(height: 10),
          const Text(
            "Let's Intelligence recaptures you...",
            style: TextStyle(color: Color.fromARGB(255, 107, 143, 125)),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: () => Navigator.push(context,
                MaterialPageRoute(builder: (_) =>  CategoryPage())),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(234, 245, 160, 32),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5.0)),
            ),
            child: const Text("READY", style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  Widget buildDrawerItem(
      {required IconData icon,
      required String title,
      required VoidCallback onTap}) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        trailing: const Icon(Icons.navigate_next),
        title: Text(title),
        onTap: onTap,
      ),
    );
  }
}
