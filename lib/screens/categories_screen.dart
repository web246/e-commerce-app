import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../models/category.dart';
import '../theme/app_theme.dart';
import '../providers/categories_provider.dart';

class CategoriesScreen extends StatefulWidget {
  const CategoriesScreen({super.key});

  @override
  State<CategoriesScreen> createState() => _CategoriesScreenState();
}

class _CategoriesScreenState extends State<CategoriesScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<CategoriesProvider>().fetchAll();
    });
  }

  @override
  Widget build(BuildContext context) {
    final categoriesProvider = context.watch<CategoriesProvider>();
    final categories = categoriesProvider.categories;

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
