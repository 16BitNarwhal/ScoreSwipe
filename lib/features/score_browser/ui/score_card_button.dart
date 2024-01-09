part of 'score_browser_screen.dart';

class CardButton extends StatelessWidget {
  final ScoreModel score;
  final Widget icon;
  final Function() onTap;

  const CardButton(
      {super.key,
      required this.score,
      required this.icon,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        height: 60,
        width: 60,
        child: icon,
      ),
    );
  }
}
