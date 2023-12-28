part of 'score_browser_screen.dart';

class EditForm extends StatefulWidget {
  final ScoreModel score;

  EditForm({Key? key, required this.score}) : super(key: key);

  @override
  State<EditForm> createState() => _EditFormState();

  final TextEditingController _titleController = TextEditingController();
}

class _EditFormState extends State<EditForm> {
  final formKey = GlobalKey<FormState>();
  late ScoreModel newScore;

  @override
  void initState() {
    super.initState();
    widget._titleController.text = widget.score.scoreName;
    newScore = widget.score;
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              padding: const EdgeInsets.only(top: 16.0),
              child: Text(
                "${widget.score.scoreName} Properties",
                style: TextStyle(
                  fontSize: 18.0,
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onBackground,
                ),
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            Container(
              padding:
                  const EdgeInsets.symmetric(vertical: 16.0, horizontal: 32),
              child: Column(
                children: [
                  Row(
                    children: [
                      Icon(
                        Icons.edit,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      const SizedBox(width: 16.0),
                      Expanded(
                        child: TextFormField(
                          controller: widget._titleController,
                          decoration: const InputDecoration(
                            border: InputBorder.none,
                            hintText: "Title",
                          ),
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter a title";
                            }
                            return null;
                          },
                        ),
                      ),
                    ],
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        newScore.isFavorite = !newScore.isFavorite;
                      });
                    },
                    child: Row(children: [
                      Icon(
                        newScore.isFavorite ? Icons.star : Icons.star_border,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        newScore.isFavorite ? "Favorited" : "Not favorited",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ]),
                  ),
                  const SizedBox(height: 16.0),
                  GestureDetector(
                    onTap: () async {
                      showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text('Warning'),
                            content: const Text(
                                'Are you sure you want to delete this score?'),
                            actions: <Widget>[
                              TextButton(
                                child: Text('Cancel',
                                    style: TextStyle(
                                        color: Theme.of(context)
                                            .colorScheme
                                            .onBackground)),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                },
                              ),
                              TextButton(
                                child: Text('Delete',
                                    style: TextStyle(color: Colors.red[900]!)),
                                onPressed: () async {
                                  Logger().wtf('Deleting score');
                                  BlocProvider.of<ScoreBrowserBloc>(context)
                                      .add(DeleteScore(widget.score));
                                  if (context.mounted) {
                                    Navigator.of(context).pop();
                                    Navigator.of(context).pop();
                                  }
                                },
                              ),
                            ],
                          );
                        },
                      );
                    },
                    child: Row(children: [
                      Icon(
                        Icons.delete,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                      const SizedBox(width: 16.0),
                      Text(
                        "Delete",
                        style: TextStyle(
                          color: Theme.of(context).colorScheme.onBackground,
                        ),
                      ),
                    ]),
                  ),
                ],
              ),
            ),
            const Divider(
              color: Colors.grey,
              thickness: 1.0,
            ),
            Container(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor: Theme.of(context).colorScheme.onError,
                      backgroundColor: Theme.of(context).colorScheme.error,
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    child: const Text('Cancel'),
                  ),
                  ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      foregroundColor:
                          Theme.of(context).colorScheme.onSecondary,
                      backgroundColor: Theme.of(context).colorScheme.secondary,
                    ),
                    onPressed: () {
                      if (formKey.currentState!.validate()) {
                        newScore.scoreName = widget._titleController.text;
                        BlocProvider.of<ScoreBrowserBloc>(context)
                            .add(EditScore(newScore));
                        if (context.mounted) {
                          Navigator.pop(context);
                        }
                      }
                    },
                    child: const Text('Save'),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
