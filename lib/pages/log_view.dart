import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class LogViewPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    return BlocBuilder<FeederBloc, FeederState>(
      builder: (context, state) {
        final logs = (state is FeederDataState) ? state.logs : <String>[];
        return logs.isEmpty
            ? Center(child: Text(s.no_logs))
            : ListView.builder(
                itemCount: logs.length,
                itemBuilder: (context, index) =>
                    ListTile(title: Text(logs[index])),
              );
      },
    );
  }
}
