import 'package:flutter/material.dart';

class HistorySheet extends StatefulWidget {
  final List<Map<String, dynamic>> history;
  final VoidCallback onClearHistory;
  final Function(String) onUseResult;

  const HistorySheet({
    super.key,
    required this.history,
    required this.onClearHistory,
    required this.onUseResult,
  });

  @override
  State<HistorySheet> createState() => _HistorySheetState();
}

class _HistorySheetState extends State<HistorySheet> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Calculation History',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              IconButton(
                onPressed: widget.onClearHistory,
                icon: const Icon(Icons.clear_all),
                tooltip: 'Clear History',
              ),
            ],
          ),
          const SizedBox(height: 16),
          Expanded(
            child:
                widget.history.isEmpty
                    ? const Center(
                      child: Text(
                        'No calculation history',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                    : ListView.builder(
                      itemCount: widget.history.length,
                      itemBuilder: (context, index) {
                        final item = widget.history[widget.history.length - 1 - index];
                        return ListTile(
                          title: Text(item['expression']),
                          subtitle: Text(
                            '${item['result']} • ${DateTime.parse(item['timestamp']).toString().substring(0, 19)}',
                          ),
                          trailing: IconButton(
                            onPressed: () => widget.onUseResult(item['result']),
                            icon: const Icon(Icons.replay),
                            tooltip: 'Use Result',
                          ),
                        );
                      },
                    ),
          ),
        ],
      ),
    );
  }
}
