part of 'score_browser_screen.dart';

class FavoriteButton extends StatelessWidget {
  const FavoriteButton({super.key, required this.score});

  final ScoreModel score;

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      child: GestureDetector(
        onTap: () {
          BlocProvider.of<ScoreBrowserBloc>(context).add(ToggleFavorite(score));
        },
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.surface,
            borderRadius: BorderRadius.circular(10),
          ),
          foregroundDecoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: Theme.of(context).colorScheme.surface,
              width: 2,
            ),
          ),
          height: 40,
          width: 40,
          child: Icon(
            score.isFavorite ? Icons.star : Icons.star_border,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
