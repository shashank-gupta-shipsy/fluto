import 'package:fluto/src/core/plugin_manager.dart';
import 'package:fluto/src/provider/fluto_provider.dart';
import 'package:fluto_plugin_platform_interface/core/pluggable.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

Future<void> showFlutoBottomSheet(BuildContext context) async {
  await showModalBottomSheet(
    isDismissible: false,
    enableDrag: false,
    context: context,
    builder: (context) {
      final provider = context.read<FlutoProvider>();
      final pluginList = FlutoPluginRegistrar.pluginList;
      provider.setSheetState(PluginSheetState.clickedAndOpened);

      final enabledPlugin = context.select<FlutoProvider, Map<String, bool>>(
          (value) => value.enabledPlugin);

      // final pluginToShow = <Pluggable>[];

      // for (var plugin in pluginList) {
      //   if (enabledPlugin[plugin.devIdentifier] == true) {
      //     pluginToShow.add(plugin);
      //   }
      // }

      return WillPopScope(
        onWillPop: () async {
          context.read<FlutoProvider>().setSheetState(PluginSheetState.closed);
          return await Future.value(true);
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ListTile(
              title: const Text("Fluto Project"),
              trailing: IconButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  context
                      .read<FlutoProvider>()
                      .setSheetState(PluginSheetState.closed);
                },
                icon: const Icon(Icons.close),
              ),
            ),
            const Divider(),
            Expanded(
              child: Visibility(
                visible: pluginList.isNotEmpty,
                replacement: const Center(child: Text("No Plugin Available")),
                child: ListView.builder(
                  padding: const EdgeInsets.symmetric(horizontal: 10),
                  itemCount: pluginList.length,
                  itemBuilder: (context, index) {
                    final plugin = pluginList[index];
                    final isEnable =
                        enabledPlugin[plugin.devIdentifier] ?? false;

                    return AnimatedSize(
                      // opacity: isEnable ? 1 : 0,
                      duration: const Duration(milliseconds: 500),
                      child: isEnable
                          ? Card(
                              clipBehavior: Clip.antiAlias,
                              color: Color.alphaBlend(
                                Theme.of(context).cardColor,
                                Theme.of(context).secondaryHeaderColor,
                              ),
                              child: FlutoSheetListTile(
                                  key: Key(plugin.devIdentifier),
                                  plugin: plugin),
                            )
                          : const SizedBox.shrink(),
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}

class FlutoSheetListTile extends StatefulWidget {
  const FlutoSheetListTile({
    Key? key,
    required this.plugin,
  }) : super(key: key);

  final Pluggable plugin;

  @override
  State<FlutoSheetListTile> createState() => _FlutoSheetListTileState();
}

class _FlutoSheetListTileState extends State<FlutoSheetListTile> {
  bool enabled = true;
  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      leading: Icon(widget.plugin.pluginConfiguration.icon),
      title: Text(widget.plugin.pluginConfiguration.name),
      subtitle: widget.plugin.pluginConfiguration.description.isNotEmpty
          ? Text(widget.plugin.pluginConfiguration.description)
          : null,
      trailing: ValueListenableBuilder(
        valueListenable: widget.plugin.pluginConfiguration.enable,
        builder: (BuildContext context, bool value, Widget? child) {
          return Switch.adaptive(
              value: enabled,
              onChanged: (value) {
                setState(() {
                  enabled = value;
                });
              });
        },
      ),
      onTap: () {
        widget.plugin.navigation.onLaunch.call();
      },
    );
  }
}
