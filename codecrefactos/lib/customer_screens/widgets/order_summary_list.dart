import 'package:codecrefactos/customer_screens/models/basket_model.dart';
import 'package:flutter/material.dart';

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
        const Text(
          'Order Summary',
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 12),

        ...items.map((item) {
          return Container(
            margin: const EdgeInsets.only(bottom: 12),
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 6),
              ],
            ),
            child: Row(
              children: [
                Image.network(
                  fixImageUrl(item.pictureUrl),
                  width: 60,
                  height: 60,
                  fit: BoxFit.contain,
                  errorBuilder: (_, __, ___) => const Icon(Icons.broken_image),
                ),

                const SizedBox(width: 12),

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
