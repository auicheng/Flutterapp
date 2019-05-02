import 'dart:math';


class OrdinalGender {
   String gender;
   int pob;

  OrdinalGender(this.gender, this.pob);

  OrdinalGender.fromJson(parsedJson){
      Random rnd = new Random();
      if (parsedJson['gender'] == 1){
          gender = 'Female';
          pob = 50 + rnd.nextInt(50);
      }else{
          gender = 'Male';
          pob = 50 + rnd.nextInt(50);
      }
  }

}