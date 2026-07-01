import 'dart:convert';

class ScheduleItem {
  String time;
  String text;
  bool done;

  ScheduleItem({
    required this.time,
    required this.text,
    this.done = false,
  });

  Map<String, dynamic> toJson() => {
    'time': time,
    'text': text,
    'done': done,
  };

  factory ScheduleItem.fromJson(Map<String, dynamic> json) => ScheduleItem(
    time: json['time'] as String,
    text: json['text'] as String,
    done: json['done'] as bool? ?? false,
  );
}

class DayPlan {
  int day;
  String date;
  String title;
  String theme;
  List<ScheduleItem> items;
  String tips;

  DayPlan({
    required this.day,
    required this.date,
    required this.title,
    required this.theme,
    required this.items,
    this.tips = '',
  });

  int get doneCount => items.where((i) => i.done).length;
  int get totalCount => items.length;
  double get progress => totalCount > 0 ? doneCount / totalCount : 0.0;

  Map<String, dynamic> toJson() => {
    'day': day,
    'date': date,
    'title': title,
    'theme': theme,
    'items': items.map((i) => i.toJson()).toList(),
    'tips': tips,
  };

  factory DayPlan.fromJson(Map<String, dynamic> json) => DayPlan(
    day: json['day'] as int,
    date: json['date'] as String,
    title: json['title'] as String,
    theme: json['theme'] as String,
    items: (json['items'] as List).map((e) => ScheduleItem.fromJson(e as Map<String, dynamic>)).toList(),
    tips: json['tips'] as String? ?? '',
  );
}

class PhotoRecord {
  final String id;
  final int dayIdx;
  final String path;
  final String time;

  PhotoRecord({
    required this.id,
    required this.dayIdx,
    required this.path,
    required this.time,
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'dayIdx': dayIdx,
    'path': path,
  };

  factory PhotoRecord.fromJson(Map<String, dynamic> json) => PhotoRecord(
    id: json['id'] as String,
    dayIdx: json['dayIdx'] as int,
    path: json['path'] as String,
    time: '',
  );
}

class BudgetItem {
  final String name;
  final String desc;
  final String range;
  final String icon;

  BudgetItem({
    required this.name,
    required this.desc,
    required this.range,
    required this.icon,
  });
}

class TipItem {
  final String title;
  final String text;

  TipItem({required this.title, required this.text});
}

class TripData {
  String startDate;
  String endDate;
  List<DayPlan> days;
  List<PhotoRecord> photos;
  String notes;
  String notesTime;

  TripData({
    required this.startDate,
    required this.endDate,
    required this.days,
    List<PhotoRecord>? photos,
    this.notes = '',
    this.notesTime = '',
  }) : photos = photos ?? [];

  int get totalItems => days.fold(0, (sum, d) => sum + d.totalCount);
  int get doneItems => days.fold(0, (sum, d) => sum + d.doneCount);

  int getDayIndex(String today) {
    final start = DateTime.tryParse(startDate);
    final t = DateTime.tryParse(today);
    if (start == null || t == null) return -1;
    final diff = t.difference(start).inDays;
    if (diff < 0) return -1;
    if (diff >= days.length) return -2;
    return diff;
  }

  int getCountdown() {
    final start = DateTime.tryParse(startDate);
    final now = DateTime.now();
    if (start == null) return 0;
    return start.difference(DateTime(now.year, now.month, now.day)).inDays;
  }

  Map<String, dynamic> toJson() => {
    'startDate': startDate,
    'endDate': endDate,
    'days': days.map((d) => d.toJson()).toList(),
    'photos': photos.map((p) => p.toJson()).toList(),
    'notes': notes,
    'notesTime': notesTime,
  };

  factory TripData.fromJson(Map<String, dynamic> json) => TripData(
    startDate: json['startDate'] as String,
    endDate: json['endDate'] as String,
    days: (json['days'] as List).map((e) => DayPlan.fromJson(e as Map<String, dynamic>)).toList(),
    photos: (json['photos'] as List?)?.map((e) => PhotoRecord.fromJson(e as Map<String, dynamic>)).toList() ?? [],
    notes: json['notes'] as String? ?? '',
    notesTime: json['notesTime'] as String? ?? '',
  );

  String toJsonString() => jsonEncode(toJson());

  factory TripData.fromJsonString(String s) => TripData.fromJson(jsonDecode(s) as Map<String, dynamic>);

