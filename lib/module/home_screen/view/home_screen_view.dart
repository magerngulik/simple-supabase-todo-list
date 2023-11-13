import 'package:flutter/material.dart';
import '../controller/home_screen_controller.dart';
import 'package:simple_todolist/core.dart';
import 'package:get/get.dart';

class HomeScreenView extends StatelessWidget {
  const HomeScreenView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GetBuilder<HomeScreenController>(
      init: HomeScreenController(),
      builder: (controller) {
        controller.view = this;

        return Scaffold(
          appBar: AppBar(
            title: const Text("Home Screens"),
          ),
          body: ListView.builder(
            itemCount:
                controller.listItems.isEmpty ? 1 : controller.listItems.length,
            physics: const ScrollPhysics(),
            itemBuilder: (BuildContext context, int index) {
              if (controller.listItems.isEmpty) {
                return SizedBox(
                  height: MediaQuery.of(context).size.height,
                  child: const Center(
                    child: Text(
                      "No data available",
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                );
              } else {
                var item = controller.listItems[index];
                return Dismissible(
                  key: UniqueKey(),
                  onDismissed: (detail) {},
                  confirmDismiss: (direction) async {
                    bool confirm = false;
                    await showDialog<void>(
                      context: context,
                      barrierDismissible: true,
                      builder: (BuildContext context) {
                        return AlertDialog(
                          title: const Text('Confirm'),
                          content: const SingleChildScrollView(
                            child: ListBody(
                              children: <Widget>[
                                Text(
                                    'Are you sure you want to delete this item?'),
                              ],
                            ),
                          ),
                          actions: <Widget>[
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.grey[600],
                              ),
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              child: const Text("No"),
                            ),
                            ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.blueGrey,
                              ),
                              onPressed: () {
                                confirm = true;
                                controller.doDeleteData(item['id']);
                                Navigator.pop(context);
                              },
                              child: const Text("Yes"),
                            ),
                          ],
                        );
                      },
                    );
                    if (confirm) {
                      return Future.value(true);
                    }
                    return Future.value(false);
                  },
                  child: InkWell(
                    onTap: () async {
                      Get.to(UpdateScreenView(
                        item: item,
                      ));
                    },
                    child: Card(
                      child: ListTile(
                        title: Text("${item['title']}"),
                        subtitle: Text("${item['description']}"),
                      ),
                    ),
                  ),
                );
              }
            },
          ),
          floatingActionButton: FloatingActionButton(
            child: const Icon(Icons.add),
            onPressed: () async {
              await showModalBottomSheet<void>(
                context: context,
                builder: (BuildContext context) {
                  return InputDescription(
                      title: controller.title,
                      description: controller.description,
                      ontap: () => controller.doSaveData());
                },
              );
            },
          ),
        );
      },
    );
  }
}

class InputDescription extends StatelessWidget {
  final TextEditingController title;
  final TextEditingController description;
  final Function() ontap;
  const InputDescription({
    super.key,
    required this.title,
    required this.description,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20.0),
      child: Wrap(
        children: [
          SizedBox(
            width: MediaQuery.of(context).size.width,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(),
                  child: TextFormField(
                    initialValue: null,
                    controller: title,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Title",
                      hintText: "Input Title",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(12),
                  margin: const EdgeInsets.only(),
                  child: TextFormField(
                    initialValue: null,
                    controller: description,
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: Colors.white,
                      labelText: "Description",
                      hintText: "Input Description",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
                const SizedBox(
                  height: 20.0,
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                  ),
                  onPressed: () => ontap(),
                  child: const Text("Simpan"),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
