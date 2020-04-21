enum PersonCondition {well,symptoms,infected}

class PersonConditionHelper{

  static String personConditionToString(PersonCondition personCondition){
    String convertedString;
    switch (personCondition) {
      case PersonCondition.well:
        convertedString = "well";
        return convertedString;
        break;
      case PersonCondition.symptoms:
        convertedString = "symptoms";
        return convertedString;
        break;
      case PersonCondition.infected:
        convertedString ="infected";
        return convertedString;
        break;
    }

    return convertedString;
}

static PersonCondition convertStringToPersonCondition(String personConditionString){
    PersonCondition personCondition;

    if(personConditionString.toLowerCase()=="well"){
      personCondition = PersonCondition.well;
    } else if (personConditionString.toLowerCase()=="symptoms"){
      personCondition = PersonCondition.symptoms;
    } else if (personConditionString.toLowerCase()=="infected"){
      personCondition = PersonCondition.infected;
    }

    return personCondition;
}

}
