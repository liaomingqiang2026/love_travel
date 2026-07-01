import 'package:flutter/material.dart';
import '../models/trip_data.dart';

class ItineraryPage extends StatefulWidget {
  final TripData tripData;
  final ValueChanged<TripData> onDataChanged;

  const ItineraryPage({super.key, required this.tripData, required this.onDataChanged});

  @override
  State<ItineraryPage> createState() => _ItineraryPageState();
}

class _ItineraryPageState extends State<ItineraryPage> {
  late TripData _data;
  int _currentDay = 0;
  final _timeController = TextEditingController();
  final _textController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _data = widget.tripData;
  }

  @override
  void didUpdateWidget(covariant ItineraryPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _data = widget.tripData;
  }

  @override
  void dispose() {
    _timeController.dispose();
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildDayTabs(),
        Expanded(child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 14),
          child: _buildDayContent(),
        )),
      ],
    );
  }

  Widget _buildDayTabs() {
    return Container(
      height: 60,
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _data.days.asMap().entries.map((entry) {
          final idx = entry.key;
          final d = entry.value;
          final allDone = d.items.isNotEmpty && d.items.every((i) => i.done);
          final someDone = d.items.any((i) => i.done);

          Color bg;
          if (idx == _currentDay) {
            bg = const Color(0xFFC0392B);
          } else if (allDone) {
            bg = const Color(0xFFE8F8F0);
          } else if (someDone) {
            bg = const Color(0xFFFDEDEC);
          } else {
            bg = const Color(0xFFF0F0F0);
          }

          Color fg = idx == _currentDay ? Colors.white : const Color(0xFF7F8C8D);

          return GestureDetector(
            onTap: () => setState(() => _currentDay = idx),
            child: Container(
              margin: const EdgeInsets.symmetric(horizontal: 3),
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              decoration: BoxDecoration(
                color: bg,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Day ${d.day}', style: TextStyle(fontWeight: FontWeight.w600, fontSize: 13, color: fg)),
                  Text(d.date.substring(0, 4), style: TextStyle(fontSize: 11, color: fg.withOpacity(0.8))),
                ],
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget _buildDayContent() {
    final d = _data.days[_currentDay];
    final doneCount = d.doneCount;
    final pct = d.totalCount > 0 ? (doneCount / d.totalCount * 100).round() : 0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Day header
        Container(
          width: double.infinity,
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: const LinearGradient(colors: [Color(0xFFC0392B), Color(0xFF922B21)]),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Day ${d.day} · ${d.date}', style: const TextStyle(fontSize: 13, color: Colors.white70)),
              const SizedBox(height: 4),
              Text(d.title, style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w700, color: Colors.white)),
              const SizedBox(height: 2),
              Text(d.theme, style: const TextStyle(fontSize: 14, color: Colors.white70)),
              const SizedBox(height: 10),
              Row(
                children: [
                  Text('$doneCount/${d.totalCount}', style: const TextStyle(fontSize: 13, color: Colors.white70)),
                  const SizedBox(width: 10),
                  Expanded(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(3),
                      child: LinearProgressIndicator(
                        value: d.totalCount > 0 ? d.doneCount / d.totalCount : 0,
                        backgroundColor: Colors.white24,
                        valueColor: const AlwaysStoppedAnimation(Color(0xFFD4AC0D)),
                        minHeight: 6,
                      ),
                    ),
                  ),
                  const SizedBox(width: 10),
                  Text('$pct%', style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w600, color: Color(0xFFD4AC0D))),
                ],
              ),
            ],
          ),
        ),
        const SizedBox(height: 12),
        // Items
        ...d.items.asMap().entries.map((entry) => _buildTimelineItem(entry.key, entry.value)),
        // Tips
        if (d.tips.isNotEmpty)
          Container(
            margin: const EdgeInsets.only(top: 12),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFFFEF9E7),
              border: const Border(left: BorderSide(color: Color(0xFFD4AC0D), width: 4)),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('💡 当日贴士', style: TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFFD4AC0D))),
                const SizedBox(height: 4),
                Text(d.tips, style: const TextStyle(fontSize: 13)),
              ],
            ),
          ),
        const SizedBox(height: 12),
        // Add form
        Card(
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Column(
              children: [
                Row(
                  children: [
                    SizedBox(
                      width: 70,
                      child: TextField(
                        controller: _timeController,
                        decoration: const InputDecoration(
                          hintText: '时间',
                          hintStyle: TextStyle(fontSize: 13),
                          contentPadding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: TextField(
                        controller: _textController,
                        decoration: const InputDecoration(
                          hintText: '添加新的行程项目…',
                          hintStyle: TextStyle(fontSize: 13),
                          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
                          border: OutlineInputBorder(),
                          isDense: true,
                        ),
                        style: const TextStyle(fontSize: 14),
                      ),
                    ),
                    const SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: _addItem,
                      style: ElevatedButton.styleFrom(
                        primary: const Color(0xFFC0392B),
                        onPrimary: Colors.white,
                        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                      ),
                      child: const Text('添加'),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 20),
      ],
    );
  }

  Widget _buildTimelineItem(int idx, ScheduleItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Time
          SizedBox(
            width: 56,
            child: Text(item.time, textAlign: TextAlign.right,
              style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFFC0392B))),
          ),
          const SizedBox(width: 8),
          // Line & dot
          SizedBox(
            width: 20,
            child: Column(
              children: [
                Container(
                  width: 10, height: 10,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: item.done ? const Color(0xFF27AE60) : const Color(0xFFC0392B),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Content
          Expanded(
            child: Card(
              margin: const EdgeInsets.only(bottom: 4),
              elevation: 0,
              color: item.done ? const Color(0xFFF8F8F8) : null,
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(item.text, style: TextStyle(
                      fontSize: 14,
                      color: item.done ? const Color(0xFFBDC3C7) : const Color(0xFF2C3E50),
                      decoration: item.done ? TextDecoration.lineThrough : null,
                    )),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        SizedBox(
                          height: 24,
                          child: Checkbox(
                            value: item.done,
                            activeColor: const Color(0xFFC0392B),
                            onChanged: (v) {
                              setState(() {
                                item.done = v ?? false;
                                widget.onDataChanged(_data);
                              });
                            },
                          ),
                        ),
                        const Text(' 已完成', style: TextStyle(fontSize: 12, color: Color(0xFF7F8C8D))),
                        const Spacer(),
                        if (!item.done)
                          _smallButton('✏️ 修改', const Color(0xFFEBF5FB), const Color(0xFF2980B9), () => _showEditDialog(idx)),
                        const SizedBox(width: 4),
                        _smallButton('🗑 删除', const Color(0xFFFDEDEC), const Color(0xFFC0392B), () => _deleteItem(idx)),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _smallButton(String text, Color bg, Color fg, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
        decoration: BoxDecoration(color: bg, borderRadius: BorderRadius.circular(12)),
        child: Text(text, style: TextStyle(fontSize: 12, color: fg, fontWeight: FontWeight.w500)),
      ),
    );
  }

  void _addItem() {
    final time = _timeController.text.trim();
    final text = _textController.text.trim();
    if (time.isEmpty || text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('请填写时间和内容')));
      return;
    }
    setState(() {
      _data.days[_currentDay].items.add(ScheduleItem(time: time, text: text));
      widget.onDataChanged(_data);
      _timeController.clear();
      _textController.clear();
    });
  }

  void _deleteItem(int idx) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认删除'),
        content: const Text('确定删除这条行程吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () {
              setState(() {
                _data.days[_currentDay].items.removeAt(idx);
                widget.onDataChanged(_data);
              });
              Navigator.pop(ctx);
            },
            style: TextButton.styleFrom(primary: Colors.red),
            child: const Text('删除'),
          ),
        ],
      ),
    );
  }

  void _showEditDialog(int idx) {
    final item = _data.days[_currentDay].items[idx];
    if (item.done) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('⚠️ 已完成项目不可修改，请先取消完成状态')),
      );
      return;
    }
    final timeCtrl = TextEditingController(text: item.time);
    final textCtrl = TextEditingController(text: item.text);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('✏️ 修改行程'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: timeCtrl,
              decoration: const InputDecoration(labelText: '时间', border: OutlineInputBorder()),
            ),
            const SizedBox(height: 12),
            TextField(
              controller: textCtrl,
              decoration: const InputDecoration(labelText: '内容', border: OutlineInputBorder()),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          ElevatedButton(
            onPressed: () {
              if (timeCtrl.text.trim().isEmpty || textCtrl.text.trim().isEmpty) return;
              setState(() {
                _data.days[_currentDay].items[idx].time = timeCtrl.text.trim();
                _data.days[_currentDay].items[idx].text = textCtrl.text.trim();
                widget.onDataChanged(_data);
              });
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(primary: const Color(0xFFC0392B), onPrimary: Colors.white),
            child: const Text('保存'),
          ),
        ],
      ),
    );
  }
}
