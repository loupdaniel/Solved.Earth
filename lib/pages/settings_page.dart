import 'package:app/Constants/gaps.dart';
import 'package:flutter/material.dart';
import 'package:app/pages/authentication/sign_up_screen.dart';
import 'package:url_launcher/url_launcher.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Gaps.v10,
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                /*return Scaffold(
                  appBar: AppBar(
                    title: const Text("계정 연결"),
                  ),
                );*/
                return const SignUpScreen();
              },
            ),
          ),
          child: const Tile(
            icon: Icons.person_outline,
            color: Colors.purple,
            text: "계정 연결",
          ),
        ),
        Gaps.v10,
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("공지사항"),
                  ),
                );
              },
            ),
          ),
          child: const Tile(
            icon: Icons.campaign_outlined,
            color: Colors.green,
            text: "공지사항",
          ),
        ),
        Gaps.v10,
        GestureDetector(
          onTap: () async {
            final url = Uri.parse(
              'https://docs.google.com/forms/d/e/1FAIpQLSckeLnESZUKqdkjAzkRZvKIaqkNC3azNiZ4SVlk6pzcthWbLQ/viewform',
            );
            if (await canLaunchUrl(url)) {
              launchUrl(url, mode: LaunchMode.externalApplication);
              // 크롬 브라우저에서 제대로 실행이 안 될 경우, launchUrl(url); 로 수정
            } else {
              // ignore: avoid_print
              print("Can't launch $url");
            }
          },
          child: const Tile(
            icon: Icons.bug_report_outlined,
            color: Colors.redAccent,
            text: "버그 신고",
          ),
        ),
        Gaps.v10,
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("서비스 이용약관"),
                  ),
                );
              },
            ),
          ),
          child: const Tile(
            icon: Icons.article_outlined,
            color: Colors.brown,
            text: "서비스 이용약관",
          ),
        ),
        Gaps.v10,
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("개인정보 처리방침"),
                  ),
                );
              },
            ),
          ),
          child: const Tile(
            icon: Icons.apps_outage,
            color: Colors.teal,
            text: "개인정보 처리방침",
          ),
        ),
        Gaps.v10,
        GestureDetector(
          onTap: () => Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) {
                return Scaffold(
                  appBar: AppBar(
                    title: const Text("오픈소스 라이선스"),
                  ),
                );
              },
            ),
          ),
          child: const Tile(
            icon: Icons.policy_outlined,
            color: Colors.blue,
            text: "오픈소스 라이선스",
          ),
        ),
      ],
    );
  }
}

class Tile extends StatelessWidget {
  final IconData icon;
  final Color color;
  final String text;

  const Tile({
    required this.icon,
    required this.color,
    super.key,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: Container(
        height: 50,
        width: 50,
        decoration: BoxDecoration(
          color: color.withOpacity(0.2),
          borderRadius: BorderRadius.circular(18),
        ),
        child: Icon(
          icon,
          color: color,
        ),
      ),
      title: Text(
        text,
        style: const TextStyle(
          fontWeight: FontWeight.w500,
          fontSize: 17,
        ),
      ),
      trailing: const Icon(
        Icons.arrow_forward_ios_outlined,
        color: Colors.black,
        size: 20,
      ),
    );
  }
}
