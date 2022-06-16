import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:google_fonts/google_fonts.dart';

//https://dribbble.com/shots/18326953-Smart-Home-App

class Dashboard extends StatefulWidget {
  var houseCode = '';

  Dashboard(code){
    houseCode = code;
  }

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
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
      body: Column(
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

                ShowcaseListItem("Shopping List", Icons.shopping_cart_outlined),
                ShowcaseListItem("Shopping List", Icons.shopping_cart_outlined),


              ],
            ),
          ),

          Container(
            margin: const EdgeInsets.only(left: 30),
            child: Text("Overview", style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.w600)),),
          ),

          Container(
            margin: const EdgeInsets.only(left: 30, top: 10),
            height: MediaQuery.of(context).size.height * 0.5,
            width: MediaQuery.of(context).size.width - 60,
            child: GridView.count(
              crossAxisCount: 2,
              children: [

                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.4,
                  margin: const EdgeInsets.only(right: 7.5),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                    color: Colors.white
                  ),
                  
                ),

                Container(
                  height: MediaQuery.of(context).size.height * 0.5,
                  width: MediaQuery.of(context).size.width * 0.4,
                  margin: const EdgeInsets.only(left: 7.5),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.white
                  ),
                ),


              ],
            ),

          ),

        ],
      ),
    );
  }
}

class ShowcaseListItem extends StatefulWidget {
  var name = "";
  IconData icon = Icons.add;

  ShowcaseListItem(nameGiven, iconGiven){
    name = nameGiven;
    icon = iconGiven;
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
          Container(
            margin: const EdgeInsets.only(top: 30, right: 20),
            decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey, width: 1)
            ),
            height: 70,
            width: 65,
            child: Icon(widget.icon, color: Colors.white, size: 30,),
          ),

          const SizedBox(
            height: 10,
          ),

          Center(
            child: Text(widget.name, style: GoogleFonts.poppins(textStyle: const TextStyle(color: Colors.white, fontSize: 10)),),
          ),
        ],
      ),
    );
  }
}
