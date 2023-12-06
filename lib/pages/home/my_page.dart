import 'package:flutter/material.dart';
import 'package:qianshi_music/constants.dart';
import 'package:qianshi_music/widgets/fix_image.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(255, 241, 240, 238),
      child: SingleChildScrollView(
        child: Column(
          children: [
            _buildBaseInfo(),
            const SizedBox(
              height: 16,
            ),
            SizedBox(
              
            )
          ],
        ),
      ),
    );
  }

  SizedBox _buildBaseInfo() {
    return SizedBox(
      height: 200,
      child: Stack(
        children: [
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Container(
              height: 120,
              width: double.infinity,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.all(Radius.circular(32)),
              ),
              margin: const EdgeInsets.only(top: -32),
              child: const Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ClipRRect(
                    borderRadius: BorderRadius.all(Radius.circular(32)),
                    child: FixImage(
                        imageUrl: AssetsContants.defaultAvatar,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Text(
                    "未登录",
                    style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(
                    height: 8,
                  ),
                  Row(
                    children: [
                      Text(
                        "0 关注",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "0 粉丝",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                      SizedBox(
                        width: 8,
                      ),
                      Text(
                        "Lv.0",
                        style: TextStyle(fontSize: 12, color: Colors.grey),
                      ),
                    ],
                  )
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
