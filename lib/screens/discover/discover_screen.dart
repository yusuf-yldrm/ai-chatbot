import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class DiscoverPage extends StatelessWidget {
  const DiscoverPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff191A23),
      appBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        leading: Container(
          width: 42,
          decoration: BoxDecoration(
            border: Border.all(
              width: 2,
              color: Colors.white.withOpacity(.5),
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.menu,
            size: 20,
            color: Colors.white,
          ),
        ),
        trailing: Container(
          width: 40,
          padding: EdgeInsets.all(8),
          decoration: BoxDecoration(
            border: Border.all(
              color: Colors.white.withOpacity(.5),
              width: 2,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
          child: Icon(
            Icons.settings,
            size: 20,
            color: Colors.white,
          ),
        ),
      ),
      body: ListView(
        padding: EdgeInsets.symmetric(horizontal: 30, vertical: 10),
        children: [
          BannerTextContainer(),
          SizedBox(
            height: 20,
          ),
          AIToolContainer(
            icon: CupertinoIcons.waveform,
            title: 'Let\'s find new things using voice recording',
            buttonText: 'Start Recording',
            leading: 'Voice Helper',
          ),
          SizedBox(height: 20),
          AIToolContainer(
            icon: CupertinoIcons.chat_bubble_fill,
            title: 'Find your knowledge on chat',
            buttonText: 'Start Chat',
            leading: 'Chat Helper',
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            'Recent Questions',
            style: TextStyle(
              color: Colors.white,
            ),
          ),
          Container(
            margin: EdgeInsets.only(top: 15),
            child: Column(
              // itemCount: 10,
              // separatorBuilder: (context, index) => SizedBox(height: 20),
              children: List.generate(
                20,
                (index) => Column(
                  children: [
                    RecentSearchItem(),
                    SizedBox(
                      height: 10,
                    )
                  ],
                ),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class RecentSearchItem extends StatelessWidget {
  const RecentSearchItem({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15, vertical: 18),
      decoration: BoxDecoration(
        color: Color(0xFF242830),
        borderRadius: BorderRadius.circular(15),
        border: Border.all(
          color: Color(0xFF53515B),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Container(
            padding: EdgeInsets.all(6),
            decoration: BoxDecoration(
              color: Color(0xFF53515B),
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            child: Icon(
              CupertinoIcons.chat_bubble_fill,
              color: Colors.white,
              size: 13,
            ),
          ),
          Container(
            width: MediaQuery.of(context).size.width / 2,
            child: Text(
              'Look for 5 potential headlines for advertising mobile apps',
              style: TextStyle(
                color: Colors.white,
              ),
            ),
          ),
          Icon(
            CupertinoIcons.arrow_right,
            color: Colors.white,
          )
        ],
      ),
    );
  }
}

class AIToolContainer extends StatelessWidget {
  const AIToolContainer({
    super.key,
    required this.icon,
    required this.buttonText,
    required this.title,
    required this.leading,
  });

  final icon, title, buttonText, leading;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width / 1.2,
      decoration: BoxDecoration(
        color: Color(0xFF242830),
        border: Border.all(),
        borderRadius: BorderRadius.circular(20),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 25,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            leading,
            style: TextStyle(color: Colors.white.withOpacity(.7)),
          ),
          SizedBox(height: 5),
          Container(
            padding: EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: Color(0xFF53515B),
              border: Border.all(
                color: Colors.white,
              ),
              borderRadius: BorderRadius.circular(
                20,
              ),
            ),
            child: Icon(
              icon,
              color: Colors.white,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Container(
            child: Text(
              title,
              style: TextStyle(
                color: Colors.white,
                fontSize: 23,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.symmetric(vertical: 10),
            width: 200,
            alignment: Alignment.center,
            child: Text(
              buttonText,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                color: Colors.black,
                fontSize: 17,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class BannerTextContainer extends StatelessWidget {
  const BannerTextContainer({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Hello, human lets talk.',
          style: TextStyle(
            color: Colors.white.withOpacity(
              .5,
            ),
          ),
        ),
        SizedBox(height: 10),
        Text(
          'Let\'s see what can i do for you ? ',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.w600,
          ),
        ),
      ],
    );
  }
}
