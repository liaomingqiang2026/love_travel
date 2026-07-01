import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'dart:math';
import '../models/trip_data.dart';

class PhotoPage extends StatefulWidget {
  final TripData tripData;
  final ValueChanged<TripData> onDataChanged;

  const PhotoPage({super.key, required this.tripData, required this.onDataChanged});

  @override
  State<PhotoPage> createState() => _PhotoPageState();
}

class _PhotoPageState extends State<PhotoPage> {
  late TripData _data;
  int _selectedDay = 0;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _data = widget.tripData;
  }

  @override
  void didUpdateWidget(covariant PhotoPage oldWidget) {
    super.didUpdateWidget(oldWidget);
    _data = widget.tripData;
  }

  String _randomId() {
    final r = Random();
    return '${DateTime.now().millisecondsSinceEpoch}_${r.nextInt(9999)}';
  }

  Future<void> _takePhoto() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.camera,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 80,
      );
      if (photo == null) return;

      // Save to app directory
      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'photo_${_randomId()}.jpg';
      final savedFile = File('${dir.path}/$fileName');
      await File(photo.path).copy(savedFile.path);

      setState(() {
        _data.photos.add(PhotoRecord(
          id: _randomId(),
          dayIdx: _selectedDay,
          path: savedFile.path,
          time: DateTime.now().toIso8601String(),
        ));
        widget.onDataChanged(_data);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('📸 照片已保存'), duration: Duration(seconds: 1)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('拍照失败: $e')),
        );
      }
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final XFile? photo = await _picker.pickImage(
        source: ImageSource.gallery,
        maxWidth: 1920,
        maxHeight: 1920,
        imageQuality: 80,
      );
      if (photo == null) return;

      final dir = await getApplicationDocumentsDirectory();
      final fileName = 'photo_${_randomId()}.jpg';
      final savedFile = File('${dir.path}/$fileName');
      await File(photo.path).copy(savedFile.path);

      setState(() {
        _data.photos.add(PhotoRecord(
          id: _randomId(),
          dayIdx: _selectedDay,
          path: savedFile.path,
          time: DateTime.now().toIso8601String(),
        ));
        widget.onDataChanged(_data);
      });

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('📸 照片已添加'), duration: Duration(seconds: 1)),
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('选择图片失败: $e')),
        );
      }
    }
  }

  void _deletePhoto(int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('删除照片'),
        content: const Text('确定删除这张照片吗？'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('取消')),
          TextButton(
            onPressed: () {
              setState(() {
                final photo = _data.photos[index];
                try { File(photo.path).deleteSync(); } catch (_) {}
                _data.photos.removeAt(index);
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

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(14),
      child: Column(
        children: [
          // Camera controls
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('📸', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      const Text('拍照记录', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  // Day selector
                  DropdownButtonFormField<int>(
                    value: _selectedDay,
                    decoration: const InputDecoration(
                      labelText: '选择日期',
                      border: OutlineInputBorder(),
                      contentPadding: EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    ),
                    items: _data.days.asMap().entries.map((entry) {
                      return DropdownMenuItem(value: entry.key, child: Text('Day ${entry.value.day} · ${entry.value.date}'));
                    }).toList(),
                    onChanged: (v) {
                      if (v != null) setState(() => _selectedDay = v);
                    },
                  ),
                  const SizedBox(height: 12),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton.icon(
                          onPressed: _takePhoto,
                          icon: const Icon(Icons.camera_alt),
                          label: const Text('拍照'),
                          style: ElevatedButton.styleFrom(
                            primary: const Color(0xFFC0392B),
                            onPrimary: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: OutlinedButton.icon(
                          onPressed: _pickFromGallery,
                          icon: const Icon(Icons.photo_library),
                          label: const Text('相册'),
                          style: OutlinedButton.styleFrom(
                            primary: const Color(0xFFC0392B),
                            side: const BorderSide(color: Color(0xFFC0392B)),
                            padding: const EdgeInsets.symmetric(vertical: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(height: 12),
          // Photo gallery
          Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Text('🖼', style: TextStyle(fontSize: 20)),
                      const SizedBox(width: 8),
                      const Text('照片相册', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w700)),
                    ],
                  ),
                  const SizedBox(height: 12),
                  if (_data.photos.isEmpty)
                    Container(
                      padding: const EdgeInsets.symmetric(vertical: 40),
                      child: Center(
                        child: Column(
                          children: [
                            const Text('📷', style: TextStyle(fontSize: 48)),
                            const SizedBox(height: 8),
                            const Text('还没有照片，点击上方按钮记录美好瞬间',
                                style: TextStyle(color: Color(0xFF7F8C8D), fontSize: 14)),
                          ],
                        ),
                      ),
                    )
                  else
                    _buildPhotoGrid(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPhotoGrid() {
    // Sort by newest first
    final reversed = _data.photos.reversed.toList();
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 8,
        mainAxisSpacing: 8,
      ),
      itemCount: reversed.length,
      itemBuilder: (context, index) {
        final photo = reversed[index];
        final originalIndex = _data.photos.length - 1 - index;
        return GestureDetector(
          onTap: () => _showPhotoFullscreen(photo.path),
          child: Stack(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.file(
                  File(photo.path),
                  width: double.infinity,
                  height: double.infinity,
                  fit: BoxFit.cover,
                  errorBuilder: (_, __, ___) => Container(
                    color: const Color(0xFFEEEEEE),
                    child: const Icon(Icons.broken_image, color: Color(0xFFBDC3C7)),
                  ),
                ),
              ),
              Positioned(
                top: 4, right: 4,
                child: GestureDetector(
                  onTap: () => _deletePhoto(originalIndex),
                  child: Container(
                    width: 24, height: 24,
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(Icons.close, color: Colors.white, size: 14),
                  ),
                ),
              ),
              Positioned(
                bottom: 0, left: 0, right: 0,
                child: Container(
                  padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 6),
                  decoration: const BoxDecoration(
                    color: Colors.black38,
                    borderRadius: BorderRadius.only(bottomLeft: Radius.circular(8), bottomRight: Radius.circular(8)),
                  ),
                  child: Text('Day ${photo.dayIdx + 1}', style: const TextStyle(color: Colors.white, fontSize: 10)),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  void _showPhotoFullscreen(String path) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => Scaffold(
          backgroundColor: Colors.black,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            foregroundColor: Colors.white,
            elevation: 0,
          ),
          body: Center(
            child: InteractiveViewer(
              child: Image.file(File(path), fit: BoxFit.contain),
            ),
          ),
        ),
      ),
    );
  }
}
