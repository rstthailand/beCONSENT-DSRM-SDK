import 'dart:convert';
DSRM dsrmfromJson(String str) => DSRM.fromJson(json.decode(str));

class DSRM {
  DSRM({
    required this.id,
    required this.uuid,
    required this.title,
    required this.description,
    this.logo,
    required this.availableLanguage,
    required this.defaultLanguage,
    required this.rightRequests,
    required this.version,
    required this.publishedAt,
    required this.workspaceId,
    required this.dsrmRequestFormId,
  });
  late final int id;
  late final String uuid;
  late final Title title;
  late final Description description;
  late final Null logo;
  late final List<String> availableLanguage;
  late final String defaultLanguage;
  late final List<RightRequests> rightRequests;
  late final String version;
  late final String publishedAt;
  late final int workspaceId;
  late final int dsrmRequestFormId;

  DSRM.fromJson(Map<String, dynamic> json){
    id = json['id'];
    uuid = json['uuid'];
    title = Title.fromJson(json['title']);
    description = Description.fromJson(json['description']);
    logo = null;
    availableLanguage = List.castFrom<dynamic, String>(json['availableLanguage']);
    defaultLanguage = json['defaultLanguage'];
    rightRequests = List.from(json['rightRequests']).map((e)=>RightRequests.fromJson(e)).toList();
    version = json['version'];
    publishedAt = json['publishedAt'];
    workspaceId = json['workspaceId'];
    dsrmRequestFormId = json['dsrmRequestFormId'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['uuid'] = uuid;
    _data['title'] = title.toJson();
    _data['description'] = description.toJson();
    _data['logo'] = logo;
    _data['availableLanguage'] = availableLanguage;
    _data['defaultLanguage'] = defaultLanguage;
    _data['rightRequests'] = rightRequests.map((e)=>e.toJson()).toList();
    _data['version'] = version;
    _data['publishedAt'] = publishedAt;
    _data['workspaceId'] = workspaceId;
    _data['dsrmRequestFormId'] = dsrmRequestFormId;
    return _data;
  }
}

class Title {
  Title({
    required this.en,
    required this.th,
  });
  late final String en;
  late final String th;

  Title.fromJson(Map<String, dynamic> json){
    en = json['en'];
    th = json['th'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['en'] = en;
    _data['th'] = th;
    return _data;
  }
}

class Description {
  Description({
    required this.en,
    required this.th,
  });
  late final String en;
  late final String th;

  Description.fromJson(Map<String, dynamic> json){
    en = json['en'];
    th = json['th'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['en'] = en;
    _data['th'] = th;
    return _data;
  }
}

class RightRequests {
  RightRequests({
    required this.id,
    required this.uuid,
    required this.workspaceId,
    required this.rightRequestName,
    required this.options,
    required this.hasFeeCharge,
    required this.enableFeeCharge,
    this.feeChargeAmount,
    required this.requestType,
  });
  late final int id;
  late final String uuid;
  late final int workspaceId;
  late final RightRequestName rightRequestName;
  late final List<Options> options;
  late final bool hasFeeCharge;
  late final bool enableFeeCharge;
  late final Null feeChargeAmount;
  late final String requestType;

  RightRequests.fromJson(Map<String, dynamic> json){
    id = json['id'];
    uuid = json['uuid'];
    workspaceId = json['workspaceId'];
    rightRequestName = RightRequestName.fromJson(json['rightRequestName']);
    options = List.from(json['options']).map((e)=>Options.fromJson(e)).toList();
    hasFeeCharge = json['hasFeeCharge'];
    enableFeeCharge = json['enableFeeCharge'];
    feeChargeAmount = null;
    requestType = json['requestType'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['id'] = id;
    _data['uuid'] = uuid;
    _data['workspaceId'] = workspaceId;
    _data['rightRequestName'] = rightRequestName.toJson();
    _data['options'] = options.map((e)=>e.toJson()).toList();
    _data['hasFeeCharge'] = hasFeeCharge;
    _data['enableFeeCharge'] = enableFeeCharge;
    _data['feeChargeAmount'] = feeChargeAmount;
    _data['requestType'] = requestType;
    return _data;
  }
}

class RightRequestName {
  RightRequestName({
    required this.en,
    required this.th,
  });
  late final String en;
  late final String th;

  RightRequestName.fromJson(Map<String, dynamic> json){
    en = json['en'];
    th = json['th'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['en'] = en;
    _data['th'] = th;
    return _data;
  }
}

class Options {
  Options({
    required this.name,
    required this.enable,
  });
  late final Name name;
  late final bool enable;

  Options.fromJson(Map<String, dynamic> json){
    name = Name.fromJson(json['name']);
    enable = json['enable'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['name'] = name.toJson();
    _data['enable'] = enable;
    return _data;
  }
}

class Name {
  Name({
    required this.en,
    required this.th,
  });
  late final String en;
  late final String th;

  Name.fromJson(Map<String, dynamic> json){
    en = json['en'];
    th = json['th'];
  }

  Map<String, dynamic> toJson() {
    final _data = <String, dynamic>{};
    _data['en'] = en;
    _data['th'] = th;
    return _data;
  }
}