import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import 'package:picture_button/src/picture_button_mixin_protocol.dart';

class PictureButton extends StatefulWidget {
  /// thank you so much use this :)
  /// have good luck !
  /// when you need another things once write Github issue.
  ///
  /// -
  ///
  /// required parameters are [[onPressed]], [[image]].
  const PictureButton({
    super.key,
    required this.onPressed,
    required this.image,
    this.width,
    this.height,
    this.fit = BoxFit.contain,
    this.opacity = 1.0,
    this.border,
    this.borderRadius,
    this.borderRadiusInk,
    this.paddingInk = EdgeInsets.zero,
    this.imageBackgroundColor,
    this.splashColor,
    this.highlightColor,
    this.focusColor,
    this.enabled = true,
    this.bubbleEffect = false,

    this.child
  }): assert(child is! Container, "Don't use widget child Container");

  /// like onTap event.
  ///
  /// [onPressed] function is VoidCallback type.
  final VoidCallback onPressed;
  /// ImageProvider type
  /// you should ImageProvider,
  ///
  /// if you maybe use only
  /// Image.asset, Image.network, Image.memory, Image.file,
  /// do not built ImageButton Widget.
  ///
  /// their use 'image' property that is return ImageProvider type
  /// ex) final image = Image.network("https://bit.ly/example_image_12345").image
  ///     PictureButton(
  ///       onPressed: () {
  ///       },
  ///       image: image,
  ///     )
  /// -
  ///
  /// asset image : AssetImage([[IMAGE_PATH]])
  /// network image :NetworkImage([[IMAGE_PATH]])
  /// file image : FileImage([[IMAGE_PATH]])
  /// memory(Uint8List - from. typed_data.dart) image : MemoryImage([[Uint8List bytes]])
  final ImageProvider image;
  /// setting Image [width]
  /// type double
  ///
  /// -
  ///
  /// if [width] is not defined, ImageProvider will find Size itself.
  final double? width;
  /// setting Image [height]
  /// type double
  ///
  /// -
  ///
  /// if [height] is not defined, ImageProvider will find Size itself.
  final double? height;
  /// Image BoxFit
  ///
  /// default is BoxFit.contain
  final BoxFit fit;
  /// ImageButton's measure opacity
  ///
  /// -
  ///
  /// default is 1.0
  ///
  /// -
  ///
  /// if you define [enabled] property return 'false'
  /// and do not define [opacity] return value '0.7'
  final double opacity;
  /// Box Border,
  /// setting Image's outlined Border
  ///
  /// -
  ///
  /// ex) Border.all(
  ///       color: Colors.black,
  ///       width: 3.0,
  ///     )
  ///
  /// -
  ///
  /// default is null
  final Border? border;
  /// Box Border Radius
  ///
  /// PictureButton Widget's BorderRadius
  /// default is BorderRadius.circular(8.0)
  final BorderRadius? borderRadius;
  /// when you [onPressed], [onLongPressed]
  /// setting this [borderRadiusInk]
  ///
  /// why am I define property name add 'Ink',
  /// once PictureButton Widget need two borderRadius.
  ///
  /// -
  ///
  /// first, [borderRadius] require Widget base border.
  /// second, [borderRadiusInl] require effect in Widget base border.
  final BorderRadius? borderRadiusInk;
  /// when you tapped[onPressed] that can you show Event splash, highlight.
  /// there area say 'Ink'
  ///
  /// this [paddingInk] define to there area.
  ///
  /// -
  ///
  /// default is [EdgeInsets.zero]
  final EdgeInsetsGeometry paddingInk;
  /// [imageBackgroundColor] behind [image] color.
  ///
  /// -
  ///
  /// maybe you define borderRadius or width, height.
  /// I recommend imageBackgroundColor Colors.transparent :)
  /// when exist only image, that is pretty.
  final Color? imageBackgroundColor;
  /// [onPressed] onTap event color
  ///
  /// get ripple effect. touch event.
  final Color? splashColor;
  /// [onPressed] stay event color
  ///
  /// get stay touched event.
  final Color? highlightColor;
  /// if you hardware keyboard or another things.
  /// direction focusing Color event.
  final Color? focusColor;
  /// [PictureButton] define Enabled
  ///
  /// if enabled is 'false' don't use onPressed and change down tone color
  ///
  /// -
  ///
  /// default is 'true'
  final bool enabled;
  /// if you onPressed Event PictureButton Widget,
  /// Widget show you bubble effect.
  ///
  /// -
  ///
  /// [bubbleEffect] default is 'false'
  @Deprecated("bubbleEffect has not implemented.")
  final bool bubbleEffect;


  /// User defined Widget on PictureButton.
  final Widget? child;

  @override
  State<PictureButton> createState() => _PictureButtonState();
}

class _PictureButtonState extends State<PictureButton> with PictureButtonMixinProtocol{
  /// real image size
  ui.Image? imageInfo;
  /// purpose. check Image real size check
  late final ImageStream imageStream;
  ///
  late final ImageStreamListener imageStreamListener;

  /// BoxFit.contain image display width size
  double? imageDisplayWidth;
  /// BoxFit.contain image display height size
  double? imageDisplayHeight;

  @override
  void initState() {
    super.initState();

    loadImageInfo();
  }

