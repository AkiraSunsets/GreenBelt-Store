import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import '../screens/initial_screen.dart';
import '../services/auth_service.dart';

// ---------------------------------------------------------------------------
// Tela de Perfil principal
// ---------------------------------------------------------------------------
class ProfileScreen extends StatefulWidget {
  /// Callback chamado quando o usuário salva um nome novo em EditProfileScreen
  final VoidCallback? onNameUpdated;

  const ProfileScreen({super.key, this.onNameUpdated});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String _userName = '';
  String _userEmail = '';

  final List<Map<String, dynamic>> _menuItems = const [
    {'icon': Icons.person_outline, 'label': 'Your profile'},
    {'icon': Icons.location_on_outlined, 'label': 'Manage Address'},
    {'icon': Icons.credit_card_outlined, 'label': 'Payment Methods'},
    {'icon': Icons.receipt_long_outlined, 'label': 'My Orders'},
    {'icon': Icons.confirmation_number_outlined, 'label': 'My Coupons'},
    {'icon': Icons.account_balance_wallet_outlined, 'label': 'My Wallet'},
    {'icon': Icons.settings_outlined, 'label': 'Settings'},
    {'icon': Icons.help_outline, 'label': 'Help Center'},
  ];

  @override
  void initState() {
    super.initState();
    _carregarDados();
  }

  Future<void> _carregarDados() async {
    final nome = await AuthService.getNome();
    final email = await AuthService.getEmail();
    if (mounted) {
      setState(() {
        _userName = nome;
        _userEmail = email;
      });
    }
  }

  void _confirmLogout(BuildContext context) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(24))),
      builder: (_) => Padding(
        padding: const EdgeInsets.all(28),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2)),
            ),
            const SizedBox(height: 24),
            Text('Logout',
                style: GoogleFonts.montserrat(
                    fontSize: 20, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Text('Are you sure you want to log out?',
                style: GoogleFonts.montserrat(
                    fontSize: 14, color: Colors.grey.shade600)),
            const SizedBox(height: 28),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.pop(context),
                    style: OutlinedButton.styleFrom(
                      side: const BorderSide(color: Color(0xFF6500B2)),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                    ),
                    child: Text('Cancel',
                        style: GoogleFonts.montserrat(
                            color: const Color(0xFF6500B2),
                            fontWeight: FontWeight.w600)),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ElevatedButton(
                    onPressed: () async {
                      await AuthService.logout();
                      if (!context.mounted) return;
                      Navigator.of(context).popUntil((r) => r.isFirst);
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const StartApp()),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF6500B2),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(50)),
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      elevation: 0,
                    ),
                    child: Text('Yes, Logout',
                        style: GoogleFonts.montserrat(
                            color: Colors.white,
                            fontWeight: FontWeight.w600)),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        automaticallyImplyLeading: false,
        title: Text('Profile',
            style: GoogleFonts.montserrat(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.black)),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 12),

            // Avatar
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                Container(
                  width: 96,
                  height: 96,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border:
                        Border.all(color: const Color(0xFF6500B2), width: 2.5),
                  ),
                  child: ClipOval(
                    child: Image.network(
                      'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&q=80',
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: const BoxDecoration(
                      color: Color(0xFF6500B2), shape: BoxShape.circle),
                  child: const Icon(Icons.edit, size: 14, color: Colors.white),
                ),
              ],
            ),

            const SizedBox(height: 12),

            // Nome real do usuário
            Text(
              _userName.isEmpty ? '...' : _userName,
              style: GoogleFonts.montserrat(
                  fontSize: 18, fontWeight: FontWeight.bold),
            ),

            // Email do usuário
            if (_userEmail.isNotEmpty)
              Text(
                _userEmail,
                style: GoogleFonts.montserrat(
                    fontSize: 13, color: Colors.grey.shade500),
              ),

            const SizedBox(height: 28),

            // Menu items
            ListView.separated(
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: _menuItems.length,
              separatorBuilder: (_, __) =>
                  Divider(color: Colors.grey.shade100, height: 1),
              itemBuilder: (context, i) {
                final item = _menuItems[i];
                return ListTile(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                  leading: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFF3E5FF),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Icon(item['icon'] as IconData,
                        color: const Color(0xFF6500B2), size: 20),
                  ),
                  title: Text(
                    item['label'] as String,
                    style: GoogleFonts.montserrat(
                        fontSize: 15, fontWeight: FontWeight.w500),
                  ),
                  trailing:
                      const Icon(Icons.chevron_right, color: Colors.grey),
                  onTap: () async {
                    if (item['label'] == 'Your profile') {
                      final updated = await Navigator.push<bool>(
                        context,
                        MaterialPageRoute(
                          builder: (_) => EditProfileScreen(
                            initialName: _userName,
                            initialEmail: _userEmail,
                          ),
                        ),
                      );
                      if (updated == true) {
                        await _carregarDados();
                        widget.onNameUpdated?.call();
                      }
                    }
                  },
                );
              },
            ),

            const SizedBox(height: 12),
            Divider(color: Colors.grey.shade100),

            // Logout
            ListTile(
              contentPadding: const EdgeInsets.symmetric(horizontal: 24),
              leading: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.red.shade50,
                  borderRadius: BorderRadius.circular(10),
                ),
                child:
                    const Icon(Icons.logout, color: Colors.red, size: 20),
              ),
              title: Text('Logout',
                  style: GoogleFonts.montserrat(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: Colors.red)),
              onTap: () => _confirmLogout(context),
            ),

            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tela de Edição de Perfil
