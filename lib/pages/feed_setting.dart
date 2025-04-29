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
                    Text(
                      s.feed_settings,
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Divider(height: AppTheme.spacingLarge),

                // Feed frequency
                Text(
                  s.set_feeding_frequency,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppTheme.spacingSmall),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _frequencyController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '3',
                          suffixText: 'times/day',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing,
                            vertical: AppTheme.spacingSmall,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacing),
                    _buildIncrementButton(
                      onPressed: () {
                        setState(() {
                          _feedFrequency = (_feedFrequency + 1).clamp(1, 10);
                          _frequencyController.text = _feedFrequency.toString();
                        });
                      },
                      icon: Icons.add,
                    ),
                    SizedBox(width: AppTheme.spacingSmall),
                    _buildIncrementButton(
                      onPressed: () {
                        setState(() {
                          _feedFrequency = (_feedFrequency - 1).clamp(1, 10);
                          _frequencyController.text = _feedFrequency.toString();
                        });
                      },
                      icon: Icons.remove,
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing),

                // Feed amount
                Text(
                  s.set_feed_amount,
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: AppTheme.spacingSmall),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: _amountController,
                        keyboardType: TextInputType.number,
                        decoration: InputDecoration(
                          hintText: '100',
                          suffixText: 'grams',
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppTheme.spacing,
                            vertical: AppTheme.spacingSmall,
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: AppTheme.spacing),
                    _buildIncrementButton(
                      onPressed: () {
                        setState(() {
                          _feedAmount = (_feedAmount + 10).clamp(10, 500);
                          _amountController.text = _feedAmount.toString();
                        });
                      },
                      icon: Icons.add,
                    ),
                    SizedBox(width: AppTheme.spacingSmall),
                    _buildIncrementButton(
                      onPressed: () {
                        setState(() {
                          _feedAmount = (_feedAmount - 10).clamp(10, 500);
                          _amountController.text = _feedAmount.toString();
                        });
                      },
                      icon: Icons.remove,
                    ),
                  ],
                ),
                SizedBox(height: AppTheme.spacing),

                // First feed time
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
                      vertical: AppTheme.spacingSmall * 1.5,
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
                SizedBox(height: AppTheme.spacingLarge),

                // Update button
                Center(
                  child: ElevatedButton.icon(
                    onPressed: () {
                      final frequency = int.tryParse(_frequencyController.text);
                      final amount = double.tryParse(_amountController.text);

                      if (frequency != null && amount != null) {
                        context.read<FeederBloc>().add(
                              FeedingFrequencyChangedEvent(frequency),
                            );
                        // In a real app, you would also update the amount and time
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content:
                                Text('Feed settings updated successfully!'),
                            backgroundColor: AppTheme.accentGreen,
                          ),
                        );
                      }
                    },
                    icon: Icon(Icons.save, color: theme.colorScheme.onPrimary),
                    label: Text(s.update_settings),
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing * 2,
                        vertical: AppTheme.spacing,
                      ),
                    ),
                  ),
                ),

                // Manual feed button
                SizedBox(height: AppTheme.spacing),
                Center(
                  child: OutlinedButton.icon(
                    onPressed: () {
                      // Trigger manual feeding
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Manual feeding initiated!'),
                          backgroundColor: AppTheme.accentAmber,
                        ),
                      );
                    },
                    icon: Icon(Icons.pets),
                    label: Text(s.feed_now),
                    style: OutlinedButton.styleFrom(
                      padding: EdgeInsets.symmetric(
                        horizontal: AppTheme.spacing * 2,
                        vertical: AppTheme.spacing,
                      ),
                      side: BorderSide(color: theme.colorScheme.primary),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildIncrementButton({
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
        icon: Icon(icon, color: Colors.white, size: 20),
        padding: EdgeInsets.all(8),
        constraints: BoxConstraints(minWidth: 36, minHeight: 36),
      ),
    );
  }
}
