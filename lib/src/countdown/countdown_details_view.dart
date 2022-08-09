import 'dart:async';
import 'dart:math' as math;

import 'package:countdown_timer/src/countdown/circles.dart';
import 'package:countdown_timer/src/countdown/data/countdown_timer.dart';
import 'package:countdown_timer/src/countdown/data/countdown_timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'countdown_text_utils.dart';

class CountdownTimerDetailsArguments {
  final int id;

  CountdownTimerDetailsArguments(this.id);
}

class CountdownTimerDetailsView extends StatelessWidget {
  const CountdownTimerDetailsView({Key? key}) : super(key: key);

  static const routeName = '/countdown_timer';

  @override
  Widget build(BuildContext context) {
    final args = ModalRoute.of(context)!.settings.arguments
        as CountdownTimerDetailsArguments;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Details'),
        actions: [
          IconButton(
            onPressed: () {
              Provider.of<CountdownTimerProvider>(context, listen: false)
                  .deleteCountdownTimer(args.id);
              Navigator.pop(context);
            },
            icon: const Icon(Icons.delete),
          ),
        ],
      ),
      body: Center(child: CountdownTimerDetails(id: args.id)),
    );
  }
}

class CountdownTimerDetails extends StatefulWidget {
  const CountdownTimerDetails({Key? key, required this.id}) : super(key: key);

  final int id;

  @override
  State<CountdownTimerDetails> createState() => _CountdownTimerDetailsState();
}

class _CountdownTimerDetailsState extends State<CountdownTimerDetails> {
  late Future<CountdownTimer> countdownTimer;
  DateTime _currentTimeLocal = DateTime.now();
  late Timer _timer;

  static const updateRate = Duration(milliseconds: 50);

  @override
  void initState() {
    super.initState();
    countdownTimer = Provider.of<CountdownTimerProvider>(context, listen: false)
        .getCountdownTimer(widget.id);
    _timer = Timer.periodic(updateRate, (timer) {
      setState(() {
        _currentTimeLocal = DateTime.now();
      });
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
        child: FutureBuilder<CountdownTimer>(
      future: countdownTimer,
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          // TODO: handle different CountdownStates
          final circles =
              buildCiclesFromCountdownTimer(snapshot.data!, _currentTimeLocal);
          final state = snapshot.data!.getCountdownState(_currentTimeLocal);
          final directionText =
              state != CountdownState.after ? 'down to' : 'up from';
          final target = snapshot.data!.getNextTarget(_currentTimeLocal);
          return Column(
            children: [
              Text(snapshot.data!.name,
                  style: Theme.of(context).textTheme.headline3),
              Text('Counting $directionText: ${formatTarget(target)}'),
              Text(
                  formatDurationToTarget(
                    target,
                    _currentTimeLocal,
                    includeMillis: true,
                  ),
                  style: Theme.of(context).textTheme.headline4),
              LayoutBuilder(builder: ((context, constraints) {
                return Column(
                  children: [
                    ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: math.min(
                            constraints.biggest.shortestSide * 0.9,
                            circlesMaxSize),
                      ),
                      child: CirclesWidget(circles: circles),
                    )
                  ],
                );
              })),
            ],
          );
        } else if (snapshot.hasError) {
          return Text('${snapshot.error}');
        }
        return const CircularProgressIndicator();
      },
    ));
  }
}
