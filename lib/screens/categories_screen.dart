import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../models/category.dart';
import '../theme/app_theme.dart';

class CategoriesScreen extends StatelessWidget {
  const CategoriesScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final categories = [
      Category(name: 'Electronics', slug: 'electronics', icon: '📱', color: '#0066FF'),
      Category(name: 'Fashion', slug: 'fashion', icon: '👔', color: '#FF6B9D'),
      Category(name: 'Phones', slug: 'phones', icon: '📞', color: '#00B4D8'),
      Category(name: 'Computers', slug: 'computers', icon: '💻', color: '#6366F1'),
      Category(name: 'Furniture', slug: 'furniture', icon: '🛋️', color: '#8B5CF6'),
      Category(name: 'Gaming', slug: 'gaming', icon: '🎮', color: '#EC4899'),
      Category(name: 'Beauty', slug: 'beauty', icon: '💄', color: '#F59E0B'),
      Category(name: 'Shoes', slug: 'shoes', icon: '👟', color: '#10B981'),
      Category(name: 'Groceries', slug: 'groceries', icon: '🛒', color: '#22C55E'),
      Category(name: 'Kitchen', slug: 'kitchen', icon: '🍳', color: '#F97316'),
      Category(name: 'Automotive', slug: 'automotive', icon: '🚗', color: '#64748B'),
      Category(name: 'Health', slug: 'health', icon: '⚕️', color: '#EF4444'),
    ];

    final width = MediaQuery.of(context).size.width;
    final crossAxisCount = width < 600 ? 2 : width < 960 ? 3 : 4;
    final childAspectRatio = width < 600 ? 0.95 : width < 960 ? 1.0 : 1.05;

    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => context.pop(),
        ),
        title: const Text('Categories'),
      ),
      body: GridView.builder(
        padding: const EdgeInsets.all(16),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: crossAxisCount,
          mainAxisSpacing: 16,
          crossAxisSpacing: 16,
          childAspectRatio: childAspectRatio,
        ),
        itemCount: categories.length,
        itemBuilder: (context, index) {
          final category = categories[index];
          return GestureDetector(
            onTap: () => context.go('/categories/${category.slug}'),
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.categoryColors[category.name]?.withOpacity(0.1) ?? AppTheme.secondary,
                borderRadius: BorderRadius.circular(16),
                border: Border.all(color: AppTheme.border),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(category.icon, style: const TextStyle(fontSize: 48)),
                  const SizedBox(height: 12),
                  Text(
                    category.name,
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),
                  Icon(Icons.arrow_forward, color: AppTheme.categoryColors[category.name] ?? AppTheme.primary, size: 20),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
