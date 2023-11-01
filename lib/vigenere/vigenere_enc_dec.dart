import 'package:flutter/material.dart';

class VigenereCipher {
  String key;
  VigenereCipher(this.key);
  List<String> alfabe = <String>[
    'a','b','c','ç','d','e',
    'f','g','ğ','h','ı','i',
    'j','k','l','m','n','o',
    'ö','p','r','s','ş','t',
    'u','ü','v','y','z'
  ];
  List<int> kaydirilacakliste = [];
  metnisifrele(String metin, String anahtarkelime)
  {
    String yenianahtarliliste = "";
    String yenianahtarliliste2 = "";
    yenianahtarliliste = metin;
    String sifreliMetin = "";

    if(metin.length >= anahtarkelime.length) {
      int mod = (metin.length % anahtarkelime.length) as int;

     for(int i=0;i<mod;i++)
       {
         yenianahtarliliste += "a";
       }
      debugPrint("mod:${mod}\nyeni anahtar liste:${yenianahtarliliste}");
      debugPrint("hata burda mı");
     //   int ksayisi = int.parse((int.parse(yenianahtarliliste.length as String) / int.parse(anahtarkelime.length as String)) as String);
      debugPrint("hata burda mı2");
      int sayac =0;
      while(sayac<yenianahtarliliste.length)
        {
          for(int i=0;i<anahtarkelime.length;i++)
          {
            yenianahtarliliste2 += anahtarkelime[i];
            sayac++;
          }
        }

    }
    kaydirilacakliste.clear();
    //kaydirma listesini oluşturma
    for(int i = 0;i<yenianahtarliliste2.length;i++)
    {
      String harf = yenianahtarliliste2[i];
      String karakter = harf.toLowerCase();
      // char karakter = char.Parse(harf.ToString().ToLower());
      if (alfabe.contains(karakter))
      {
        int index = 0;
        index = alfabe.indexOf(karakter);
        kaydirilacakliste.add(index);
      }
      else
      {
        kaydirilacakliste.add(0);
      }
    }
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
        int otelenmisIndex = (index + kaydirilacakliste[i]) % alfabe.length;
        if (harf.compareTo('A') >= 0 && harf.compareTo('Z') <= 0)
        {
          // MessageBox.Show("Harf büyük");
          sifreliMetin += alfabe[otelenmisIndex].toString().toUpperCase();
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
  metnicoz(String metin, String anahtarkelime)
  {
    String yenianahtarliliste = "";
    String yenianahtarliliste2 = "";
    yenianahtarliliste = metin;
    String sifreliMetin = "";
    if(metin.length >= anahtarkelime.length) {
      int mod = (metin.length % anahtarkelime.length) as int;
      for(int i=0;i<mod;i++)
      {
        yenianahtarliliste += "a";
      }
      int sayac =0;
      while(sayac<yenianahtarliliste.length)
      {
        for(int i=0;i<anahtarkelime.length;i++)
        {
          yenianahtarliliste2 += anahtarkelime[i];
          sayac++;
        }
      }
    }
    kaydirilacakliste.clear();
    //kaydirma listesini oluşturma
    for(int i = 0;i<yenianahtarliliste2.length;i++)
    {
      String harf = yenianahtarliliste2[i];
      String karakter = harf.toLowerCase();
      // char karakter = char.Parse(harf.ToString().ToLower());
      if (alfabe.contains(karakter))
      {
        int index = 0;
        index = alfabe.indexOf(karakter);
        kaydirilacakliste.add(index);
      }
      else
      {
        kaydirilacakliste.add(0);
      }
    }
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
        int otelenmisIndex = (index - kaydirilacakliste[i]) % alfabe.length;
        if (harf.compareTo('A') >= 0 && harf.compareTo('Z') <= 0)
        {
          // MessageBox.Show("Harf büyük");
          sifreliMetin += alfabe[otelenmisIndex].toString().toUpperCase();
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
}
