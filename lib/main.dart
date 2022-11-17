import 'dart:io';
import 'dart:math';
import 'dart:typed_data';
import 'dart:ui';
import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:share_plus/share_plus.dart';
import 'package:video_player/video_player.dart';
import 'package:just_audio/just_audio.dart';
import 'package:audio_session/audio_session.dart';
import 'package:rxdart/rxdart.dart';
import 'package:lottie/lottie.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {

  @override
  void initState() {
    checkper();
    super.initState();
  }

  checkper() async
  {
    await Permission.storage.isDenied.then((value) => 
    Permission.storage.request());
  }

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Copytext(),
    );
  }
}

class Copytext extends StatefulWidget {
  const Copytext({super.key});

  @override
  State<Copytext> createState() => _CopytextState();
}

class _CopytextState extends State<Copytext> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Share Media'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const Share_image()));
                },
                child: Container(
                  height: 40,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text('Share Image',style: TextStyle(color: Colors.white),),
                ),
              ),
              const SizedBox(height: 15,),
              InkWell(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const Share_audio()));
                },
                child: Container(
                  height: 40,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text('Share Audio',style: TextStyle(color: Colors.white),),
                ),
              ),
              const SizedBox(height: 15,),
              InkWell(
                onTap: () {
                  Navigator.push(context, CupertinoPageRoute(builder: (context) => const Share_video()));
                },
                child: Container(
                  height: 40,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text('Share Video',style: TextStyle(color: Colors.white),),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}


SnackBarrr(BuildContext context, String title){
  return ScaffoldMessenger.of(context).showSnackBar(
    SnackBar(
      content: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: Text(title, style: const TextStyle(color: Colors.white),),
      ),
      backgroundColor: Colors.green.withOpacity(0.8),
      action: SnackBarAction(label: "",textColor: Colors.white, onPressed: (){}),
      padding: const EdgeInsets.only(top: 5,left: 8),
      duration: const Duration(seconds: 3),
    ),
  );
}


class Share_image extends StatefulWidget {
  const Share_image({super.key});

  @override
  State<Share_image> createState() => _Share_imageState();
}

class _Share_imageState extends State<Share_image> {

  Directory directory = Directory('/storage/emulated/0/Pictures/Share_media');
  var rng = Random();
  String name = '';

  @override
  void initState() {
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Share Image'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            RepaintBoundary(
              key: previewContainers,
              child: Image.asset('assets/images/flutter image.jpg')
            ),
            const SizedBox(height: 15,),
            InkWell(
              onTap: () {
                takeScreenShot();
              },
              child: Container(
                height: 40,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: const Text('Share Image',style: TextStyle(color: Colors.white),),
              ),
            ) 
          ],
        ),
      ),
    );
  }
    GlobalKey previewContainers = GlobalKey();
  Future<void> takeScreenShot() async {
    setState(() {
      name = rng.nextInt(1000000).toString();
    });
    final RenderRepaintBoundary boundary = previewContainers.currentContext!
        .findRenderObject() as RenderRepaintBoundary;
    final image = await boundary.toImage(pixelRatio: 3);
    final ByteData? byteData =
        await image.toByteData(format: ImageByteFormat.png);
    final Uint8List pngBytes = byteData!.buffer.asUint8List();
    File imgFile =
        File('/storage/emulated/0/Pictures/Share_media/Status_$name.png');
    await imgFile.writeAsBytes(pngBytes);
    Share.shareFiles(
        ['/storage/emulated/0/Pictures/Share_media/Status_$name.png']);
  }
}

class Share_audio extends StatefulWidget {
  const Share_audio({super.key});

  @override
  State<Share_audio> createState() => _Share_audioState();
}

class _Share_audioState extends State<Share_audio> {

    var rng = Random();
   String? savePath;
   String download = '';
   int btn = 0; 
    final _player = AudioPlayer();

  @override
  void initState() {
    downloadFile('https://successoftinfotech.com/SuccessoftPanel/img/voice/audio_10EK90.mp3');
    _init();
    super.initState();
  }

  Future<void> downloadFile(uri) async {
    savePath = '/storage/emulated/0/Download/Share_media/Share_audio${rng.nextInt(1000000)}.mp3';
    Dio dio = Dio();
    dio.download(
      
      uri,
      savePath,
      onReceiveProgress: (rcv, total){
        setState(() {
          download = ((rcv / total) * 100).toStringAsFixed(0);
          print("@@@hello${((rcv / total) * 100).toStringAsFixed(0)}");
        });
        if(download == '100'){
          setState(() {
            btn = 1;
          });
        }
      },
      deleteOnError: true,
    ).then((_) async{
      
    });
  }


