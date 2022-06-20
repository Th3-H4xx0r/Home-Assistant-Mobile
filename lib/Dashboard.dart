import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:home_assistant/ShoppingList.dart';
import 'package:weather/weather.dart';

//https://dribbble.com/shots/18326953-Smart-Home-App

class Dashboard extends StatefulWidget {
  var houseCode = '';
  var city = '';

  Dashboard(code, cityName){
    houseCode = code;
    city = cityName;
  }

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {

  var temp = "0";
  var descriptionWeather = "";
  var weatherMain = "";
  var highTemp = "0";
  var lowTemp = "0";
  Widget weatherIcon = Icon(Icons.sunny, color: Colors.yellow[600], size: 50);

  Future getWeather(wf) async {
    Weather w = await wf.currentWeatherByCityName(widget.city);
    print(w.temperature!.fahrenheit);
    print(w.weatherIcon);
    print(w.toJson());
    temp = w.temperature?.fahrenheit?.round().toString() ?? "0";
    descriptionWeather = convertToTitleCase(w.weatherDescription!);
    weatherMain = w.weatherMain!;
    lowTemp = w.tempMin!.fahrenheit!.round().toString();
    highTemp = w.tempMax!.fahrenheit!.round().toString();

    if(weatherMain == "Clear"){
      weatherIcon = Icon(Icons.sunny, color: Colors.yellow[600], size: 50);
    } else if(weatherMain == "Rain"){
      weatherIcon = Icon(CupertinoIcons.cloud_rain_fill, color: Colors.grey, size: 50);
    } else if(weatherMain == "Clouds"){
      weatherIcon = Icon(CupertinoIcons.cloud_fill, color: Colors.white, size: 50);
    } else if(weatherMain == "Snow"){
      weatherIcon = Icon(CupertinoIcons.snow, color: Colors.white, size: 50);
    }
    setState((){});
  }

  String convertToTitleCase(String text) {

    if (text.length <= 1) {
      return text.toUpperCase();
    }

    // Split string into multiple words
    final List<String> words = text.split(' ');

    // Capitalize first letter of each words
    final capitalizedWords = words.map((word) {
      if (word.trim().isNotEmpty) {
        final String firstLetter = word.trim().substring(0, 1).toUpperCase();
        final String remainingLetters = word.trim().substring(1);

        return '$firstLetter$remainingLetters';
      }
      return '';
    });

    // Join/Merge all words back to one String
    return capitalizedWords.join(' ');
  }

  @override
  void initState(){
    WeatherFactory wf = WeatherFactory("edfa3e8f09d7b9afe9e3f0087d76703c");
    getWeather(wf);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(12, 12, 12, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(12, 12, 12, 1),
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back, color: Colors.white),
          onPressed: (){
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Container(
            margin: const EdgeInsets.only(top: 20, left: 30),
            child: Text("Welcome Back", style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white, fontSize: 28, fontWeight: FontWeight.w600)),),
          ),

          Container(
            margin: const EdgeInsets.only(top: 5, left: 30),
            child: Text("Welcome back to your smart home", style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.grey, fontSize: 15)),),
          ),

          Container(
            width: MediaQuery.of(context).size.width - 30,
            height: MediaQuery.of(context).size.height * 0.2,
            margin: const EdgeInsets.only(left: 30),
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ShowcaseListItem("Shopping List", Icons.shopping_cart_outlined, ShoppingList(widget.houseCode)),
                const SizedBox(
                  width: 15,
                ),
                ShowcaseListItem("Inventory", CupertinoIcons.archivebox, Container()),

                const SizedBox(
                  width: 15,
                ),
                ShowcaseListItem("", CupertinoIcons.plus, Container()),
              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 30),
            child: Text("Overview", style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),),
          ),

          Column(
              children: [
                Container(
                  margin: const EdgeInsets.only(left: 30, top: 10),
                  width: MediaQuery.of(context).size.width - 30,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: (MediaQuery.of(context).size.width * 0.5) - 35,
                        margin: const EdgeInsets.only(right: 7.5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.white
                        ),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [

                            SizedBox(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Container(
                                    margin: const EdgeInsets.only(top: 15),
                                    child: Text("5 Members", style: GoogleFonts.poppins(fontSize: 20, fontWeight: FontWeight.w700), textAlign: TextAlign.start,),
                                  ),

                                  Container(
                                    margin: const EdgeInsets.only(top: 0),
                                    child: Text("House Members", style: GoogleFonts.poppins(fontSize: 15, color: Colors.grey), textAlign: TextAlign.start,),
                                  ),
                                ],
                              ),
                            ),

                            SizedBox(
                              child: AspectRatio(
                                  aspectRatio: 1.5,
                                  child: SvgPicture.asset(
                                      "lib/images/people.svg")),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: (MediaQuery.of(context).size.width * 0.5) - 35,
                        margin: const EdgeInsets.only(left: 7.5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black,
                            border: Border.all(color: Colors.grey)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            Container(
                              width: 70,
                              margin: const EdgeInsets.only(left: 15, top: 15),
                              child: Image.asset("lib/images/home_sync_logo.png"),
                            ),

                            Row(
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10, top: 70),
                                  child: Text("Home", style: GoogleFonts.roboto(color: Colors.blue[500], fontWeight: FontWeight.w700, fontSize: 25),),
                                ),Container(
                                  margin: const EdgeInsets.only(left: 0, top: 70),
                                  child: Text("Sync", style: GoogleFonts.roboto(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 25),),
                                ),
                              ],
                            ),

                            Container(
                              margin: const EdgeInsets.only(left: 10, top: 5),
                              child: Text("Smart Light Management", style: GoogleFonts.roboto(color: Colors.grey, fontSize: 15),),
                            ),
                          ],
                        ),
                      ),


                    ],
                  ),

                ),

                Container(
                  margin: const EdgeInsets.only(left: 20, top: 10),
                  width: MediaQuery.of(context).size.width - 30,
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [

                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: (MediaQuery.of(context).size.width * 0.5) - 35,
                        margin: const EdgeInsets.only(left: 7.5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black,
                            border: Border.all(color: Colors.grey)
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: const EdgeInsets.only(left: 10, top: 10),
                              child: weatherIcon,
                            ),

                              Row(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(left: 10, top: 0),
                                    child: Text(temp, style: GoogleFonts.poppins(color: Colors.white, fontSize: 60),),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(left: 0, top: 20),
                                    child: Text("°F", style: GoogleFonts.poppins(color: Colors.white, fontSize: 25),),
                                  ),
                                ],
                              ),

                            Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(left: 10, top: 0),
                                  child: const Icon(Icons.arrow_upward, color: Colors.white,),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 0, top: 3),
                                  child: Text(highTemp + "°F", style: const TextStyle(color: Colors.white, fontSize: 15),),
                                ),

                                Container(
                                  margin: const EdgeInsets.only(left: 5, top: 0),
                                  child: const Icon(Icons.arrow_downward, color: Colors.white,),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(left: 0, top: 3),
                                  child: Text(lowTemp + "°F", style: const TextStyle(color: Colors.white, fontSize: 15),),
                                ),
                              ],
                            ),

                            Container(
                              padding: const EdgeInsets.only(left: 10, top: 10),
                              child: Text(descriptionWeather, style: const TextStyle(color: Colors.white, fontSize: 20, fontWeight: FontWeight.bold),),
                            ),


                          ],
                        ),
                      ),

                      Container(
                        height: MediaQuery.of(context).size.height * 0.3,
                        width: (MediaQuery.of(context).size.width * 0.5) - 35,
                        margin: const EdgeInsets.only(left: 7.5),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            color: Colors.black,
                            border: Border.all(color: Colors.grey)
                        ),
                        child: const Center(
                          child: Icon(Icons.add, color: Colors.white, size: 50,),
                        ),
                      ),




                    ],
                  ),

                ),
              ],
            ),

        ],
      ),
    ),
    );
  }
}

class ShowcaseListItem extends StatefulWidget {
  var name = "";
  IconData icon = Icons.add;
  Widget destination = ShoppingList("10000");

  ShowcaseListItem(nameGiven, iconGiven, dest){
    name = nameGiven;
    icon = iconGiven;
    destination = dest;
  }

  @override
  State<ShowcaseListItem> createState() => _ShowcaseListItemState();
}

class _ShowcaseListItemState extends State<ShowcaseListItem> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, CupertinoPageRoute(builder: (context) => widget.destination));
            },
            child: Container(
              margin: const EdgeInsets.only(top: 30, right: 0),
              decoration: BoxDecoration(
                  color: Colors.black,
                  borderRadius: BorderRadius.circular(15),
                  border: Border.all(color: Colors.grey, width: 1)
              ),
              height: 70,
              width: 65,
              child: Icon(widget.icon, color: Colors.white, size: 30,),
            ),
          ),

          const SizedBox(
            height: 10,
          ),

          Container(
            child: Center(
              child: Text(widget.name, style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white, fontSize: 10)),),
            ),
          ),
        ],
      ),
    );
  }
}
