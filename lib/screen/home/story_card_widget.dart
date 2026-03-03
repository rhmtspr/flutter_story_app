// import 'package:flutter/material.dart';
// import 'package:flutter_restaurant_app/data/model/restaurant_model.dart';

// class RestaurantCard extends StatelessWidget {
//   final Restaurant restaurant;
//   final VoidCallback onTap;

//   const RestaurantCard({
//     super.key,
//     required this.restaurant,
//     required this.onTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     final colors = Theme.of(context).colorScheme;
//     final text = Theme.of(context).textTheme;

//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//       child: Material(
//         color: colors.surface,
//         borderRadius: BorderRadius.circular(16),
//         elevation: 1.5,
//         child: InkWell(
//           borderRadius: BorderRadius.circular(16),
//           onTap: onTap,
//           child: Padding(
//             padding: const EdgeInsets.all(12),
//             child: Row(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 /// IMAGE
//                 ClipRRect(
//                   borderRadius: BorderRadius.circular(12),
//                   child: Hero(
//                     tag: restaurant.pictureId,
//                     child: Image.network(
//                       "https://restaurant-api.dicoding.dev/images/small/${restaurant.pictureId}",
//                       width: 110,
//                       height: 90,
//                       fit: BoxFit.cover,
//                       errorBuilder: (_, __, ___) => Container(
//                         width: 110,
//                         height: 90,
//                         color: colors.surfaceContainerHighest,
//                         child: Icon(Icons.broken_image, color: colors.outline),
//                       ),
//                     ),
//                   ),
//                 ),

//                 const SizedBox(width: 12),

//                 /// TEXT CONTENT
//                 Expanded(
//                   child: Column(
//                     crossAxisAlignment: CrossAxisAlignment.start,
//                     children: [
//                       /// NAME
//                       Text(
//                         restaurant.name,
//                         maxLines: 2,
//                         overflow: TextOverflow.ellipsis,
//                         style: text.titleMedium?.copyWith(
//                           fontWeight: FontWeight.w600,
//                         ),
//                       ),

//                       const SizedBox(height: 6),

//                       /// CITY
//                       Row(
//                         children: [
//                           Icon(
//                             Icons.location_on_outlined,
//                             size: 16,
//                             color: colors.onSurfaceVariant,
//                           ),
//                           const SizedBox(width: 4),
//                           Expanded(
//                             child: Text(
//                               restaurant.city,
//                               maxLines: 1,
//                               overflow: TextOverflow.ellipsis,
//                               style: text.bodySmall?.copyWith(
//                                 color: colors.onSurfaceVariant,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),

//                       const SizedBox(height: 8),

//                       /// RATING BADGE
//                       Container(
//                         padding: const EdgeInsets.symmetric(
//                           horizontal: 8,
//                           vertical: 4,
//                         ),
//                         decoration: BoxDecoration(
//                           color: colors.primaryContainer,
//                           borderRadius: BorderRadius.circular(8),
//                         ),
//                         child: Row(
//                           mainAxisSize: MainAxisSize.min,
//                           children: [
//                             Icon(
//                               Icons.star_rounded,
//                               size: 16,
//                               color: colors.primary,
//                             ),
//                             const SizedBox(width: 4),
//                             Text(
//                               restaurant.rating.toString(),
//                               style: text.labelMedium?.copyWith(
//                                 fontWeight: FontWeight.w600,
//                                 color: colors.onPrimaryContainer,
//                               ),
//                             ),
//                           ],
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }
