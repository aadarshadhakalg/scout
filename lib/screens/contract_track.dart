import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:scout/models/contract_model.dart';
import 'package:scout/screens/work_diary_screen.dart';
import 'package:scout/widgets/clock_button.dart';

import '../bloc/tracker/tracker_bloc.dart';

class ContractTrackScreen extends StatefulWidget {
  const ContractTrackScreen({
    super.key,
    required this.contract,
  });

  final Contract contract;

  @override
  State<ContractTrackScreen> createState() => _ContractTrackScreenState();
}

class _ContractTrackScreenState extends State<ContractTrackScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<TrackerBloc, TrackerState>(
      bloc: GetIt.I.get<TrackerBloc>(),
      listener: (context, state) {},
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              onPressed: () {
                if (state is TrackingState) {
                } else {
                  Navigator.of(context).pop();
                }
              },
              icon: const Icon(Icons.arrow_back),
            ),
            title: const Text("Current Session"),
            actions: [
              Center(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "${state is TrackingState ? ((state.lastCaptured ?? state.starttime).difference(state.starttime).toString().substring(0, 4)) : "0"} H",
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (state is TrackingState)
                Center(
                  child: ClockButton(
                    key: const ValueKey('clock out'),
                    text: 'Clock out',
                    clockIcon: Icons.touch_app_outlined,
                    colors: const [Color(0xff8e3098), Color(0xffea3a75)],
                    onTap: () {
                      GetIt.I.get<TrackerBloc>().add(StopTracking());
                    },
                  ),
                ),
              if (state is TrackerInitial)
                Center(
                  child: ClockButton(
                    key: const ValueKey('clock in'),
                    text: widget.contract.status == Status.onhold
                        ? "On Hold"
                        : 'Clock in',
                    clockIcon: Icons.touch_app_outlined,
                    colors: widget.contract.status == Status.onhold
                        ? const [
                            Colors.grey,
                            Colors.grey,
                          ]
                        : const [
                            Color.fromARGB(255, 29, 98, 224),
                            Color.fromARGB(255, 231, 20, 238)
                          ],
                    onTap: widget.contract.status == Status.onhold
                        ? () {}
                        : () {
                            GetIt.I.get<TrackerBloc>().add(
                                  StartTRacking(widget.contract),
                                );
                          },
                  ),
                ),
              GestureDetector(
                onTap: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (_) => WorkDiaryView(
                        contract: widget.contract,
                      ),
                    ),
                  );
                },
                child: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 12),
                  child: Text(
                    "View Work Diary",
                    style: TextStyle(
                      color: Colors.blue,
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: TextField(
                  onChanged: (value) {
                    GetIt.I.get<TrackerBloc>().add(
                          SetMemo(value),
                        );
                  },
                  decoration: InputDecoration(
                    filled: true,
                    border: InputBorder.none,
                    suffixIcon: IconButton(
                      onPressed: () async {},
                      icon: const Icon(Icons.edit),
                    ),
                  ),
                ),
              ),
              // if (state is TrackingState)
              //   const Expanded(
              //     child: SizedBox(),
              //   ),
              if (state is TrackingState)
                StreamBuilder<int>(
                  stream: Stream.periodic(const Duration(minutes: 1), (index) {
                    return index;
                  }),
                  builder: (context, snapshot) {
                    return ListTile(
                      title: const Text("Last Captured"),
                      trailing: Text(
                        "${DateTime.now().difference(state.lastCaptured ?? DateTime.now()).inMinutes} minutes ago",
                      ),
                    );
                  },
                ),
              if (state is TrackingState)
                if (state.lastCaptured != null)
                  FutureBuilder<ByteData?>(
                    future: state.lastScreenshot!
                        .toByteData(format: ImageByteFormat.png),
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        return Image.memory(
                          Uint8List.view(snapshot.data!.buffer),
                          scale: 3,
                        );
                      } else {
                        return const Placeholder();
                      }
                    },
                  ),
            ],
          ),
        );
      },
    );
  }
}
