import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:math';

class Houses extends StatefulWidget {
  const Houses({Key? key}) : super(key: key);

  @override
  State<Houses> createState() => _HousesState();
}

class _HousesState extends State<Houses> {
  // Global vars
  var houses = [];
  var showCreateHouseModalFragment = false;
  var showJoinHouseModalFragment = false;
  var createHouseLoading = false;
  var showHouseCreateSuccessFragment = true;
  var errorMessageCreateHouse = '';
  var housesDetails = [];
  var loadingHouses = true;

  // Text editing controllers
  var houseNameController = TextEditingController();

  Future getHouses() async {
    loadingHouses = true;
    final prefs = await SharedPreferences.getInstance();
    final List<String>? items = prefs.getStringList('Houses');

    if (items != null) {
      houses = items;
    }

    housesDetails = [];
    var index = 0;
    houses.forEach((element) async {
      await FirebaseFirestore.instance.collection("Houses").doc(element).get().then((value){
        housesDetails.add(value.data());
        updateListRefresh(items, index);
        index++;
      });
      print(housesDetails);
    });
    print(items);
    setState(() {});
  }

  void updateListRefresh(original, index) {
      if(index == (original.length-1)){
        loadingHouses = false;
        print(loadingHouses);
        setState((){});
      }
  }

