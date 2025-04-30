import 'package:bloc/bloc.dart';

class LogExpandCubit extends Cubit<bool> {
  LogExpandCubit() : super(false);

  void toggle() => emit(!state);
}
