import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:simple_todolist/module/home_screen/view/home_screen_view.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "",
    anonKey: "",
    //untuk bagian ini nanti di isi ya
  );

  runApp(
    const GetMaterialApp(
      debugShowCheckedModeBanner: false,
      home: HomeScreenView(),
    ),
  );
}

final supabase = Supabase.instance.client;
