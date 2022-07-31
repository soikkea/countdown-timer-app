import 'dart:collection';

import 'package:countdown_timer/src/countdown/countdown_details_view.dart';
import 'package:countdown_timer/src/countdown/data/countdown_timer_provider.dart';
import 'package:countdown_timer/src/countdown/edit_countdown_view.dart';
import 'package:countdown_timer/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'data/countdown_timer.dart';

class CountdownTimerListView extends StatefulWidget {
  const CountdownTimerListView({Key? key}) : super(key: key);

  static const routeName = '/';

  @override
  State<CountdownTimerListView> createState() => _CountdownTimerListViewState();
}

class _CountdownTimerListViewState extends State<CountdownTimerListView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Countdown Timers'), actions: [
        IconButton(
            onPressed: () {
              Navigator.restorablePushNamed(context, SettingsView.routeName);
            },
            icon: const Icon(Icons.settings))
      ]),
      body: const _CountdownTimerList(),
      floatingActionButton: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, EditCountdownTimerView.routeName);
          },
          child: const Icon(Icons.add)),
    );
  }
}

class _CountdownTimerList extends StatelessWidget {
  const _CountdownTimerList({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    var provider = context.watch<CountdownTimerProvider>();

    var futureList = provider.timers;

    return FutureBuilder(
        future: futureList,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            var list = snapshot.data! as UnmodifiableListView<CountdownTimer>;
            return ListView.builder(
                restorationId: 'countdownTimerListView',
                itemCount: list.length,
                itemBuilder: ((context, index) => ListTile(
                      title: Text(list[index].name),
                      onTap: () {
                        Navigator.pushNamed(
                            context, CountdownTimerDetailsView.routeName,
                            arguments:
                                CountdownTimerDetailsArguments(list[index].id));
                      },
                    )));
          } else if (snapshot.hasError) {
            return Text('${snapshot.error}');
          }

          return const CircularProgressIndicator();
        });
  }
}