  static TripData createDefault() {
    return TripData(
      startDate: '2026-07-02',
      endDate: '2026-07-06',
      days: [
        DayPlan(day: 1, date: '7月2日（周四）', title: '抵达日', theme: '抵达汇合 · 简单打卡',
          tips: '抵达日以休整为主，两批抵达时间不同，先到者先入住休整。',
          items: [
            ScheduleItem(time: '13:31', text: '廖明强一家抵达重庆北站，搭乘轨道交通10号线前往解放碑酒店，全程约40分钟'),
            ScheduleItem(time: '15:00', text: '办理入住，房间休整，补充饮用水、儿童零食'),
            ScheduleItem(time: '18:00', text: '楼下社区店吃重庆小面，选择花市豌杂面，给儿童单独做不辣口味'),
            ScheduleItem(time: '20:00', text: '步行解放碑步行街简单打卡，避开八一路主小吃街，仅少量尝本地小摊冰粉'),
            ScheduleItem(time: '22:50', text: '廖曼婷江北机场T3落地，打车直达酒店汇合，全员休息'),
          ]),
        DayPlan(day: 2, date: '7月3日（周五）', title: '渝中区经典打卡线', theme: '解放碑 · 李子坝 · 鹅岭 · 洪崖洞',
          tips: '白象居选低层机位即可，全程带儿童避免高层爬楼；洪崖洞不进楼内，千厮门大桥拍全景最佳。',
          items: [
            ScheduleItem(time: '08:00', text: '酒店自助早餐'),
            ScheduleItem(time: '09:00', text: '步行解放碑打卡，浅逛八一路好吃街，只选购少量特色小吃'),
            ScheduleItem(time: '10:30', text: '轨道交通2号线前往李子坝，轻轨穿楼观景台打卡，停留20分钟即可'),
            ScheduleItem(time: '12:00', text: '李子坝周边社区家常菜馆午餐，搭配清汤菜品适配孩子'),
            ScheduleItem(time: '13:30', text: '打车前往鹅岭二厂文创公园，室内文创店+平缓天台拍照，控制游玩1.5小时'),
            ScheduleItem(time: '15:30', text: '打车前往白象居，仅选低层机位打卡，不全程爬高层楼梯，游玩40分钟'),
            ScheduleItem(time: '17:30', text: '洪崖洞周边社区火锅店晚餐，点鸳鸯锅，推荐春红火锅'),
            ScheduleItem(time: '19:30', text: '步行千厮门大桥拍摄洪崖洞全景，不进入洪崖洞楼内拥挤区域'),
            ScheduleItem(time: '21:20', text: '步行返回酒店休息'),
          ]),
        DayPlan(day: 3, date: '7月4日（周六）', title: '科普+南岸江景线', theme: '科技馆 · 三峡博物馆 · 长江索道 · 南滨路',
          tips: '科技馆和三峡博物馆均免费但需预约/凭身份证，索道务必从南岸坐回渝中避开排队高峰。',
          items: [
            ScheduleItem(time: '09:00', text: '酒店早餐'),
            ScheduleItem(time: '09:30', text: '重庆科技馆（免费，凭身份证入场），室内恒温，儿童专区互动项目充足'),
            ScheduleItem(time: '12:30', text: '科技馆附近平价简餐'),
            ScheduleItem(time: '14:00', text: '三峡博物馆（免费，提前公众号预约），配套人民大礼堂外观打卡'),
            ScheduleItem(time: '17:00', text: '乘坐6号线至上新街索道南站，提前线上购票，从南岸坐索道跨江回渝中'),
            ScheduleItem(time: '18:30', text: '龙门浩老街散步、吹江风，平坦步道适合儿童活动'),
            ScheduleItem(time: '20:00', text: '沿南滨路滨江步道观赏渝中夜景，视野开阔，替代南山一棵树'),
            ScheduleItem(time: '21:10', text: '打车返回解放碑酒店'),
          ]),
        DayPlan(day: 4, date: '7月5日（周日）', title: '古镇+文艺老街线', theme: '磁器口古镇 · 黄桷坪涂鸦街 · 交通茶馆',
          tips: '磁器口务必早出发避开人流，走后街路线更清净；涂鸦街户外为主，选早晚拍照光线好。',
          items: [
            ScheduleItem(time: '08:30', text: '酒店早餐，早出发避开古镇人流'),
            ScheduleItem(time: '09:30', text: '轨道交通1号线直达磁器口古镇，走正门→宝轮寺→嘉陵江码头→后街路线，游玩2小时'),
            ScheduleItem(time: '12:00', text: '磁器口后街本地餐馆午餐，毛血旺、鸡杂搭配清汤小菜'),
            ScheduleItem(time: '14:00', text: '轨道交通1号线转18号线前往黄桷坪涂鸦街，户外拍照1小时'),
            ScheduleItem(time: '15:30', text: '交通茶馆喝盖碗茶休息，人均10元，感受本地老茶馆氛围'),
            ScheduleItem(time: '17:30', text: '黄桷坪附近豆花饭、家常菜晚餐'),
            ScheduleItem(time: '19:30', text: '轻轨返程回酒店'),
          ]),
        DayPlan(day: 5, date: '7月6日（周一）', title: '老城慢逛+返程', theme: '山城步道 · 伴手礼采购 · 返程',
          tips: '山城步道只走下坡段省体力；伴手礼在市区超市买比景区便宜很多。',
          items: [
            ScheduleItem(time: '09:00', text: '酒店早餐，办理退房，行李寄存前台'),
            ScheduleItem(time: '10:00', text: '山城步道平缓段游览，只走下坡路段，体验老重庆街巷风貌'),
            ScheduleItem(time: '11:40', text: '附近居民楼江湖菜午餐，点不辣菜品给孩子'),
            ScheduleItem(time: '13:00', text: '超市采购麻花、火锅底料等伴手礼，不在景区购买特产'),
            ScheduleItem(time: '14:00', text: '返回酒店取行李，根据返程车次/航班，搭乘轻轨或网约车前往车站、机场'),
          ]),
      ],
    );
  }
}