  Future<void> _init() async {
    final session = await AudioSession.instance;
    await session.configure(const AudioSessionConfiguration.speech());
    _player.playbackEventStream
        .listen((event) {}, onError: (Object e, StackTrace stackTrace) {});
    try {
      await _player.setAudioSource(AudioSource.uri(
        
           Uri.parse('https://successoftinfotech.com/SuccessoftPanel/img/deshbhakti/knowledge_16VU20.mpeg'),
          
          ));
    } catch (e) {}
  }

  Stream<PositionData> get _positionDataStream =>
      Rx.combineLatest3<Duration, Duration, Duration?, PositionData>(
          _player.positionStream,
          _player.bufferedPositionStream,
          _player.durationStream,
          (position, bufferedPosition, duration) => PositionData(
              position, bufferedPosition, duration ?? Duration.zero));

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Share Audio'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ControlButtons(_player),
            StreamBuilder<PositionData>(
              stream: _positionDataStream,
              builder: (context, snapshot) {
                final positionData = snapshot.data;
                return SeekBar(
                  duration: positionData?.duration ?? Duration.zero,
                  position: positionData?.position ?? Duration.zero,
                  bufferedPosition:
                      positionData?.bufferedPosition ?? Duration.zero,
                  onChangeEnd: _player.seek,
                );
              },
            ),
            const SizedBox(height: 15,),
            btn == 1 ? InkWell(
              onTap: () {
                Share.shareFiles([savePath!]);
              },
              child: Container(
                height: 40,
                width: 100,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Text('Share Audio',style: TextStyle(color: Colors.white),),
              ),
            ) : Container(
                height: 40,
                width: 100,
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Lottie.asset("assets/lottie/load.json",height: 35),
              ),
          ],
        ) ,
      ),
    );
  }
}

class PositionData {
  final Duration position;
  final Duration bufferedPosition;
  final Duration duration;

  PositionData(this.position, this.bufferedPosition, this.duration);
}

class ControlButtons extends StatelessWidget {
  final AudioPlayer player;

  const ControlButtons(this.player, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        StreamBuilder<PlayerState>(
          stream: player.playerStateStream,
          builder: (context, snapshot) {
            final playerState = snapshot.data;
            final processingState = playerState?.processingState;
            final playing = playerState?.playing;
            if (processingState == ProcessingState.loading ||
                processingState == ProcessingState.buffering) {
              return Container(
                margin: const EdgeInsets.all(15),
                child: const CircularProgressIndicator(color: Colors.green),
              );
            } else if (playing != true) {
              return IconButton(
                icon: const Icon(Icons.play_arrow),
                iconSize: 50.0,
                onPressed: player.play,
              );
            } else if (processingState != ProcessingState.completed) {
              return IconButton(
                icon: const Icon(Icons.pause),
                iconSize: 50.0,
                onPressed: player.pause,
              );
            } else {
              return IconButton(
                icon: const Icon(Icons.replay),
                iconSize: 64.0,
                onPressed: () => player.seek(Duration.zero),
              );
            }
          },
        ),
      ],
    );
  }
}

class SeekBar extends StatefulWidget {
  final Duration duration;
  final Duration position;
  final Duration bufferedPosition;
  final ValueChanged<Duration>? onChanged;
  final ValueChanged<Duration>? onChangeEnd;

  const SeekBar(
      {Key? key,
      required this.duration,
      required this.position,
      required this.bufferedPosition,
      this.onChanged,
      this.onChangeEnd})
      : super(key: key);

  @override
  // ignore: library_private_types_in_public_api
  _SeekBarState createState() => _SeekBarState();
}

class _SeekBarState extends State<SeekBar> {

