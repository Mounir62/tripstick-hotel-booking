// import 'package:flutter/material.dart';
// import 'package:tripstick/widgets/favorites_manager.dart';
// import '../models/hotel.dart';
// import '../screens/hotel_details_screen.dart';

// class HotelCard extends StatefulWidget {
//   final Hotel hotel;

//   const HotelCard({super.key, required this.hotel});

//   @override
//   State<HotelCard> createState() => _HotelCardState();
// }

// class _HotelCardState extends State<HotelCard> {
//   bool isLiked = false;

//   @override
//   Widget build(BuildContext context) {
//     return GestureDetector(
//       onTap: () {
//         Navigator.push(
//           context,
//           MaterialPageRoute(
//             builder: (_) => HotelDetailsScreen(hotel: widget.hotel),
//           ),
//         );
//       },
//       child: Card(
//         margin: const EdgeInsets.only(bottom: 16),
//         shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//         elevation: 4,
//         clipBehavior: Clip.antiAlias,
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Image.network(
//               widget.hotel.imageUrl,
//               height: 180,
//               width: double.infinity,
//               fit: BoxFit.cover,
//             ),
//             Padding(
//               padding: const EdgeInsets.all(12.0),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     widget.hotel.name,
//                     style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   const SizedBox(height: 4),
//                   Row(
//                     children: [
//                       Icon(
//                         Icons.location_on,
//                         size: 16,
//                         color: Colors.grey[600],
//                       ),
//                       const SizedBox(width: 4),
//                       Text(
//                         widget.hotel.location,
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                       const Spacer(),
//                       Icon(Icons.star, size: 16, color: Colors.amber),
//                       Text('${widget.hotel.rating}'),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Row(
//                     children: [
//                       Text(
//                         '\$${widget.hotel.price.toStringAsFixed(0)} / night',
//                         style: const TextStyle(fontWeight: FontWeight.bold),
//                       ),
//                       const Spacer(),
//                       IconButton(
//                         onPressed: () {
//                           setState(() {
//                             FavoritesManager.toggleFavorite(widget.hotel);
//                           });
//                         },
//                         icon: Icon(
//                           Icons.favorite,
//                           color:
//                               FavoritesManager.isFavorite(widget.hotel)
//                                   ? Colors.red
//                                   : Colors.grey,
//                           size: 28,
//                         ),
//                       ),
//                     ],
//                   ),
//                 ],
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
