import 'dart:ffi';
import 'dart:ui';
import 'package:currencyconverter/Api/api.dart';
import 'package:currencyconverter/models/currencyModel.dart';
import 'package:flutter/material.dart';

class CurrenciesPage extends StatefulWidget {
  const CurrenciesPage({Key? key}) : super(key: key);
  static const routeName = '/currencies';

  @override
  _CurrenciesPageState createState() => _CurrenciesPageState();
}

class _CurrenciesPageState extends State<CurrenciesPage> {
  List<dynamic> items = [];

  @override
  void initState() {
    super.initState();
    Api.loadItems().then((loadedItems) {
      setState(() {
        items = loadedItems;
      });
    });
  }

  currencyPickerContainer(CurrencyModel data) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          Api.currencySymbol = data.symbol;
          Api.currencyName = data.name;
          Api.currencyValue = double.tryParse(data.rate)!;
          Navigator.pop(context);
        },
        child: Container(
            width: 90,
            height: 90,
            decoration: BoxDecoration(
                color: Colors.blueGrey.shade300,
                borderRadius: BorderRadius.all(Radius.circular(20))),
            child: Center(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  data.name,
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    data.symbol,
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ))),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        elevation: 0,
        centerTitle: true,
        foregroundColor: Colors.black,
        backgroundColor: Colors.black,
        title: const Text(
          "Currency Picker",
          style: TextStyle(
            color: Colors.white,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Api.loadItems().then((loadedItems) {
                setState(() {
                  items = loadedItems;
                });
              });
            },
            icon: Icon(
              Icons.cached,
              color: Colors.white,
            ),
          )
        ],
      ), //AppBar
      backgroundColor: Colors.black,
      body: Padding(
        padding: const EdgeInsets.only(top: 0, left: 20, right: 20, bottom: 0),
        child: items.length == 0
            ? const Center(
                child: Text(
                  'No currencies available at the moment\nRefresh',
                  style: TextStyle(
                      color: Colors.white,
                      fontSize: 13,
                      fontWeight: FontWeight.normal),
                  textAlign: TextAlign.center,
                ),
              )
            : GridView.builder(
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  return currencyPickerContainer(items[index]);
                },
              ),
      ),
    );
  }
}
