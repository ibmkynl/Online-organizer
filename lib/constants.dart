import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

const double kGroupCreateGroupTypesIconSize = 50;
const double kGroupCreatePrivacyIconSize = 100;
const double kTaggedMemberIconSize = 18;
const int kPhotoQuality = 20;
const int kVideoQuality = 40;
const double kMapZoom = 9;
const double kDrawerGroupListIconSize = 13;
const double kNewPostIconSize = 45;
//
const kAppBodyBackgroundColor = Color(0xFF202125);
const kButtonBackgroundColor = Color(0xFF00A273);
const kTextBackgroundColor = Color(0xFF2c2d33);
const kFadeTextColor = Color(0xFF9ba0a6);
const kSliverAppBarDivider = Color(0xFF616267);
//
final kSnackBarStyle = TextStyle(
  color: Colors.red,
);
final kDrawerNameStyle = TextStyle(fontSize: 20);
final kDrawerEmailStyle = TextStyle(fontSize: 15, color: kFadeTextColor);
//
void pageScroll(Widget pageName, context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) {
        return pageName;
      },
    ),
  );
}

Widget getMonth(int monthNumber) {
  switch (monthNumber) {
    case 1:
      return Text("Jan", style: TextStyle(color: kFadeTextColor));
      break;
    case 2:
      return Text("Feb", style: TextStyle(color: kFadeTextColor));
      break;
    case 3:
      return Text("March", style: TextStyle(color: kFadeTextColor));
      break;
    case 4:
      return Text("April", style: TextStyle(color: kFadeTextColor));
      break;
    case 5:
      return Text("May", style: TextStyle(color: kFadeTextColor));
      break;
    case 6:
      return Text("June", style: TextStyle(color: kFadeTextColor));
      break;
    case 7:
      return Text("July", style: TextStyle(color: kFadeTextColor));
      break;
    case 8:
      return Text("Aug", style: TextStyle(color: kFadeTextColor));
      break;
    case 9:
      return Text("Sep", style: TextStyle(color: kFadeTextColor));
      break;
    case 10:
      return Text("Oct", style: TextStyle(color: kFadeTextColor));
      break;
    case 11:
      return Text("Nov", style: TextStyle(color: kFadeTextColor));
      break;
    case 12:
      return Text("Dec", style: TextStyle(color: kFadeTextColor));
      break;
    default:
      return Text("", style: TextStyle(color: kFadeTextColor));
      break;
  }
}

String monthName(int monthNumber) {
  switch (monthNumber) {
    case 1:
      return "Jan";
      break;
    case 2:
      return "Feb";
      break;
    case 3:
      return "March";
      break;
    case 4:
      return "April";
      break;
    case 5:
      return "May";
      break;
    case 6:
      return "June";
      break;
    case 7:
      return "July";
      break;
    case 8:
      return "Aug";
      break;
    case 9:
      return "Sep";
      break;
    case 10:
      return "Oct";
      break;
    case 11:
      return "Nov";
      break;
    case 12:
      return "Dec";
      break;
    default:
      return "";
      break;
  }
}

IconData getExtensionIcon(String extension) {
  switch (extension) {
    case 'pdf':
      return FontAwesomeIcons.filePdf;
      break;
    case 'doc':
      return FontAwesomeIcons.fileWord;
      break;
    case 'docx':
      return FontAwesomeIcons.fileWord;
      break;
    case 'ppt':
      return FontAwesomeIcons.filePowerpoint;
      break;
    case 'pptx':
      return FontAwesomeIcons.filePowerpoint;
      break;
    case 'xls':
      return FontAwesomeIcons.fileExcel;
      break;
    case 'xlsx':
      return FontAwesomeIcons.fileExcel;
      break;
    case 'txt':
      return FontAwesomeIcons.fileAlt;
      break;

    default:
      return FontAwesomeIcons.file;
      break;
  }
}

String getLikeCount(int likeCount) {
  if (likeCount < 1000) {
    return "$likeCount";
  } else if (likeCount < 1000000) {
    return (likeCount ~/ 1000).toString() + "K";
  } else if (likeCount > 1000000) {
    return (likeCount ~/ 1000000).toString() + "M";
  }
}
