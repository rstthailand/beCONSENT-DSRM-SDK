library dsrm_sdk;

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:dsrm_sdk/model/dsrm_data.dart';
import 'package:dsrm_sdk/model/rightreq.dart';

late DSRM _d;

String _url = "";
String title = '';
String des = '';

Future getData() async {
  final uri = Uri.parse(_url);
  var response = await http.get(uri);
  print(response.body);
  _d = dsrmfromJson(response.body);
}

init(String url) {
  _url = url;
  getData();
}

show(var context) {
  Future.delayed(
      Duration.zero,
          () => showDialog(
        context: context,
        builder: (context) => FutureBuilder(
            future: getData(),
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.done) {
                if (_d.defaultLanguage == 'th') {
                  title = _d.title.th;
                  des = _d.description.th;
                } else {
                  title = _d.title.en;
                  des = _d.description.en;
                }
                return DSRMPWidget();
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            }),
      ));
}

class DSRMPWidget extends StatefulWidget {

  @override
  State<StatefulWidget> createState() {
    return DSRMState();
  }
}

class DSRMState extends State<DSRMPWidget> {
  List<RightReq> rightReq = [];
  List<Options> option = [];
  List<bool> _isCheck = [];
  String name = '';
  int RightRequestID = 0;
  final FirstName = TextEditingController();
  final LastName = TextEditingController();
  final Email = TextEditingController();
  final County = TextEditingController();

  bool isSelected = false;

  send_info() async {
    final url = Uri.parse(
        "http://dev.beconsent.tech/api/v1/03a29a62-eb39-4d7b-895c-7e900d893e37/dsrm-request");
    List<int> op = [];
    for (int i = 0; i < _isCheck.length; i++) {
      if (_isCheck[i] == true) {
        op.add(i);
      }
    }
    Map<String, dynamic> args = {
      "dsrmRequestFormId": _d.dsrmRequestFormId,
      "dsrmRequestFormVersion": _d.version.toString(),
      "uid": _d.uuid,
      "consentId": "${_d.id}",
      "identityValidation": {
        "firstName": FirstName.text,
        "lastName": LastName.text,
        "email": Email.text,
        "country": County.text
      },
      "hasGuardian": false,
      "rightRequestId": RightRequestID,
      "selectedRightRequestOptions": op,
      "additionalRequestOption": "I want the full detail.",
      "requestDetail": "I want to see the detail of this consent",
      "requestedAttachment": "<file-url>",
      "collectionChannel": "Mobile App"
    };
    //
    var body = json.encode(args);

    var response = await http
        .post(url, body: body, headers: {'Content-type': 'application/json'});
    print(response.statusCode);
    print(response.body);
  }

