import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:smart_feeding_app/app_theme.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_bloc.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_event.dart';
import 'package:smart_feeding_app/bloc/feeder_bloc/feeder_state.dart';
import 'package:smart_feeding_app/generated/l10n.dart';

class FeedSettingsWidget extends StatefulWidget {
  @override
  _FeedSettingsWidgetState createState() => _FeedSettingsWidgetState();
}

class _FeedSettingsWidgetState extends State<FeedSettingsWidget> {
  final TextEditingController _frequencyController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  double _feedAmount = 100.0; // Default value in grams
  int _feedFrequency = 3; // Default value in times per day
  TimeOfDay _firstFeedTime = TimeOfDay(hour: 7, minute: 0);
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _frequencyController.text = _feedFrequency.toString();
    _amountController.text = _feedAmount.toString();
  }

  @override
  void dispose() {
    _frequencyController.dispose();
    _amountController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final S s = S.of(context);
    final theme = Theme.of(context);

    return BlocBuilder<FeederBloc, FeederState>(
      builder: (context, state) {
        // In a real app, you would get these values from the state
        if (state is FeederDataState) {
          // Update controllers if needed
        }

        return Card(
          elevation: AppTheme.cardElevation,
          child: Padding(
            padding: EdgeInsets.all(AppTheme.spacing),
            // Use SingleChildScrollView to make content scrollable
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.schedule,
                        color: theme.colorScheme.primary,
                      ),
                      SizedBox(width: AppTheme.spacingSmall),
                      Expanded(
                        child: Text(
                          s.feed_settings,
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                    ],
                  ),
                  Divider(height: AppTheme.spacingLarge),

                  // Feed frequency - more compact layout
                  Text(
                    s.set_feeding_frequency,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingSmall),
                  _buildCompactInputRow(
                    controller: _frequencyController,
                    suffix: s.times_per_day,
                    onIncrease: () {
                      setState(() {
                        _feedFrequency = (_feedFrequency + 1).clamp(1, 10);
                        _frequencyController.text = _feedFrequency.toString();
                      });
                    },
                    onDecrease: () {
                      setState(() {
                        _feedFrequency = (_feedFrequency - 1).clamp(1, 10);
                        _frequencyController.text = _feedFrequency.toString();
                      });
                    },
                  ),
                  SizedBox(height: AppTheme.spacing),

                  // Feed amount - more compact layout
                  Text(
                    s.set_feed_amount,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingSmall),
                  _buildCompactInputRow(
                    controller: _amountController,
                    suffix: s.grams_message,
                    onIncrease: () {
                      setState(() {
                        _feedAmount = (_feedAmount + 10).clamp(10, 500);
                        _amountController.text = _feedAmount.toString();
                      });
                    },
                    onDecrease: () {
                      setState(() {
                        _feedAmount = (_feedAmount - 10).clamp(10, 500);
                        _amountController.text = _feedAmount.toString();
                      });
                    },
                  ),
                  SizedBox(height: AppTheme.spacing),

                  // First feed time - more compact
                  Text(
                    s.first_feed_time,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingSmall),
                  InkWell(
                    onTap: () async {
                      final TimeOfDay? picked = await showTimePicker(
                        context: context,
                        initialTime: _firstFeedTime,
                      );
                      if (picked != null && picked != _firstFeedTime) {
                        setState(() {
                          _firstFeedTime = picked;
                        });
                      }
                    },
                    child: Container(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing,
                        vertical: AppTheme.spacingSmall,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(color: theme.dividerColor),
                        borderRadius:
                            BorderRadius.circular(AppTheme.borderRadius),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '${_firstFeedTime.format(context)}',
                            style: TextStyle(fontSize: 16),
                          ),
                          Icon(Icons.access_time),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: AppTheme.spacingMedium),

                  // Action buttons in a row to save space
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: () {
                            final frequency =
                                int.tryParse(_frequencyController.text);
                            final amount =
                                double.tryParse(_amountController.text);

                            if (frequency != null && amount != null) {
                              context.read<FeederBloc>().add(
                                    FeedingFrequencyChangedEvent(frequency),
                                  );
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                      'Feed settings updated successfully!'),
                                  backgroundColor: AppTheme.accentGreen,
                                ),
                              );
                            }
                          },
                          icon: Icon(Icons.save,
                              color: theme.colorScheme.onPrimary, size: 18),
                          label: Text(s.update_settings,
                              style: TextStyle(fontSize: 14)),
                          style: ElevatedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingSmall,
                              vertical: AppTheme.spacingSmall,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: AppTheme.spacingSmall),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: () {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Manual feeding initiated!'),
                                backgroundColor: AppTheme.accentAmber,
                              ),
                            );
                          },
                          icon: Icon(Icons.pets, size: 18),
                          label:
                              Text(s.feed_now, style: TextStyle(fontSize: 14)),
                          style: OutlinedButton.styleFrom(
                            padding: EdgeInsets.symmetric(
                              horizontal: AppTheme.spacingSmall,
                              vertical: AppTheme.spacingSmall,
                            ),
                            side: BorderSide(color: theme.colorScheme.primary),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  // Helper method for more compact input rows
  Widget _buildCompactInputRow({
    required TextEditingController controller,
    required String suffix,
    required VoidCallback onIncrease,
    required VoidCallback onDecrease,
  }) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              suffixText: suffix,
              contentPadding: EdgeInsets.symmetric(
                horizontal: AppTheme.spacing,
                vertical: AppTheme.spacingSmall / 2,
              ),
              isDense: true,
            ),
            style: TextStyle(fontSize: 14),
          ),
        ),
        SizedBox(width: AppTheme.spacingSmall),
        _buildCompactButton(
          onPressed: onIncrease,
          icon: Icons.add,
        ),
        SizedBox(width: AppTheme.spacingSmall / 2),
        _buildCompactButton(
          onPressed: onDecrease,
          icon: Icons.remove,
        ),
      ],
    );
  }

  // Smaller, more compact buttons
  Widget _buildCompactButton({
    required VoidCallback onPressed,
    required IconData icon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.primary,
        borderRadius: BorderRadius.circular(AppTheme.borderRadius / 2),
      ),
      child: IconButton(
        onPressed: onPressed,
        icon: Icon(icon, color: Colors.white, size: 16),
        padding: EdgeInsets.all(4),
        constraints: BoxConstraints(minWidth: 28, minHeight: 28),
        visualDensity: VisualDensity.compact,
      ),
    );
  }
}
