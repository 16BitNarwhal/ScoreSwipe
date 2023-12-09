part of 'score_browser_screen.dart';

class EditForm extends StatefulWidget {
  final ScoreModel score;
  final Function refresh;

  EditForm({Key? key, required this.score, required this.refresh})
      : super(key: key);

  @override
  State<EditForm> createState() => _EditFormState();

  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _genresController = TextEditingController();
}

class _EditFormState extends State<EditForm> {
  final formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    widget._titleController.text = widget.score.scoreName;
    // TextEditingController(text: widget.score.genres.join(", "));
  }

  @override
  Widget build(BuildContext context) {
    return Form(
      child: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          border: Border.all(color: Theme.of(context).primaryColor, width: 2.0),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Title",
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                controller: widget._titleController,
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return "Please enter a title";
                  }
                  return null;
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 8.0),
              child: TextFormField(
                decoration: InputDecoration(
                  border: const OutlineInputBorder(),
                  labelText: "Genres",
                  labelStyle: TextStyle(
                    color: Theme.of(context).primaryColor,
                  ),
                ),
                style: TextStyle(
                  color: Theme.of(context).primaryColor,
                ),
                controller: widget._genresController,
                validator: (value) {
                  return null;
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: Text('Warning',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          content: Text(
                              'Are you sure you want to delete this score?',
                              style: TextStyle(
                                  color:
                                      Theme.of(context).colorScheme.primary)),
                          actions: <Widget>[
                            TextButton(
                              child: Text('Cancel',
                                  style: TextStyle(
                                      color: Theme.of(context)
                                          .colorScheme
                                          .primary)),
                              onPressed: () {
                                Navigator.of(context).pop();
                              },
                            ),
                            TextButton(
                              child: Text('Delete',
                                  style: TextStyle(
                                      color:
                                          Theme.of(context).colorScheme.error)),
                              onPressed: () async {
                                // TODO: delete score
                                // await widget.score.deleteScore();
                                if (context.mounted) {
                                  Navigator.of(context).pop(); // pop alert
                                  Navigator.of(context).pop(); // pop edit form
                                  widget.refresh();
                                }
                              },
                            ),
                          ],
                        );
                      },
                    );
                  },
                  child: Text("Delete",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary)),
                ),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: Text("Cancel",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary)),
                ),
                ElevatedButton(
                  onPressed: () async {
                    // TODO: edit score
                    // widget.score.setTitle(widget._titleController.text);
                    // widget.score
                    //     .setGenres(widget._genresController.text.split(","));
                    // await widget.score.saveMetadata();
                    if (context.mounted) {
                      Navigator.pop(context);
                      widget.refresh();
                    }
                  },
                  child: Text("Save",
                      style: TextStyle(
                          color: Theme.of(context).colorScheme.onPrimary)),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
