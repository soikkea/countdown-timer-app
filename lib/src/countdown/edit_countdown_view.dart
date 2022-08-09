import 'package:countdown_timer/src/countdown/data/countdown_timer.dart';
import 'package:countdown_timer/src/countdown/data/countdown_timer_provider.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class EditCountdownTimerView extends StatelessWidget {
  const EditCountdownTimerView({Key? key}) : super(key: key);

  static const routeName = '/edit_countdown_timer';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Create Countdown')),
      body: const CountdownTimerForm(),
    );
  }
}

class CountdownTimerForm extends StatefulWidget {
  const CountdownTimerForm({Key? key}) : super(key: key);

  @override
  State<CountdownTimerForm> createState() => _CountdownTimerFormState();
}

class _CountdownTimerFormState extends State<CountdownTimerForm> {
  final _formKey = GlobalKey<FormState>();
  String _name = '';
  DateTime _target = DateTime.now();
  DateTime _endTime = DateTime.now();
  bool _includeEndTime = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Form(
        key: _formKey,
        child: Column(
          children: [
            TextFormField(
              decoration: const InputDecoration(
                labelText: 'Name',
              ),
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return "Name can't be empty";
                }
                return null;
              },
              onChanged: (value) {
                setState(() {
                  _name = value;
                });
              },
            ),
            _FormDateTimePicker(
              date: _target,
              onChanged: (value) {
                setState(() {
                  _target = value;
                });
              },
              title: 'Target',
            ),
            Row(
              children: [
                Text(
                  'Include end time',
                  style: Theme.of(context).textTheme.bodyText1,
                ),
                Switch(
                    value: _includeEndTime,
                    onChanged: (enabled) {
                      setState(() {
                        _includeEndTime = enabled;
                      });
                    }),
              ],
            ),
            if (_includeEndTime)
              FormField<DateTime>(
                initialValue: _endTime,
                validator: (value) {
                  if (_includeEndTime && !_endTime.isAfter(_target)) {
                    return 'End time must be after target';
                  }
                  return null;
                },
                builder: (formFieldState) {
                  return Column(
                    children: [
                      _FormDateTimePicker(
                        date: _endTime,
                        onChanged: (value) {
                          setState(() {
                            _endTime = value;
                          });
                        },
                        title: 'End Time',
                      ),
                      if (!formFieldState.isValid)
                        Text(
                          formFieldState.errorText ?? "",
                          style: Theme.of(context)
                              .textTheme
                              .caption!
                              .copyWith(color: Theme.of(context).errorColor),
                        )
                    ],
                  );
                },
              ),
            ElevatedButton(
              onPressed: () {
                if (_formKey.currentState!.validate()) {
                  final newCountdown = CountdownTimer(
                    id: 0,
                    name: _name,
                    startTime: _target.toUtc(),
                    endTime: _includeEndTime ? _endTime.toUtc() : null,
                    createdAt: DateTime.now().toUtc(),
                  );
                  Provider.of<CountdownTimerProvider>(
                    context,
                    listen: false,
                  ).add(newCountdown);
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                    content: Text('New Countdown added!'),
                  ));
                  Navigator.pop(context);
                }
              },
              child: const Text('Submit'),
            )
          ],
        ));
  }
}

class _FormDateTimePicker extends StatefulWidget {
  final DateTime date;
  final ValueChanged<DateTime> onChanged;
  final String title;
  const _FormDateTimePicker({
    Key? key,
    required this.date,
    required this.onChanged,
    required this.title,
  }) : super(key: key);

  @override
  State<_FormDateTimePicker> createState() => __FormDateTimePickerState();
}

class __FormDateTimePickerState extends State<_FormDateTimePicker> {
  DateTime _combineDateAndTime(DateTime date, TimeOfDay time) {
    return DateTime(date.year, date.month, date.day, time.hour, time.minute);
  }

  @override
  Widget build(BuildContext context) {
    Locale currentLocale = Localizations.localeOf(context);
    return Row(
      children: [
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                widget.title,
                style: Theme.of(context).textTheme.bodyText1,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  GestureDetector(
                    onTap: () async {
                      final time = TimeOfDay.fromDateTime(widget.date);
                      var newDate = await showDatePicker(
                        context: context,
                        initialDate: widget.date,
                        locale: currentLocale,
                        firstDate: DateTime(1900),
                        lastDate: DateTime(2100),
                      );

                      if (newDate == null) {
                        return;
                      }

                      widget.onChanged(_combineDateAndTime(newDate, time));
                    },
                    child: Text(
                      DateFormat.yMd().format(widget.date),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                  GestureDetector(
                    onTap: () async {
                      final time = await showTimePicker(
                        context: context,
                        initialTime: TimeOfDay.fromDateTime(widget.date),
                      );
                      if (time == null) {
                        return;
                      }

                      widget.onChanged(_combineDateAndTime(widget.date, time));
                    },
                    child: Text(
                      DateFormat.Hm().format(widget.date),
                      style: Theme.of(context).textTheme.subtitle1,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}
