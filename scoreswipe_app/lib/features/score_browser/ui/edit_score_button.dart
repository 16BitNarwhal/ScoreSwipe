part of 'score_browser_screen.dart';

class EditButton extends StatelessWidget {
  final ScoreModel score;

  const EditButton({Key? key, required this.score}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          builder: (context) {
            return Dialog(child: EditForm(score: score));
          },
        );
      },
      child: SizedBox(
        height: 60,
        width: 60,
        child: Icon(
          Icons.edit,
          size: 30,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
