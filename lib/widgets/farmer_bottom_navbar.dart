import 'package:flutter/material.dart';

class FarmerBottomNavbar extends StatelessWidget {
  final int currentIndex;

  const FarmerBottomNavbar({
    super.key,
    required this.currentIndex,
  });

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: const Color(0xff075739),
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        if (index == currentIndex) return;

        switch(index){
          case 0:
            Navigator.pushReplacementNamed(context,'/farmerDashboard');
            break;

          case 1:
            Navigator.pushReplacementNamed(context,'/myCrops');
            break;

          case 2:
            Navigator.pushReplacementNamed(context, '/farmerInquiries');
            break;

          case 3:
            Navigator.pushReplacementNamed(context,'/profile');
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: "Home",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.local_florist),
          label: "My Crops",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.chat_bubble),
          label: "Inquiries",
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: "Profile",
        ),
      ],
    );
  }
}