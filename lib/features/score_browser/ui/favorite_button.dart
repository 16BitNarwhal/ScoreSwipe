part of 'score_browser_screen.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.score});

  final ScoreModel score;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        BlocProvider.of<ScoreBrowserBloc>(context).add(ToggleFavorite(score));
      },
      child: SizedBox(
        height: 60,
        width: 60,
        child: Icon(
          score.isFavorite ? Icons.star : Icons.star_border,
          size: 30,
          color: Theme.of(context).colorScheme.onSurface,
        ),
      ),
    );
  }
}
