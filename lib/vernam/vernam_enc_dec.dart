import 'package:flutter/material.dart';

class Vernam {
  List<String> alfabe = <String>[
    'a','b','c','ç','d','e',
    'f','g','ğ','h','ı','i',
    'j','k','l','m','n','o',
    'ö','p','r','s','ş','t',
    'u','ü','v','y','z','x','w','q'
  ];
  List<String> ikililiste = <String>[
    '00000','00001','00010','00011',
    '00100','00101', '00110','00111',
    '01000','01001','01010','01011',
    '01100','01101', '01110','01111',
    '10000','10001','10010','10011',
    '10100','10101', '10110','10111',
    '11000','11001','11010','11011',
    '11100','11101', '11110','11111'
  ];
  List<int> kaydirilacakliste = [];
  metnisifrele(String metin, String anahtarkelime)
  {
    List<String> metninikilisi = <String>[];
    List<String> anahtarinikilisi = <String>[];
    List<String> xorlanmishali = <String>[];


    metninikilisi = metninikilisistemdekikarsiligi(metin);
    anahtarinikilisi = metninikilisistemdekikarsiligi(anahtarkelime);
    xorlanmishali = ikilisteyixorla(metninikilisi, anahtarinikilisi);
    String sifreliMetin = '';
    for(int i=0;i<xorlanmishali.length;i++)
      {
        String ikiliblok = xorlanmishali[i];
        int indeiximiz = ikililistedekiindexibul(ikiliblok);
        if(indeiximiz == -1)
          {
            sifreliMetin += ' ';
          }
        else
          {
            sifreliMetin += alfabe[indeiximiz % alfabe.length];
          }
      }
    return sifreliMetin;
  }
  ikililistedekiindexibul(String item)
  {
    int index = -1;

    for(int i=0;i<ikililiste.length;i++)
      {
        if(ikililiste[i].compareTo(item)== 0)
          {
            index = i;
            break;
          }
      }
    return index;
  }
  metninikilisistemdekikarsiligi(String gmetin)
  {
    List<String> metninikilisi = <String>[];
    metninikilisi.clear();
    for(int i= 0;i<gmetin.length;i++)
      {
        String harf = gmetin[i];
        String karakter = harf.toLowerCase();
        if (alfabe.contains(karakter))
        {
          int index = 0;
          index = alfabe.indexOf(karakter);
          metninikilisi.add(ikililiste[index]);
        }
        else
        {
          metninikilisi.add(karakter);
        }
      }
    return metninikilisi;
  }
  metnicoz(String metin, String anahtarkelime)
  {
    List<String> metninikilisi = <String>[];
    List<String> anahtarinikilisi = <String>[];
    List<String> xorlanmishali = <String>[];

    metninikilisi = metninikilisistemdekikarsiligi(metin);
    anahtarinikilisi = metninikilisistemdekikarsiligi(anahtarkelime);
    xorlanmishali = ikilisteyixorla(metninikilisi, anahtarinikilisi);

    String sifrsicozulmusMetin = '';
    for(int i=0;i<xorlanmishali.length;i++)
    {
      String ikiliblok = xorlanmishali[i];
      int indeiximiz = ikililistedekiindexibul(ikiliblok);
      if(indeiximiz == -1)
      {
        sifrsicozulmusMetin += ' ';
      }
      else
      {
        sifrsicozulmusMetin += alfabe[indeiximiz];
      }
    }
    return sifrsicozulmusMetin;
  }
  ikilisteyixorla(List<String> ikilimetin,List<String> ikilianahtar)
  {
    List<String> metninxorlanmishali = <String>[];
    for(int i= 0;i<ikilimetin.length;i++)
    {
      String item = '';
      String ikilimetinItem = ikilimetin[i];
      String ikilianahtarItem = ikilianahtar[i];
      if(ikilimetinItem.length == 5)
        {
          for(int j=0;j<ikilimetinItem.length;j++)
          {
            String deger = '1';
            if((ikilimetinItem[j] == '0' && ikilianahtarItem[j] == '0') || (ikilimetinItem[j] == '1' && ikilianahtarItem[j] == '1'))
            {
              deger = '0';
            }
            item += deger;
          }
        }
      metninxorlanmishali.add(item);
    }
    return metninxorlanmishali;
  }
}