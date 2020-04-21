import 'package:social_share/social_share.dart';
import 'package:trackcorona/utilities/social_media_enum.dart';

class SocialMediaShare {
  String appUrl = 'https://google.com/#/hello';
  String trailingText = ' ';

  SocialMediaShare._privateConstructor();

  static final SocialMediaShare _instance =
      SocialMediaShare._privateConstructor();

  factory SocialMediaShare() {
    return _instance;
  }

  void postMessageToSocialMedia(String message, SocialMedia mySocialMedia ) {

    if (mySocialMedia == SocialMedia.twitter){
    SocialShare.shareTwitter(message,
            hashtags: ['DodgeCoronaapp', 'DodgeCorona', "KeepYourLovedOnesSafe"],
            url: appUrl,
            trailingText: " ")
        .then((value) => print(value));

    } else if (mySocialMedia == SocialMedia.whatsapp){
      SocialShare.shareWhatsapp(message + "\n" + appUrl);

    } else if (mySocialMedia == SocialMedia.sms){
      SocialShare.shareSms(message, url: appUrl, trailingText: trailingText);

    } else if (mySocialMedia == SocialMedia.clipboard){
      SocialShare.copyToClipboard(message + "\n" + appUrl);

    }else if(mySocialMedia == SocialMedia.facebook){
      // TODO cannot share on facebook because these bastards steal data

    } else if (mySocialMedia == SocialMedia.telegram){
      SocialShare.shareTelegram(message + "\n" + appUrl);
    }

  } // end of postMessageToSocialMedia

  void postStoriesToSocialMedia(SocialMedia mySocial){
    // TODO to be implemented later on

  }
}
