import 'package:flutter/material.dart';
import 'package:kids_learning_app/utils/route/route_constant.dart';

class MyDrawer extends StatelessWidget {
  const MyDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: MediaQuery.of(context).size.width * 0.75,
      child: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(colors: [Color(0xFFFFF3E0), Color(0xFFFFE0B2)], begin: Alignment.topLeft, end: Alignment.bottomRight),
        ),
        child: Column(
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
              decoration: const BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30), bottomRight: Radius.circular(30)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10),
                  Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(8),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(15)),
                        child: const Text("🧸", style: TextStyle(fontSize: 30)),
                      ),
                      const SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            "KiddoMind",
                            style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text("Learn & Play", style: TextStyle(fontSize: 13, color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 8),

            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                physics: const BouncingScrollPhysics(),
                children: [
                  _buildCategorySection("📚 Learning"),
                  _buildTile(
                    context,
                    icon: Icons.home_rounded,
                    title: "Home",
                    color: const Color(0xFFFF6B6B),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AllRoutesConstant.mainhomeRoute);
                    },
                  ),
                  _buildTile(
                    context,
                    icon: Icons.abc,
                    title: "Alphabets",
                    color: const Color(0xFF2196F3),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AllRoutesConstant.atozRoute);
                    },
                  ),
                  _buildTile(
                    context,
                    icon: Icons.pets,
                    title: "Animals",
                    color: const Color(0xFFFF9800),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AllRoutesConstant.animalRoute);
                    },
                  ),
                  _buildTile(
                    context,
                    icon: Icons.flutter_dash,
                    title: "Birds",
                    color: const Color(0xFF9C27B0),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AllRoutesConstant.birdsRoute);
                    },
                  ),
                  _buildTile(
                    context,
                    icon: Icons.accessibility_new,
                    title: "Body Parts",
                    color: const Color(0xFF00BCD4),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AllRoutesConstant.partsRoute);
                    },
                  ),
                  _buildTile(
                    context,
                    icon: Icons.palette,
                    title: "Colors",
                    color: const Color(0xFFE91E63),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AllRoutesConstant.colourRoute);
                    },
                  ),
                  _buildTile(
                    context,
                    icon: Icons.apple,
                    title: "Fruits",
                    color: const Color(0xFFFFB74D),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AllRoutesConstant.fruitRoute);
                    },
                  ),
                  _buildTile(
                    context,
                    icon: Icons.public,
                    title: "Solar System",
                    color: const Color(0xFF1A237E),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AllRoutesConstant.solarRoute);
                    },
                  ),

                  const SizedBox(height: 8),
                  _buildCategorySection("🧮 Math"),
                  _buildTile(
                    context,
                    icon: Icons.numbers,
                    title: "Counting",
                    color: const Color(0xFF00BCD4),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AllRoutesConstant.countingRoute);
                    },
                  ),
                  _buildTile(
                    context,
                    icon: Icons.calculate,
                    title: "Multiplication",
                    color: const Color(0xFF8D6E63),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AllRoutesConstant.tableRoute);
                    },
                  ),

                  const SizedBox(height: 8),
                  _buildCategorySection("🎨 Creativity"),
                  _buildTile(
                    context,
                    icon: Icons.draw,
                    title: "Drawing Board",
                    color: const Color(0xFFFF6F00),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AllRoutesConstant.drawingboardRoute);
                    },
                  ),

                  const Divider(height: 24, thickness: 1, color: Colors.grey),

                  _buildTile(
                    context,
                    icon: Icons.person_rounded,
                    title: "About",
                    color: const Color(0xFFFF6B6B),
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, AllRoutesConstant.aboutRoute);
                    },
                  ),
                ],
              ),
            ),

            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text("✨ Made with", style: TextStyle(fontSize: 12, color: Colors.grey)),
                  const SizedBox(width: 4),
                  const Text("❤️", style: TextStyle(fontSize: 12, color: Colors.red)),
                  const SizedBox(width: 4),
                  Text("for Kids", style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategorySection(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 8, bottom: 6),
      child: Text(
        title,
        style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1),
      ),
    );
  }

  Widget _buildTile(BuildContext context, {required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 3),
      child: InkWell(
        borderRadius: BorderRadius.circular(16),
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12)),
                child: Icon(icon, color: color, size: 22),
              ),
              const SizedBox(width: 12),

              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ),

              Icon(Icons.arrow_forward_ios_rounded, size: 12, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
