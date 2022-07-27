import 'package:dsrm_sdk/model/dsrm_data.dart';

class RightReq{
  String title;
  bool isSelected;
  List<Options> req;
  int id;

  RightReq({
    required this.title,
    required this.isSelected,
    required this.req,
    required this.id
});
}