  double? _dragValue;
  late SliderThemeData _sliderThemeData;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _sliderThemeData = SliderTheme.of(context).copyWith(
      trackHeight: 2.0,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        SliderTheme(
          data: _sliderThemeData.copyWith(
            thumbShape: HiddenThumbComponentShape(),
            activeTrackColor: Colors.grey.shade500,
            inactiveTrackColor: Colors.grey.shade300,
          ),
          child: ExcludeSemantics(
            child: Slider(
              min: 0.0,
              max: widget.duration.inMilliseconds.toDouble(),
              value: min(widget.bufferedPosition.inMilliseconds.toDouble(),
                  widget.duration.inMilliseconds.toDouble()),
              onChanged: (value) {
                setState(() {
                  _dragValue = value;
                });
                if (widget.onChanged != null) {
                  widget.onChanged!(Duration(milliseconds: value.round()));
                }
              },
              onChangeEnd: (value) {
                if (widget.onChangeEnd != null) {
                  widget.onChangeEnd!(Duration(milliseconds: value.round()));
                }
                _dragValue = null;
              },
            ),
          ),
        ),
        SliderTheme(
          data: _sliderThemeData.copyWith(
              inactiveTrackColor: Colors.transparent, activeTrackColor: Colors.green),
          child: Slider(
            thumbColor: Colors.green,
            min: 0.0,
            max: widget.duration.inMilliseconds.toDouble(),
            value: min(_dragValue ?? widget.position.inMilliseconds.toDouble(),
                widget.duration.inMilliseconds.toDouble()),
            onChanged: (value) {
              setState(() {
                _dragValue = value;
              });
              if (widget.onChanged != null) {
                widget.onChanged!(Duration(milliseconds: value.round()));
              }
            },
            onChangeEnd: (value) {
              if (widget.onChangeEnd != null) {
                widget.onChangeEnd!(Duration(milliseconds: value.round()));
              }
              _dragValue = null;
            },
          ),
        ),
        Positioned(
          right: 16.0,
          bottom: 0.0,
          child: Text(
              RegExp(r'((^0*[1-9]\d*:)?\d{2}:\d{2})\.\d+$')
                      .firstMatch("$_remaining")
                      ?.group(1) ??
                  '$_remaining',
              style: Theme.of(context).textTheme.caption),
        ),
      ],
    );
  }

  Duration get _remaining => widget.duration - widget.position;
}

class HiddenThumbComponentShape extends SliderComponentShape {
  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) => Size.zero;

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {}
}


class Share_video extends StatefulWidget {
  const Share_video({super.key});

  @override
  State<Share_video> createState() => _Share_videoState();
}

class _Share_videoState extends State<Share_video> {

  late VideoPlayerController _controller;
  Directory directory = Directory('/storage/emulated/0/Download/Share_media');
  var rng = Random();
   String? savePath;
   String download = '';
   int btn = 0; 

  @override
  void initState() {
    if (!directory.existsSync()) {
      directory.createSync(recursive: true);
    }
    downloadFile('https://successoftinfotech.com/SuccessoftPanel/img/video/tt.mp4');
    super.initState();
    _controller = VideoPlayerController.network('https://successoftinfotech.com/SuccessoftPanel/img/video/tt.mp4')
      ..initialize().then((value) {
        setState(() {
          _controller.setLooping(true);
          _controller.play();
        });
      });
  }

  Future<void> downloadFile(uri) async {
    savePath = '/storage/emulated/0/Download/Share_media/Share_video${rng.nextInt(1000000)}.mp4';
    Dio dio = Dio();
    dio.download(
      
      uri,
      savePath,
      onReceiveProgress: (rcv, total){
        setState(() {
          download = ((rcv / total) * 100).toStringAsFixed(0);
          print("@@@hello${((rcv / total) * 100).toStringAsFixed(0)}");
        });
        if(download == '100'){
          setState(() {
            btn = 1;
          });
        }
      },
      deleteOnError: true,
    ).then((_) async{
      
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green,
        title: const Text('Share Video'),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SizedBox(
              height: MediaQuery.of(context).size.width/0.8,
              width : MediaQuery.of(context).size.width/1.4,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: _controller.value.isInitialized 
                ?
                AspectRatio(
                  aspectRatio: _controller.value.aspectRatio,
                  child: VideoPlayer(_controller))
                :
                Center(child: const CircularProgressIndicator(color: Colors.green,))
              ),
            ),
            const SizedBox(height: 15,),
            btn == 1 ? InkWell(
                onTap: () {
                  Share.shareFiles([savePath!]);
                },
                child: Container(
                  height: 40,
                  width: 100,
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: Colors.green,
                    borderRadius: BorderRadius.circular(10)
                  ),
                  child: Text('Share Video',style: TextStyle(color: Colors.white),),
                ),
              ) : Container(
                height: 40,
                width: 100,
                padding: EdgeInsets.all(8),
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.green,
                  borderRadius: BorderRadius.circular(10)
                ),
                child: Lottie.asset("assets/lottie/load.json",height: 35),
              ),
          ],
        ),
      ),
    );
  }
}