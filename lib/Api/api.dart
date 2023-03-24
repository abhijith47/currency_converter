import 'dart:convert';
import 'dart:developer';
import 'dart:io';
import 'package:currencyconverter/models/currencyModel.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';

class Api {
  static String currencySymbol = 'INR';
  static String currencyName = 'Indian Rupee';
  static double currencyValue = 1.0;
  static getSymbols() async {
    if (await Permission.storage.request().isGranted) {
      if (await connectivityCheck()) {
        const String baseUrl = "https://api.apilayer.com/exchangerates_data/";
        const String apiKey = 'xLXevGcZfaFoluYXmL5Nb76gz7urqxLv';
        try {
          final url = Uri.parse(baseUrl + 'symbols?' + "apikey=${apiKey}");
          var response = await http.get(url);
          if (response.statusCode == 200) {
            var data = jsonDecode(response.body);
            if (data['symbols'].length > 0) {
              try {
                final url2 = Uri.parse(
                    baseUrl + 'latest?' + 'base=INR&' + "apikey=${apiKey}");
                var response2 = await http.get(url2);
                if (response2.statusCode == 200) {
                  var data2 = jsonDecode(response2.body);
                  if (data2['rates'].length > 0) {
                    final currencyRates = data2['rates'];
                    final currencyNames = data['symbols'];
                    log('---');
                    final currencies =
                        await currencyRates.entries.map<CurrencyModel>((entry) {
                      final name = entry.key.toString();
                      final currency = entry.value.toString();
                      final currencyName = currencyNames[name].toString();
                      return CurrencyModel(
                          name: currencyName, rate: currency, symbol: name);
                    }).toList();
                    log(currencies.toString());
                    _saveItems(currencies);
                  }
                } else {
                  debugPrint('no data received');
                }
              } catch (e) {
                debugPrint(e.toString());
              }
            }
          } else {
            debugPrint('no data received');
          }
        } catch (e) {
          debugPrint(e.toString());
        }
      } else {
        debugPrint('no internet');
      }
    }
  }

  static Future<File> _getItemsFile() async {
    final directory = await getApplicationDocumentsDirectory();
    final itemsFilePath = "${directory.path}/currency.json";
    return File(itemsFilePath);
  }

  static Future<void> _saveItems(List<CurrencyModel> items) async {
    final itemsFile = await _getItemsFile();
    final itemsJson = items.map((item) => item.toJson()).toList();
    final itemsJsonString = jsonEncode(itemsJson);
    await itemsFile.writeAsString(itemsJsonString);
  }

  static Future<List<CurrencyModel>> loadItems() async {
    final itemsFile = await _getItemsFile();
    final itemsJsonString = await itemsFile.readAsString();
    final List<dynamic> jsonList = jsonDecode(itemsJsonString);
    final items = jsonList
        .map((json) => CurrencyModel(
              name: json['name'],
              rate: json['rate'],
              symbol: json['symbol'],
            ))
        .toList();
    return items;
  }

  static Future<bool> connectivityCheck({int seconds = 10}) async {
    //to check internet connectivity on device
    //creating a custom internet checker which returns a bool
    //checking if a response is getting from google.com with 10 seconds timeout
    try {
      Uri url = Uri.parse('https://www.google.com/');
      final response = await http.get(url).timeout(Duration(seconds: seconds));
      if (response.statusCode == 200) {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      return false;
    }
  }
}
