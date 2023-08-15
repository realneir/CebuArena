import 'package:captsone_ui/Screens/sidebar/leaderboards.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

// Player model as an example
class Player {
  final String name;
  final double winRate;

  Player({required this.name, required this.winRate});
}

// Widget to display preview of top 3 players
class PreviewLeaderboards extends StatelessWidget {
  final List<Player> players;

  PreviewLeaderboards(this.players);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: players.take(3).map((player) {
        return ListTile(
          leading: Text(' ${players.indexOf(player) + 1}'),
          title: Text(player.name),
          trailing: Text('Win Rate: ${player.winRate.toStringAsFixed(2)}%'),
        );
      }).toList(),
    );
  }
}

class HomeView extends StatefulWidget {
  @override
  _HomeViewState createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // List of players (replace this with your real data)
  final List<Player> players = [
    Player(name: 'Reneir Pogi', winRate: 85.0),
    Player(name: 'Kylie Puth', winRate: 80.0),
    Player(name: 'Hanz Anthony', winRate: 75.0),
  ];

  int _currentIndex = 0;
  int _sliderIndex = 0;
  final List<String> _sliderItems = [
    'assets/Slider1.jpg',
    'assets/Slider2.jpg',
    'assets/Slider3.jpg',
  ];

  List<Widget> generateDotIndicators() {
    return _sliderItems.map((item) {
      int index = _sliderItems.indexOf(item);
      return Container(
        width: 8.0,
        height: 8.0,
        margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 2.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentIndex == index ? Colors.blue : Colors.black,
        ),
      );
    }).toList();
  }

  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.stretch, children: [
      Expanded(
        child: Padding(
          padding: EdgeInsets.symmetric(vertical: 30),
          child: CarouselSlider(
            items: _sliderItems.map((item) {
              return Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  image: DecorationImage(
                    image: AssetImage(item),
                    fit: BoxFit.cover,
                  ),
                ),
              );
            }).toList(),
            options: CarouselOptions(
              height: 300,
              autoPlay: true,
              enlargeCenterPage: true,
              enableInfiniteScroll: false, // Disable infinite scroll
              onPageChanged: (index, reason) {
                setState(() {
                  _currentIndex = index;
                });
              },
            ),
            carouselController: CarouselController(),
          ),
        ),
      ),
      Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: generateDotIndicators(),
      ),
      Expanded(
          child: Padding(
              padding: EdgeInsets.only(top: 10),
              child: Stack(
                children: [
                  Container(
                    color: Colors.transparent,
                  ),
                  Align(
                    alignment: Alignment.topCenter,
                    child: Container(
                      margin: EdgeInsets.symmetric(horizontal: 20),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _sliderIndex = 0;
                              });
                            },
                            child: Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _sliderIndex == 0
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Leaderboards',
                                  style: GoogleFonts.orbitron(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _sliderIndex = 1;
                              });
                            },
                            child: Container(
                              width: 150,
                              height: 50,
                              decoration: BoxDecoration(
                                border: Border(
                                  bottom: BorderSide(
                                    color: _sliderIndex == 1
                                        ? Colors.black
                                        : Colors.transparent,
                                    width: 2.0,
                                  ),
                                ),
                              ),
                              child: Center(
                                child: Text(
                                  'Events',
                                  style: GoogleFonts.orbitron(
                                    fontSize: 15,
                                    color: Colors.black,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (_sliderIndex == 0)
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 90, bottom: 20),
                        height: 200,
                        color: Color(0xFFDAC0A3),
                        child: PreviewLeaderboards(players),
                      ),
                    ),
                  if (_sliderIndex == 1)
                    Align(
                      alignment: Alignment.center,
                      child: Container(
                        margin: EdgeInsets.only(top: 90, bottom: 20),
                        height: 200,
                        color: Colors.grey,
                        child: Center(
                          child: Text(
                            'Events Container',
                            style: TextStyle(fontSize: 24),
                          ),
                        ),
                      ),
                    ),
                ],
              )))
    ]);
  }
}
