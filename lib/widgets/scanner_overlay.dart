import 'package:flutter/material.dart';

class ScannerOverlay extends StatelessWidget {
  final Color borderColor;
  final double borderWidth;
  final double overlaySize;

  const ScannerOverlay({
    this.borderColor = Colors.white,
    this.borderWidth = 4.0,
    this.overlaySize = 250.0,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ColorFiltered(
          colorFilter: ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.srcOut),
          child: Stack(
            fit: StackFit.expand,
            children: [
              Container(
                decoration: const BoxDecoration(
                  color: Colors.black,
                  backgroundBlendMode: BlendMode.dstOut,
                ),
              ),
              Align(
                alignment: Alignment.center,
                child: Container(
                  width: overlaySize,
                  height: overlaySize,
                  decoration: const BoxDecoration(
                    color: Colors.black,
                    shape: BoxShape.rectangle,
                  ),
                ),
              ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.center,
          child: Container(
            width: overlaySize,
            height: overlaySize,
            decoration: BoxDecoration(
              border: Border.all(color: borderColor, width: borderWidth),
            ),
          ),
        ),
      ],
    );
  }
}