  /// if image fit is BoxFit.cover, BoxFit.fill,
  /// then imageInfo size not check.
  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      enabled: widget.enabled,
      child: LayoutBuilder(
        builder: (context, constraints) {
          if (imageInfo != null) {
            final Size displaySize = calculateImageDisplaySize(constraints);
            imageDisplayWidth = displaySize.width;
            imageDisplayHeight = displaySize.height;
          }

          return Container(
            constraints: constraints,
            // width: width ?? constraints.maxWidth,
            // height: height ?? constraints.maxHeight,
            padding: widget.paddingInk,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: widget.image,
                fit: widget.fit,
                opacity: widget.opacity,
              ),
              color: widget.imageBackgroundColor,
              border: widget.border,
              borderRadius: widget.borderRadius,
            ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                onTap: widget.enabled ? widget.onPressed : null,
                splashColor: widget.splashColor,
                highlightColor: widget.highlightColor,
                focusColor: widget.focusColor,
                borderRadius: widget.borderRadiusInk ?? widget.borderRadius,
                enableFeedback: widget.enabled,
                child: SizedBox(
                  width: imageWidth,
                  height: imageHeight,
                  child: widget.child,
                ),
              ),
            ),
          );
        },
      ),
    );
  }


  /// ImageProvider's real sizes.
  ///
  /// example) assets/google_sign_image.png : 567x132
  @override
  Future<void> loadImageInfo() async {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      imageStream = widget.image.resolve(ImageConfiguration.empty);
      imageStreamListener = ImageStreamListener((ImageInfo imageInfo, bool synchronousCall) {
        setState(() {
          this.imageInfo = imageInfo.image;
          // if you want Log resolve this annotation :)
          // debugPrint("[---REAL IMAGE SIZE ---]");
          // debugPrint("imageInfo width:${this.imageInfo!.width}");
          // debugPrint("imageInfo height:${this.imageInfo!.height}");
          // debugPrint("[------------------ ---]");
        });

        imageStream.removeListener(imageStreamListener);
      });

      imageStream.addListener(imageStreamListener);
    });
  }


  /// calculate image ratio to displaySize.
  ///
  /// if you do not define width, height.
  /// this function get image's display size.
  ///
  /// BoxFit.contain, BoxFit.fitWidth, BoxFit.fitHeight
  @override
  Size calculateImageDisplaySize(BoxConstraints constraints) {
    assert(imageInfo != null, "imageInfo instance has not create.");

    late final double widgetWidth;
    late final double widgetHeight;

    /// if widget.width exist
    /// compare imageInfo.width
    ///
    /// if widget.width is smaller than constraints.maxWidth
    /// choice widget.width
    if (widget.width != null) {
      widgetWidth = widget.width! <= constraints.maxWidth ? widget.width! : constraints.maxWidth;
    } else {
      widgetWidth = constraints.maxWidth <= imageInfo!.width.toDouble() ? constraints.maxWidth : imageInfo!.width.toDouble();
    }

    /// if widget.height exist
    /// compare imageInfo.height
    ///
    /// if widget.width is smaller than constraints.maxHeight
    /// choice widget.height
    if (widget.height != null) {
      widgetHeight = widget.height! <= constraints.maxHeight ? widget.height! : constraints.maxHeight;
    } else {
      widgetHeight = constraints.maxHeight <= imageInfo!.height.toDouble() ? constraints.maxHeight : imageInfo!.height.toDouble();
    }

    final double widthRatio = widgetWidth / imageInfo!.width.toDouble();
    final double heightRatio = widgetHeight  / imageInfo!.height.toDouble();

    // if you want Log resolve this annotation :)
    // debugPrint("constraint maxWidth:${constraints.maxWidth}");
    // debugPrint("constraint maxHeight:${constraints.maxHeight}");
    // debugPrint("calculate widgetWidth:$widgetWidth");
    // debugPrint("calculate widgetHeight:$widgetHeight");
    // debugPrint("-------------------------------------");
    // debugPrint("widthRatio:$widthRatio");
    // debugPrint("heightRatio:$heightRatio");
    // debugPrint("-------------------------------------");
    // choice more than smaller Ratio
    final double scale = widthRatio < heightRatio ? widthRatio : heightRatio;

    return Size(
      imageInfo!.width.toDouble() * scale,
      imageInfo!.height.toDouble() * scale
    );
  }

  /// define [imageWidth]
  @override
  double? get imageWidth {
    double? width;
    if (widget.fit == BoxFit.cover ||
        widget.fit == BoxFit.fill ||
        widget.fit == BoxFit.fitWidth
    ) {
      // filled image area
      width = widget.width ?? imageInfo?.width.toDouble();
    } else {
      // scaleDown image area
      // contain, fitWidth, fitHeight, scaleDown
      width = imageDisplayWidth;
    }
    // if you want Log resolve this annotation :)
    // debugPrint("widget.width:${widget.width}");
    // debugPrint("imageInfo?.width.toDouble():${imageInfo?.width.toDouble()}");
    // debugPrint("imageDisplayWidth:$imageDisplayWidth");
    // debugPrint("--->imageWidth:$width");
    return width;
  }

  /// define [imageHeight]
  @override
  double? get imageHeight {
    double? height;
    if (widget.fit == BoxFit.cover ||
        widget.fit == BoxFit.fill ||
        widget.fit == BoxFit.fitHeight
    ) {
      // filled image area
      height = widget.height ?? imageInfo?.height.toDouble();
    } else {
      // scaleDown image area
      // contain, fitWidth,  scaleDown
      height = imageDisplayHeight;
    }

    // if you want Log resolve this annotation :)
    // debugPrint("widget.height:${widget.height}");
    // debugPrint("imageInfo?.height.toDouble():${imageInfo?.height.toDouble()}");
    // debugPrint("imageDisplayHeight:$imageDisplayHeight");
    // debugPrint("--->imageHeight:$height");
    return height;
  }
}