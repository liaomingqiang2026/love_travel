import 'package:flutter/material.dart';
import '../models/trip_data.dart';
import 'package:intl/intl.dart';

class HomePage extends StatefulWidget {
  final TripData tripData;
  final ValueChanged<TripData> onDataChanged;

  const HomePage({super.key, required this.tripData, required this.onDataChanged});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late TripData _data;

  @override
  void initState() {
    super.initState();
    _data = widget.tripData;
  }

  @override
  void didUpdateWidget(covariant HomePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _data = widget.tripData;
  }

  String get today {
    final n = DateTime.now();
    return '${n.year}-${n.month.toString().padLeft(2, '0')}-${n.day.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final dayIdx = _data.getDayIndex(today);
    final countdown = _data.getCountdown();

    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _buildCountdown(dayIdx, countdown),
          const SizedBox(height: 12),
          _buildStats(),
          const SizedBox(height: 12),
          _buildTodaySchedule(dayIdx),
          const SizedBox(height: 12),
          _buildNextDay(dayIdx),
          const SizedBox(height: 12),
          _buildWeather(),
        ],
      ),
    );
  }

  Widget _buildCountdown(int dayIdx, int countdown) {
    String numText, labelText;
    if (dayIdx == -1) {
      numText = '$countdown';
      labelText = '距离出发还有';
    } else if (dayIdx == -2) {
      numText = '🎉';
      labelText = '旅行已结束';
    } else {
      final d = _data.days[dayIdx];
      numText = 'Day ${d.day}';
      labelText = '${d.date} · ${d.title}';
    }

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        gradient: const LinearGradient(colors: [Color(0xFFC0392B), Color(0xFFD35400)]),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withOpacity(0.15), blurRadius: 12, offset: const Offset(0, 4))],
      ),
      child: Column(
        children: [
          Text(numText, style: const TextStyle(fontSize: 48, fontWeight: FontWeight.w800, color: Colors.white, letterSpacing: 2)),
          const SizedBox(height: 8),
          Text(labelText, style: const TextStyle(fontSize: 15, color: Colors.white70)),
          const SizedBox(height: 6),
          Text('重庆5日行 · ${_data.startDate} — ${_data.endDate}',
              style: const TextStyle(fontSize: 13, color: Colors.white54)),
        ],
      ),
    );
  }

  Widget _buildStats() {
    return Row(
      children: [
        _statCard('总天数', '${_data.days.length}', Colors.red),
        _statCard('已完成', '${_data.doneItems}/${_data.totalItems}', Colors.green),
        _statCard('进行中', '${_data.days.where((d) => d.items.any((i) => !i.done)).length}天', Colors.blue),
      ],
    );
  }

  Widget _statCard(String label, String num, Color color) {
    return Expanded(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 4),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16),
          child: Column(
            children: [
              Text(num, style: TextStyle(fontSize: 26, fontWeight: FontWeight.w800, color: color)),
              const SizedBox(height: 4),
              Text(label, style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D))),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTodaySchedule(int dayIdx) {
    if (dayIdx >= 0 && dayIdx < _data.days.length) {
      final todayPlan = _data.days[dayIdx];
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  const Text('📋 今日行程', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                  const Spacer(),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                    decoration: BoxDecoration(
                      color: const Color(0xFFFDEDEC),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Text('Day ${todayPlan.day} · ${todayPlan.date}', 
                      style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: Color(0xFFC0392B))),
                  ),
                ],
              ),
              const Divider(),
              ...todayPlan.items.map((item) => _buildScheduleItem(dayIdx, item)),
            ],
          ),
        ),
      );
    }
    if (dayIdx == -1) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: Column(
              children: [
                const Text('🧳', style: TextStyle(fontSize: 40)),
                const SizedBox(height: 8),
                Text('旅行将于 ${_data.startDate} 开始', style: const TextStyle(color: Color(0xFF7F8C8D))),
              ],
            ),
          ),
        ),
      );
    }
    return const SizedBox.shrink();
  }

  Widget _buildScheduleItem(int dayIdx, ScheduleItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          SizedBox(
            width: 20, height: 20,
            child: Checkbox(
              value: item.done,
              activeColor: const Color(0xFFC0392B),
              onChanged: (v) {
                setState(() {
                  item.done = v ?? false;
                  _data.days[dayIdx].items[dayIdx] = item;
                  widget.onDataChanged(_data);
                });
              },
            ),
          ),
          const SizedBox(width: 8),
          Text(item.time, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 13, color: Color(0xFFC0392B))),
          const SizedBox(width: 8),
          Expanded(
            child: Text(item.text, style: TextStyle(fontSize: 14, color: item.done ? const Color(0xFFBDC3C7) : const Color(0xFF2C3E50), decoration: item.done ? TextDecoration.lineThrough : null)),
          ),
        ],
      ),
    );
  }

  Widget _buildNextDay(int dayIdx) {
    if (dayIdx < 0 || dayIdx >= _data.days.length - 1) return const SizedBox.shrink();
    final next = _data.days[dayIdx + 1];
    return Card(
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: const Color(0xFFFDEDEC),
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(children: [
              const Text('⏰ ', style: TextStyle(fontSize: 16)),
              const Text('下次行程提醒', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            ]),
            const SizedBox(height: 8),
            Text('Day ${next.day} · ${next.date}', style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15)),
            const SizedBox(height: 4),
            Text('${next.title} — ${next.theme}', style: const TextStyle(fontSize: 14)),
            const SizedBox(height: 2),
            Text('共 ${next.items.length} 项行程', style: const TextStyle(fontSize: 13, color: Color(0xFF7F8C8D))),
          ],
        ),
      ),
    );
  }

  Widget _buildWeather() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text('🌤 重庆天气参考', style: TextStyle(fontSize: 15, fontWeight: FontWeight.w700)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFEBF5FB),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                children: [
                  const Text('☀️', style: TextStyle(fontSize: 32)),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: const [
                      Text('28°C ~ 37°C', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
                      SizedBox(height: 4),
                      Text('7月初重庆高温，正午室内活动避暑', style: TextStyle(fontSize: 13, color: Color(0xFF7F8C8D))),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