// ---------------------------------------------------------------------------
class EditProfileScreen extends StatefulWidget {
  final String initialName;
  final String initialEmail;

  const EditProfileScreen({
    super.key,
    required this.initialName,
    required this.initialEmail,
  });

  @override
  State<EditProfileScreen> createState() => _EditProfileScreenState();
}

class _EditProfileScreenState extends State<EditProfileScreen> {
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  final _phoneController = TextEditingController(text: '');
  String? _selectedGender;
  bool _isSaving = false;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.initialName);
    _emailController = TextEditingController(text: widget.initialEmail);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _phoneController.dispose();
    _emailController.dispose();
    super.dispose();
  }

  Future<void> _salvar() async {
    final novoNome = _nameController.text.trim();
    if (novoNome.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Name cannot be empty.',
              style: GoogleFonts.montserrat()),
          backgroundColor: Colors.red.shade700,
          behavior: SnackBarBehavior.floating,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() => _isSaving = true);
    await AuthService.atualizarNome(novoNome);
    if (!mounted) return;
    setState(() => _isSaving = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content:
            Text('Profile updated!', style: GoogleFonts.montserrat()),
        backgroundColor: const Color(0xFF6500B2),
        behavior: SnackBarBehavior.floating,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );

    // Retorna true para indicar que houve atualização
    Navigator.pop(context, true);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.pop(context),
          ),
          title: Text('Your Profile',
              style: GoogleFonts.montserrat(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.black)),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
          padding:
              const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Column(
            children: [
              Stack(
                alignment: Alignment.bottomRight,
                children: [
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                          color: const Color(0xFF6500B2), width: 2.5),
                    ),
                    child: ClipOval(
                      child: Image.network(
                        'https://images.unsplash.com/photo-1535713875002-d1d0cf377fde?w=200&q=80',
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(6),
                    decoration: const BoxDecoration(
                        color: Color(0xFF6500B2), shape: BoxShape.circle),
                    child: const Icon(Icons.edit,
                        size: 14, color: Colors.white),
                  ),
                ],
              ),

              const SizedBox(height: 28),

              _EditField(label: 'Name', controller: _nameController),
              const SizedBox(height: 16),

              // Phone
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Phone Number',
                      style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextField(
                            controller: _phoneController,
                            keyboardType: TextInputType.phone,
                            decoration: InputDecoration(
                              contentPadding: const EdgeInsets.symmetric(
                                  horizontal: 16, vertical: 14),
                              border: InputBorder.none,
                              hintText: '(00) 00000-0000',
                              hintStyle: GoogleFonts.montserrat(
                                  color: Colors.grey.shade400),
                            ),
                            style: GoogleFonts.montserrat(fontSize: 14),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              // Email (read-only — troca de email requer fluxo separado)
              _EditField(
                label: 'Email',
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                readOnly: true,
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Contact support to change your email.',
                  style: GoogleFonts.montserrat(
                      fontSize: 11, color: Colors.grey.shade400),
                ),
              ),

              const SizedBox(height: 16),

              // Gender
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Gender',
                      style: GoogleFonts.montserrat(
                          fontSize: 13,
                          fontWeight: FontWeight.w600,
                          color: Colors.grey.shade600)),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.grey.shade100,
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: DropdownButtonHideUnderline(
                      child: DropdownButton<String>(
                        value: _selectedGender,
                        isExpanded: true,
                        hint: Text('Select',
                            style: GoogleFonts.montserrat(
                                color: Colors.grey.shade400, fontSize: 14)),
                        items: ['Male', 'Female', 'Other']
                            .map((g) => DropdownMenuItem(
                                value: g,
                                child: Text(g,
                                    style: GoogleFonts.montserrat(
                                        fontSize: 14))))
                            .toList(),
                        onChanged: (v) =>
                            setState(() => _selectedGender = v),
                        style: GoogleFonts.montserrat(
                            fontSize: 14, color: Colors.black),
                        icon: const Icon(Icons.keyboard_arrow_down,
                            color: Color(0xFF6500B2)),
                      ),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 40),

              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isSaving ? null : _salvar,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF6500B2),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(50)),
                  ),
                  child: _isSaving
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text('Update',
                          style: GoogleFonts.montserrat(
                              color: Colors.white,
                              fontWeight: FontWeight.w700,
                              fontSize: 16)),
                ),
              ),

              const SizedBox(height: 32),
            ],
          ),
        ),
      ),
    );
  }
}

class _EditField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final TextInputType keyboardType;
  final bool readOnly;

  const _EditField({
    required this.label,
    required this.controller,
    this.keyboardType = TextInputType.text,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.montserrat(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600)),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          keyboardType: keyboardType,
          readOnly: readOnly,
          decoration: InputDecoration(
            filled: true,
            fillColor:
                readOnly ? Colors.grey.shade200 : Colors.grey.shade100,
            contentPadding:
                const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
              borderSide: BorderSide.none,
            ),
          ),
          style: GoogleFonts.montserrat(
              fontSize: 14,
              color: readOnly ? Colors.grey.shade500 : Colors.black),
        ),
      ],
    );
  }
}