import 'package:flutter/material.dart';
import '../../theme/app_theme.dart';
import '../../utils/constants.dart';

class RadiusSelector extends StatelessWidget {
  const RadiusSelector({
    super.key,
    required this.selected,
    required this.onChanged,
  });

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return SegmentedButton<int>(
      segments: Constants.radiusOptions
          .map(
            (option) => ButtonSegment<int>(
              value: option['value'] as int,
              label: Text(option['label'] as String),
            ),
          )
          .toList(),
      selected: {selected},
      onSelectionChanged: (values) => onChanged(values.first),
      showSelectedIcon: false, // チェックマークを非表示にして高さを統一する
      style: SegmentedButton.styleFrom(
        selectedBackgroundColor: AppTheme.primary,
        selectedForegroundColor: Colors.white,
      ),
    );
  }
}
