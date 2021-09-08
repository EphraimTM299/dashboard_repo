import 'package:flutter/material.dart';
import 'package:test_web/constaints.dart';
import 'package:test_web/pages/news.dart';

class TopBar extends StatelessWidget {
  final bool _showDesktop;
  const TopBar([this._showDesktop = false]);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: topBarHeight,
      padding: EdgeInsets.symmetric(horizontal: componentPadding),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Padding(
                padding: const EdgeInsets.only(bottom: 8),
                child: Text(
                  'Dashboard',
                  style: Theme.of(context).textTheme.headline1,
                ),
              ),
              Positioned(
                child: Container(
                  height: 4,
                  width: 60,
                  decoration: BoxDecoration(
                      color: Theme.of(context).primaryColor,
                      borderRadius: BorderRadius.circular(4)),
                ),
                bottom: 0,
                left: 0,
              )
            ],
          ),
          Expanded(
            child: Container(),
            flex: 1,
          ),
          Row(crossAxisAlignment: CrossAxisAlignment.start, children: [
            IconButton(
              icon: Icon(
                Icons.search,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
            ),
            IconButton(
              icon: Icon(
                Icons.notifications_outlined,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {},
            ),
            this._showDesktop
                ? SizedBox.shrink()
                : IconButton(
                    icon: Icon(
                      Icons.article_outlined,
                      color: Theme.of(context).primaryColor,
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => NewsPage()),
                      );
                    },
                  )
          ])
        ],
      ),
    );
  }
}
