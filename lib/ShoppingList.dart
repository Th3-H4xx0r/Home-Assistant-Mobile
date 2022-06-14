import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';

class ShoppingList extends StatefulWidget {
  var houseCode = '';

  ShoppingList(code) {
    houseCode = code.toString();
  }

  @override
  State<ShoppingList> createState() => _ShoppingListState();
}

class _ShoppingListState extends State<ShoppingList> {
  // For shop creation
  var shopNameController = TextEditingController();
  var errorMessageCreateShop = "";
  var createShopLoading = false;

  // For item creation
  var itemNameController = TextEditingController();
  var errorMessageCreateItem = "";
  var createItemLoading = false;

  Future updateShoppingList() async {}

  Future showAddShopBottomSheet() async {
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                height: 5,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(2)),
                              ),
                              Container(
                                margin:
                                    const EdgeInsets.only(top: 30, bottom: 10),
                                child: const Text(
                                  "Create Shop",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 15),
                                child: const Text(
                                  "Create a shop that you can put items in later",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),
                              Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(50, 50, 55, 1),
                                    borderRadius: BorderRadius.circular(10)),
                                height: 45,
                                child: TextField(
                                  controller: shopNameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      hintText: "Shop Name",
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                              ),

                              // Error Message
                              Container(
                                child: Text(
                                  errorMessageCreateShop,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),

                              Container(
                                margin:
                                    const EdgeInsets.only(top: 15, bottom: 20),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue.shade700,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      createShopLoading = true;
                                      setState(() {});

                                      // Add to firebase
                                      if (shopNameController.text != '') {
                                        try {
                                          FirebaseFirestore.instance
                                              .collection('Houses')
                                              .doc(widget.houseCode)
                                              .collection("Shopping List")
                                              .doc()
                                              .set({
                                            'shopName': shopNameController.text,
                                            'type': "shop"
                                          }).then((value) async {
                                            errorMessageCreateShop = "";
                                            createShopLoading = false;
                                            shopNameController.clear();
                                            Navigator.pop(context);
                                          });
                                        } catch (e) {
                                          errorMessageCreateShop = e.toString();
                                          createShopLoading = false;
                                          setState(() {});
                                        }
                                      } else {
                                        createShopLoading = false;
                                        errorMessageCreateShop =
                                            "Cannot be empty";
                                        setState(() {});
                                      }
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 30,
                                            right: 30,
                                            top: 15,
                                            bottom: 15),
                                        child: createShopLoading == false
                                            ? const Text("Create Shop")
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
                        ],
                      ),
                    )));
          });
        });
  }

  Future showAddItemBottomSheet(shopName) async {
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
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Container(
                                margin: const EdgeInsets.only(top: 10),
                                height: 5,
                                width: MediaQuery.of(context).size.width * 0.3,
                                decoration: BoxDecoration(
                                    color: Colors.grey,
                                    borderRadius: BorderRadius.circular(2)),
                              ),

                              Container(
                                margin:
                                    const EdgeInsets.only(top: 30, bottom: 10),
                                child: const Text(
                                  "Add Item to List",
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 25,
                                      fontWeight: FontWeight.bold),
                                ),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width * 0.8,
                                margin:
                                    const EdgeInsets.only(top: 5, bottom: 15),
                                child: const Text(
                                  "Add an item to the list",
                                  style: TextStyle(
                                      color: Colors.grey, fontSize: 15),
                                  textAlign: TextAlign.center,
                                ),
                              ),

                              Container(
                                width: MediaQuery.of(context).size.width * 0.85,
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.only(top: 20),
                                decoration: BoxDecoration(
                                    color: const Color.fromRGBO(50, 50, 55, 1),
                                    borderRadius: BorderRadius.circular(10)),
                                height: 45,
                                child: TextField(
                                  controller: itemNameController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: InputDecoration(
                                      hintText: "Item Name",
                                      hintStyle:
                                          const TextStyle(color: Colors.grey),
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.circular(10),
                                      )),
                                ),
                              ),

                              // Error Message
                              Container(
                                child: Text(
                                  errorMessageCreateItem,
                                  style: const TextStyle(color: Colors.red),
                                ),
                              ),

                              Container(
                                margin:
                                    const EdgeInsets.only(top: 15, bottom: 20),
                                child: SizedBox(
                                  width:
                                      MediaQuery.of(context).size.width * 0.85,
                                  child: ElevatedButton(
                                    style: ElevatedButton.styleFrom(
                                      primary: Colors.blue.shade700,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(5.0),
                                      ),
                                    ),
                                    onPressed: () async {
                                      createItemLoading = true;
                                      setState(() {});

                                      // Add to firebase
                                      if (itemNameController.text != '') {
                                        try {
                                          FirebaseFirestore.instance
                                              .collection('Houses')
                                              .doc(widget.houseCode)
                                              .collection("Shopping List")
                                              .doc()
                                              .set({
                                            'shopName': shopName,
                                            'type': "item",
                                            'itemName': itemNameController.text,
                                            'checked': false,
                                          }).then((value) async {
                                            errorMessageCreateItem = "";
                                            createItemLoading = false;
                                            itemNameController.clear();
                                            Navigator.pop(context);
                                          });
                                        } catch (e) {
                                          errorMessageCreateItem = e.toString();
                                          createItemLoading = false;
                                          setState(() {});
                                        }
                                      } else {
                                        createItemLoading = false;
                                        errorMessageCreateItem =
                                            "Cannot be empty";
                                        setState(() {});
                                      }
                                    },
                                    child: Container(
                                        margin: const EdgeInsets.only(
                                            left: 30,
                                            right: 30,
                                            top: 15,
                                            bottom: 15),
                                        child: createItemLoading == false
                                            ? const Text("Add Item")
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
                        ],
                      ),
                    )));
          });
        });
  }

  Future showDeleteShopConfirmation(shop) async {
    AwesomeDialog(
      context: context,
      dialogType: DialogType.QUESTION,
      animType: AnimType.BOTTOMSLIDE,
      dialogBackgroundColor: Colors.white.withOpacity(0.2),
      titleTextStyle: const TextStyle(color: Colors.white, fontSize: 25),
      descTextStyle: const TextStyle(color: Colors.white),
      title: 'Delete Shop?',
      desc: 'Are you sure you want to remove this shop from the shopping list? It will delete all items for the shop as well.',
      btnCancelOnPress: () {},
      btnOkOnPress: () {
        FirebaseFirestore.instance.collection("Houses").doc(widget.houseCode)
            .collection("Shopping List").where('shopName', isEqualTo: shop)
            .get()
            .then((value) {
          value.docs.forEach((element) {
            FirebaseFirestore.instance.collection("Houses").doc(
                widget.houseCode).collection("Shopping List")
                .doc(element.id)
                .delete();
          });
        });
      }
        //FirebaseFirestore.instance.collection("Houses").doc(widget.houseCode).collection("Shopping List").where("shopName", isEqualTo: shop)
    ).show();
  }

  Future toggleCheckItem(id, current) async {
    FirebaseFirestore.instance.collection("Houses").doc(widget.houseCode).collection("Shopping List").doc(id).update({
      "checked": !current,
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(12, 12, 12, 1),
      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color.fromRGBO(12, 12, 12, 1),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            CupertinoIcons.back,
            color: Colors.white,
          ),
        ),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                margin: const EdgeInsets.only(left: 30, top: 20),
                child: const Text(
                  "Shopping List",
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 30),
                ),
              ),

              Container(
                margin: const EdgeInsets.only(right: 10, top: 20),
                child: IconButton(
                    onPressed: (){
                      showAddShopBottomSheet();
                    },
                    icon: const Icon(Icons.add, color: Colors.white,)
                ),
              ),
            ],
          ),

          Container(
              height: MediaQuery.of(context).size.height * 0.8,
              child: StreamBuilder(
                stream: FirebaseFirestore.instance
                    .collection("Houses")
                    .doc(widget.houseCode)
                    .collection("Shopping List")
                    .snapshots(),
                builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                  var data = snapshot.data?.docs ?? [];
                  print(data);

                  if (data.isEmpty) {
                    return Container(
                      margin: EdgeInsets.only(
                          top: MediaQuery.of(context).size.height * 0.23),
                      child: Center(
                        child: Column(
                          children: [
                            Container(
                              width: MediaQuery.of(context).size.width * 0.5,
                              child: AspectRatio(
                                  aspectRatio: 1.5,
                                  child: SvgPicture.asset(
                                      "lib/images/shopping_list_1.svg")),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 20),
                              child: const Text(
                                "Nothing Here",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                            Container(
                              margin: const EdgeInsets.only(top: 5),
                              child: const Text(
                                "Create your first shopping\nlist item below",
                                style:
                                    TextStyle(color: Colors.grey, fontSize: 15),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            FlatButton(
                                onPressed: () {
                                  showAddShopBottomSheet();
                                },
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(5),
                                ),
                                color: Colors.blue.shade700,
                                child: Container(
                                  padding: const EdgeInsets.all(10),
                                  child: const Text(
                                    "Create Item",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )),
                          ],
                        ),
                      ),
                    );
                  } else {
                    return ListView.builder(
                        itemCount: data.length,
                        physics: const BouncingScrollPhysics(),
                        itemBuilder: (context, index) {
                          var document = data[index];
                          var itemsForShop = [];

                          for (var x = 0; x < data.length; x++) {
                            if (data[x]['type'] == 'item' &&
                                data[x]['shopName'] == document['shopName']) {
                              itemsForShop.add(data[x]);
                            }
                          }

                          if (document['type'] == 'shop') {
                            return Container(
                                margin:
                                    const EdgeInsets.only(left: 15, top: 30),
                                child: Column(
                                  children: [
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Row(
                                          children: [
                                            Container(
                                              height: 50,
                                              width: 50,
                                              decoration: BoxDecoration(
                                                  borderRadius:
                                                  BorderRadius.circular(30),
                                                  color: Colors.blue.shade700),
                                              child: const Icon(
                                                Icons.shopping_bag_outlined,
                                                color: Colors.white,
                                              ),
                                            ),
                                            Container(
                                              margin: const EdgeInsets.only(left: 10),
                                              child: Text(
                                                document['shopName'].toString(),
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 18),
                                              ),
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [

                                            Container(
                                              child: IconButton(
                                                onPressed: (){
                                                  showDeleteShopConfirmation(document['shopName']);
                                                },
                                                icon: const Icon(Icons.delete, color: Colors.white,),
                                              ),
                                            ),

                                            Container(
                                              child: IconButton(
                                                onPressed: (){
                                                  showAddItemBottomSheet(document['shopName']);
                                                },
                                                icon: const Icon(Icons.shopping_cart_checkout, color: Colors.white,),
                                              ),
                                            ),

                                          ],
                                        ),

                                      ],
                                    ),
                                    ListView.builder(
                                      shrinkWrap: true,
                                        physics: const NeverScrollableScrollPhysics(),
                                        itemCount: itemsForShop.length,
                                        itemBuilder: (context, index1) {
                                          return Dismissible(
                                              key: UniqueKey(),
                                              onDismissed: (direction){
                                                Future.delayed(const Duration(milliseconds: 600)).then((value){
                                                  FirebaseFirestore.instance.collection("Houses").doc(widget.houseCode).collection("Shopping List").doc(itemsForShop[index1].id).delete();
                                                });
                                              },
                                              child: Container(
                                                height: 60,
                                                margin: const EdgeInsets.only(
                                                    left: 15, right: 15, top: 10),
                                                width: MediaQuery.of(context)
                                                    .size
                                                    .width -
                                                    60,
                                                decoration: BoxDecoration(
                                                    borderRadius:
                                                    BorderRadius.circular(10),
                                                    color: Colors.white
                                                        .withOpacity(0.15)),
                                                child: Row(
                                                  mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                                  children: [
                                                    Container(
                                                      margin: const EdgeInsets.only(
                                                          left: 20),
                                                      child: Text(
                                                        itemsForShop[index1]['itemName'].toString(),
                                                        style: const TextStyle(
                                                            color: Colors.white),
                                                      ),
                                                    ),
                                                    Container(
                                                      child: Checkbox(
                                                        value: itemsForShop[index1]['checked'],
                                                        checkColor: Colors.white,
                                                        activeColor: Colors.blue.shade700,
                                                        onChanged: (val) {
                                                          toggleCheckItem(itemsForShop[index1].id, itemsForShop[index1]['checked']);
                                                        },
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                              )
                                          );
                                        })
                                  ],
                                ));
                          } else {
                            return Text("NONE");
                          }
                        });
                  }
                },
              )),
        ],
      ),
    );
  }
}
