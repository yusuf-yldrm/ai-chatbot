import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:use/networking/open_ai_service.dart';
import 'package:use/pages/image/image_page.dart';

class GeneratorPage extends StatefulWidget {

  final String prompt;

  const GeneratorPage({
    super.key,
    required this.prompt,
  });

  @override
  State<GeneratorPage> createState() => GeneratorPageState();
}

class GeneratorPageState extends State<GeneratorPage> {

  // Properties

  List<String> images = [];

  // Life Cycle

  @override
  void initState() {
    super.initState();

    createImages();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // View

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "DALL·E 2",
          style: TextStyle(
            color: Colors.white,
            fontSize: 17,
            fontWeight: FontWeight.w600
          )
        ),
      ),
      backgroundColor: Colors.black,
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          child: Container(
            child: Padding(
              padding: EdgeInsets.only(top: 15, left: 20, right: 20, bottom: 20),
              child: Column(children: [
                TextField(
                  enabled: false,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.grey[900],
                    labelText: widget.prompt,
                  ),
                ),
        
                SizedBox(height: 32),

                images.isEmpty 
                  ?
                    Column(children: [
                      CupertinoActivityIndicator(),
        
                      SizedBox(height: 32),

                      Container(
                        width: MediaQuery.of(context).size.width - 42,
                        child: Padding(
                          padding: EdgeInsets.only(top: 24, left: 18, right: 18, bottom: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Tip",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 25,
                                  fontWeight: FontWeight.w600
                                ),
                              ),

                              SizedBox(height: 10),

                              Text(
                                "Add ‘’digital art’’ for striking and high-quality images.",
                                style: TextStyle(
                                  color: Colors.grey,
                                  fontSize: 15,
                                  fontWeight: FontWeight.w400
                                ),
                              ),

                              SizedBox(height: 26),

                              Divider(),

                              SizedBox(height: 26),

                              Text(
                                "‘’A fortune-telling shiba inu reading your fate in giant hamburger, digital art’’",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                                ),
                              ),

                              SizedBox(height: 20),

                              ClipRRect(
                                child: Image(
                                  image: AssetImage("resources/images/tip_image.png"),
                                ),
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ]
                          ),
                        ),
                        decoration: BoxDecoration(
                          color: Colors.grey[900],
                          borderRadius: BorderRadius.circular(8)
                        ),
                      )
                    ])
                  :
                    GridView.builder(
                      physics: NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemCount: images.length,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 2,
                        mainAxisSpacing: 21,
                        crossAxisSpacing: 21,
                      ),
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context, MaterialPageRoute(builder: (context) => ImagePage(image: images[index]))
                            );
                          },
                          child: AnimatedContainer(
                            duration: Duration(milliseconds: 300),
                            decoration: BoxDecoration(
                              color: Colors.grey[900],
                              borderRadius: BorderRadius.circular(8),
                              image: DecorationImage(
                                image: CachedNetworkImageProvider(images[index]),
                                fit: BoxFit.cover,
                              ),
                            ),
                          ),
                        );
                      },
                    ),
              ]),
            ),
          ),
        ),
      ),
    );
  }

  // Methods

  createImages() async {
    final response = await OpenAIService.createImages(widget.prompt, 6);
    setState(() {
      images = response.data.map((item) => item.image ?? "").toList();
    });
  }
}