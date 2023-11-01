
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sezarveigenerevernam/Sabitler.dart';


class AlgoritmaSecimi extends StatefulWidget {

  AlgoritmaSecimi({Key? key,}):super(key: key);

  @override
  _AlgoritmaSecimiState createState() => _AlgoritmaSecimiState();
}

class _AlgoritmaSecimiState extends State<AlgoritmaSecimi> with TickerProviderStateMixin{
  String newValue = "";
   List<String> list = <String>['Sezar Şifreleme Algoritması', 'Vigenere Şifreleme', 'Vernam Şifreleme'];
  String dropdownValue = 'Sezar Şifreleme Algoritması';
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(8),
      ),
      elevation: 0,
      //  backgroundColor: Colors.orange,
      child: Container(
        child: commentChild(),
      ),
    );
  }

  Widget commentChild() {
    return Padding(
      padding: const EdgeInsets.all(10.0),
      child: new Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Text('Algoritma Seçimi'),
          new ListTile(
            title: Text(''),
            trailing: DropdownButton<String>(
              value: dropdownValue,
              icon: const Icon(Icons.arrow_downward),
              elevation: 16,
              style: const TextStyle(color: Colors.deepPurple),
              underline: Container(
                height: 2,
                color: Colors.deepPurpleAccent,
              ),
              onChanged: (String? value) {
                // This is called when the user selects an item.
                setState(() {
                  dropdownValue = value!;
                  if(dropdownValue == "Sezar Şifreleme Algoritması")
                  {
                    Sabitler.algoritmasecimi = 1;
                  }
                  else if(dropdownValue == "Vigenere Şifreleme")
                  {
                    Sabitler.algoritmasecimi = 2;
                  }
                  else
                  {
                    Sabitler.algoritmasecimi = 3;
                  }
                  debugPrint(dropdownValue);
                  Navigator.of(context).pop(true);
                });
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(value),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
  mesajgonder(String msj) {
    showDialog(
        context: context,
        builder: (context) {
          Future.delayed(Duration(seconds: 1), () {
            Navigator.of(context).pop(true);
            Navigator.of(context).pop();//
          });
          return AlertDialog(
            title: Text(
              "$msj",
              textAlign: TextAlign.center,
            ),
          );
        });
  }

}
