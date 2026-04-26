import 'package:codecrefactos/Settings/Widgets/change_password_sheet.dart';
import 'package:codecrefactos/Settings/Widgets/create_account_sheet.dart';
import 'package:codecrefactos/Settings/Widgets/edit_profile_sheet.dart';
import 'package:codecrefactos/apiService.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:codecrefactos/login_screen/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final _api = ApiService();
  bool _isLoggingOut = false;

  // ─── Profile Data ──────────────────────────────────────────
  bool _profileLoading = false;
  String _fullName = 'Admin User';
  String _email = 'superadmin@workspace.com';
  String _initials = 'AU';

  @override
  void initState() {
    super.initState();
    _fetchProfile();
  }

  Future<void> _fetchProfile() async {
    setState(() => _profileLoading = true);
    try {
      final response = await _api.get('User/profile');
      final data = response.data;

      final name = data['fullName'] ?? data['userName'] ?? 'Admin User';
      final email = data['email'] ?? '';

      final parts = name.trim().split(' ');
      String initials;
      if (parts.length >= 2) {
        initials = '${parts[0][0]}${parts[1][0]}'.toUpperCase();
      } else if (parts.isNotEmpty && parts[0].isNotEmpty) {
        initials = parts[0][0].toUpperCase();
      } else {
        initials = 'AU';
      }

      setState(() {
        _fullName = name;
        _email = email;
        _initials = initials;
      });
    } on DioException catch (e) {
      debugPrint('Profile error: ${_api.handleError(e)}');
    } catch (e) {
      debugPrint('Profile error: $e');
    } finally {
      setState(() => _profileLoading = false);
    }
  }

  // ─── Open Edit Profile ─────────────────────────────────────
  void _openEditProfile() async {
    await showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => EditProfileSheet(
        currentName: _fullName,
        currentEmail: _email,
        initials: _initials,
      ),
    );
    // أعد تحميل البيانات بعد الإغلاق
    _fetchProfile();
  }

  void _openChangePassword() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const ChangePasswordSheet(),
    );
  }

  void _openCreateAccount() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => const CreateAccountSheet(),
    );
  }

  Future<void> _openWhatsApp() async {
    final Uri whatsappUri = Uri.parse('whatsapp://send?phone=201031426089');
    final Uri webUri = Uri.parse(
      'https://api.whatsapp.com/send?phone=201031426089',
    );
    try {
      if (await canLaunchUrl(whatsappUri)) {
        await launchUrl(whatsappUri, mode: LaunchMode.externalApplication);
      } else {
        await launchUrl(webUri, mode: LaunchMode.externalApplication);
      }
    } catch (_) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Could not open WhatsApp')));
    }
  }

  Future<void> _logout() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Terminate Session',
          style: TextStyle(
            fontWeight: FontWeight.w700,
            color: Color(0xFF1A202C),
          ),
        ),
        content: const Text(
          'Are you sure you want to log out?',
          style: TextStyle(color: Color(0xFF718096)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx, false),
            child: const Text(
              'Cancel',
              style: TextStyle(color: Color(0xFF718096)),
            ),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(ctx, true),
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFE53E3E),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
              elevation: 0,
            ),
            child: const Text('Logout'),
          ),
        ],
      ),
    );

    if (confirm != true) return;
    setState(() => _isLoggingOut = true);

    try {
      await _api.dio.post(
        'user/logout',
        options: Options(contentType: Headers.jsonContentType),
      );
    } on DioException catch (_) {
    } finally {
      ApiService.token = null;
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove('token');
      await prefs.remove('role');

      if (!mounted) return;
      setState(() => _isLoggingOut = false);

      Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (_) => LoginScreen()),
        (route) => false,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF0F2F7),
      body: Column(
        children: [
          Container(
            color: Colors.white,
            height: MediaQuery.of(context).padding.top,
          ),
          _buildHeader(),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.only(top: 16, bottom: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildCriticalControls(),
                  _buildTechResources(),
                  _buildTerminateButton(),
                  _buildAccessMode(),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(28),
          bottomRight: Radius.circular(28),
        ),
      ),
      padding: const EdgeInsets.fromLTRB(20, 52, 20, 28),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(14),
              gradient: const LinearGradient(
                colors: [Color(0xFF4A5568), Color(0xFF2D3748)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            alignment: Alignment.center,
            child: _profileLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      color: Colors.white,
                      strokeWidth: 2,
                    ),
                  )
                : Text(
                    _initials,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                      fontSize: 16,
                      letterSpacing: 1,
                    ),
                  ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _profileLoading ? 'Loading...' : _fullName,
                  style: const TextStyle(
                    fontWeight: FontWeight.w700,
                    fontSize: 16,
                    color: Color(0xFF1A202C),
                  ),
                ),
                const SizedBox(height: 3),
                Row(
                  children: [
                    const Icon(
                      Icons.email_outlined,
                      size: 12,
                      color: Color(0xFF718096),
                    ),
                    const SizedBox(width: 4),
                    Expanded(
                      child: Text(
                        _profileLoading ? '...' : _email,
                        style: const TextStyle(
                          fontSize: 12,
                          color: Color(0xFF718096),
                        ),
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: _openEditProfile,
            child: const Text(
              'EDIT\nPROFILE',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w700,
                color: Color(0xFF718096),
                letterSpacing: 1,
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionLabel(String title, {bool showShield = false}) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 22, 20, 12),
      child: Row(
        children: [
          if (showShield) ...[
            const Icon(
              Icons.shield_outlined,
              size: 16,
              color: Color(0xFFE53E3E),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.w700,
              color: Color(0xFFA0AEC0),
              letterSpacing: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCriticalControls() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Critical Controls', showShield: true),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(height: 10),
              _buildCard(
                onTap: _openChangePassword,
                child: Row(
                  children: [
                    _buildIconBox(
                      icon: Icons.lock_outline,
                      iconColor: const Color(0xFF718096),
                      bgColor: const Color(0xFFF7FAFC),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Text(
                        'Change Security Credentials',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFFA0AEC0)),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              _buildCard(
                onTap: _openCreateAccount,
                child: Row(
                  children: [
                    _buildIconBox(
                      icon: Icons.person_add_outlined,
                      iconColor: const Color(0xFF4299E1),
                      bgColor: const Color(0xFFEBF8FF),
                    ),
                    const SizedBox(width: 14),
                    const Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Create New Account',
                            style: TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Color(0xFF1A202C),
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Add a new user to the system',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFA0AEC0),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const Icon(Icons.chevron_right, color: Color(0xFFA0AEC0)),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildTechResources() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _buildSectionLabel('Tech Resources'),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: _buildCard(
            onTap: _openWhatsApp,
            child: Row(
              children: [
                _buildIconBox(
                  icon: Icons.chat_bubble_outline,
                  iconColor: const Color(0xFF38A169),
                  bgColor: const Color(0xFFF0FFF4),
                ),
                const SizedBox(width: 14),
                const Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Emergency Tech Support',
                        style: TextStyle(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Color(0xFF1A202C),
                        ),
                      ),
                      SizedBox(height: 2),
                      Text(
                        'Direct line to System Developer',
                        style: TextStyle(
                          fontSize: 12,
                          color: Color(0xFFA0AEC0),
                        ),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right, color: Color(0xFFA0AEC0)),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildTerminateButton() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 8),
      child: GestureDetector(
        onTap: _isLoggingOut ? null : _logout,
        child: Container(
          width: double.infinity,
          padding: const EdgeInsets.symmetric(vertical: 16),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFFED7D7), width: 1.5),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 4,
                offset: const Offset(0, 1),
              ),
            ],
          ),
          child: _isLoggingOut
              ? const SizedBox(
                  height: 20,
                  child: Center(
                    child: SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        color: Color(0xFFE53E3E),
                        strokeWidth: 2.5,
                      ),
                    ),
                  ),
                )
              : const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(
                      Icons.logout_rounded,
                      color: Color(0xFFE53E3E),
                      size: 18,
                    ),
                    SizedBox(width: 10),
                    Text(
                      'Terminate Session',
                      style: TextStyle(
                        color: Color(0xFFE53E3E),
                        fontWeight: FontWeight.w700,
                        fontSize: 15,
                      ),
                    ),
                  ],
                ),
        ),
      ),
    );
  }

  Widget _buildAccessMode() {
    return const Padding(
      padding: EdgeInsets.only(top: 8),
      child: Center(
        child: Text(
          'ACCESS MODE: 202.16.4.1 · 2024',
          style: TextStyle(
            fontSize: 11,
            color: Color(0xFFB0BEC5),
            letterSpacing: 1,
          ),
        ),
      ),
    );
  }

  Widget _buildCard({Widget? child, VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 4,
              offset: const Offset(0, 1),
            ),
          ],
        ),
        child: child,
      ),
    );
  }

  Widget _buildIconBox({
    required IconData icon,
    required Color iconColor,
    required Color bgColor,
  }) {
    return Container(
      width: 38,
      height: 38,
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}
