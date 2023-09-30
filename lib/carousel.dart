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
    return Scaffold(
      appBar: AppBar(
        title: const Text("Pick Your Theme"),
      ),
      body: ListView(
        children: [
          CarouselSlider(
            items: [
              //1st Image of Slider

              GestureDetector(
                child: Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: const DecorationImage(
                      image: AssetImage("assets/castleboat1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
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
                child: Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: const DecorationImage(
                      image: AssetImage("assets/darkcastle1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
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
                child: Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: const DecorationImage(
                      image: AssetImage("assets/underwatercastle1.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
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
                child: Container(
                  margin: const EdgeInsets.all(6.0),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8.0),
                    image: const DecorationImage(
                      image: AssetImage("assets/darkcastlepath2.jpg"),
                      fit: BoxFit.cover,
                    ),
                  ),
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
              height: 585.0,
              enlargeCenterPage: true,
              autoPlay: true,
              aspectRatio: 2 / 3,
              autoPlayCurve: Curves.fastOutSlowIn,
              enableInfiniteScroll: true,
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              viewportFraction: 0.8,
            ),
          ),
        ],
      ),
    );
  }
}
