import 'package:chefaa/features/patient/cart/presentation/manager/cart_cubit.dart';
import 'package:chefaa/features/patient/pharmacy/medicines/data/models/medicine_model.dart';
import 'package:chefaa/features/patient/pharmacy/medicines/presentation/widgets/medicine_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/routes/app_routes_names.dart';

class MedicineList extends StatelessWidget {
  final List<MedicineModel> medicines;
  final String pharmacyId;

  const MedicineList({
    super.key,
    required this.medicines,
    required this.pharmacyId,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: medicines.length,
      separatorBuilder: (_, _) => 16.verticalSpace,
      itemBuilder: (_, index) {
        final med = medicines[index];
        return GestureDetector(
          onTap: () {
            context.push(
              AppRoutesNames.medicineDetails,
              extra: {
                'name': med.name,
                'activeIngredient': med.category,
                'price': '${med.price} EGP',
                'medicineId': med.id,
                'pharmacyId': pharmacyId,
              },
            );
          },
          child: MedicineCard(
            name: med.name,
            description: med.category,
            price: '${med.price} EGP',
            onAddTap: () {
              CartManager().addToCart(
                pharmacyId: pharmacyId,
                medicineId: med.id,
                name: med.name,
                dosage: med.category,
                price: med.price.toDouble(),
                quantity: 1,
              );
              ScaffoldMessenger.of(context).clearSnackBars();
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Row(
                    children: [
                      const Icon(
                        Icons.check_circle_rounded,
                        color: Colors.white,
                        size: 20,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          '1 Pack of ${med.name} added to cart.',
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ],
                  ),
                  backgroundColor: const Color(0xff059669),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              );
            },
          ),
        );
      },
    );
  }
}
