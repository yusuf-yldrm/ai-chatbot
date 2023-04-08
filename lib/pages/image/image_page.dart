import 'dart:io';
import 'package:http/http.dart' as http;
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:share_extend/share_extend.dart';
import 'package:use/helpers/data_store.dart';
import 'package:use/networking/open_ai_service.dart';
import 'package:image_downloader/image_downloader.dart';
import 'package:use/pages/paywall/paywall_page.dart';
import 'package:use/pages/rating/rating_page.dart';

class ImagePage extends StatefulWidget {

  final String image;

  const ImagePage({
    super.key,
    required this.image,
  });

  @override
  State<ImagePage> createState() => ImagePageState();
}

class ImagePageState extends State<ImagePage> {

  // Properties

  List<String> images = [];
  bool downloading = false;

  // Life Cycle

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  // View

  @override
  Widget build(BuildContext context) {
    return Consumer<DataStore>(
      builder: (context, dataStore, child) => Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.black,
          title: Text(
            "Image",
            style: TextStyle(
              color: Colors.white,
              fontSize: 17,
              fontWeight: FontWeight.w600
            )
          ),
          actions: [
            IconButton(
              icon: Icon(Icons.share, color: Colors.white),
              onPressed: () async {
                final url = Uri.parse(widget.image);
                final response = await http.get(url);
                final bytes = response.bodyBytes;
    
                final temp = await getTemporaryDirectory();
                final path = '${temp.path}/image.png';
                final file = File(path);
                await file.writeAsBytes(bytes);
    
                await ShareExtend.shareMultiple([path], "images");
              },
            ),
    
            downloading
              ?
                CupertinoActivityIndicator()
              :
                IconButton(
                  icon: Icon(Icons.save, color: Colors.white),
                  onPressed: () async {
                    if (downloading) return;
    
                    setState(() {
                      downloading = true;
                    });
    
                    try {
                      await ImageDownloader.downloadImage(widget.image);
                    } catch (e) {
                      showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: Text("Something went wrong."),
                            content: Text(e.toString()),
                          )
                      );
                    }
    
                    setState(() {
                      downloading = false;
                    });
    
                    Navigator.of(context).push(
                      CupertinoPageRoute(
                        fullscreenDialog: true,
                        builder: (context) => RatingPage(),
                      ),
                    );
                  },
                ),
          ],
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: CachedNetworkImage(
            fit: BoxFit.fill,
            imageUrl: widget.image,
            placeholder: (context, url) {
              return Center(child: Container(color: Colors.grey[700]));
            }
          ),
        ),
      ),
    );
  }
}