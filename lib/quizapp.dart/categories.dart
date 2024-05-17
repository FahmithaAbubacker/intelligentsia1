import 'package:flutter/material.dart';
import 'package:intelligentsia1/quizapp.dart/levels.dart';

class CategoryPage extends StatelessWidget {
  final List<Map<String, dynamic>> categories = [
    {
      'name': 'General Knowledge',
      'image': 'pictures/gk.png',
      'categoryId': '9'
    },
    {'name': 'Science', 'image': 'pictures/code.png', 'categoryId': '18'},
    {'name': 'Sports', 'image': 'pictures/sports.png', 'categoryId': '21'},
    {'name': 'Film', 'image': 'pictures/film.png', 'categoryId': '11'},
  ];

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Stack(
        children: [
          Image.asset(
            "pictures/mm.jpg",
            fit: BoxFit.cover,
            height: size.height / 1.2,
            width: size.width,
          ),
          Padding(
            padding: EdgeInsets.all(120),
            child: Column(
              children: [
                Text(
                  "Categories",
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                )
              ],
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
                height: 600,
                padding: EdgeInsets.symmetric(horizontal: 10),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(20),
                        topRight: Radius.circular(20))),
                child: ListView.builder(
                  itemCount: categories.length,
                  itemBuilder: (context, index) => Column(
                    children: [
                      Padding(
                          padding: EdgeInsets.all(8.0),
                          child: SizedBox(
                            height: 130,
                            width: double.infinity,
                            child: Card(
                              color: Colors.white,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  ListTile(
                                    leading:
                                        Image.asset(categories[index]['image']),
                                    title: Text(
                                      categories[index]['name'],
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold),
                                      textAlign: TextAlign.center,
                                    ),
                                    trailing: Container(
                                      height: 50,
                                      width: 50,
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(10),
                                          color: Colors.amber),
                                      alignment: Alignment.topCenter,
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.navigate_next_sharp,
                                          color: Colors.black,
                                        ),
                                        onPressed: () {
                                          Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    DifficultyLevels(
                                                  categoryId: categories[index]
                                                      ['categoryId'],
                                                ),
                                              ));
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ))
                    ],
                  ),
                )),
          ),
        ],
      ),
    );
  }
}
