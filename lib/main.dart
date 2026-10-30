import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:project_jawa/app.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void _hideSystemUI() {
  SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  _hideSystemUI();

  SystemChrome.setSystemUIChangeCallback((systemOverlaysAreVisible) async {
    if (systemOverlaysAreVisible) {
      _hideSystemUI();
    }
  });
  
  await Supabase.initialize(
    url: 'https://oxfzvwebbbemmvrmmuxj.supabase.co',
    anonKey: 'sb_publishable_fUNN14BwfzumTJPv1raRZQ_lizQhgVp',
  );

  runApp(const LakonApp());
}
