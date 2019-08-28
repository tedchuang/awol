import 'package:flutter/material.dart';

import 'package:date_utils/date_utils.dart';
import 'package:scoped_model/scoped_model.dart';
import 'package:awol/scoped.dart';
import 'package:table_calendar/table_calendar.dart';

import '../utils/text_sizer.dart';

class ReportPage extends StatefulWidget {
  final MainModel model;
  ReportPage(this.model);

  @override
  _ReportPageState createState() => _ReportPageState();
}

class _ReportPageState extends State<ReportPage> with TickerProviderStateMixin {
  DateTime _selectedDay;
  Map<DateTime, List> _events;
  Map<DateTime, List> _visibleEvents;
  Map<DateTime, List> _visibleHolidays;
  List _selectedEvents;
  AnimationController _controller;
  final Map<DateTime, List> _holidays = Map<DateTime, List>();

  @override
  void initState() {
    // widget.model.getServices(
    //   daChurch: widget.model.user.wkrChurch,
    //   daWorker: widget.model.user.wkrId,
    // );
    // _events = widget.model.listEvents;
    _events = null;
    super.initState();
    _selectedDay = DateTime.now();
    // print('SELECTED DAY: ' + _selectedDay.toString());
    _selectedEvents = _events[_selectedDay] ?? [];
    _visibleEvents = _events;
    _visibleHolidays = _holidays;

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _controller.forward();
  }

  void _onDaySelected(DateTime day, List events) {
    setState(() {
      _selectedDay = day;
      _selectedEvents = events;
    });
  }

  void _onVisibleDaysChanged(
      DateTime first, DateTime last, CalendarFormat format) {
    // _selectedEvents = [];
    // widget.model
    //     .getServices(
    //       firstDate: first,
    //       lastDate: last,
    //       daChurch: widget.model.user.wkrChurch,
    //       daWorker: widget.model.user.wkrId,
    //     )
    //     .then(
    //       (_) => {
    //         setState(
    //           () {
    //             _events = widget.model.listEvents;
    //             _visibleEvents = Map.fromEntries(
    //               _events.entries.where(
    //                 (entry) =>
    //                     entry.key
    //                         .isAfter(first.subtract(const Duration(days: 1))) &&
    //                     entry.key.isBefore(last.add(const Duration(days: 1))),
    //               ),
    //             );
    //             _visibleHolidays = Map.fromEntries(
    //               _holidays.entries.where(
    //                 (entry) =>
    //                     entry.key
    //                         .isAfter(first.subtract(const Duration(days: 1))) &&
    //                     entry.key.isBefore(last.add(const Duration(days: 1))),
    //               ),
    //             );
    //           },
    //         )
    //       },
    //     );
  }

  @override
  Widget build(BuildContext context) {
    // double _calWidth = MediaQuery.of(context).size.width * 0.88;
    return ScopedModelDescendant<MainModel>(
      builder: (BuildContext context, Widget child, MainModel model) {
        return Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Container(
              // width: _calWidth,
              child: _buildTableCalendarWithBuilders(),
            ),
            const SizedBox(height: 10.0),
            Expanded(child: _buildEventList()),
          ],
        );
      },
    );
  }

  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      locale: 'en_US',
      rowHeight: 32.0,
      events: _visibleEvents,
      holidays: _visibleHolidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: 'Weekly',
        CalendarFormat.week: 'Monthly',
      },
      // -----------------------------------------------------------------------
      calendarStyle: CalendarStyle(
        markersMaxAmount: 99,
        outsideDaysVisible: true,
        weekdayStyle: TextStyle().copyWith(color: Colors.black, fontSize: 21.0),
        weekendStyle:
            TextStyle().copyWith(color: Colors.purple[800], fontSize: 21.0),
        outsideWeekendStyle: TextStyle()
            .copyWith(color: Colors.teal[800].withAlpha(127), fontSize: 16.8),
        outsideStyle: TextStyle()
            .copyWith(color: Colors.grey[800].withAlpha(127), fontSize: 16.8),
      ),
      // -----------------------------------------------------------------------
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle:
            TextStyle().copyWith(color: Colors.purple[800], fontSize: 14.0),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: true,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_controller),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: Colors.deepOrange[300],
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle().copyWith(fontSize: 18.2),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: Colors.amber[400],
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle().copyWith(fontSize: 18.2),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];
          if (events != null) {
            children.add(
              Positioned(
                right: 0,
                bottom: 0,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays != null && false) {
            // ----- ----- ----- holidays disabled on May 31, 2019
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _controller.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
    );
  }

  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: Utils.isSameDay(date, _selectedDay)
            ? Colors.brown[500]
            : Utils.isSameDay(date, DateTime.now())
                ? Colors.brown[300]
                : Colors.blue[400],
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 10.0,
            height: 1.1,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }

  Widget _buildEventList() {
    if (_selectedEvents.length < 1) {
      return Column(
        children: <Widget>[
          SizedBox(height: 22.0),
          Text('Tap on a date with scheduled event'),
        ],
      );
    }
    return ListView(
      children: _selectedEvents
          .map(
            (event) => Container(
              decoration: BoxDecoration(
                color: Colors.lightBlue,
                gradient: new LinearGradient(
                    colors: [Colors.pink[100], Colors.yellow[100]],
                    begin: Alignment.centerRight,
                    end: new Alignment(-1.0, -1.0)),
                boxShadow: [
                  new BoxShadow(
                    color: Colors.blueGrey[100],
                    offset: new Offset(4.0, 4.0),
                    blurRadius: 2.0,
                    spreadRadius: 0.0,
                  ),
                ],
                border: Border.all(width: 0.8),
                // borderRadius: BorderRadius.circular(12.0),
              ),
              margin:
                  const EdgeInsets.symmetric(horizontal: 16.0, vertical: 4.0),
              child: Ink(
                color: Colors.lightGreen,
                child: ListTile(
                  // isThreeLine: true,
                  leading: Hero(
                    tag: event,
                    child: CircleAvatar(
                      radius: 26.0,
                      backgroundImage: AssetImage('assets/images/giving.jpeg'),
                    ),
                  ),
                  title: TextSizer(
                    'widget.model.tileTitle(event)',
                    daWay: TextAlign.left,
                    daSize: 18.0,
                  ),
                  subtitle: TextSizer(
                    'widget.model.tileSubtitle(event)',
                    daWay: TextAlign.left,
                    daSize: 16.0,
                    daLines: 2,
                    daColor: Colors.teal[900],
                  ),
                  onTap: () {
                    Navigator.pushNamed<bool>(context, '/service/' + event);
                  },
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}
