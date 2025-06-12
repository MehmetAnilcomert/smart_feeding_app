import 'package:flutter_bloc/flutter_bloc.dart';

class LogExpandCubit extends Cubit<bool> {
  LogExpandCubit() : super(false);

  void toggle() => emit(!state);
}
