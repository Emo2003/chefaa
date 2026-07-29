import 'package:chefaa/features/patient/cart/presentation/manager/cart_cubit.dart';
import 'package:chefaa/features/patient/pharmacy/medicines/data/models/medicine_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../../../../../core/routes/app_routes_names.dart';
import 'add_to_cart_button.dart';

class VerticalMedicineCard extends StatelessWidget {
  final MedicineModel medicine;
  final String pharmacyId;

  const VerticalMedicineCard({
    super.key,
    required this.medicine,
    required this.pharmacyId,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        context.push(AppRoutesNames.medicineDetails, extra: medicine);
      },
      child: Container(
        width: double.infinity,
        margin: const EdgeInsets.only(bottom: 12),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: BoxDecoration(
                color: const Color(0xffEAF7F0),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(
                Icons.medication_outlined,
                color: Color(0xff0F8A5F),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    medicine.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: Color(0xff1A1D29),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    medicine.category,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      fontSize: 12.5,
                      fontWeight: FontWeight.w500,
                      color: Colors.grey.shade500,
                    ),
                  ),
                  const SizedBox(height: 6),
                  Text(
                    '${medicine.price} EGP',
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Color(0xff0F8A5F),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            AddToCartButton(
              onPressed: () {
                CartManager().addToCart(
                  pharmacyId: pharmacyId,
                  medicineId: medicine.id,
                  name: medicine.name,
                  dosage: medicine.category,
                  price: medicine.price.toDouble(),
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
                            '1 Pack of ${medicine.name} added to cart.',
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
          ],
        ),
      ),
    );
  }
}
