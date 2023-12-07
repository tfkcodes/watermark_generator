import 'dart:io';
import 'dart:ui' as ui;
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:watermark_generator/widgets/button.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:watermark_generator/widgets/home/image_holder.dart';
import 'package:watermark_generator/widgets/decorated_container.dart';
import 'package:watermark_generator/widgets/home/position_select.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  double sliderValue = 20;
  AlignmentGeometry selectedPosition = Alignment.center;
  String watermarkText = "";
  File? selectedFile;
  String selectedNavItem = 'Home';

  bool isExporting = false;

  final GlobalKey thumbnailKey = GlobalKey();

  handleExport() async {
    if (selectedFile == null) {
      Fluttertoast.showToast(
        msg: "Please import image",
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
      return;
    }
    if (watermarkText == "") {
      Fluttertoast.showToast(
        msg: "Please include watermark",
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
      return;
    }

    try {
      setState(() {
        isExporting = true;
      });
      RenderRepaintBoundary boundary = thumbnailKey.currentContext!
          .findRenderObject() as RenderRepaintBoundary;
      ui.Image image = await boundary.toImage(pixelRatio: 10.0);
      ByteData? byteData =
          await image.toByteData(format: ui.ImageByteFormat.png);
      if (byteData == null) {
        throw Exception();
      }
      Uint8List pngBytes = byteData.buffer.asUint8List();
      await ImageGallerySaver.saveImage(pngBytes, name: 'image_$sliderValue');
      setState(() {
        isExporting = false;
      });
      Fluttertoast.showToast(msg: "Image saved to gallery");
    } catch (e) {
      Fluttertoast.showToast(msg: "Something went wrong");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xffF8FAFB),
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: const Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Iconsax.convertshape,
              size: 18,
            ),
            SizedBox(width: 5),
            Text(
              "WATERMARK",
              style: TextStyle(
                  fontSize: 17,
                  fontWeight: FontWeight.w600,
                  color: Colors.white),
            ),
          ],
        ),
        leading: Builder(
          builder: (BuildContext context) {
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(15),
                  color: Colors.white,
                ),
                child: IconButton(
                  icon: const Icon(
                    Icons.menu,
                    color: Colors.blue,
                  ),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                ),
              ),
            );
          },
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.blue,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  CircleAvatar(
                    radius: 30,
                    backgroundColor: Colors.white,
                    // You can add an image here using the Image.network or Image.asset widget
                    // For simplicity, let's add some text
                    child: Text(
                      'T',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.blue,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    'Tfkcodes',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                    ),
                  ),
                  Text(
                    'contact@lucianojr.me',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
              child: ListTile(
                selected: selectedNavItem == 'Home',
                selectedTileColor: Colors.blue,
                selectedColor: Colors.white,
                leading: Icon(Icons.home),
                title: Text('Home'),
                onTap: () {
                  // Add your home screen navigation logic here
                  setState(() {
                    selectedNavItem = 'Home';
                  });
                  Navigator.pop(context);
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
              child: ListTile(
                selected: selectedNavItem == 'Settings',
                selectedTileColor: Colors.blue,
                selectedColor: Colors.white,
                leading: Icon(Icons.settings),
                title: Text('Settings'),
                onTap: () {
                  // Add your settings screen navigation logic here
                  setState(() {
                    selectedNavItem = 'Settings';
                  });
                  Navigator.pop(context);
                },
              ),
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // * Image holder
              ImageHolder(
                  watermarkText: watermarkText,
                  onSelected: (p0) {
                    setState(() {
                      selectedFile = p0;
                    });
                  },
                  selectedFile: selectedFile,
                  thumbnailKey: thumbnailKey,
                  selectedPosition: selectedPosition,
                  sliderValue: sliderValue),
              // * Watermark
              DecoratedContainer(
                child: TextField(
                  onChanged: (value) {
                    setState(() {
                      watermarkText = value;
                    });
                  },
                  decoration: InputDecoration(
                    hintText: "Watermark text".toUpperCase(),
                    hintStyle: const TextStyle(fontSize: 13),
                  ),
                ),
              ),
              // * Size selector
              DecoratedContainer(
                child: CupertinoSlider(
                  value: sliderValue,
                  min: 10,
                  max: 40,
                  onChanged: (value) {
                    setState(() {
                      sliderValue = value;
                    });
                  },
                ),
              ),
              // * Position
              PositionSelect(
                positions: const [
                  Alignment.bottomCenter,
                  Alignment.bottomLeft,
                  Alignment.bottomRight,
                  //
                  Alignment.topCenter,
                  Alignment.topLeft,
                  Alignment.topRight,
                  //
                  Alignment.center,
                  Alignment.centerLeft,
                  Alignment.centerRight,
                ],
                selectedPosition: selectedPosition,
                onSelect: (p0) {
                  setState(() {
                    selectedPosition = p0;
                  });
                },
              ),
              // * Button
              Button(
                isLoading: isExporting,
                text: "Embed watermark",
                onTap: () {
                  if (isExporting) {
                    return;
                  }
                  handleExport();
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
