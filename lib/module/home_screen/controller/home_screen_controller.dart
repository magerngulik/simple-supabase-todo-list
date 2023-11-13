import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:logger/logger.dart';
import 'package:simple_todolist/main.dart';
import '../view/home_screen_view.dart';

class HomeScreenController extends GetxController {
  HomeScreenView? view;
  var title = TextEditingController();
  var description = TextEditingController();
  RxList listItems = [].obs;
  var isLoading = false.obs;

  doSaveData() async {
    debugPrint("button di tekan");
    if (title.text == "") {
      debugPrint("kondisi pertama terpenuhi");
      Get.snackbar(
        "Warning",
        "title tidak boleh kosong",
      );
      return;
    } else if (description.text == "") {
      debugPrint("kondisi kedua terpenuhi");
      Get.snackbar("Warning", "Description tidak boleh kosong");
      return;
    }
    try {
      Map dataUpload = {"title": title.text, "description": description.text};
      await supabase.from('todo').insert(dataUpload);
    } catch (e) {
      Get.snackbar("Error", "Terjadi error ketiak upload data $e");
      Get.back();
      return;
    }

    title.text = "";
    description.text = "";

    getListData();
    Get.back();
  }

  getListData() async {
    isLoading.value = true;
    final data = await supabase.from('todo').select('*');
    listItems = RxList.from(data);
    isLoading.value = false;
    update();
  }

  doDeleteData(int id) async {
    Get.showOverlay(
      loadingWidget: const Center(
        child: CircularProgressIndicator(),
      ),
      asyncFunction: () async {
        try {} catch (e) {
          debugPrint(e.toString());
        }
      },
    );
    debugPrint("ini id : $id");
    try {
      await supabase.from('todo').delete().match({'id': id});
    } catch (e) {
      debugPrint("$e");
      Get.snackbar("Error", "Terjadi error ketika delete data $e");
    }
    getListData();
    Get.back();
  }

  @override
  void onInit() {
    super.onInit();
    getListData();
  }
}
