import 'package:connectivity_widget/connectivity_widget.dart';
import 'package:currencyconverter/Api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_awesome_calculator/flutter_awesome_calculator.dart';

class Calculator extends StatefulWidget {
  static const routeName = '/calculator';
  @override
  _CalculatorState createState() => _CalculatorState();
}

class _CalculatorState extends State<Calculator> {
  dynamic inputvalue = 0;

  @override
  void initState() {
    super.initState();
    Api.getSymbols();
  }

  currencyPickerContainer(bool target) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        onTap: () {
          if (target) {
            Navigator.pushNamed(
              context,
              '/currencies',
            ).then((value) {
              setState(() {});
            });
          }
        },
        child: Container(
            width: 50,
            height: 50,
            decoration: BoxDecoration(
                color: target ? Colors.blue.shade100 : Colors.green.shade100,
                borderRadius: const BorderRadius.all(Radius.circular(8))),
            child: Center(child: Text(!target ? 'INR' : Api.currencySymbol))),
      ),
    );
  }

  currencyContainer(bool target) {
    return Expanded(
      child: InkWell(
        onTap: () {
          if (target) {
            Navigator.pushNamed(
              context,
              '/currencies',
            ).then((value) {
              setState(() {});
            });
          }
        },
        child: Container(
            height: 50,
            decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(8))),
            child: Center(
                child: Text(
                    target ? format().toString() : inputvalue.toString()))),
      ),
    );
  }

  format() {
    if (inputvalue != 0 && inputvalue != null && inputvalue != '') {
      return (double.tryParse(inputvalue.toString())! * Api.currencyValue)
          .toString();
    } else {
      return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          elevation: 0,
          centerTitle: false,
          foregroundColor: Colors.black,
          backgroundColor: Colors.black,
          title: const Text(
            "Currency Calculator",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          actions: [
            ConnectivityWidget(
                builder: (context, isOnline) => Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Row(
                              children: [
                                Icon(
                                  isOnline ? Icons.wifi : Icons.wifi_off,
                                  color: Colors.white,
                                  size: 15,
                                ),
                                Text(
                                  "${isOnline ? 'Online' : 'Offline'}",
                                  style: TextStyle(
                                      fontSize: 12, color: Colors.white),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ))
          ],
        ), //AppBar

        backgroundColor: Colors.black,
        body: SizedBox(
          height: MediaQuery.of(context).size.height,
          width: MediaQuery.of(context).size.width,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        currencyPickerContainer(false),
                        currencyContainer(false)
                      ],
                    ),
                    Icon(
                      Icons.swap_vert_circle,
                      color: Colors.blue.shade300,
                    ),
                    Row(
                      children: [
                        currencyPickerContainer(true),
                        currencyContainer(true)
                      ],
                    ),
                    Api.currencySymbol == 'INR'
                        ? const SizedBox()
                        : Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Text(
                                  '1 Indian Rupee is ${Api.currencyValue} ${Api.currencyName}',
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ],
                          ),
                  ],
                ),
              ),
              FlutterAwesomeCalculator(
                showAnswerField: true,
                context: context,
                digitsButtonColor: Colors.white,
                backgroundColor: Colors.black,
                expressionAnswerColor: Colors.white,
                onChanged: (answer, expression) {
                  setState(() {
                    inputvalue = answer;
                  });
                },
              ),
            ],
          ),
        ));
  }
}
