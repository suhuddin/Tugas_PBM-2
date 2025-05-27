import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';

class InteractiveScenePage extends StatefulWidget {
  final VoidCallback onQuestComplete;
  const InteractiveScenePage({super.key, required this.onQuestComplete});

  @override
  State<InteractiveScenePage> createState() => _InteractiveScenePageState();
}

class _InteractiveScenePageState extends State<InteractiveScenePage> {
  Offset _keyPosition = const Offset(50, 300);
  Offset _backgroundOffset = Offset.zero;
  bool _isDialogueVisible = false;
  bool _isChestOpen = false;
  String _chestHint = "Terkunci...";
  final GlobalKey _chestKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: InteractiveViewer(
        boundaryMargin: const EdgeInsets.all(double.infinity),
        minScale: 1.0,
        maxScale: 3.0,
        child: Stack(
          children: [
            // Background with drag gesture
            Transform.translate(
              offset: _backgroundOffset,
              child: RawGestureDetector(
                gestures: <Type, GestureRecognizerFactory>{
                  HorizontalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<HorizontalDragGestureRecognizer>(
                    () => HorizontalDragGestureRecognizer(),
                    (HorizontalDragGestureRecognizer instance) {
                      instance.onUpdate = (details) {
                        setState(() {
                          _backgroundOffset += Offset(details.delta.dx, 0);
                        });
                      };
                    },
                  ),
                  VerticalDragGestureRecognizer: GestureRecognizerFactoryWithHandlers<VerticalDragGestureRecognizer>(
                    () => VerticalDragGestureRecognizer(),
                    (VerticalDragGestureRecognizer instance) {
                      instance.onUpdate = (details) {
                        setState(() {
                          _backgroundOffset += Offset(0, details.delta.dy);
                        });
                      };
                    },
                  ),
                },
                child: Container(
                  width: MediaQuery.of(context).size.width * 1.2,
                  height: MediaQuery.of(context).size.height * 1.2,
                  color: const Color(0xff303952),
                  child: const Center(
                    child: Text("🪐", style: TextStyle(fontSize: 200, color: Colors.white24)),
                  ),
                ),
              ),
            ),

            // Astronaut (Double Tap)
            Positioned(
              bottom: 50,
              left: 60,
              child: GestureDetector(
                onDoubleTap: () {
                  setState(() {
                    _isDialogueVisible = !_isDialogueVisible;
                  });
                },
                child: const Text("👩‍🚀", style: TextStyle(fontSize: 80)),
              ),
            ),

            // Balon Dialog
            if (_isDialogueVisible)
              Positioned(
                bottom: 140,
                left: 30,
                child: Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Text("Aku harus buka box itu!", style: TextStyle(color: Colors.black)),
                ),
              ),

            // Box (Long Press)
            Positioned(
              key: _chestKey,
              bottom: 50,
              right: 50,
              child: GestureDetector(
                onLongPress: () {
                  if (_isChestOpen) return;
                  setState(() {
                    _chestHint = "Sepertinya butuh kunci...";
                  });
                  Future.delayed(const Duration(seconds: 2), () {
                    if (mounted) {
                      setState(() {
                        _chestHint = "Terkunci...";
                      });
                    }
                  });
                },
                child: Text(_isChestOpen ? "🔓" : "📦", style: const TextStyle(fontSize: 80)),
              ),
            ),

            // Petunjuk
            Positioned(
              bottom: 140,
              right: 20,
              child: Text(_chestHint, style: const TextStyle(color: Colors.white, fontStyle: FontStyle.italic)),
            ),

            // Kunci (Drag & Drop)
            Positioned(
              left: _keyPosition.dx,
              top: _keyPosition.dy,
              child: GestureDetector(
                onPanUpdate: (details) {
                  if (_isChestOpen) return;
                  setState(() {
                    _keyPosition += details.delta;
                  });
                },
                onPanEnd: (_) {
                  if (_isChestOpen) return;
                  final RenderBox chestBox = _chestKey.currentContext!.findRenderObject() as RenderBox;
                  final chestPosition = chestBox.localToGlobal(Offset.zero);
                  final chestRect = chestPosition & chestBox.size;

                  if (chestRect.contains(_keyPosition)) {
                    setState(() {
                      _isChestOpen = true;
                      _chestHint = "Terbuka!";
                      _keyPosition = const Offset(-100, -100);
                    });

                    Future.delayed(const Duration(seconds: 2), widget.onQuestComplete);
                  }
                },
                child: const Text("🔑", style: TextStyle(fontSize: 50)),
              ),
            ),
          ],
        ),
      ),
    );
  }
}