  void submit() {
    String first_name = FirstName.text;
    String last_name = LastName.text;
    String email = Email.text;
    String country = County.text;
    if (first_name == '' || last_name == '' || email == '' || country == '') {
      showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: Text('Please fill all Identity Validation'),
            actions: [
              OutlinedButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: Text('Close'))
            ],
          ));
    } else {
      if (RightRequestID == 0) {
        showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: Text('Please Select right request'),
              actions: [
                OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text('Close'))
              ],
            ));
      } else {
        send_info();
        Navigator.of(context).pop();
      }
    }
  }

  add_index() {
    if (rightReq.isNotEmpty) {
    } else {
      for (var i in _d.rightRequests) {
        if (_d.defaultLanguage == 'th') {
          RightReq r = RightReq(
              title: i.rightRequestName.th,
              isSelected: isSelected,
              req: i.options,
              id: i.id);
          rightReq.add(r);
        } else {
          RightReq r = RightReq(
              title: i.rightRequestName.en,
              isSelected: isSelected,
              req: i.options,
              id: i.id);
          rightReq.add(r);
        }
      }
    }
  }

  check(List<RightReq> r) {
    for (var i in r) {
      if (i.isSelected == true) {
        setState(() {
          name = i.title;
          option = i.req;
          _isCheck = List<bool>.filled(option.length, false);
          RightRequestID = i.id;
        });
        // return Text(name);
      } else {
        // return Text('');
      }
    }
  }

  @override
  void initState() {
    getData();
    add_index();
    check(rightReq);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(20.0))),
      child: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        physics: ClampingScrollPhysics(),
        child: Container(
          decoration: const BoxDecoration(
            borderRadius: BorderRadius.all(Radius.circular(20)),
          ),
          child: Column(
            children: [
              Padding(
                  padding: EdgeInsets.all(25),
                  child: Column(
                    children: [
                      Align(
                        child: Text(
                          title,
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      Align(alignment: Alignment.centerLeft, child: Text(des))
                    ],
                  )),
              Padding(
                  padding: const EdgeInsets.only(left: 25, right: 25),
                  child: Column(
                    children: const [
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                            "Identity Validation",
                            style: TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          )),
                      Align(
                          alignment: Alignment.centerLeft,
                          child: Text(
                              "In order to validation your or the data subject on whose behalf you write to us request,"
                                  "we need to verify your identity. Please fill out thr form below")),
                    ],
                  )),
              Center(
                child: Padding(
                  padding: const EdgeInsets.fromLTRB(25, 15, 25, 25),
                  child: Column(children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "First Name",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                          controller: FirstName,
                          decoration: InputDecoration(
                            hintText: 'First Name',
                            border: OutlineInputBorder(),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Last Name",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                          controller: LastName,
                          decoration: InputDecoration(
                            hintText: 'Last Name',
                            border: OutlineInputBorder(),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Email",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                          keyboardType: TextInputType.emailAddress,
                          controller: Email,
                          decoration: InputDecoration(
                            hintText: 'Email',
                            border: OutlineInputBorder(),
                          ),
                        )
                      ],
                    ),
                    const SizedBox(
                      height: 8,
                    ),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Country",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.w700),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        TextField(
                          controller: County,
                          decoration: InputDecoration(
                            hintText: 'Country',
                            border: OutlineInputBorder(),
                          ),
                        )
                      ],
                    ),
                  ]),
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(25, 0, 25, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text(
                        'Select right request',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      Text(
                        'Please select which data subject right request you are making',
                        style: TextStyle(fontSize: 16),
                      )
                    ],
                  )),
              ListView.builder(
                  padding: const EdgeInsets.fromLTRB(25, 15, 25, 0),
                  itemCount: rightReq.length,
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemBuilder: (context, i) {
                    return Column(
                        children: [
                          ElevatedButton(
                              style: ButtonStyle(
                                  backgroundColor:
                                  MaterialStateProperty.all(Colors.white),
                                  foregroundColor: rightReq[i].isSelected
                                      ? MaterialStateProperty.all(Colors.blue)
                                      : MaterialStateProperty.all(Colors.grey),
                                  shape: MaterialStateProperty.all<
                                      RoundedRectangleBorder>(
                                      RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(20),
                                          side: rightReq[i].isSelected
                                              ? BorderSide(
                                              width: 3, color: Colors.blue)
                                              : BorderSide(
                                              width: 3, color: Colors.grey)))),
                              onPressed: () {
                                setState(() {
                                  rightReq.forEach((element) {
                                    element.isSelected = false;
                                  });
                                  rightReq[i].isSelected = true;
                                });
                                check(rightReq);
                              },
                              child: Padding(
                                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 8),
                                  child: Row(
                                    children: [
                                      rightReq[i].isSelected
                                          ? Icon(Icons.check)
                                          : Text(''),
                                      Flexible(
                                        child: Text(rightReq[i].title,
                                            maxLines: 2,
                                            overflow: TextOverflow.ellipsis,
                                            style: TextStyle(
                                                color: Colors.lightBlue,
                                                fontWeight: FontWeight.normal)),
                                      )
                                    ],
                                  )
                              )
                          ),
                          SizedBox( height: 5)
                        ]);
                  }),
              Padding(
                  padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Align(
                        child: Text(
                          name,
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        alignment: Alignment.centerLeft,
                      ),
                      SizedBox(
                        height: 4,
                      ),
                    ],
                  )),
              ListView.builder(
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: option.length,
                  itemBuilder: (context, i) {
                    return ListTile(
                      leading: Checkbox(
                        value: _isCheck[i],
                        onChanged: (value) {
                          setState(() {
                            _isCheck[i] = value!;
                          });
                        },
                      ),
                      title: Text(option[i].name.th),
                    );
                  }),
              Padding(
                  padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                  child: Text(
                    'Please provide details why you believe the personal data we kept about you to be inaccurate or incomplete.',
                    style: TextStyle(color: Colors.grey),
                  )),
              Padding(
                padding: EdgeInsets.fromLTRB(25, 15, 25, 0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Describe in Detail",
                      style:
                      TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                    SizedBox(
                      height: 8,
                    ),
                    TextFormField(
                      minLines: 2,
                      maxLines: 5,
                      keyboardType: TextInputType.multiline,
                      decoration: InputDecoration(
                          hintText: 'Please provide description of request',
                          border: OutlineInputBorder(
                              borderRadius:
                              BorderRadius.all(Radius.circular(18)))),
                    )
                  ],
                ),
              ),
              Padding(
                  padding: const EdgeInsets.fromLTRB(25, 25, 25, 0),
                  child: Text(
                    'I certify that the information given on this request form is true and accurate, and I understand that it may be necessary for me to provide additional information in order to confirm my identity. I understand that the initial response period of 30 calendar days specified in Personal Data Protection Act, will not commence until [Name Organization] can verify of my entitlement.',
                    style: TextStyle(color: Colors.grey),
                  )),
              Padding(
                padding: const EdgeInsets.all(25),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                        onPressed: () => submit(),
                        style: ButtonStyle(
                            backgroundColor:
                            MaterialStateProperty.all(Colors.blue),
                            shape: MaterialStateProperty.all<
                                RoundedRectangleBorder>(
                                RoundedRectangleBorder(
                                    borderRadius:
                                    BorderRadius.circular(20)))),
                        child: Padding(
                            padding: EdgeInsets.all(10.0),
                            child: Text(
                              'Submit',
                              style: TextStyle(fontSize: 16, color: Colors.white),
                            ))
                    ),
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}