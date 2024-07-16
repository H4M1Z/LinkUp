import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:gossip_go/screens/camera_screen.dart/controller/camera_notifier.dart';
import 'package:gossip_go/screens/camera_screen.dart/controller/camera_states.dart';
import 'package:gossip_go/utils/colors.dart';

class TakePictureScreen extends ConsumerStatefulWidget {
  const TakePictureScreen({super.key, required this.camera});
  static const pageName = '/picture-screen';
  final CameraDescription camera;
  @override
  ConsumerState<ConsumerStatefulWidget> createState() =>
      _TakePictureScreenState();
}

class _TakePictureScreenState extends ConsumerState<TakePictureScreen> {
  // late CameraController _controller;
  // late Future<void> _initializeControllerFuture;

  @override
  void initState() {
    super.initState();
    // To display the current output from the Camera,
    // create a CameraController.

    SchedulerBinding.instance.addPostFrameCallback(
      (_) =>
          ref.read(cameraNotifierProvider.notifier).initialize(widget.camera),
    );

    // _controller = CameraController(
    //   // Get a specific camera from the list of available cameras.
    //   widget.camera,
    //   // Define the resolution to use.
    //   ResolutionPreset.max,
    // );

    // // Next, initialize the controller. This returns a Future.
    // _initializeControllerFuture = _controller.initialize();
  }

  @override
  void dispose() {
    // Dispose of the controller when the widget is disposed.
    // _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Take a picture'),
        centerTitle: true,
      ),
      // You must wait until the controller is initialized before displaying the
      // camera preview. Use a FutureBuilder to display a loading spinner until the
      // controller has finished initializing.
      body: Column(
        children: [
          Expanded(
            flex: 8,
            child: Builder(
              builder: (context) {
                var state = ref.watch(cameraNotifierProvider);
                if (state is CameraLoadingState ||
                    state is CameraInitialState) {
                  return const CircularProgressIndicator(
                    color: tabColor,
                  );
                } else {
                  return FutureBuilder<void>(
                    future: ref
                        .read(cameraNotifierProvider.notifier)
                        .initializeControllerFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.done) {
                        // If the Future is complete, display the preview.
                        return CameraPreview(ref
                            .read(cameraNotifierProvider.notifier)
                            .controller);
                      } else {
                        // Otherwise, display a loading indicator.
                        return const Center(
                          child: CircularProgressIndicator(
                            color: tabColor,
                          ),
                        );
                      }
                    },
                  );
                }
              },
            ),
          ),
          Expanded(
            flex: 2,
            child: Center(
              child: FloatingActionButton(
                onPressed: () => ref
                    .read(cameraNotifierProvider.notifier)
                    .takePicture(context),
                backgroundColor: tabColor,
                child: const Icon(
                  Icons.camera_alt_rounded,
                  color: Colors.black,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
