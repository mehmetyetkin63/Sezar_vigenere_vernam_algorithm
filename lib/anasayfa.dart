import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:sezarveigenerevernam/Sabitler.dart';
import 'package:sezarveigenerevernam/algoritmasecimi.dart';
import 'package:sezarveigenerevernam/sesimetnedonustur.dart';
import 'package:sezarveigenerevernam/sifrecozme.dart';
import 'package:sezarveigenerevernam/vernam/vernam_enc_dec.dart';
import 'package:sezarveigenerevernam/vigenere/vigenere_enc_dec.dart';

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  final TextEditingController _controller = TextEditingController();
  final TextEditingController _controlleranahtarkelime = TextEditingController();
  final TextEditingController _controllersifre = TextEditingController();
  List<String> anahtarlistem= [];
  String secilianahtar = "1";
  String sifrelenmisveri = "";
  String baslik = "";
  String anahtarsecimibaslik = "Anahtar Seçimi";
  bool durum = false;
  List<String> alfabe = <String>[
    'a','b','c','ç','d','e',
    'f','g','ğ','h','ı','i',
    'j','k','l','m','n','o',
    'ö','p','r','s','ş','t',
    'u','ü','v','y','z','x','w','q'
  ];
  List<String> list = <String>['Sezar Şifreleme Algoritması', 'Vigenere Şifreleme Algoritması', 'Vernam Şifreleme Algoritması'];
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      for(int i= 1;i<=alfabe.length-1;i++)
        DropdownMenuItem(value: "$i", child: Text("$i")),
    ];
    return menuItems;
  }
  int randomsayiuret() {
    final random = Random();
    return random.nextInt(alfabe.length-2) + 1;
  }
  metnisifrele(String metin, int anahtar)
  {
    String sifreliMetin = "";

//    foreach (String harf in metin)
    for(int i = 0;i<metin.length;i++)
    {
      String harf = metin[i];
      String karakter = harf.toLowerCase();
     // char karakter = char.Parse(harf.ToString().ToLower());
      if (alfabe.contains(karakter))
      {
        // MessageBox.Show("Harf:" + harf + " karakter:" + karakter);
        int index = 0;
        index = alfabe.indexOf(karakter);
        int otelenmisIndex = (index + anahtar) % alfabe.length;
        if (harf.compareTo('A') >= 0 && harf.compareTo('Z') <= 0)
        {
          // MessageBox.Show("Harf büyük");
          sifreliMetin += alfabe[otelenmisIndex]..toString().toUpperCase();
        }
        else
        {
          //  MessageBox.Show("Harf küçük");
          sifreliMetin += alfabe[otelenmisIndex];
        }
      }
      else
      {
        sifreliMetin += harf;
      }
    }

    return sifreliMetin;
  }
