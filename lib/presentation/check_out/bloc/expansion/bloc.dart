
import 'package:flutter_bloc/flutter_bloc.dart';

import 'event.dart';

class ExpansionBloc extends Bloc<ExpansionEvent, bool> {
  ExpansionBloc() : super(false) {
    on<ChangeExpansionEvent>((ChangeExpansionEvent event, Emitter<bool> emit) =>
        changeExpansion(event, emit));
  }

  void changeExpansion(event, emit) {
    emit(!state);
  }
}
