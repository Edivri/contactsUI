import 'package:exemplo/src/about/about_page.dart';
import 'package:exemplo/src/contact/add_page.dart';
import 'package:exemplo/src/contact/edit_page.dart';
import 'package:exemplo/src/contact/view_page.dart';
import 'package:exemplo/src/home/home_bloc.dart';
import 'package:exemplo/src/home/home_module.dart';
import 'package:flutter/material.dart';

class ContactList extends StatefulWidget {
  final List<Map> items;

  ContactList({this.items}) : super();
  @override
  _ContactListState createState() => _ContactListState();
}

class _ContactListState extends State<ContactList> {
  Offset _tapPosition;
  HomeBloc bloc;

  @override
  void initState() {
    bloc = HomeModule.to.getBloc<HomeBloc>();
    super.initState();
  }

  void _onTapDown(TapDownDetails details) {
    _tapPosition = details.globalPosition;
    print(_tapPosition);
  }

  Column column(context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Container(
          child: Icon(
            Icons.list,
            size: 120,
          ),
        ),
        SizedBox(height: 20),
        Center(
          child: Text(
            'Your contact list is empty',
            style: TextStyle(fontSize: 18),
          ),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AddPage()),
            );
          },
          child: Text(
            "ADD CONTACT",
            style: TextStyle(
              color: Colors.teal,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        SizedBox(height: 20),
        GestureDetector(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => AboutPage()),
            );
          },
          child: Text(
            "ON",
            style: TextStyle(
              color: Colors.teal,
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ],
    );
  }

  void _showDialog(item) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: new Text("Do you want to exclude or contact?"),
          content: new Text(item['name']),
          actions: <Widget>[
            new FlatButton(
              child: new Text("Cancel"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Sim"),
              onPressed: () {
                Navigator.of(context).pop();
                bloc.deleteContact(item['id']);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final RenderBox overlay = Overlay.of(context).context.findRenderObject();

    if (widget.items.length == 0) {
      return column(context);
    }

    return ListView.builder(
      itemCount: widget.items.length,
      itemBuilder: (BuildContext context, int index) {
        Map item = widget.items[index];
        return GestureDetector(
          onTapDown: _onTapDown,
          onLongPress: () {
            showMenu(
              context: context,
              items: [
                PopupMenuItem(
                  child: FlatButton(
                    child: Text(
                      "Edit",
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      bloc.setContact(item);
                      Navigator.of(context).pop();
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => EditPage()),
                      );
                    },
                  ),
                ),
                PopupMenuItem(
                  child: FlatButton(
                    child: Text(
                      "Exclude",
                      style: TextStyle(fontSize: 16),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop();
                      _showDialog(item);
                    },
                  ),
                ),
              ],
              position: RelativeRect.fromRect(
                _tapPosition & Size(40, 40), // smaller rect, the touch area
                Offset.zero & overlay.size, // Bigger rect, the entire screen
              ),
            );
          },
          child: Container(
            width: MediaQuery.of(context).size.width,
            child: ListTile(
              contentPadding: EdgeInsets.symmetric(horizontal: 20.0),
              leading: CircleAvatar(
                child: Text(
                  item['name'].substring(0, 1).toUpperCase(),
                  style: TextStyle(fontSize: 26, color: Colors.white60),
                ),
              ),
              trailing: item['favorite'] == 1
                  ? Icon(Icons.star, color: Colors.teal)
                  : Icon(Icons.star_border),
              title: Text(
                item['name'],
                style: TextStyle(fontSize: 17),
              ),
              subtitle: item['phoneNumber'].toString().isNotEmpty
                  ? Text(item['phoneNumber'])
                  : null,
              onTap: () {
                bloc.setContact(item);
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => ViewPage()),
                );
              },
            ),
          ),
        );
      },
    );
  }
}
