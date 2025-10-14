import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../scoped_models/settings_viewmodel.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({super.key});

  @override
  State<SettingsView> createState() => _SettingsViewState();
}

class _SettingsViewState extends State<SettingsView> {
  final _ctrl = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final vm = context.watch<SettingsViewModel>();
    return Scaffold(
      appBar: AppBar(title: const Text('Banned Countries')),
      body: Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _ctrl,
                    decoration: const InputDecoration(labelText: 'Country'),
                  ),
                ),
                ElevatedButton(
                  onPressed: () {
                    vm.add(_ctrl.text.trim());
                    _ctrl.clear();
                  },
                  child: const Text('Add'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Expanded(
              child: ListView.builder(
                itemCount: vm.banned.length,
                itemBuilder: (context, i) => ListTile(
                  title: Text(vm.banned[i]),
                  trailing: IconButton(
                    icon: const Icon(Icons.delete),
                    onPressed: () => vm.removeAt(i),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