varnamiacinanahtarolustur()
{
  _controlleranahtarkelime.text = "";
  for(int i=0;i<_controller.text.length;i++)
    {
      var intValue = Random().nextInt(alfabe.length);
      _controlleranahtarkelime.text += alfabe[intValue];
    }
  vernamsifreleme();
}
  mesajgonder(String msj) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Text(
              msj,
              textAlign: TextAlign.center,
            ),
          );
        });
  }
  mesajgonder2(String msj) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 2), () {
            varnamiacinanahtarolustur();
            Navigator.of(context).pop(true);
          });
          return AlertDialog(
            title: Text(
              msj,
              textAlign: TextAlign.center,
            ),
          );
        });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    Timer(const Duration(seconds:2),(){
      setState(() {
        algoritmasecimi();
      });
    });

  }
  void algoritmasecimi()
  {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlgoritmaSecimi();
        }).then((val) {
       setState(() {
         debugPrint("Seçim yapıldı yapılan seçim:${Sabitler.algoritmasecimi}");
         baslik = list[Sabitler.algoritmasecimi-1];
         if(Sabitler.algoritmasecimi==1)
           {
             anahtarsecimibaslik = "Anahtar Seçimi";
           }
         else
           {
             anahtarsecimibaslik = "Anahtar Kelime";
           }
       });
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(baslik),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(6),
              child: TextFormField(
                controller: _controller,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (newValue) => _controller.text = newValue,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.text_increase_outlined),
                    labelText: "Şifrelenecek metni giriniz",
                    hintText: "Sifrelencek metin",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue))),
              ),
            ),
            if(MediaQuery.of(context).size.width>600)
              Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 18)
                  ),
                  onPressed: () {
                    txtdosyasindanoku();
                  },
                  child: const Text('Dosyadan Oku'),
                ),
                ElevatedButton.icon(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const SesiMetneDonustur();
                        }).then((val) {
                      _controller.text = Sabitler.metnedonusenses;
                    });
                  },
                  icon: const Icon(Icons.mic),  //icon data for elevated button
                  label: const Text("Ses"), //label text
                ),
                ElevatedButton.icon(
                  onPressed: (){
                    setState(() {
                      _controller.text = "";
                      durum =false;
                      sifrelenmisveri = "";
                      secilianahtar = "1";
                      _controlleranahtarkelime.text = "";
                      Sabitler.anahtar = secilianahtar;
                      Sabitler.sifrelenecekmetin = "";
                      Sabitler.sifrelimetin = sifrelenmisveri;
                    });
                  },
                  icon: const Icon(Icons.cleaning_services_sharp),  //icon data for elevated button
                  label: const Text("Temizle"), //label text
                )
              ],
            ),
            if(MediaQuery.of(context).size.width<=600)
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                      textStyle: const TextStyle(fontSize: 18)
                  ),
                  onPressed: () {
                    txtdosyasindanoku();
                  },
                  child: const Text('Dosyadan Oku'),
                ),
            if(MediaQuery.of(context).size.width<=600)
              ElevatedButton.icon(
                  onPressed: (){
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const SesiMetneDonustur();
                        }).then((val) {
                      _controller.text = Sabitler.metnedonusenses;
                    });
                  },
                  icon: const Icon(Icons.mic),  //icon data for elevated button
                  label: const Text("Ses"), //label text
                ),
            if(MediaQuery.of(context).size.width<=600)
              ElevatedButton.icon(
                  onPressed: (){
                    setState(() {
                      _controller.text = "";
                      durum =false;
                      sifrelenmisveri = "";
                      secilianahtar = "1";
                      _controlleranahtarkelime.text = "";
                      Sabitler.anahtar = secilianahtar;
                      Sabitler.sifrelenecekmetin = "";
                      Sabitler.sifrelimetin = sifrelenmisveri;
                    });
                  },
                  icon: const Icon(Icons.cleaning_services_sharp),  //icon data for elevated button
                  label: const Text("Temizle"), //label text
                ),

            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 18)
                ),
                onPressed: () {
                      algoritmasecimi();
                },
                child:  const Text("Algoritma Seçimi"),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    textStyle: const TextStyle(fontSize: 18)
                ),
                onPressed: () {

                },
                child:  Text(anahtarsecimibaslik),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if(Sabitler.algoritmasecimi == 1)   Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton(
                      value: secilianahtar,
                      onChanged: (String? newValue){
                        setState(() {
                          secilianahtar = newValue!;
                        });
                      },
                      items: dropdownItems
                  ),
                ),
                if(Sabitler.algoritmasecimi == 1)   Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 18)
                    ),
                    onPressed: () {
                      setState(() {
                        secilianahtar = dropdownItems[randomsayiuret()].value as String;
                      });
                    },
                    child: const Text('Rastgele Ata'),
                  ),
                ),
              ],
            ),
            if(Sabitler.algoritmasecimi == 2 || Sabitler.algoritmasecimi == 3)
              Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(3),
                child:  TextFormField(
                  controller: _controlleranahtarkelime,
                   keyboardType: TextInputType.text,
                   maxLines: null,
                  onChanged: (newValue) => _controlleranahtarkelime.text = newValue,
                  decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.text_increase_outlined),
                      labelText: "Anahtar kelimeyi giriniz",
                      hintText: "Anahtar kelime",
                      border: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.blue))),
                ),
              ),
            ElevatedButton.icon(
              onPressed: (){
                if(_controller.text == "" || _controller.text == " ")
                {
                  mesajgonder("Lütfen şifrelenecek metni giriniz.");
                }
                else
                {
                  if(Sabitler.algoritmasecimi == 3)
                  {
                    if(_controlleranahtarkelime.text == "" || _controlleranahtarkelime.text == " ")
                    {
                      mesajgonder2("Anahtar metni girilmdiği için anahtar oluşturuluyor");
                    }
                    else
                    {
                      if(_controlleranahtarkelime.text.length != _controller.text.length)
                        {
                          mesajgonder("Anahtar uzunluğu metin uzunluğu kadar olmalıdır.");
                        }
                      else
                        {
                          vernamsifreleme();
                        }
                    }
                  }
                  if(Sabitler.algoritmasecimi == 2)
                    {
                      if(_controlleranahtarkelime.text == "" || _controlleranahtarkelime.text == " ")
                        {
                          mesajgonder("Anahtar kelimeyi giriniz");
                        }
                      else
                        {
                          vigeneresifreleme();
                        }
                    }
                  else if(Sabitler.algoritmasecimi == 1)
                    {
                      String veri = "";

                      int anahtar = 0;
                      anahtar = int.parse(secilianahtar);
                      veri = _controller.text;
                      sifrelenmisveri = metnisifrele(veri, anahtar);
                      durum = true;
                      setState(() {
                        _controllersifre.text = sifrelenmisveri;
                        Sabitler.anahtar = secilianahtar;
                        Sabitler.sifrelenecekmetin = veri;
                        Sabitler.sifrelimetin = sifrelenmisveri;
                      });
                    }

                }
              },
              icon: const Icon(Icons.lock),  //icon data for elevated button
              label: const Text("Şifrele"), //label text
            ),
            const Divider(),
            if(durum)Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(6),
              child: TextFormField(
                controller: _controllersifre,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (newValue) => _controller.text = newValue,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.key),
                    labelText: "Şifreli metin",
                    hintText: "Sifreli metin",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue))),
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        tooltip: 'Metni Çöz',
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const Sifrecozme()),
          );
        },
        child: const Icon(Icons.lock_open_rounded),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );


  }

   txtdosyasindanoku() async {
     String okunanmetin = "";
     okunanmetin = await rootBundle.loadString('assets/benim_dosyam.txt');
     setState(() {
       _controller.text = okunanmetin;
     });
  }
  //vigenere cipher algoritması
  void vigeneresifreleme() {
    String result = "";
    //_result = _keyValue.text;
    var shift = _controlleranahtarkelime.text;
    // print(shift);
    var text = _controller.text;
    //  print(text);
    VigenereCipher enc = VigenereCipher(shift);
   // _result = enc.encrypt(text);
    result = enc.metnisifrele(text,shift);
    Sabitler.sifrelimetin = result;
    sifrelenmisveri = result;
    durum = true;
    setState(() {
      _controllersifre.text = sifrelenmisveri;
      Sabitler.anahtar = secilianahtar;
      Sabitler.sifrelenecekmetin = _controller.text;
      Sabitler.sifrelimetin = sifrelenmisveri;
    });

  }
  void vernamsifreleme() {
    String result = "";
    //_result = _keyValue.text;
    var shift = _controlleranahtarkelime.text;
    // print(shift);
    var text = _controller.text;
    //  print(text);
    // _result = enc.encrypt(text);
    result = Vernam().metnisifrele(text,shift);
    Sabitler.sifrelimetin = result;
    sifrelenmisveri = result;
    durum = true;
    setState(() {
      _controllersifre.text = sifrelenmisveri;
      Sabitler.anahtar = secilianahtar;
      Sabitler.sifrelenecekmetin = _controller.text;
      Sabitler.sifrelimetin = sifrelenmisveri;
    });

  }
}
