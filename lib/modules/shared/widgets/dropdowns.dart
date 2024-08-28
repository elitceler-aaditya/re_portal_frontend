// import 'package:flutter/material.dart';
// import 'package:callerxyz/shared/widgets/colors.dart';

// class CustomDropDown extends StatelessWidget {
//   final String? label;
//   final List<String> items;
//   final String? value;
//   final bool isExpanded;
//   final Function(String?)? onChanged;

//   const CustomDropDown({
//     super.key,
//     this.label,
//     required this.items,
//     this.value,
//     this.isExpanded = false,
//     this.onChanged,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Container(
//       height: 40,
//       padding: const EdgeInsets.symmetric(horizontal: 10),
//       decoration: BoxDecoration(
//         color: CustomColors.blue10,
//         borderRadius: BorderRadius.circular(8),
//         border: Border.all(color: CustomColors.blue, width: 1.5),
//       ),
//       child: DropdownButton<String?>(
//         isExpanded: isExpanded,
//         underline: SizedBox(),
//         hint: Text(
//           label ?? "None",
//           style: TextStyle(
//             color: CustomColors.blue,
//           ),
//         ),
//         icon: Icon(
//           Icons.keyboard_arrow_down_outlined,
//           color: CustomColors.blue,
//         ),
//         value: value,
//         onChanged: onChanged,
//         items: [
//           DropdownMenuItem<String?>(
//             value: null,
//             child: Text(
//               label ?? "None",
//               style: TextStyle(
//                 color: CustomColors.blue,
//               ),
//             ),
//           ),
//           ...items.map<DropdownMenuItem<String>>((value) {
//             return DropdownMenuItem<String>(
//               value: value,
//               child: Text(
//                 value,
//                 style: TextStyle(
//                   color: CustomColors.blue,
//                 ),
//               ),
//             );
//           }).toList(),
//         ],
//       ),
//     );
//   }
// }
