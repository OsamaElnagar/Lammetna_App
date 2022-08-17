import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class HBNAV extends StatefulWidget {
  const HBNAV({Key? key}) : super(key: key);

  @override
  State<HBNAV> createState() => _HBNAVState();
}

class _HBNAVState extends State<HBNAV> {
  late ScrollController _hideButtonController;

  late bool _isVisible;

  @override
  initState() {
    super.initState();
    _isVisible = true;
    _hideButtonController = ScrollController();
    _hideButtonController.addListener(() {
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.reverse) {
        if (_isVisible) {
          setState(() {
            _isVisible = false;
            print("**** $_isVisible up");
          });
        }
      }
      if (_hideButtonController.position.userScrollDirection ==
          ScrollDirection.forward) {
        if (!_isVisible) {
          setState(() {
            _isVisible = true;
            print("**** $_isVisible down");
          });
        }
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('widget.title'),
      ),
      body: Center(
          child: CustomScrollView(
        controller: _hideButtonController,
        shrinkWrap: true,
        slivers: <Widget>[
          SliverPadding(
            padding: const EdgeInsets.all(20.0),
            sliver: SliverList(
              delegate: SliverChildListDelegate(
                <Widget>[
                  const Text('I\'m dedicating every day to you'),
                  const Text('Domestic life was never quite my style'),
                  const Text('When you smile, you knock me out, I fall apart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('And I thought I was so smart'),
                  const Text('I realize I am crazy'),
                ],
              ),
            ),
          ),
        ],
      )),
      bottomNavigationBar: AnimatedContainer(
        duration: const Duration(milliseconds: 500),
        height: _isVisible ? 60.0 : 0.0,
        child: _isVisible
            ? BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                items: const [
                  BottomNavigationBarItem(
                      icon: Icon(Icons.home), label: 'Home'),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.card_giftcard),
                    label: 'Offers',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.account_box),
                    label: 'Account',
                  ),
                ],
                currentIndex: 0,
              )
            : Container(
                color: Colors.white,
                width: MediaQuery.of(context).size.width,
              ),
      ),
    );
  }
}