  Future firebaseLogin() async {
    await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: 'test@gmail.com', password: 'password123');
  }

  Future updateLocalList(randomNumber) async {
    randomNumber = randomNumber.toString();
    final prefs = await SharedPreferences.getInstance();
    var currentList = prefs.getStringList('Houses');
    currentList == null
        ? currentList = [randomNumber]
        : currentList.add(randomNumber);
    print(currentList);
    prefs.setStringList('Houses', currentList);
  }

  Future showHouseCreationModal() async {
    // Sets default values
    showJoinHouseModalFragment = false;
    showCreateHouseModalFragment = false;
    createHouseLoading = false;
    showHouseCreateSuccessFragment = false;

    showModalBottomSheet<void>(
        context: context,
        isScrollControlled: true,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setState) {
            return Padding(
                padding: MediaQuery.of(context).viewInsets,
                child: Container(
                    decoration: const BoxDecoration(
                        color: Color.fromRGBO(33, 35, 41, 1)),
                    child: IntrinsicHeight(
                      child: Column(
                        children: [
                          // Main menu
                          Visibility(
                              visible: !showCreateHouseModalFragment &&
                                  !showJoinHouseModalFragment &&
                                  !showHouseCreateSuccessFragment,
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: const EdgeInsets.only(top: 10),
                                    height: 5,
                                    width:
                                        MediaQuery.of(context).size.width * 0.3,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(2)),
                                  ),
                                  Container(
                                    margin: const EdgeInsets.only(
                                        top: 30, bottom: 10),
                                    child: const Text(
                                      "House Creation\nOptions",
                                      textAlign: TextAlign.center,
                                      style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 25,
                                          fontWeight: FontWeight.bold),
                                    ),
                                  ),
                                  Container(
                                    width:
                                        MediaQuery.of(context).size.width * 0.8,
                                    margin: const EdgeInsets.only(
                                        top: 5, bottom: 15),
                                    child: const Text(
                                      "You can either create a new house or join a existing house using a house code.",
                                      style: TextStyle(
                                          color: Colors.grey, fontSize: 15),
                                      textAlign: TextAlign.center,
                                    ),
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue.shade700,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      onPressed: () {
                                        showCreateHouseModalFragment = true;
                                        showJoinHouseModalFragment = false;
                                        setState(() {});
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 30,
                                              right: 30,
                                              top: 15,
                                              bottom: 15),
                                          child: const Text("Create House")),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue.shade700,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(30.0),
                                        ),
                                      ),
                                      onPressed: () {},
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 30,
                                              right: 30,
                                              top: 15,
                                              bottom: 15),
                                          child: const Text(
                                              "Join House with Code")),
                                    ),
                                  ),
                                  const SizedBox(
                                    height: 10,
                                  ),
                                ],
                              )),

                          // Create House Fragment
                          Visibility(
                            visible: showCreateHouseModalFragment,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Container(
                                  margin: const EdgeInsets.only(top: 10),
                                  height: 5,
                                  width:
                                      MediaQuery.of(context).size.width * 0.3,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(2)),
                                ),
                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 30, bottom: 10),
                                  child: const Text(
                                    "Create House",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold),
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.8,
                                  margin:
                                      const EdgeInsets.only(top: 5, bottom: 15),
                                  child: const Text(
                                    "Create a house that your family can join later",
                                    style: TextStyle(
                                        color: Colors.grey, fontSize: 15),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                Container(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  margin: const EdgeInsets.only(top: 10),
                                  padding: const EdgeInsets.only(top: 20),
                                  decoration: BoxDecoration(
                                      color:
                                          const Color.fromRGBO(50, 50, 55, 1),
                                      borderRadius: BorderRadius.circular(10)),
                                  height: 45,
                                  child: TextField(
                                    controller: houseNameController,
                                    decoration: InputDecoration(
                                        hintText: "House Name",
                                        border: OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius:
                                              BorderRadius.circular(10),
                                        )),
                                  ),
                                ),

                                // Error Message
                                Container(
                                  child: Text(
                                    errorMessageCreateHouse,
                                    style: const TextStyle(color: Colors.red),
                                  ),
                                ),

                                Container(
                                  margin: const EdgeInsets.only(
                                      top: 15, bottom: 20),
                                  child: SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.85,
                                    child: ElevatedButton(
                                      style: ElevatedButton.styleFrom(
                                        primary: Colors.blue.shade700,
                                        shape: RoundedRectangleBorder(
                                          borderRadius:
                                              BorderRadius.circular(5.0),
                                        ),
                                      ),
                                      onPressed: () async {
                                        createHouseLoading = true;
                                        setState(() {});

                                        // Login firebase

                                        await firebaseLogin().then((value) {
                                          if (houseNameController.text != '') {
                                            try {
                                              // Create House Function
                                              Random random = Random();
                                              var randomNumber = random
                                                      .nextInt(99999) +
                                                  11111; // Generate House Code

                                              // Checks if house code does not already exist

                                              FirebaseFirestore.instance
                                                  .collection('Houses')
                                                  .doc(randomNumber.toString())
                                                  .get()
                                                  .then((value) {
                                                var data = value.data();
                                                print(data);

                                                if (data == null) {
                                                  randomNumber =
                                                      random.nextInt(99999) +
                                                          10000;

                                                  FirebaseFirestore.instance
                                                      .collection('Houses')
                                                      .doc(randomNumber
                                                          .toString())
                                                      .set({
                                                    'houseCode': randomNumber,
                                                    'houseName':
                                                        houseNameController.text
                                                  }).then((value) async {
                                                    // Stores the house code locally
                                                    await updateLocalList(
                                                        randomNumber);

                                                    errorMessageCreateHouse =
                                                        "";
                                                    setState(() {});

                                                    Future.delayed(
                                                            const Duration(
                                                                seconds: 1))
                                                        .then((value) async {
                                                      await getHouses();
                                                      showHouseCreateSuccessFragment =
                                                          true;
                                                      showCreateHouseModalFragment =
                                                          false;
                                                      setState(() {});
                                                    });
                                                  });
                                                }
                                              });
                                            } catch (e) {
                                              errorMessageCreateHouse =
                                                  e.toString();
                                              createHouseLoading = false;
                                              setState(() {});
                                            }
                                          } else {
                                            createHouseLoading = false;
                                            errorMessageCreateHouse =
                                                "Cannot be empty";
                                            setState(() {});
                                          }
                                        });
                                      },
                                      child: Container(
                                          margin: const EdgeInsets.only(
                                              left: 30,
                                              right: 30,
                                              top: 15,
                                              bottom: 15),
                                          child: createHouseLoading == false
                                              ? const Text("Create House")
                                              : const SizedBox(
                                                  height: 18,
                                                  child: SpinKitRing(
                                                    lineWidth: 2,
                                                    color: Colors.white,
                                                  ),
                                                )),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),

                          // House created fragment
                          Visibility(
                              visible: showHouseCreateSuccessFragment,
                              child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      margin: const EdgeInsets.only(
                                          top: 30, bottom: 10),
                                      child: const Text(
                                        "House Created",
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 25,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    ),
                                    Container(
                                        width:
                                            MediaQuery.of(context).size.width *
                                                0.4,
                                        margin: const EdgeInsets.only(
                                            top: 5, bottom: 15),
                                        child: const Icon(
                                          Icons.check_circle,
                                          color: Colors.green,
                                          size: 60,
                                        )),
                                    Container(
                                      width: MediaQuery.of(context).size.width *
                                          0.8,
                                      margin: const EdgeInsets.only(
                                          top: 5, bottom: 15),
                                      child: const Text(
                                        "You have successfully created the house. It will now be available on the 'My Houses' list.",
                                        style: TextStyle(
                                            color: Colors.grey, fontSize: 15),
                                        textAlign: TextAlign.center,
                                      ),
                                    ),
                                    SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          0.85,
                                      child: ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.green.shade700,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(5),
                                          ),
                                        ),
                                        onPressed: () {
                                          Navigator.pop(context);
                                        },
                                        child: Container(
                                            margin: const EdgeInsets.only(
                                                left: 30,
                                                right: 30,
                                                top: 15,
                                                bottom: 15),
                                            child: const Text("Continue")),
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                  ]))
                        ],
                      ),
                    )));
          });
        });
  }

  @override
  void initState() {
    // TODO: implement initState
    firebaseLogin();
    getHouses();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        backgroundColor: const Color.fromRGBO(12, 12, 12, 1),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.12, left: 30),
                  child: const Text(
                    "My Houses",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 30,
                        fontWeight: FontWeight.bold),
                  ),
                ),

                Container(
                  margin: EdgeInsets.only(
                      top: MediaQuery.of(context).size.height * 0.12, right: 30),
                  child: GestureDetector(
                    onTap: (){
                      showHouseCreationModal();
                    },
                    child: Icon(Icons.add, color: Colors.white,),
                  ),
                ),
              ],
            ),

            loadingHouses == true ? Container(
              width: MediaQuery.of(context).size.width,
              margin: EdgeInsets.only(top: MediaQuery.of(context).size.height * 0.35),
              child: Center(
                child: SpinKitRing(
                  color: Colors.white,
                  lineWidth: 2,
                ),
              ),
            ) :
                Column(
                  children: [
                    Container(
                        margin: const EdgeInsets.only(left: 30),
                        child: houses.isNotEmpty
                            ? Container(
                            height: MediaQuery.of(context).size.height * 0.8,
                            width: MediaQuery.of(context).size.width - 60,
                            child: MediaQuery.removePadding(
                              context: context,
                              removeTop: true,
                              child: ListView.builder(
                                itemCount: housesDetails.length,
                                physics: const BouncingScrollPhysics(),
                                itemBuilder: (context, index){
                                  var data = housesDetails[index];
                                  print(data);
                                  var houseName = data['houseName'];

                                  return HouseCard(houseName);
                                },
                              ),
                            ))
                            : Center(
                          child: Column(
                            children: [
                              Center(
                                child: Container(
                                  margin: EdgeInsets.only(
                                      right: MediaQuery.of(context).size.width *
                                          0.12,
                                      top: MediaQuery.of(context).size.height *
                                          0.15),
                                  child: AspectRatio(
                                      aspectRatio: 1.5,
                                      child: SvgPicture.asset(
                                          "lib/images/no_houses_img.svg")),
                                  width: MediaQuery.of(context).size.width * 0.6,
                                ),
                              ),
                              Container(
                                child: const Text(
                                  "No Houses Here",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 22,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                margin: const EdgeInsets.only(top: 5, bottom: 15),
                                child: const Text(
                                  "Create or join a house below to get started!",
                                  style: TextStyle(color: Colors.grey),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.7,
                                child: ElevatedButton(
                                  onPressed: () {
                                    showHouseCreationModal();
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                    MaterialStateProperty.all<Color>(
                                        Colors.blue.shade700),
                                  ),
                                  child: Container(
                                      margin: const EdgeInsets.only(
                                          left: 30,
                                          right: 30,
                                          top: 12,
                                          bottom: 12),
                                      child: const Text("Create or Join")),
                                ),
                              ),
                            ],
                          ),
                        ))
                  ],
                )


          ],
        ),
      ),
    );
  }
}

