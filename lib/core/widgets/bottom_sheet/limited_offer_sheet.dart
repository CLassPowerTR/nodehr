import 'package:flutter/material.dart';
import 'package:nodehr/core/constants/app_colors.dart';
import 'package:nodehr/core/models/offer_package_model.dart';

class LimitedOfferSheet extends StatelessWidget {
  const LimitedOfferSheet({super.key});

  @override
  Widget build(BuildContext context) {
    final List<OfferPackageModel> packages = const [
      OfferPackageModel(
        id: 'basic',
        title: 'Basic',
        description: '720p • 1 ekran',
        price: 29.99,
        oldPrice: 39.99,
        durationDays: 30,
      ),
      OfferPackageModel(
        id: 'standard',
        title: 'Standard',
        description: '1080p • 2 ekran',
        price: 49.99,
        oldPrice: 59.99,
        durationDays: 30,
      ),
      OfferPackageModel(
        id: 'premium',
        title: 'Premium',
        description: '4K • 4 ekran',
        price: 69.99,
        oldPrice: 79.99,
        durationDays: 30,
      ),
    ];

    return LayoutBuilder(
      builder: (context, constraints) {
        final double maxWidth = constraints.maxWidth;
        final bool isWide = maxWidth > 520;
        return Container(
          decoration: const BoxDecoration(
            color: AppColors.surface,
            borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
          ),
          padding: const EdgeInsets.fromLTRB(16, 12, 16, 24),
          child: SafeArea(
            top: false,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 48,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Text(
                  'Sınırlı Teklif',
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                const SizedBox(height: 8),
                Text(
                  'Bugüne özel indirimli paketler',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                const SizedBox(height: 16),
                Flexible(
                  child: isWide
                      ? Row(
                          children: packages
                              .map((p) => Expanded(child: _OfferTile(model: p)))
                              .toList(growable: false),
                        )
                      : Column(
                          mainAxisSize: MainAxisSize.min,
                          children: packages
                              .map(
                                (p) => Padding(
                                  padding: const EdgeInsets.only(bottom: 12),
                                  child: _OfferTile(model: p),
                                ),
                              )
                              .toList(growable: false),
                        ),
                ),
                const SizedBox(height: 8),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.secondary,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    onPressed: () => Navigator.of(context).maybePop(),
                    child: const Text('Devam Et'),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _OfferTile extends StatelessWidget {
  final OfferPackageModel model;
  const _OfferTile({required this.model});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white10,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: Colors.white12),
      ),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(model.title, style: Theme.of(context).textTheme.titleMedium),
              const SizedBox(width: 8),
              if (model.oldPrice != null)
                Text(
                  '${model.oldPrice!.toStringAsFixed(0)}₺',
                  style: const TextStyle(
                    decoration: TextDecoration.lineThrough,
                    color: Colors.white54,
                  ),
                ),
              const Spacer(),
              Text(
                '${model.price.toStringAsFixed(0)}₺',
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            model.description,
            style: Theme.of(context).textTheme.bodyMedium,
          ),
          const SizedBox(height: 8),
          Text(
            '${model.durationDays} gün',
            style: Theme.of(context).textTheme.bodySmall,
          ),
        ],
      ),
    );
  }
}
