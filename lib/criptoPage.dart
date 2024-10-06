import 'package:cripto_app/modelsCripto.dart';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'constants.dart';

class criptoScreen extends StatefulWidget {
  criptoScreen({super.key, this.criptoList});
  List<Cripto>? criptoList;

  @override
  State<criptoScreen> createState() => _criptoScreenState();
}

class _criptoScreenState extends State<criptoScreen> {
  List<Cripto>? criptoList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    criptoList = widget.criptoList;
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: blackColor,
        body: SafeArea(
          child: RefreshIndicator(
            color: greenColor,
            backgroundColor: blackColor,
            onRefresh: () async {
              List<Cripto> fereshData = await _getData();
              setState(() {
                criptoList = fereshData;
              });
            },
            child: ListView.builder(
              itemCount: criptoList!.length,
              itemBuilder: (context, index) => _getItemListTile(
                criptoList![index],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _getItemListTile(Cripto cripto) {
    return ListTile(
      title: Text(
        cripto.name!,
        style: TextStyle(color: greenColor),
      ),
      subtitle: Text(
        cripto.symbol!,
        style: TextStyle(color: greyColor),
      ),
      leading: Text(
        cripto.rank!.toString(),
        textAlign: TextAlign.center,
        style: TextStyle(color: greyColor),
      ),
      trailing: SizedBox(
        width: 150,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  cripto.priceUsd!.toStringAsFixed(2),
                  style: TextStyle(color: greyColor, fontSize: 15),
                ),
                Text(
                  cripto.changePercent24Hr!.toStringAsFixed(2),
                  style: TextStyle(
                    color: _getColorText(
                      cripto.changePercent24Hr!,
                    ),
                    fontSize: 14,
                  ),
                ),
              ],
            ),
            SizedBox(
              width: 50,
              child: Center(
                child: _getIconChangePercent(cripto.changePercent24Hr!),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

Widget _getIconChangePercent(double percentChange) {
  return percentChange <= 0
      ? Icon(
          Icons.trending_down,
          size: 24,
          color: Colors.red,
        )
      : Icon(
          Icons.trending_up,
          size: 24,
          color: Colors.green,
        );
}

Color _getColorText(double percentChange) {
  return percentChange >= 0 ? greenColor : redColor;
}

Future<List<Cripto>> _getData() async {
  var respose = await Dio().get('https://api.coincap.io/v2/assets');
  List<Cripto> dataApi = respose.data['data']
      .map<Cripto>((jsonMapObject) => Cripto.fromMapJson(jsonMapObject))
      .toList();
  return dataApi;
}
