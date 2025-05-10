import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_social_app/features/micropost/services/micropost_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class MicropostForm extends StatefulWidget {
  final Function() onPostCreated;
  
  const MicropostForm({
    Key? key,
    required this.onPostCreated,
  }) : super(key: key);

  @override
  State<MicropostForm> createState() => _MicropostFormState();
}

class _MicropostFormState extends State<MicropostForm> {
  final TextEditingController _contentController = TextEditingController();
  final MicropostService _micropostService = MicropostService();
  final ImagePicker _imagePicker = ImagePicker();
  File? _selectedImage;
  bool _isSubmitting = false;
  String? _error;

  @override
  void dispose() {
    _contentController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final pickedFile = await _imagePicker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  Future<void> _submitPost() async {
    if (_contentController.text.trim().isEmpty) {
      setState(() {
        _error = 'Content cannot be empty';
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final formData = FormData();
      formData.fields.add(MapEntry('micropost[content]', _contentController.text.trim()));
      
      if (_selectedImage != null) {
        formData.files.add(MapEntry(
          'micropost[image]',
          await MultipartFile.fromFile(_selectedImage!.path),
        ));
      }

      await _micropostService.createMicropost(formData);
      _contentController.clear();
      setState(() {
        _selectedImage = null;
      });
      widget.onPostCreated();
    } catch (error) {
      setState(() {
        _error = 'Failed to create micropost. Please try again.';
      });
    } finally {
      setState(() {
        _isSubmitting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Compose new micropost',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (_error != null)
          Container(
            padding: const EdgeInsets.all(8),
            margin: const EdgeInsets.only(bottom: 8),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(4),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Text(
              _error!,
              style: TextStyle(color: Colors.red.shade800),
            ),
          ),
        TextField(
          controller: _contentController,
          maxLength: 140,
          maxLines: 3,
          decoration: const InputDecoration(
            hintText: 'What\'s on your mind?',
            border: OutlineInputBorder(),
          ),
        ),
        if (_selectedImage != null)
          Container(
            margin: const EdgeInsets.only(top: 8, bottom: 8),
            height: 100,
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade300),
              borderRadius: BorderRadius.circular(4),
            ),
            child: Stack(
              children: [
                Center(
                  child: Image.file(
                    _selectedImage!,
                    height: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                Positioned(
                  top: 4,
                  right: 4,
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _selectedImage = null;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.all(4),
                      decoration: BoxDecoration(
                        color: Colors.black.withOpacity(0.6),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.close,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        Row(
          children: [
            IconButton(
              onPressed: _isSubmitting ? null : _pickImage,
              icon: const Icon(Icons.image),
              tooltip: 'Add image',
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isSubmitting ? null : _submitPost,
              child: _isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : const Text('Post'),
            ),
          ],
        ),
      ],
    );
  }
}
