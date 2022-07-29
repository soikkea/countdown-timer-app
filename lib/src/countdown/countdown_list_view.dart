import 'package:countdown_timer/src/countdown/countdown_details_view.dart';
import 'package:countdown_timer/src/countdown/data/countdown_timer_provider.dart';
import 'package:countdown_timer/src/countdown/edit_countdown_view.dart';
import 'package:countdown_timer/src/settings/settings_view.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

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
    var list = context.watch<CountdownTimerProvider>();

    return ListView.builder(
        restorationId: 'countdownTimerListView',
        itemCount: list.timers.length,
        itemBuilder: ((context, index) => ListTile(
              title: Text(list.timers[index].name),
              onTap: () {
                // TODO go to timer details
                Navigator.pushNamed(
                    context, CountdownTimerDetailsView.routeName,
                    arguments:
                        CountdownTimerDetailsArguments(list.timers[index].id));
              },
            )));
  }
}
