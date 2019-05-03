import 'dart:math';


class OrdinalGender {
   String gender;
   int pob;

  OrdinalGender(this.gender, this.pob);

  OrdinalGender.fromJson(parsedJson)
    :gender = parsedJson['gender'],
   pob = parsedJson['prob'];

}