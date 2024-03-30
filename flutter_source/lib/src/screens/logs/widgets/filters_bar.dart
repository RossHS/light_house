import 'package:flutter/material.dart';
import 'package:light_house/src/models/log_message_model.dart';
import 'package:light_house/src/widgets/animated_button.dart';

class FiltersBar extends StatelessWidget {
  const FiltersBar(
    this.selectedMessageLevel, {
    super.key,
  });

  final ValueNotifier<Set<MessageLevel>> selectedMessageLevel;

  @override
  Widget build(BuildContext context) {
    const messageLevels = MessageLevel.values;
    return Stack(
      alignment: AlignmentDirectional.topCenter,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 50.0),
          child: ValueListenableBuilder(
            valueListenable: selectedMessageLevel,
            builder: (_, selectedFilters, __) => Wrap(
              alignment: WrapAlignment.center,
              children: [
                ToggleAnimatedButton(
                  isSelected: selectedFilters.isEmpty,
                  onPressed: (value) {
                    if (value) selectedMessageLevel.value = {};
                  },
                  child: const Text('all'),
                ),
                ...messageLevels.map(
                  (e) => ToggleAnimatedButton(
                    isSelected: selectedFilters.contains(e),
                    onPressed: (value) => value ? add(e) : remove(e),
                    child: Text(e.name),
                  ),
                ),
              ],
            ),
          ),
        ),
        const Align(
          alignment: Alignment.topLeft,
          child: BackButton(),
        ),
      ],
    );
  }

  void add(MessageLevel msgLevel) {
    selectedMessageLevel.value = {...selectedMessageLevel.value, msgLevel};
  }

  void remove(MessageLevel msgLevel) {
    final temp = {...selectedMessageLevel.value};
    temp.remove(msgLevel);
    selectedMessageLevel.value = temp;
  }
}
