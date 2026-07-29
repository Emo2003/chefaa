import 'package:chefaa/core/resources/values_manager.dart';
import 'package:chefaa/core/routes/app_routes_names.dart';
import 'package:chefaa/core/widgets/inside_app_bar.dart';
import
'package:chefaa/features/doctor/home/presentation/widgets/custom_outline_button.dart';
import 'package:chefaa/features/patient/cart/presentation/manager/cart_cubit.dart';
import 'package:chefaa/features/patient/cart/presentation/widgets/cart_item_card.dart';
import 'package:chefaa/features/patient/cart/presentation/widgets/order_summary_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  late final List<Map<String, dynamic>> cartItems;

  @override
  void initState() {
    super.initState();
    cartItems = CartManager().cartItems;
  }

  double deliveryFee = 15;

  double get subtotal {
    double total = 0;

    for (var item in cartItems) {
      total += item["price"] * item["quantity"];
    }

    return total;
  }

  double get total => subtotal + deliveryFee;

  void increaseQuantity(int index) {
    setState(() {
      cartItems[index]["quantity"]++;
    });
  }

  void decreaseQuantity(int index) {
    setState(() {
      if (cartItems[index]["quantity"] > 1) {
        cartItems[index]["quantity"]--;
      }
    });
  }

  void removeItem(int index) {
    setState(() {
      cartItems.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(100),
        child: InsideAppBar(
          title: " My Cart ",
          subtitle: "Check your items before placing order",
          isLayout: true,
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppPadding.p20,
          vertical: AppPadding.p32,
        ),
        child: Column(
          children: [
            Expanded(
              child: ListView.separated(
                itemCount: cartItems.length,
                shrinkWrap: true,
                separatorBuilder: (_, _) => 16.verticalSpace,

                itemBuilder: (context, index) {
                  final item = cartItems[index];
                  return CartItemCard(
                    item: item,
                    index: index,
                    onIncrease: () => increaseQuantity(index),
                    onDecrease: () => decreaseQuantity(index),
                    onDelete: () => removeItem(index),
                  );
                },
              ),
            ),

            20.verticalSpace,
            CustomOutlineButton(text: "Add More Items", onPressed: () {}),

            10.verticalSpace,
            OrderSummaryCard(
              subtotal: subtotal,
              deliveryFee: deliveryFee,
              total: total,
              onPressed: () {
                final pid = CartManager().pharmacyId;
                if (pid == null || pid.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Pharmacy info is missing. Please add items from a pharmacy first.",
                      ),
                      backgroundColor: Colors.red,
                    ),
                  );
                  return;
                }
                context.push(
                  AppRoutesNames.checkoutPage,
                  extra: {
                    'pharmacyId': pid,
                    'items': cartItems,
                    'subtotal': subtotal,
                    'deliveryFee': deliveryFee,
                  },
                );
              },
              btnTitle: "Proceed to Checkout",
            ),
          ],
        ),
      ),
    );
  }
}
