enum SocialMedia {twitter, facebook, instagram, line, whatsapp, telegram, sms,
  others, clipboard}

class SocialMediaHelper{

  static String personConditionToString(SocialMedia socialMedia){
    String convertedString;
    switch (socialMedia) {
      case SocialMedia.twitter:
        convertedString = "twitter";
        return convertedString;
        break;
      case SocialMedia.facebook:
        convertedString = "facebook";
        return convertedString;
        break;
      case SocialMedia.instagram:
        convertedString = "instagram";
        return convertedString;
        break;
      case SocialMedia.line:
        convertedString = "line";
        return convertedString;
        break;
      case SocialMedia.whatsapp:
        convertedString = "whatsapp";
        return convertedString;
        break;
      case SocialMedia.telegram:
        convertedString = "telegram";
        return convertedString;
        break;
      case SocialMedia.sms:
        convertedString = "sms";
        return convertedString;
        break;
      case SocialMedia.others:
        convertedString = "others";
        return convertedString;
        break;
      case SocialMedia.clipboard:
        convertedString = "clipboard";
        return convertedString;
        break;
    }

    return convertedString;
  }

  static SocialMedia convertStringToPersonCondition(String socialMediaString){
    SocialMedia socialMedia;

    if(socialMediaString.toLowerCase()=="twitter"){
      socialMedia = SocialMedia.twitter;
    } else if (socialMediaString.toLowerCase()=="facebook"){
      socialMedia = SocialMedia.facebook;
    } else if (socialMediaString.toLowerCase()=="instagram"){
      socialMedia = SocialMedia.instagram;
    }else if (socialMediaString.toLowerCase()=="line"){
      socialMedia = SocialMedia.line;
    }else if (socialMediaString.toLowerCase()=="whatsapp"){
      socialMedia = SocialMedia.whatsapp;
    }else if (socialMediaString.toLowerCase()=="telegram"){
      socialMedia = SocialMedia.telegram;
    }else if (socialMediaString.toLowerCase()=="sms"){
      socialMedia = SocialMedia.sms;
    }else if (socialMediaString.toLowerCase()=="others"){
      socialMedia = SocialMedia.others;
    }else if (socialMediaString.toLowerCase()=="clipboard"){
      socialMedia = SocialMedia.clipboard;
    }

    return socialMedia;
  }

}
