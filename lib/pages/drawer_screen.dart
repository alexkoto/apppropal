// import 'package:flutter/material.dart';
// import 'admin_drawer.dart';
// import 'user_drawer.dart';

// class DrawerScreen extends StatelessWidget {
//   final bool isAdmin;
//   final Function onDashboardTap;
//   final Function onUserManagementTap;

//   DrawerScreen({
//     required this.isAdmin,
//     required this.onDashboardTap,
//     required this.onUserManagementTap,
//   });

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Drawer Example'),
//       ),
//       drawer: isAdmin
//           ? AdminDrawer(
//               onDashboardTap: onDashboardTap,
//               onUserManagementTap: onUserManagementTap,
//             )
//           : UserDrawer(
//               onDashboardTap: onDashboardTap,
//             ),
//       body: Center(
//         child: Text(
//           'Main Content',
//           style: TextStyle(fontSize: 24.0),
//         ),
//       ),
//     );
//   }
// }
