import 'package:cripto_app/criptoPage.dart';
import 'package:cripto_app/modelsCripto.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:dio/dio.dart';

void main() {
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: app(),
  ));
}

class app extends StatefulWidget {
  const app({super.key});

  @override
  State<app> createState() => _appState();
}

class _appState extends State<app> {
  List<Cripto>? criptoList;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: Colors.black,
        body: SafeArea(
          child: Column(
            children: [
              Image.asset(
                'images/t.png',
                height: 590,
              ),
              Text(
                '... در حال دریافت اطلاعات از سرور ',
                style: TextStyle(
                    color: Colors.white, fontFamily: 'mh', fontSize: 26),
              ),
              SizedBox(
                height: 60,
              ),
              SpinKitWave(
                size: 30,
                color: Colors.white,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void getData() async {
    var respose = await Dio().get('https://api.coincap.io/v2/assets');
    List<Cripto> criptoList = respose.data['data']
        .map((jsonMapObject) => Cripto.fromMapJson(jsonMapObject))
        .toList()
        .cast<Cripto>();
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => criptoScreen(
          criptoList: criptoList,
        ),
      ),
    );
  }
}
