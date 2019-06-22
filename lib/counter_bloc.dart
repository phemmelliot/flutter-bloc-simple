import 'dart:async';

import 'counter_event.dart';

class CounterBloc {
  int _counter = 0;

  // These are controllers for both the event incoming into the bloc and the state that is getting outputted
  final _counterStateController = StreamController<int>();
  final _counterEventController = StreamController<CounterEvent>();

  // A state of type int gets inputted into this sink from the event controller's stream
  StreamSink<int> get _counterStateInput => _counterStateController.sink;

  // This is the stream that gets outputted to the view, it get its value from the sink above
  Stream<int> get counter => _counterStateController.stream;

  // This is the sink where events get passed in from the view, it passes this down to the event controller's stream
  Sink<CounterEvent> get counterEventInput => _counterEventController.sink;

  CounterBloc() {
    // This stream gets the event that get passed in from the event controller sink above
    _counterEventController.stream.listen(_handleStateFromEvent);
  }

  // This is the function that manipulates the state based on the event and the adds the new state to the controller
  _handleStateFromEvent(CounterEvent counterEvent) {
    if (counterEvent is IncrementEvent){
     _counter++;
    } else {
      _counter--;
    }

    _counterStateInput.add(_counter);
  }

  // This closes the streams to prevent memory leaks
  void dispose() {
    _counterEventController.close();
    _counterStateController.close();
  }
}
