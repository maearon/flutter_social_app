import 'package:flutter/material.dart';
import 'package:flutter_social_app/core/models/micropost.dart';
import 'package:flutter_social_app/core/models/user.dart';
import 'package:flutter_social_app/core/utils/date_format_util.dart';
import 'package:flutter_social_app/core/utils/gravatar_util.dart';
import 'package:flutter_social_app/features/auth/providers/auth_provider.dart';
import 'package:flutter_social_app/features/micropost/services/micropost_service.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MicropostItem extends ConsumerStatefulWidget {
  final Micropost micropost;
  final Function() onDelete;
  
  const MicropostItem({
    Key? key,
    required this.micropost,
    required this.onDelete,
  }) : super(key: key);

  @override
  ConsumerState<MicropostItem> createState() => _MicropostItemState();
}

class _MicropostItemState extends ConsumerState<MicropostItem> {
  final MicropostService _micropostService = MicropostService();
  bool _isDeleting = false;

  Future<void> _deleteMicropost() async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Delete Micropost'),
        content: const Text('Are you sure you want to delete this micropost?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(false),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () => Navigator.of(context).pop(true),
            child: const Text('Delete'),
            style: TextButton.styleFrom(foregroundColor: Colors.red),
          ),
        ],
      ),
    );

    if (confirmed != true) return;

    setState(() {
      _isDeleting = true;
    });

    try {
      await _micropostService.deleteMicropost(widget.micropost.id);
      widget.onDelete();
    } catch (error) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to delete micropost'),
          backgroundColor: Colors.red,
        ),
      );
      setState(() {
        _isDeleting = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final currentUser = authState.user;
    final isCurrentUserPost = currentUser?.id == widget.micropost.userId;

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 0),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                GestureDetector(
                  onTap: () => context.go('/users/${widget.micropost.userId}'),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      GravatarUtil.getGravatarUrl(
                        widget.micropost.gravatarId ?? '',
                        size: 50,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: GestureDetector(
                              onTap: () => context.go('/users/${widget.micropost.userId}'),
                              child: Text(
                                widget.micropost.userName ?? 'User',
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                          ),
                          Text(
                            DateFormatUtil.formatDate(widget.micropost.timestamp),
                            style: TextStyle(
                              color: Colors.grey.shade600,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 4),
                      Text(widget.micropost.content),
                      if (widget.micropost.image.isNotEmpty && widget.micropost.image != 'default.jpg')
                        Padding(
                          padding: const EdgeInsets.only(top: 8),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.network(
                              widget.micropost.image,
                              fit: BoxFit.cover,
                              width: double.infinity,
                              height: 200,
                              errorBuilder: (context, error, stackTrace) {
                                return Container(
                                  width: double.infinity,
                                  height: 200,
                                  color: Colors.grey.shade200,
                                  child: const Center(
                                    child: Icon(Icons.error),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      if (isCurrentUserPost)
                        Align(
                          alignment: Alignment.centerRight,
                          child: _isDeleting
                              ? const SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: CircularProgressIndicator(strokeWidth: 2),
                                )
                              : IconButton(
                                  onPressed: _deleteMicropost,
                                  icon: const Icon(Icons.delete),
                                  color: Colors.red,
                                  tooltip: 'Delete',
                                ),
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
