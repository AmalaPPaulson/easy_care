import 'package:flutter/material.dart';
import 'package:video_compress/video_compress.dart';

class VideoLoad extends StatefulWidget {
  const VideoLoad({super.key});

  @override
  State<VideoLoad> createState() => VideoLoadState();
}

class VideoLoadState extends State<VideoLoad> {
  Subscription? _subscription;
  double? progress;
  @override
  void initState() {

    // TODO: implement initState
    super.initState();
    _subscription =
        VideoCompress.compressProgress$.subscribe((progress) {
      debugPrint('progress: $progress');
        
    });
  }  
  @override
  void dispose() {
    super.dispose();
    _subscription!.unsubscribe();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: createBody(),
    );
  }

  Widget createBody (){
    final value = progress == null? progress:progress!/100;
    return  Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text('Compressing Video...'),
          const SizedBox(height: 16,),
          LinearProgressIndicator(value: value,),
          Text('progress $value'),
        ],
    );
  }
}