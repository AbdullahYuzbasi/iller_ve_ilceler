import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:iller_ve_ilceler/il.dart';
import 'package:iller_ve_ilceler/ilce.dart';

class AnaSayfa extends StatefulWidget {
  @override
  State<AnaSayfa> createState() => _AnaSayfaState();
}

class _AnaSayfaState extends State<AnaSayfa> {
  List<Il> iller = [];

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _jsonCozumle();
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: Text("Iller ve Ilceler"),
      ),
      body: ListView.builder(
          itemCount: iller.length,
          itemBuilder: _listeOgesiniOlustur,
      ),
    );
  }

  Widget _listeOgesiniOlustur(BuildContext context, int index) {
    return Card(
      child: ExpansionTile(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(iller[index].isim),
            Text(iller[index].plakaKodu),
          ],
        ),
        leading: Icon(Icons.location_city),
        //trailing: Text(iller[index].plakaKodu), plaka kodu yazmazsa orada ok olacak
        children: iller[index].ilceler.map((ilce) {
          return ListTile(
            title: Text(ilce.isim),
          );
        }).toList(),
      ),
    );
  }

  void _jsonCozumle() async {
    String jsonString = await rootBundle.loadString("assets/iller_ilceler.json");//jsondakileri string turunde okumak icin
    //mape cevirmek istiyoruz cunku json icin en kullanisli yapi map yapisidir.Bunuda cozumleyerek yapiyoruz(json.decode())
    Map<String, dynamic> illerMap = json.decode(jsonString);

    for(String plakaKodu in illerMap.keys){  //map icinde map old. icin bu yeterli degil devam ediyoruz.
      Map<String, dynamic> ilMap = illerMap[plakaKodu]; //icerdeki map
      String ilIsmi = ilMap["name"];
      Map<String,dynamic> ilcelerMap = ilMap["districts"]; //'cerdek' mapin anahtar kelimesi ile ulasiyoruz.
                                                            //burada ilceleri map halinde elimizde tutuyoruz.

      List<Ilce> tumIlceler = [];
      for(String ilceKodu in ilcelerMap.keys){  //ilcelerin anahtarlarini("01_03" gibisinden) tek tek gezip listeye atamak icin yapiyoruz
        Map<String,dynamic> ilceMap = ilcelerMap[ilceKodu];  //yine iceride map oldugundan yeni map olusturuyoruz.
        String ilceIsmi = ilceMap["name"];
        Ilce ilce = Ilce(ilceIsmi); //nesne olusturuyoruz.
        tumIlceler.add(ilce);
      }
      Il il = Il(ilIsmi,plakaKodu, tumIlceler);
      iller.add(il);
    }
    setState(() {});
  }

}
