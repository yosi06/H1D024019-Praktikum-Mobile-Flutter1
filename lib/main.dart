import 'package:flutter/material.dart';
import 'queue.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Simulasi Antrian (Queue)',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const QueueDemoPage(),
    );
  }
}

class QueueDemoPage extends StatefulWidget {
  const QueueDemoPage({super.key});

  @override
  State<QueueDemoPage> createState() => _QueueDemoPageState();
}

class _QueueDemoPageState extends State<QueueDemoPage> {
  final Queue<String> _queue = Queue<String>();
  final TextEditingController _controller = TextEditingController();
  String? _lastPopped;

  void _enqueueItem() {
    final text = _controller.text.trim();
    if (text.isNotEmpty) {
      setState(() {
        _queue.enqueue(text);
        _controller.clear();
      });
    }
  }

  void _popItem() {
    setState(() {
      _lastPopped = _queue.pop();
    });

    if (_lastPopped == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Antrian sudah kosong!')),
      );
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simulasi Class Queue (FIFO)'),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      labelText: 'Nama / Data Antrian',
                      border: OutlineInputBorder(),
                    ),
                    onSubmitted: (_) => _enqueueItem(),
                  ),
                ),
                const SizedBox(width: 8),
                ElevatedButton.icon(
                  onPressed: _enqueueItem,
                  icon: const Icon(Icons.add),
                  label: const Text('Enqueue'),
                ),
              ],
            ),
            const SizedBox(height: 12),
            ElevatedButton.icon(
              onPressed: _popItem,
              icon: const Icon(Icons.remove_circle_outline),
              label: const Text('Pop (Keluarkan Antrian Terdepan)'),
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red.shade100,
                foregroundColor: Colors.red.shade900,
              ),
            ),
            const Divider(height: 32),
            if (_lastPopped != null)
              Container(
                margin: const EdgeInsets.only(bottom: 16),
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.green.shade50,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.shade300),
                ),
                child: Text(
                  'Elemen yang baru dikeluarkan: $_lastPopped',
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
              ),
            Text(
              'Daftar Antrian Saat Ini (Panjang: ${_queue.length})',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Expanded(
              child: _queue.isEmpty
                  ? const Center(
                      child: Text(
                        'Antrian masih kosong.',
                        style: TextStyle(color: Colors.grey),
                      ),
                    )
                  : ListView.builder(
                      itemCount: _queue.length,
                      itemBuilder: (context, index) {
                        return Card(
                          margin: const EdgeInsets.symmetric(vertical: 4),
                          child: ListTile(
                            leading: CircleAvatar(
                              child: Text('${index + 1}'),
                            ),
                            title: Text(_queue.items[index]),
                            trailing: index == 0
                                ? const Chip(
                                    label: Text('Depan / Head'),
                                    backgroundColor: Colors.amberAccent,
                                  )
                                : null,
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}