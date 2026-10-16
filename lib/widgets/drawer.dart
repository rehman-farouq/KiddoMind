import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
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
              padding: EdgeInsets.symmetric(horizontal: 20.w, vertical: 30.h),
              decoration: BoxDecoration(
                gradient: LinearGradient(colors: [Color(0xFFFF6B6B), Color(0xFFFF8E53)], begin: Alignment.topLeft, end: Alignment.bottomRight),
                borderRadius: BorderRadius.only(bottomLeft: Radius.circular(30.r), bottomRight: Radius.circular(30.r)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 10.h),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.all(8.w),
                        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.2), borderRadius: BorderRadius.circular(15.r)),
                        child: Text("🧸", style: TextStyle(fontSize: 30.sp)),
                      ),
                      SizedBox(width: 12.w),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "KiddoMind",
                            style: TextStyle(fontSize: 22.sp, fontWeight: FontWeight.bold, color: Colors.white),
                          ),
                          Text("Learn & Play", style: TextStyle(fontSize: 13.sp, color: Colors.white70)),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),

            SizedBox(height: 8.h),

            Expanded(
              child: ListView(
                padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 8.h),
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

                  SizedBox(height: 8.h),
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

                  SizedBox(height: 8.h),
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

                  Divider(height: 24.h, thickness: 1, color: Colors.grey),

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
              padding: EdgeInsets.symmetric(vertical: 12.h),
              decoration: BoxDecoration(
                border: Border(top: BorderSide(color: Colors.grey.shade200, width: 1.w)),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("✨ Made with", style: TextStyle(fontSize: 12.sp, color: Colors.grey)),
                  SizedBox(width: 4.w),
                  Text("❤️", style: TextStyle(fontSize: 12.sp, color: Colors.red)),
                  SizedBox(width: 4.w),
                  Text("for Kids", style: TextStyle(fontSize: 12.sp, color: Colors.grey.shade600)),
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
      padding: EdgeInsets.only(left: 8.w, top: 8.h, bottom: 6.h),
      child: Text(
        title,
        style: TextStyle(fontSize: 12.sp, fontWeight: FontWeight.bold, color: Colors.grey.shade600, letterSpacing: 1),
      ),
    );
  }

  Widget _buildTile(BuildContext context, {required IconData icon, required String title, required Color color, required VoidCallback onTap}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 3.h),
      child: InkWell(
        borderRadius: BorderRadius.circular(16.r),
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 12.w, vertical: 10.h),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16.r),
            boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.04), blurRadius: 6.r, offset: const Offset(0, 2))],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(8.w),
                decoration: BoxDecoration(color: color.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12.r)),
                child: Icon(icon, color: color, size: 22.sp),
              ),
              SizedBox(width: 12.w),

              Expanded(
                child: Text(
                  title,
                  style: TextStyle(fontSize: 14.sp, fontWeight: FontWeight.w600, color: Colors.black87),
                ),
              ),

              Icon(Icons.arrow_forward_ios_rounded, size: 12.sp, color: Colors.grey.shade400),
            ],
          ),
        ),
      ),
    );
  }
}
