import 'dart:io';
import 'dart:ui' as ui;
import 'package:iconsax/iconsax.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/rendering.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:watermark_generator/widgets/components/button.dart';
import 'package:watermark_generator/widgets/home/image_holder.dart';
import 'package:watermark_generator/widgets/decorated_container.dart';
import 'package:watermark_generator/widgets/drawer/custom_drawer.dart';
import 'package:watermark_generator/widgets/home/position_select.dart';
import 'package:watermark_generator/widgets/components/color_picker_dialog.dart';

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
  File? watermarkLogo;

  final GlobalKey thumbnailKey = GlobalKey();
  Color selectedColor = Colors.white;
  List<Color> colorSuggestions = [
    Colors.red,
    Colors.blue,
    Colors.green,
    Colors.orange,
    Colors.purple,
    Colors.teal,
    Colors.pink,
    Colors.amber,
    Colors.indigo,
    Colors.deepOrange,
  ];
  void _pickWatermarkImage() async {
    try {
      ImagePicker imagePicker = ImagePicker();
      XFile? file = await imagePicker.pickImage(source: ImageSource.gallery);
      if (file != null) {
        // Handle the selected image file, you can set it as the watermark image
        // For example, you can use it in your watermark logic
        // Update your logic based on your use case
        File watermarkImage = File(file.path);
        // You can use watermarkImage as needed, e.g., set it as the watermark logo
        // For example, you can update the ImageHolder's watermarkLogo
        setState(() {
          watermarkLogo = watermarkImage;
        });
      }
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Something went wrong",
        backgroundColor: Colors.white,
        textColor: Colors.black,
      );
    }
  }

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
      drawer: AppDrawer(
        selectedNavItem: selectedNavItem,
        onNavItemChanged: (item) {
          setState(() {
            selectedNavItem = item;
          });
        },
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
                  textColor: selectedColor,
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
                      suffixIcon: IconButton(
                          onPressed: () {
                            _pickWatermarkImage();
                          },
                          icon: Icon(Icons.image))),
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
              DecoratedContainer(
                child: colorPickerButton(),
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

  Widget colorPickerButton() {
    return Button(
        text: "Pick COlor",
        onTap: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return ColorPickerDialog(
                colorSuggestions: colorSuggestions,
                selectedColor: selectedColor,
                onColorSelected: (color) {
                  setState(() {
                    selectedColor = color;
                  });
                  Navigator.of(context).pop();
                },
              );
            },
          );
        });
  }
}
