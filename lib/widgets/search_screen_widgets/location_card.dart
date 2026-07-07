import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import '../../theme/app_theme.dart';

class LocationCard extends StatelessWidget {
  const LocationCard({
    super.key,
    required this.position,
    required this.isLoading,
    required this.error,
    required this.onTap,
  });

  final Position? position;
  final bool isLoading;
  final String? error;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: InkWell(
        onTap: isLoading ? null : onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            children: [
              Icon(
                Icons.location_on,
                color: position != null
                    ? AppTheme.primary
                    : AppTheme.textSecondary,
                size: 28,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: isLoading
                    ? const Text('現在地を取得中...')
                    : error != null
                    ? Text(
                        error!,
                        style: const TextStyle(color: Colors.red, fontSize: 13),
                      )
                    : position != null
                    ? Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '現在地を取得しました',
                            style: TextStyle(fontWeight: FontWeight.w600),
                          ),
                          Text(
                            '緯度: ${position!.latitude.toStringAsFixed(5)}  '
                            '経度: ${position!.longitude.toStringAsFixed(5)}',
                            style: TextStyle(
                              fontSize: 12,
                              color: AppTheme.textSecondary,
                            ),
                          ),
                        ],
                      )
                    : const Text('タップして現在地を取得'),
              ),
              if (isLoading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Icon(Icons.chevron_right, color: AppTheme.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
