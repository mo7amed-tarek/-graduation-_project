import 'package:codecrefactos/customer_screens/models/basket_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OrderSummaryList extends StatelessWidget {
  final List<BasketItem> items;

  const OrderSummaryList({super.key, required this.items});

  String fixImageUrl(String url) {
    const baseUrl = "http://store2.runasp.net";

    if (url.isEmpty) return "";
    if (url.startsWith("http")) return url;

    return baseUrl + url;
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Order Summary',
          style: TextStyle(fontSize: 18.sp, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 12.h),

        ...items.map((item) {
          return Container(
            margin: EdgeInsets.only(bottom: 12.h),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16.r),
              boxShadow: [BoxShadow(color: Colors.black12, blurRadius: 6.r)],
            ),
            child: Row(
              children: [
                Image.network(
                  fixImageUrl(item.pictureUrl),
                  width: 60.w,
                  height: 60.h,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),

                SizedBox(width: 12.w),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        item.productName,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text('Qty: ${item.quantity}'),
                    ],
                  ),
                ),

                Text(
                  '${(item.price * item.quantity).toStringAsFixed(0)} EGP',
                  style: const TextStyle(
                    color: Colors.green,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          );
        }),
      ],
    );
  }
}
