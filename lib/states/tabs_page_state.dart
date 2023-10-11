import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import '../pages/tabs_page.dart';

class TabsPageState extends State<TabsPage>
    with
        SingleTickerProviderStateMixin,
        RouteAware {
  TabsPageState(this.observer);

  final FirebaseAnalyticsObserver observer;

  final FirebaseAnalytics analytics = FirebaseAnalytics.instance;

  late final TabController _controller = TabController(
    vsync: this,
    length: tabs.length,
    initialIndex: selectedIndex,
  );
  int selectedIndex = 0;

  final List<Tab> tabs = <Tab>[
    const Tab(text: 'LEFT'),
    const Tab(text: 'RIGHT'),
  ];

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    widget.observer.subscribe(this, ModalRoute.of(context)! as PageRoute);
  }

  @override
  void dispose() {
    widget.observer.unsubscribe(this);
    super.dispose();
  }

  @override
  void initState() {
    super.initState();
    _controller.addListener(() {
      setState(() {
        if (selectedIndex != _controller.index) {
          selectedIndex = _controller.index;
          _sendCurrentTabToAnalytics();
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        bottom: TabBar(
          controller: _controller,
          tabs: tabs,
        ),
      ),
      body: TabBarView(
        controller: _controller,
        children: tabs.map((Tab tab) {
          return Center(child: Text(tab.text!));
        }).toList(),
      ),
    );
  }

  @override
  void didPush() {
    _sendCurrentTabToAnalytics();
  }

  @override
  void didPopNext() {
    _sendCurrentTabToAnalytics();
  }

  void _sendCurrentTabToAnalytics() {
    analytics.setCurrentScreen(
      screenName: '${TabsPage.routeName}/tab$selectedIndex',
    );
  }
}