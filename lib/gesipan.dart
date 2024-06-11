import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Feedback App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: FeedbackPage(),
    );
  }
}

class FeedbackPage extends StatefulWidget {
  @override
  _FeedbackPageState createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  String _selectedType = '후기';
  List<FeedbackItem> feedbacks = [];
  List<bool> _selectedToggle = [true, false];

  void _toggleFeedbackType(int index) {
    setState(() {
      _selectedType = index == 0 ? '후기' : '건의사항';
      _selectedToggle = [index == 0, index == 1];
    });
  }

  void _deleteFeedback(int index) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('글 삭제'),
        content: Text('정말로 이 글을 삭제하시겠습니까?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Text('취소'),
          ),
          TextButton(
            onPressed: () {
              setState(() {
                feedbacks.removeAt(index);
              });
              Navigator.of(context).pop();
            },
            child: Text('확인'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 247),
      appBar: AppBar(
        title: Text('게시판', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
      body: Stack(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ToggleButtons(
                      borderRadius: BorderRadius.circular(8),
                      selectedColor: Colors.white,
                      fillColor: Colors.blue,
                      color: Colors.blue,
                      selectedBorderColor: Colors.blue,
                      borderColor: Colors.blue,
                      isSelected: _selectedToggle,
                      onPressed: (int index) {
                        _toggleFeedbackType(index);
                      },
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            '후기 게시판',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text(
                            '건의사항 게시판',
                            style: TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: feedbacks.length,
                  itemBuilder: (context, index) {
                    if (feedbacks[index].type != _selectedType) return SizedBox.shrink();
                    return Dismissible(
                      key: Key(feedbacks[index].title),
                      direction: DismissDirection.endToStart,
                      background: Container(
                        color: Colors.red,
                        alignment: Alignment.centerRight,
                        padding: EdgeInsets.symmetric(horizontal: 20),
                        child: Icon(Icons.delete, color: Colors.white),
                      ),
                      onDismissed: (direction) {
                        _deleteFeedback(index);
                      },
                      child: ListTile(
                        title: Text(
                          feedbacks[index].title,
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '작성자: ${feedbacks[index].author}',
                              style: TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                            Row(
                              children: [
                                Text(
                                  '작성일시: ${feedbacks[index].formattedDateTime}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                                SizedBox(width: 20),
                                Text(
                                  '조회수: ${feedbacks[index].views}',
                                  style: TextStyle(fontSize: 12, color: Colors.grey),
                                ),
                              ],
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => FeedbackDetailsPage(
                                feedback: feedbacks[index],
                                onUpdate: () {
                                  setState(() {});
                                },
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
          Positioned(
            bottom: 16,
            left: 0,
            right: 0,
            child: Center(
              child: SizedBox(
                width: 150,
                height: 60,
                child: ElevatedButton(
                  onPressed: () async {
                    final newFeedback = await Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => AddFeedbackPage()),
                    );
                    if (newFeedback != null) {
                      setState(() {
                        feedbacks.add(newFeedback);
                      });
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.zero,
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30),
                      side: BorderSide(
                        color: Color(0xFFC9C9D2),
                        width: 1,
                      ),
                    ),
                  ),
                  child: Ink(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Container(
                      constraints: BoxConstraints(minWidth: 150, minHeight: 60),
                      alignment: Alignment.center,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Image.asset(
                            'assets/pencil.png',
                            width: 33,
                            height: 23,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(width: 8),
                          Text(
                            '글 쓰기',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class AddFeedbackPage extends StatefulWidget {
  @override
  _AddFeedbackPageState createState() => _AddFeedbackPageState();
}

class _AddFeedbackPageState extends State<AddFeedbackPage> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  String _selectedType = '후기';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color.fromARGB(255, 245, 245, 247),
        appBar: AppBar(
          title: Text('글 작성'),
          leading: IconButton(
            icon: Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
        ),
        body: Padding(
        padding: const EdgeInsets.all(16.0),
    child: Column(
    crossAxisAlignment: CrossAxisAlignment.stretch,
    children: [
    DropdownButton<String>(
    value: _selectedType,
    items: <
        String>['후기', '건의사항'].map((String value) {
      return DropdownMenuItem<String>(
        value: value,
        child: Text(value),
      );
    }).toList(),
      onChanged: (String? newValue) {
        setState(() {
          _selectedType = newValue!;
        });
      },
    ),
      TextField(
        controller: _titleController,
        decoration: InputDecoration(labelText: '제목을 입력하세요'),
      ),
      SizedBox(height: 16.0),
      TextField(
        controller: _contentController,
        decoration: InputDecoration(labelText: '내용을 입력하세요'),
        maxLines: null,
      ),
      SizedBox(height: 16.0),
      ElevatedButton(
        onPressed: () {
          Navigator.pop(
            context,
            FeedbackItem(
              title: _titleController.text,
              content: _contentController.text,
              author: '작성자',
              createdDateTime: DateTime.now(),
              type: _selectedType,
            ),
          );
        },
        child: Text('작성 완료'),
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.blue,
          foregroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
        ),
      ),
    ],
    ),
        ),
    );
  }
}

class FeedbackDetailsPage extends StatefulWidget {
  final FeedbackItem feedback;
  final VoidCallback onUpdate;

  FeedbackDetailsPage({required this.feedback, required this.onUpdate});

  @override
  _FeedbackDetailsPageState createState() => _FeedbackDetailsPageState();
}

class _FeedbackDetailsPageState extends State<FeedbackDetailsPage> {
  final TextEditingController _commentController = TextEditingController();

  void _addComment() {
    if (_commentController.text.isNotEmpty) {
      setState(() {
        widget.feedback.comments.add(
          Comment(
            author: '댓글 작성자',
            content: _commentController.text,
          ),
        );
        _commentController.clear();
      });
      widget.onUpdate();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 245, 245, 247),
      appBar: AppBar(
        title: Text('게시글 상세 정보'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.delete),
            onPressed: () {
              showDialog(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text('글 삭제'),
                  content: Text('정말로 이 글을 삭제하시겠습니까?'),
                  actions: <Widget>[
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text('취소'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                        Navigator.of(context).pop();
                      },
                      child: Text('확인'),
                    ),
                  ],
                ),
              );
            },
          ),
        ],
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              widget.feedback.title,
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Text(
              '작성자: ${widget.feedback.author}',
              style: TextStyle(fontSize: 12, color: Colors.grey),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Row(
              children: [
                Text(
                  '작성일시: ${widget.feedback.formattedDateTime}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
                SizedBox(width: 20),
                Text(
                  '조회수: ${widget.feedback.views}',
                  style: TextStyle(fontSize: 12, color: Colors.grey),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '내용: ${widget.feedback.content}',
              style: TextStyle(fontSize: 16),
            ),
          ),
          Divider(),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              '댓글:',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: widget.feedback.comments.length,
              itemBuilder: (context, index) {
                final comment = widget.feedback.comments[index];
                return ListTile(
                  title: Text(comment.content),
                  subtitle: Text('작성자: ${comment.author}'),
                  leading: Icon(Icons.comment),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _commentController,
                    decoration: InputDecoration(
                      labelText: '댓글을 작성하세요',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                ElevatedButton(
                  onPressed: _addComment,
                  child: Text('댓글 작성'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class FeedbackItem {
  String title;
  String content;
  String author;
  DateTime createdDateTime;
  int views;
  List<Comment> comments;
  String type;

  FeedbackItem({
    required this.title,
    required this.content,
    required this.author,
    required this.createdDateTime,
    this.views = 0,
    List<Comment>? comments,
    required this.type,
  }) : comments = comments ?? [];

  String get formattedDateTime {
    return "${createdDateTime.year}-${createdDateTime.month.toString().padLeft(2, '0')}-${createdDateTime.day.toString().padLeft(2, '0')} ${createdDateTime.hour.toString().padLeft(2, '0')}:${createdDateTime.minute.toString().padLeft(2, '0')}";
  }
}

class Comment {
  String author;
  String content;

  Comment({required this.author, required this.content});
}
