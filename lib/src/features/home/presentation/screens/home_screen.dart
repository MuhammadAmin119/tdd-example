import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tdd_example/src/features/home/presentation/cubit/home_cubit.dart';
import 'package:tdd_example/src/features/home/presentation/cubit/home_state.dart';
import 'package:tdd_example/src/features/home/presentation/widget/product_card_widget.dart';
class HomeScreen extends StatelessWidget {
   HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title:  Text('Products')),
      body: BlocBuilder<HomeCubit, HomeState>(
        builder: (context, state) {
          if (state.status == HomeStatus.loading) {
            return  Center(child: CircularProgressIndicator());
          }

          if (state.status == HomeStatus.error) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                   Icon(Icons.error_outline, size: 48, color: Colors.red),
                   SizedBox(height: 12),
                  Text(state.errorText ?? 'Something went wrong'),
                   SizedBox(height: 12),
                  ElevatedButton(
                    onPressed: () => context.read<HomeCubit>().getProducts(),
                    child:  Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state.status == HomeStatus.success) {
            final products = state.products;
            return ListView.builder(
              padding:  EdgeInsets.all(16),
              itemCount: products?.name.length
               ?? 0,
              itemBuilder: (context, index) {
                final product = products!;
                return ProductCard(product: product);
              },
            );
          }

          return  SizedBox();
        },
      ),
    );
  }
}

