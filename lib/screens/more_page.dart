import 'package:flutter/material.dart';
import '../models/trip_data.dart';

class MorePage extends StatefulWidget {
  final TripData tripData;
  final ValueChanged<TripData> onDataChanged;

  const MorePage({super.key, required this.tripData, required this.onDataChanged});

  @override
  State<MorePage> createState() => _MorePageState();
}

class _MorePageState extends State<MorePage> {
  late TripData _data;
  late TextEditingController _noteController;

  final _budgetItems = [
    {'icon': '🏨', 'name': '住宿费', 'desc': '家庭套房 · 5晚', 'range': '3000 — 4500 元', 'color': const Color(0xFF8E44AD)},
    {'icon': '🎫', 'name': '门票及活动', 'desc': '长江索道、盖碗茶等', 'range': '约 620 元', 'color': const Color(0xFF2980B9)},
    {'icon': '🍜', 'name': '餐饮', 'desc': '三餐 + 小吃', 'range': '4100 — 4800 元', 'color': const Color(0xFFE67E22)},
    {'icon': '🚇', 'name': '市内交通', 'desc': '轻轨 + 网约车', 'range': '550 — 950 元', 'color': const Color(0xFF27AE60)},
    {'icon': '🛍', 'name': '杂费', 'desc': '伴手礼、饮用水、药品等', 'range': '750 — 1250 元', 'color': const Color(0xFFE74C3C)},
  ];

  final _tips = [
    {'title': '🚇 交通', 'text': '景区往返优先轨道交通，夜间出行提前预约网约车，不乘坐路边揽客黑车；周末索道、古镇站点轻轨人流量大，牵好儿童'},
    {'title': '🍜 美食', 'text': '景区内不安排正餐，正餐选择居民区老店；所有火锅、江湖菜默认鸳鸯锅，提前告知店家免辣需求'},
    {'title': '🏛 游玩', 'text': '户外景点集中安排早晚，正午全部在博物馆、科技馆等室内场所；全程穿舒适平底运动鞋，随身备足饮用水'},
    {'title': '🛍 购物', 'text': '特产、伴手礼统一在市区连锁超市采购，不在古镇、洪崖洞景区商铺消费'},
  ];

  @override
  void initState() {
    super.initState();
    _data = widget.tripData;
    _noteController = TextEditingController(text: _data.notes);
  }

  @override
  void didUpdateWidget(covariant MorePage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _data = widget.tripData;
    if (_noteController.text != _data.notes) {
      _noteController.text = _data.notes;
    }
  }

  @override
  void dispose() {
    _noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          _buildBudgetSection(),
          const SizedBox(height: 12),
          _buildTipsSection(),
          const SizedBox(height: 12),
          _buildNotesSection(),
          const SizedBox(height: 12),
          _buildSettingsSection(),
        ],
      ),
    );
  }

  Widget _buildBudgetSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('💰', style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Text('费用明细', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 4),
            const Text('一家五口 · 全程5天 · 不含往返大交通', style: TextStyle(fontSize: 12, color: Color(0xFF7F8C8D), fontStyle: FontStyle.italic)),
            const Divider(),
            ..._budgetItems.map((item) => _buildBudgetRow(item)),
            const Divider(),
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFFC0392B),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('💰 合计总预算', style: TextStyle(fontSize: 15, color: Colors.white70)),
                  Text('9000 — 12600 元', style: TextStyle(fontSize: 20, fontWeight: FontWeight.w800, color: Color(0xFFD4AC0D))),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetRow(Map item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(
        children: [
          Container(
            width: 36, height: 36,
            decoration: BoxDecoration(
              color: (item['color'] as Color).withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Center(child: Text(item['icon'] as String, style: const TextStyle(fontSize: 18))),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(item['name'] as String, style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14)),
                Text(item['desc'] as String, style: const TextStyle(fontSize: 12, color: Color(0xFF7F8C8D))),
              ],
            ),
          ),
          Text(item['range'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFFC0392B))),
        ],
      ),
    );
  }

  Widget _buildTipsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('💡', style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Text('出行贴士', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 8),
            ..._tips.map((tip) => Container(
              margin: const EdgeInsets.only(bottom: 8),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFFFEF9E7),
                border: const Border(left: BorderSide(color: Color(0xFFD4AC0D), width: 4)),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(tip['title'] as String, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 14, color: Color(0xFFD4AC0D))),
                  const SizedBox(height: 4),
                  Text(tip['text'] as String, style: const TextStyle(fontSize: 13)),
                ],
              ),
            )),
          ],
        ),
      ),
    );
  }

  Widget _buildNotesSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('📝', style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Text('备忘录', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 10),
            TextField(
              controller: _noteController,
              maxLines: 5,
              decoration: const InputDecoration(
                hintText: '写下你的旅行备注、采购清单等…',
                border: OutlineInputBorder(),
                contentPadding: EdgeInsets.all(12),
              ),
              style: const TextStyle(fontSize: 14),
              onChanged: (v) {
                _data.notes = v;
                _data.notesTime = DateTime.now().toIso8601String();
                widget.onDataChanged(_data);
              },
            ),
            if (_data.notesTime.isNotEmpty) ...[
              const SizedBox(height: 6),
              Text('最后编辑：${_formatTime(_data.notesTime)}', style: const TextStyle(fontSize: 12, color: Color(0xFFBDC3C7))),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildSettingsSection() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text('⚙️', style: TextStyle(fontSize: 20)),
                SizedBox(width: 8),
                Text('设置', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
              ],
            ),
            const SizedBox(height: 12),
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _resetData,
                icon: const Icon(Icons.delete_outline),
                label: const Text('重置所有数据'),
                style: OutlinedButton.styleFrom(
                  primary: const Color(0xFFC0392B),
                  side: const BorderSide(color: Color(0xFFC0392B)),
                  padding: const EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            const SizedBox(height: 8),
            const Center(
              child: Text('数据存储在本地，清除应用数据会丢失', 
                style: TextStyle(fontSize: 12, color: Color(0xFFBDC3C7))),
            ),
          ],
        ),
      ),
    );
  }

  void _resetData() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('确认重置'),
        content: const Text('确定重置所有数据吗？这将清除所有行程完成状态、照片和备忘录。\\n此操作不可撤销。'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () {
              final fresh = TripData.createDefault();
              widget.onDataChanged(fresh);
              setState(() {
                _data = fresh;
                _noteController.text = '';
              });
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('🗑 已重置所有数据')),
              );
            },
            style: TextButton.styleFrom(primary: Colors.red),
            child: const Text('确认重置'),
          ),
        ],
      ),
    );
  }

  String _formatTime(String iso) {
    try {
      final dt = DateTime.parse(iso);
      return '${dt.month}/${dt.day} ${dt.hour.toString().padLeft(2, '0')}:${dt.minute.toString().padLeft(2, '0')}';
    } catch (_) {
      return iso;
    }
  }
}
