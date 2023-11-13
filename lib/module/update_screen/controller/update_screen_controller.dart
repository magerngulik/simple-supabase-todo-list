// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:simple_todolist/main.dart';
import 'package:simple_todolist/module/home_screen/controller/home_screen_controller.dart';

import '../view/update_screen_view.dart';

class UpdateScreenController extends GetxController {
  UpdateScreenView? view;
  Map item;
  UpdateScreenController(
    this.item,
  );

  var halamanHome = Get.put(HomeScreenController());

  var log = Logger();

  @override
  void onInit() {
    super.onInit();
    updateTitleController.text = item['title'];
    updateDescriptionController.text = item['description'];
  }

  var updateTitleController = TextEditingController();
  var updateDescriptionController = TextEditingController();

  doUpdateData() async {
    var currentTitle = item['title'];
    var currentDescription = item['description'];
    var currentId = item['id'];

    debugPrint("current id :$currentId");
    debugPrint("current description :$currentDescription");
    debugPrint("current title :$currentTitle");

    Get.showOverlay(
        loadingWidget: const Center(
          child: CircularProgressIndicator(),
        ),
        asyncFunction: () async {
          try {
            Map dataChange = {
              "title": updateTitleController.text,
              "description": updateDescriptionController.text,
            };
            debugPrint("kondisi di sini berjalan");
            log.w(dataChange);
            log.w(currentId);

            await supabase
                .from('todo')
                .update(dataChange)
                .match({'id': currentId});
          } catch (e) {
            Get.snackbar("Kesalahan", "Terjadi masalah pada update data");
          }
          halamanHome.getListData();

          Get.back();
        });
  }
}
