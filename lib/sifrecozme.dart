import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:sezarveigenerevernam/model/sozluk.dart';
import 'package:sezarveigenerevernam/vernam/vernam_enc_dec.dart';
import 'package:sezarveigenerevernam/vigenere/vigenere_enc_dec.dart';
import 'Sabitler.dart';
import 'package:http/http.dart' as http;
class Sifrecozme extends StatefulWidget {
  const Sifrecozme({super.key});

  @override
  State<Sifrecozme> createState() => _SifrecozmeState();
}

class _SifrecozmeState extends State<Sifrecozme> {
  late Sozluk characterList;
  final TextEditingController _controllersifreli = TextEditingController();
  final TextEditingController _controllersifrecozulmus = TextEditingController();
  final TextEditingController _controlleranahtarkelime = TextEditingController();
  List<String> anahtarlistem= [];
  List<String> cozumlistem= [];
  List<int> kelimeanlamlarinisay= [];
  String secilianahtar = "Anahtar bilinmiyor";
  String sifresicozulmusveri = "";
  bool durum = false;
  bool analizbittimi = true;
  int seciliindex = 0;
  List<String> alfabe = <String>[
    'a','b','c','ç','d','e',
    'f','g','ğ','h','ı','i',
    'j','k','l','m','n','o',
    'ö','p','r','s','ş','t',
    'u','ü','v','y','z','x','w','q'
  ];
  analizet2()
  async {
    kelimeanlamlarinisay.clear();
    for(int i = 0;i < cozumlistem.length;i++) {
      kelimeanlamlarinisay.add(0);
      var kelimeler = cozumlistem[i].split(' ');
      try {
          if (kelimeler.length >= 3) {
              for (int j = 0; j < 3; j++) {
                await CharacterApi.getCharacters(kelimeler[j]).then((response) {
                  setState(() {
                    Iterable list = json.decode(response.body);
                    kelimeanlamlarinisay[i] += int.parse(list.elementAt(0)['anlam_say']);
                    debugPrint("Kelime anlamlarını say:${list.elementAt(0)['anlam_say']}");
                  });
                });
              }
          }
          else if (kelimeler.length == 2) {
            for (int j = 0; j < 2; j++) {
              await CharacterApi.getCharacters(kelimeler[j]).then((response) {
                setState(() {
                  Iterable list = json.decode(response.body);
                  kelimeanlamlarinisay[i] +=
                      int.parse(list.elementAt(0)['anlam_say']);
                  // debugPrint("Kelime anlamlarını say:${kelimeanlamlarinisay[index]}");
                });
              });
            }
          }
          else if (kelimeler.length == 1) {
            debugPrint("Kelime:${kelimeler[0]}");
            await CharacterApi.getCharacters(kelimeler[0]).then((response) {
              setState(() {
                Iterable list = json.decode(response.body);
                kelimeanlamlarinisay[i] += int.parse(list.elementAt(0)['anlam_say']);
                debugPrint("Kelime anlamlarını say:${kelimeanlamlarinisay[i]}");
              });
            });
          }
          }
        catch(e)
        {
          debugPrint('hata oluştu :$i');
        }

    }
    debugPrint("İşlem bitti");
    int maksimum = kelimeanlamlarinisay[0];
    int maksimumindex = 1;
    for(int i=1;i<kelimeanlamlarinisay.length;i++)
      {
        if(kelimeanlamlarinisay[i] > maksimum)
          {
            maksimum = kelimeanlamlarinisay[i];
            maksimumindex = i+1;
          }
      }
    setState(() {
      analizbittimi = true;
    });
      mesajgonder("Analiz sonucunda tahmini anahtar:$maksimumindex");
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _controllersifreli.text = Sabitler.sifrelimetin;
  }
  List<DropdownMenuItem<String>> get dropdownItems{
    List<DropdownMenuItem<String>> menuItems = [
      const DropdownMenuItem(value: "Anahtar bilinmiyor", child: Text("Anahtar bilinmiyor")),
      for(int i= 1;i<=28;i++)
        DropdownMenuItem(value: "$i", child: Text("$i")),
    ];
    return menuItems;
  }
  metnicoz(String sifrelimetin, int anahtar)
  {
    String cozulmusmetin = "";
//    foreach (String harf in metin)
    for(int i = 0;i<sifrelimetin.length;i++)
    {
      String harf = sifrelimetin[i];
      String karakter = harf.toLowerCase();
     // char karakter = char.Parse(harf.ToString().ToLower());
      if (alfabe.contains(karakter))
      {
        // MessageBox.Show("Harf:" + harf + " karakter:" + karakter);
        int index = 0;
        index = alfabe.indexOf(karakter);
        int otelenmisIndex = (index - anahtar) % alfabe.length;
        if (harf.compareTo('A') >= 0 && harf.compareTo('Z') <= 0)
        {
          // MessageBox.Show("Harf büyük");
          cozulmusmetin += alfabe[otelenmisIndex]..toString().toUpperCase();
        }
        else
        {
          //  MessageBox.Show("Harf küçük");
          cozulmusmetin += alfabe[otelenmisIndex];
        }
      }
      else
      {
        cozulmusmetin += harf;
      }
    }

    return cozulmusmetin;
  }
  mesajgonder(String msj) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(const Duration(seconds: 2), () {
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
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: const Text("Şifre Çözme"),
      ),
      body: analizbittimi? SingleChildScrollView(
        child: Column(
          children: [
            Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(6),
              child: TextFormField(
                controller: _controllersifreli,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (newValue) => _controllersifreli.text = newValue,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.key),// Icons.text_increase_outlined
                    labelText: "Şifrelenmiş metni giriniz",
                    hintText: "Sifrelenmiş metin",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue))),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(8.0),
              child: Divider(),
            ),
            if(Sabitler.algoritmasecimi == 1)
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                        textStyle: const TextStyle(fontSize: 18)
                    ),
                    onPressed: () {

                    },
                    child: const Text('Anahtar Seçimi'),
                  ),
                ),
            if(Sabitler.algoritmasecimi == 1)
              Padding(
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
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: (){
                      if(_controllersifreli.text == "" || _controllersifreli.text == " ")
                      {
                        mesajgonder("Lütfen şifrelenmiş metni giriniz.");
                      }
                      else
                      {
                        if(Sabitler.algoritmasecimi == 2 || Sabitler.algoritmasecimi == 3)
                        {
                          if(_controlleranahtarkelime.text == "" || _controlleranahtarkelime.text == " ")
                          {
                            mesajgonder("Anahtar kelimeyi giriniz");
                          }
                          else
                          {
                            if(Sabitler.algoritmasecimi == 2)
                              {
                                vigenere();
                              }
                            else if(Sabitler.algoritmasecimi == 3)
                            {
                              vernam();
                            }

                          }
                        }
                        else
                          {
                            String sifreliveri = "";

                            int anahtar = 0;
                            cozumlistem.clear();
                            if(secilianahtar == "Anahtar bilinmiyor")
                            {
                              sifreliveri = _controllersifreli.text;
                              for(int anahtar = 1;anahtar < alfabe.length;anahtar++)
                              {
                                cozumlistem.add("${metnicoz(sifreliveri, anahtar)}");
                              }

                              setState(() {

                              });
                              //  apiCagir("merhaba");
                            }
                            else
                            {
                              anahtar = int.parse(secilianahtar);
                              sifreliveri = _controllersifreli.text;
                              sifresicozulmusveri = metnicoz(sifreliveri, anahtar);
                              durum = true;
                              setState(() {
                                _controllersifrecozulmus.text = sifresicozulmusveri;
                              });
                            }
                          }
                      }
                    },
                    icon: const Icon(Icons.lock_open),  //icon data for elevated button
                    label: const Text("Şifre Çöz"), //label text
                  ),
                ),
              if(cozumlistem.isNotEmpty)  Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: ElevatedButton.icon(
                    onPressed: () async {
                      setState(() {
                        analizbittimi = false;
                        analizet2();
                      });

                    },
                    icon: const Icon(Icons.analytics),  //icon data for elevated button
                    label: const Text("Analiz Et"), //label text
                  ),
                )
              ],
            ),
            const Divider(),
            if(durum)Container(
              alignment: Alignment.center,
              padding: const EdgeInsets.all(6),
              child: TextFormField(
                controller: _controllersifrecozulmus,
                keyboardType: TextInputType.multiline,
                maxLines: null,
                onChanged: (newValue) => _controllersifrecozulmus.text = newValue,
                decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.text_increase_outlined),
                    labelText: "Çözülmüş Metin",
                    hintText: "Çözülmüş metin",
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue))),
              ),
            ),
            if(cozumlistem.isNotEmpty)
              const ListTile(
                title: Text("Olası Çözümler",style: TextStyle(color: Colors.red),),

              ),
             for(int i=0;i< cozumlistem.length;i++)
              ListTile(
                  title: Text("${i+1}--> ${cozumlistem[i]}"),
                ),
          ],
        ),
      ):const Center(child: CircularProgressIndicator()),
     // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
  void vigenere() {
    String result ="";
    var shift = _controlleranahtarkelime.text;
    // print(shift);
    var text = _controllersifreli.text;
    //  print(text);
    VigenereCipher enc = VigenereCipher(shift);
   // _result = enc.decrypt(text);
    result = enc.metnicoz(text,shift);
    setState(() {
      durum = true;
      _controllersifrecozulmus.text = result;
    });
  }
  void vernam() {
    String result ="";
    var shift = _controlleranahtarkelime.text;
    // print(shift);
    var text = _controllersifreli.text;
    //  print(text);
    Vernam enc = Vernam();
    // _result = enc.decrypt(text);
    result = enc.metnicoz(text,shift);
    setState(() {
      durum = true;
      _controllersifrecozulmus.text = result;
    });
  }
}

class CharacterApi {
  static Future getCharacters(String gkelime) {
    debugPrint("Gelen kelime:$gkelime");
    final uri = Uri.parse('https://sozluk.gov.tr/gts?ara=$gkelime');
    debugPrint("dönen sonuc:${http.get(uri)}");
    return http.get(uri);
  }
}
