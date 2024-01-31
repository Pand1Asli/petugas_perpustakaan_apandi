import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:dio/dio.dart' as dio;
import 'package:petugas_perpustakaan_kelas_c/app/modules/book/controllers/book_controller.dart';
import '../../../data/constant/endpoint.dart';
import '../../../data/provider/api_provider.dart';
import '../../../data/provider/storage_provider.dart';
import '../../../routes/app_pages.dart';

class AddBookController extends GetxController {
  final GlobalKey<FormState> formKey = GlobalKey <FormState>();
  final TextEditingController judulController = TextEditingController();
  final TextEditingController penulisController = TextEditingController();
  final TextEditingController penerbitController = TextEditingController();
  final TextEditingController tahunterbitController = TextEditingController();
  final loading = false.obs;
  final BookController _bookController = Get.find();

  final count = 0.obs;
  @override
  void onInit() {
    super.onInit();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }
  add() async {loading(true);
  try{
    FocusScope.of(Get.context!).unfocus();
    formKey.currentState?.save();
    if (formKey.currentState!.validate()) {
      final response = await ApiProvider.instance().post(Endpoint.book,
          data: {"judul" : judulController.text.toString(),
                 "penulis" : penulisController.text.toString(),
                 "penerbit" : penerbitController.text.toString(),
                 "tahun_terbit" : int.parse(tahunterbitController.text.toString()),
      });
      if (response.statusCode == 201) {
        _bookController.getData();
        await StorageProvider.write(StorageKey.status, "logged");
        Get.offAllNamed(Routes.BOOK);
      } else {
        Get.snackbar("sorry", "Login Gagal", backgroundColor: Colors.orange);
      }
    }loading(false);
  }on dio.DioException catch (e) {loading(false);
  if (e.response != null) {
    if (e.response?.data != null) {
      Get.snackbar("sorry", "${e.response?.data['message']}", backgroundColor: Colors.orange);
    }
  } else {
    Get.snackbar("sorry", e.message ?? "", backgroundColor: Colors.red);
  }
  } catch (e) {loading(false);
  Get.snackbar("Error", e.toString(), backgroundColor: Colors.red);
  }
  }

  void increment() => count.value++;
}
