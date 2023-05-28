import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:googleapis_auth/auth_io.dart';

import '../../Google_API_Credentials.dart';
import '../../theme.dart';

import 'widgets___chat_bubble.dart';

class ChatBubbleInChatByMe extends StatefulWidget {
  ChatBubbleInChatByMe(
      this.message, this.helpText, this.tipExist, this.isMobile,
      {Key? key})
      : super(key: key);

  final String message;
  final List<String> helpText;
  final bool tipExist;
  bool isMobile;

  @override
  State<ChatBubbleInChatByMe> createState() => _ChatBubbleInChatByMeState();
}

class _ChatBubbleInChatByMeState extends State<ChatBubbleInChatByMe> {
  late AutoRefreshingAuthClient client;

  @override
  void initState() {
    initAPI();
    super.initState();
  }

  Future<void> initAPI() async {
    client = await clientViaServiceAccount(
        credentials, ['https://www.googleapis.com/auth/cloud-platform']);
  }

  bool fold = false;
  bool translate = false;

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    return Padding(
      padding:
          EdgeInsets.symmetric(vertical: !widget.isMobile ? 8.h : 4.h, horizontal: screenWidth * 0.05),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: !widget.isMobile ?  screenWidth / 4.5 : screenWidth/2.25,
            constraints: BoxConstraints(
                maxWidth: !widget.isMobile ?  screenWidth / 4.5 : screenWidth/2.25),
            decoration: BoxDecoration(
              color: Colors.grey[100],
              borderRadius: const BorderRadius.all(
                Radius.circular(12),
              ),
            ),
            child:
                Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: 10.h, horizontal: 16.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        listenButton(() {
                          speak(widget.message, context, client,
                              'en-US-Neural2-H');
                        }, widget.isMobile),
                        translateButton(() {
                          setState(() {
                            translate = !translate;
                          });
                        }, translate,widget.isMobile),
                      ],
                    ),
                    SizedBox(
                      height: 15.h,
                    ),
                    Text(
                      widget.message,
                      style: textTheme()
                          .displayLarge!
                          .copyWith(fontSize: !widget.isMobile ? 15.sp : 30.sp, fontWeight: FontWeight.w500),
                    ),
                    SizedBox(
                      height: 20.h,
                    ),
                    if (translate) translateText(widget.message, widget.isMobile)
                  ],
                ),
              ),
            ]),
          ),
        ],
      ),
    );
  }
}
