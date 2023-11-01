class Sozluk
{
   int kelime_no;
   int anlam_say;
   Sozluk.fromJson(Map json)
       : kelime_no = json['kelime_no'],
         anlam_say = json['anlam_say'];
   Map toJson() {
     return {'kelime_no': kelime_no, 'anlam_say': anlam_say};
   }

}