import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/cupertino.dart';

import '../states/main_page_state.dart';

class MainPage extends StatefulWidget {
  const MainPage({
    Key? key,
    required this.title,
    required this.analytics,
    required this.observer,
    required this.db
  }) : super(key: key);

  final String title;
  final FirebaseAnalytics analytics;
  final FirebaseAnalyticsObserver observer;
  final FirebaseFirestore db;

  @override
  MainPageState createState() => MainPageState();
}