import 'package:flutter/material.dart';
// drawer.dart

class AppDrawer extends StatelessWidget {
  final String selectedNavItem;
  final Function(String) onNavItemChanged;

  const AppDrawer({
    Key? key,
    required this.selectedNavItem,
    required this.onNavItemChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          const DrawerHeader(
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.white,
                  child: Text(
                    'T',
                    style: TextStyle(
                      fontSize: 24,
                      color: Colors.blue,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                SizedBox(height: 10),
                Text(
                  'Tfkcodes',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
                Text(
                  'contact@lucianojr.me',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),
          buildDrawerItem('Home', Icons.home),
          buildDrawerItem('Settings', Icons.settings),
          // Add social media icons
          // Align(
          //   alignment: Alignment.bottomCenter,
          //   child: buildSocialMediaIcons(),
          // )
        ],
      ),
    );
  }

  Widget buildDrawerItem(String title, IconData icon) {
    return Padding(
      padding: const EdgeInsets.only(left: 8.0, top: 8.0, bottom: 8.0),
      child: ListTile(
        selected: selectedNavItem == title,
        selectedTileColor: Colors.blue,
        selectedColor: Colors.white,
        leading: Icon(icon),
        title: Text(title),
        onTap: () {
          onNavItemChanged(title);
        },
      ),
    );
  }

  Widget buildSocialMediaIcons() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly, children: [
        SocialMediaIcon(icon: Icons.facebook, url: 'https://www.facebook.com'),
        SocialMediaIcon(icon: Icons.facebook, url: 'https://www.facebook.com'),
        SocialMediaIcon(icon: Icons.facebook, url: 'https://www.facebook.com'),
      ]),
    );
  }
}

class SocialMediaIcon extends StatelessWidget {
  final IconData icon;
  final String url;

  const SocialMediaIcon({Key? key, required this.icon, required this.url})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(icon),
      onPressed: () {
        // Add logic to open the corresponding social media URL
      },
      color: Colors.blue,
    );
  }
}
