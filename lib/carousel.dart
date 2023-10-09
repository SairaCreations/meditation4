import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:meditation4/widgets/youtube_frame.dart';

final Map myMap = {
  'CottageCore': 'PL0QvugQOWFqLuyG2OCDoZQX4xQyw3PeTO',
  'CozyStudyVibes': 'PL0QvugQOWFqLbKOJK2h0OeS2iisr04aHh',
  'DarkAcademia': 'PL0QvugQOWFqImEjdHTxNaSz18epOsQYve',
  'AnimeLowFi': 'PL4cUxeGkcC9hYBP0AZ3MNdEiiZqd4mHGm'
};

class Carousel extends StatelessWidget {
  const Carousel({super.key});

  @override
  Widget build(BuildContext context) {
    double viewportFraction =
        MediaQuery.of(context).size.width >= 768 ? 0.4 : 0.8;

    double newheights = MediaQuery.of(context).size.width >= 768 ? 625 : 525;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 27, 40, 62),
        title: const Text(
          "Choose Your Ambience!",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color.fromARGB(255, 27, 40, 62),
              Color.fromARGB(255, 146, 110, 124)
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: ListView(
          children: [
            CarouselSlider(
              items: [
                //1st Image of Slider

                GestureDetector(
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: const DecorationImage(
                            image: AssetImage("assets/naturedesk.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                        // ),
                      ),
                      Positioned(
                        bottom: 50,
                        right: 50,
                        child: ClipRect(
                          // Wrap the text in a ClipRect
                          child: Container(
                            child: const Text(
                              'Fantasy',
                              style: TextStyle(
                                fontSize: 23,
                                //fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (builder) =>
                                YoutubeAppDemo(listName: 'CottageCore')),
                        (route) => false);
                  },
                ),

                //2nd Image of Slider
                GestureDetector(
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: const DecorationImage(
                            image: AssetImage("assets/citydesk.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        right: 50,
                        child: ClipRect(
                          // Wrap the text in a ClipRect
                          child: Container(
                            child: const Text(
                              'Minimalist',
                              style: TextStyle(
                                fontSize: 23,
                                //fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (builder) =>
                                YoutubeAppDemo(listName: 'CozyStudyVibes')),
                        (route) => false);
                  },
                ),

                //3rd Image of Slider
                GestureDetector(
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: const DecorationImage(
                            image: AssetImage("assets/darkacademia.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        right: 50,
                        child: ClipRect(
                          // Wrap the text in a ClipRect
                          child: Container(
                            child: const Text(
                              'Dark Academia',
                              style: TextStyle(
                                fontSize: 23,
                                //fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (builder) =>
                                YoutubeAppDemo(listName: 'DarkAcademia')),
                        (route) => false);
                  },
                ),
                //4th Image of Slider
                GestureDetector(
                  child: Stack(
                    children: [
                      Container(
                        margin: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          image: const DecorationImage(
                            image: AssetImage("assets/animedesk.jpg"),
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 50,
                        right: 50,
                        child: ClipRect(
                          // Wrap the text in a ClipRect
                          child: Container(
                            child: const Text(
                              'Anime Lo-Fi',
                              style: TextStyle(
                                fontSize: 23,
                                //fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                  onTap: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(
                            builder: (builder) =>
                                YoutubeAppDemo(listName: 'AnimeLowFi')),
                        (route) => false);
                  },
                )
              ],

              //Slider Container properties
              options: CarouselOptions(
                height: newheights,
                enlargeCenterPage: true,
                autoPlay: true,
                aspectRatio: 2 / 3,
                autoPlayCurve: Curves.fastOutSlowIn,
                enableInfiniteScroll: true,
                autoPlayAnimationDuration: const Duration(milliseconds: 800),
                viewportFraction: viewportFraction,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
