import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:ready_lms/components/buttons/app_button.dart';
import 'package:ready_lms/components/buttons/outline_button.dart';
import 'package:ready_lms/components/form_widget.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/controllers/profile.dart';
import 'package:ready_lms/generated/l10n.dart';
import 'package:ready_lms/model/authentication/user.dart';
import 'package:ready_lms/model/updateUser.dart';
import 'package:ready_lms/service/hive_service.dart';
import 'package:ready_lms/service/profile.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/view/profile/widget/change_pass_bottom_widget.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ProfileViewState();
}

class _ProfileViewState extends ConsumerState<ProfileScreen> {
  String? image;
  final ImagePicker picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  String? name, email, phone;
  final TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController phoneNameController = TextEditingController();
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      init();
    });
  }

  getPermission(Permission permission) async {
    var checkStatus = await permission.status;

    if (checkStatus.isGranted) {
      return;
    } else {
      var status = await permission.request();
      if (status.isGranted) {
      } else if (status.isDenied) {
        getPermission(permission);
      } else {
        openAppSettings();
        EasyLoading.showError('Allow the permission');
      }
    }
  }

  Future getImage(ImageSource media) async {
    // if (media == ImageSource.camera) {
    //   getPermission(Permission.camera);
    // } else {
    //   getPermission(Permission.storage);
    // }
    var img = await picker.pickImage(source: media);
    if (img != null) {
      var image = await compressImage(File(img.path));
      if (image != null) {
        ref.read(profileServiceProvider).uploadImage = XFile(image.path);
        image = null;
        setState(() {});
      }
    }
  }

  Future<void> init() async {
    User? user = ref.read(hiveStorageProvider).getUserInfo();
    name = user?.name ?? '';
    email = user?.email ?? '';
    phone = user?.phone ?? '';
    nameController.text = user?.name ?? '';
    emailController.text = user?.email ?? '';
    phoneNameController.text = user?.phone ?? '';
    if (user?.profilePicture != null) {
      image = user?.profilePicture;
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          S.of(context).myProfile,
          maxLines: 1,
        ),
        leading: IconButton(
            onPressed: () {
              context.nav.pop();
            },
            icon: SvgPicture.asset(
              'assets/svg/ic_arrow_left.svg',
              width: 24.h,
              height: 24.h,
              color: context.color.onSurface,
            )),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Container(
              width: double.infinity,
              color: context.color.surface,
              padding: EdgeInsets.all(20.h),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Stack(
                    children: [
                      Container(
                        width: 112.h,
                        height: 112.h,
                        decoration: const BoxDecoration(shape: BoxShape.circle),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(62.w),
                          child: ref.read(profileServiceProvider).uploadImage ==
                                  null
                              ? image == null
                                  ? Center(
                                      child: Image.asset(
                                        'assets/images/im_demo_user_1.png',
                                        fit: BoxFit.cover,
                                      ),
                                    )
                                  : FadeInImage.assetNetwork(
                                      placeholder: 'assets/images/spinner.gif',
                                      image: image ?? '',
                                      fit: BoxFit.cover,
                                    )
                              : Image.file(
                                  File(ref
                                      .read(profileServiceProvider)
                                      .uploadImage!
                                      .path),
                                  fit: BoxFit.cover,
                                ),
                        ),
                      ),
                      Positioned(
                        bottom: 2,
                        right: 0,
                        child: GestureDetector(
                          onTap: () {
                            ApGlobalFunctions.getPickImageAlert(
                                context: context,
                                pressCamera: () {
                                  getImage(ImageSource.camera);
                                  Navigator.of(context).pop();
                                },
                                pressGallery: () {
                                  getImage(ImageSource.gallery);
                                  Navigator.of(context).pop();
                                });
                          },
                          child: Image.asset(
                            'assets/images/ic_camera.png',
                            height: 32.h,
                            width: 32.h,
                          ),
                        ),
                      )
                    ],
                  ),
                  48.ph,
                  Form(
                      key: formKey,
                      child: Column(
                        children: [
                          CustomFormWidget(
                            label: S.of(context).fullName,
                            controller: nameController,
                            maxLength: 20,
                            maxLines: 1,
                            validator: (val) => validatorWithMessage(
                                message:
                                    '${S.of(context).fullName} ${S.of(context).isRequired}',
                                value: val),
                          ),
                          32.ph,
                          CustomFormWidget(
                            label: S.of(context).email,
                            controller: emailController,
                            validator: (val) => validatorWithMessage(
                              message:
                                  '${S.of(context).email} ${S.of(context).isRequired}',
                              value: val,
                              isEmail: true,
                            ),
                          ),
                          32.ph,
                          CustomFormWidget(
                            label: S.of(context).phoneNumber,
                            controller: phoneNameController,
                            validator: (val) => validatorWithMessage(
                                message:
                                    '${S.of(context).phoneNumber} ${S.of(context).isRequired}',
                                value: val),
                          ),
                        ],
                      )),
                  32.ph,
                  Text(
                    S.of(context).password,
                    style: AppTextStyle(context)
                        .bodyTextSmall
                        .copyWith(fontSize: 12.sp),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'XXXXXXXXXX',
                        style: AppTextStyle(context).bodyText,
                      ),
                      AppOutlineButton(
                        title:
                            '${S.of(context).change} ${S.of(context).password}',
                        borderRadius: 30.r,
                        fontSize: 12.sp,
                        textPaddingHorizontal: 6.w,
                        textPaddingVertical: 6.w,
                        fontWeight: FontWeight.w400,
                        width: null,
                        onTap: () {
                          ApGlobalFunctions.showBottomSheet(
                              context: context,
                              widget: const ChangePassBottomWidget());
                        },
                      )
                    ],
                  )
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: double.infinity,
        color: context.color.surface,
        padding: EdgeInsets.all(20.h),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppButton(
                title: S.of(context).updateProfile,
                textPaddingVertical: 16.h,
                showLoading: ref.watch(profileController),
                titleColor: context.color.surface,
                onTap: () async {
                  if (formKey.currentState!.validate()) {
                    if (phoneNameController.text != phone ||
                        emailController.text != email ||
                        nameController.text != name ||
                        ref.read(profileServiceProvider).uploadImage != null) {
                      UpdateUser user = UpdateUser(
                        phone: phoneNameController.text.isNotEmpty
                            ? phoneNameController.text
                            : phone, // Use original value if unchanged
                        email: emailController.text.isNotEmpty
                            ? emailController.text
                            : email, // Use original value if unchanged
                        name: nameController.text.isNotEmpty
                            ? nameController.text
                            : name, // Use original value if unchanged
                      );
                      print(user.toMap());

                      var res = await ref
                          .read(profileController.notifier)
                          .updateProfile(
                              user: UpdateUser(
                                  phone: phoneNameController.text != phone
                                      ? phoneNameController.text
                                      : phone,
                                  email: emailController.text != email
                                      ? emailController.text
                                      : email,
                                  name: nameController.text != name
                                      ? nameController.text
                                      : name));
                      EasyLoading.showSuccess(res.message);
                    } else {
                      EasyLoading.showSuccess(S.of(context).nothingtochange);
                    }
                  }
                })
          ],
        ),
      ),
    );
  }

  Future<File?> compressImage(File file) async {
    try {
      int percentage = 100;
      File? compressedFile;
      int sizeInBytes = File(file.path).lengthSync();
      double sizeInMb = sizeInBytes / (1024 * 1024);

      // while (sizeInMb > 2) {
      //   percentage = percentage - 20;
      //   compressedFile = await FlutterNativeImage.compressImage(
      //     file.path,
      //     quality: 70,
      //     percentage: percentage,
      //   );
      //   int sizeInBytes = File(compressedFile.path).lengthSync();
      //   sizeInMb = sizeInBytes / (1024 * 1024);
      // }
      return File(compressedFile?.path ?? file.path);
    } catch (e) {
      if (kDebugMode) {
        print('--error--$e');
      }
      return null; //If any error occurs during compression, the process is stopped.
    }
  }
}