class HouseCard extends StatefulWidget {
  var houseName = 'Mountain House';

  HouseCard(house) {
    houseName = house;
  }

  @override
  State<HouseCard> createState() => _HouseCardState();
}

//https://dribbble.com/shots/18300406-Affitto-Real-Estate-App
class _HouseCardState extends State<HouseCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width - 60,
      height: MediaQuery.of(context).size.height * 0.30,
      margin: const EdgeInsets.only(top: 20),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          image: const DecorationImage(
              fit: BoxFit.cover, image: AssetImage("lib/images/house_4.jpg")),
          color: Colors.white),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 30, left: 30),
            width: MediaQuery.of(context).size.width * 0.3,
            child: Text(
              widget.houseName,
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 25,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Container(
            margin: const EdgeInsets.only(left: 20, bottom: 20),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    primary: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15),
                    ),
                  ),
                  onPressed: () {
                    //Navigator.push(context, route)
                  },
                  child: Container(
                      margin: const EdgeInsets.only(
                          left: 20, right: 20, top: 15, bottom: 15),
                      child: const Text(
                        "Manage House",
                        style: TextStyle(
                            color: Colors.black, fontWeight: FontWeight.bold),
                      )),
                ),
                Container(
                  height: 60,
                  width: 60,
                  margin: const EdgeInsets.only(right: 10),
                  child: FlatButton(
                    color: Colors.white.withOpacity(0.3),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(70),
                    ),
                    onPressed: () {},
                    child: Container(
                        margin: const EdgeInsets.only(
                            left: 0, right: 0, top: 0, bottom: 0),
                        child: const Icon(
                          Icons.cancel_presentation,
                          color: Colors.white,
                        )),
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
