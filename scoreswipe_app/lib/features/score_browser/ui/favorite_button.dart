part of 'score_browser_screen.dart';

class FavoriteButton extends StatefulWidget {
  const FavoriteButton({super.key, required this.scoreData});

  final ScoreData scoreData;

  @override
  State<FavoriteButton> createState() => _FavoriteButtonState();
}

class _FavoriteButtonState extends State<FavoriteButton> {
  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 8,
      child: GestureDetector(
        onTap: () {
          setState(() {
            widget.scoreData.toggleFavorite();
          });
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
            widget.scoreData.isFavorite ? Icons.star : Icons.star_border,
            color: Theme.of(context).colorScheme.onSurface,
          ),
        ),
      ),
    );
  }
}
