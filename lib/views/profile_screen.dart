import 'package:flutter/material.dart';

class Profile {
  final String id;
  final String name;
  final String email;
  final String? phone;
  final String? photoUrl;
  final String? bio;
  final DateTime? dateOfBirth;
  final String? location;
  final int followers;
  final int following;
  final int posts;

  Profile({
    required this.id,
    required this.name,
    required this.email,
    this.phone,
    this.photoUrl,
    this.bio,
    this.dateOfBirth,
    this.location,
    this.followers = 0,
    this.following = 0,
    this.posts = 0,
  });

  Profile copyWith({
    String? id,
    String? name,
    String? email,
    String? phone,
    String? photoUrl,
    String? bio,
    DateTime? dateOfBirth,
    String? location,
    int? followers,
    int? following,
    int? posts,
  }) {
    return Profile(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      phone: phone ?? this.phone,
      photoUrl: photoUrl ?? this.photoUrl,
      bio: bio ?? this.bio,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      location: location ?? this.location,
      followers: followers ?? this.followers,
      following: following ?? this.following,
      posts: posts ?? this.posts,
    );
  }
}

class ProfileScreen extends StatefulWidget {
  static const String id = "profile_screen";
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final Profile _profile = Profile(
    id: '1',
    name: 'John Doe',
    email: 'john.doe@example.com',
    phone: '+1234567890',
    photoUrl: 'https://via.placeholder.com/150',
    bio: 'Flutter Developer | Mobile App Enthusiast',
    dateOfBirth: DateTime(1990, 5, 15),
    location: 'Jakarta, Indonesia',
    followers: 1248,
    following: 567,
    posts: 89,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // Navigate to edit profile screen
            },
          ),
          IconButton(
            icon: const Icon(Icons.settings),
            onPressed: () {
              // Navigate to settings
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ProfileHeader(profile: _profile),
            const SizedBox(height: 24),
            ProfileStats(profile: _profile),
            const SizedBox(height: 24),
            ProfileMenu(profile: _profile),
          ],
        ),
      ),
    );
  }
}

class ProfileHeader extends StatelessWidget {
  final Profile profile;

  const ProfileHeader({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        CircleAvatar(
          radius: 60,
          backgroundImage: profile.photoUrl != null
              ? NetworkImage(profile.photoUrl!)
              : const AssetImage('assets/default_avatar.png') as ImageProvider,
        ),
        const SizedBox(height: 16),
        Text(
          profile.name,
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        if (profile.bio != null)
          Text(
            profile.bio!,
            style: TextStyle(fontSize: 16, color: Colors.grey[600]),
            textAlign: TextAlign.center,
          ),
        const SizedBox(height: 8),
        if (profile.location != null)
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.location_on, size: 16, color: Colors.grey[600]),
              const SizedBox(width: 4),
              Text(
                profile.location!,
                style: TextStyle(fontSize: 14, color: Colors.grey[600]),
              ),
            ],
          ),
      ],
    );
  }
}

class ProfileStats extends StatelessWidget {
  final Profile profile;

  const ProfileStats({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatColumn(profile.posts, 'Posts'),
        _buildStatColumn(profile.followers, 'Followers'),
        _buildStatColumn(profile.following, 'Following'),
      ],
    );
  }

  Widget _buildStatColumn(int count, String label) {
    return Column(
      children: [
        Text(
          count.toString(),
          style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 4),
        Text(label, style: TextStyle(fontSize: 14, color: Colors.grey[600])),
      ],
    );
  }
}

class ProfileMenu extends StatelessWidget {
  final Profile profile;

  const ProfileMenu({super.key, required this.profile});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _buildMenuTile(
          icon: Icons.person,
          title: 'Edit Profile',
          onTap: () {
            // Navigate to edit profile
          },
        ),
        _buildMenuTile(
          icon: Icons.email,
          title: 'Email',
          subtitle: profile.email,
          onTap: () {},
        ),
        if (profile.phone != null)
          _buildMenuTile(
            icon: Icons.phone,
            title: 'Phone',
            subtitle: profile.phone,
            onTap: () {},
          ),
        if (profile.dateOfBirth != null)
          _buildMenuTile(
            icon: Icons.cake,
            title: 'Date of Birth',
            subtitle: _formatDate(profile.dateOfBirth!),
            onTap: () {},
          ),
        _buildMenuTile(
          icon: Icons.security,
          title: 'Privacy & Security',
          onTap: () {},
        ),
        _buildMenuTile(icon: Icons.help, title: 'Help & Support', onTap: () {}),
        _buildMenuTile(
          icon: Icons.logout,
          title: 'Logout',
          onTap: () {
            _showLogoutDialog(context);
          },
          color: Colors.red,
        ),
      ],
    );
  }

  Widget _buildMenuTile({
    required IconData icon,
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Color? color,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(color: color, fontWeight: FontWeight.w500),
      ),
      subtitle: subtitle != null ? Text(subtitle) : null,
      trailing: const Icon(Icons.chevron_right),
      onTap: onTap,
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logout'),
        content: const Text('Are you sure you want to logout?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Cancel'),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              // Implement logout logic
            },
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
