// Copyright 2017 The Chromium Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:flutter/material.dart';
import 'package:firebase_analytics/firebase_analytics.dart';

import '../states/tabs_page_state.dart';

class TabsPage extends StatefulWidget {
  const TabsPage(this.observer, {Key? key}) : super(key: key);

  final FirebaseAnalyticsObserver observer;

  static const String routeName = '/tab';

  @override
  State<StatefulWidget> createState() => TabsPageState(observer);
}