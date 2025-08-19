// ignore_for_file: use_build_context_synchronously

import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/svg.dart';
import 'package:ready_lms/components/custom_dot.dart';
import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/config/app_text_style.dart';
import 'package:ready_lms/config/theme.dart';
import 'package:ready_lms/controllers/courses/my_course_details.dart';
import 'package:ready_lms/model/course_detail.dart';
import 'package:ready_lms/model/current_class.dart';
import 'package:ready_lms/model/hive_mode/hive_cart_model.dart';
import 'package:ready_lms/routes.dart';
import 'package:ready_lms/utils/context_less_nav.dart';
import 'package:ready_lms/utils/entensions.dart';
import 'package:ready_lms/utils/global_function.dart';
import 'package:ready_lms/view/courses/my_course_details/component/content_details_bottom_widget.dart';
import 'package:webview_flutter/webview_flutter.dart';

// TODO: We need to implement this to the
class LessonItemCard extends ConsumerStatefulWidget {
  const LessonItemCard({
    super.key,
    this.isBottom = false,
    required this.model,
    required this.isActive,
  });
  final bool? isBottom;
  final Contents model;
  final bool isActive;
  @override
  ConsumerState<LessonItemCard> createState() => _LessonItemCardState();
}

class _LessonItemCardState extends ConsumerState<LessonItemCard> {
  final isViewContent = StateProvider<bool>((ref) {
    return false;
  });
  final downloadPercentage = StateProvider<String>((ref) {
    return '';
  });
  bool isListening = false;
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      ref.read(isViewContent.notifier).state = widget.model.isViewed;
    });
  }

  void checkForViewRequest() {
    if (!ref.watch(isViewContent) && widget.isActive) {
      if (widget.model.type == FileSystem.video.name ||
          widget.model.type == FileSystem.audio.name) {
        var videoPlayerController =
            ref.watch(myCourseDetailsController).videoPlayerController;
        if (videoPlayerController != null) {
          ref
              .read(myCourseDetailsController)
              .videoPlayerController!
              .addListener(() {
            isListening = true;
            if (videoPlayerController.value.position >=
                videoPlayerController.value.duration) {
              makeContentView();
            }
          });
        }
      } else if (widget.model.type == FileSystem.document.name) {
      } else {
        makeContentView();
      }
    }
  }

  makeContentView() {
    ref
        .read(myCourseDetailsController.notifier)
        .makeContentView(widget.model.id)
        .then((value) {
      if (value.isSuccess) {
        if (mounted) ref.read(isViewContent.notifier).state = value.response;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    var isViewContent = ref.watch(this.isViewContent);
    if (!isListening) {
      checkForViewRequest();
    }

    return Container(
      margin: EdgeInsets.only(bottom: 8.h),
      color: widget.isActive
          ? context.color.primary.withOpacity(.1)
          : context.color.surface,
      child: GestureDetector(
        onTap: () async {
          if (ref.read(myCourseDetailsController).videoPlayerController !=
              null) {
            if (ref
                .read(myCourseDetailsController)
                .videoPlayerController!
                .value
                .isPlaying) {
              ref
                  .read(myCourseDetailsController)
                  .videoPlayerController!
                  .pause();
            }
          }
          if (widget.model.type == FileSystem.document.name) {
            ref
                .read(myCourseDetailsController.notifier)
                .setCurrentPlay(CurrentPlay(
                  fileName: widget.model.fileExtension == 'pdf'
                      ? ref
                          .read(myCourseDetailsController)
                          .courseDetails
                          ?.course
                          .title
                      : widget.model.title,
                  fileSystem: widget.model.type,
                  id: widget.model.id,
                  fileLink: ref
                      .read(myCourseDetailsController)
                      .courseDetails
                      ?.course
                      .thumbnail,
                ));

            if (widget.model.fileExtension == 'pdf') {
              bool isContentDownloaded = await ref
                  .read(myCourseDetailsController.notifier)
                  .isContentDownloaded(id: widget.model.id);
              if (isContentDownloaded) {
                await ref
                    .read(myCourseDetailsController.notifier)
                    .getHiveContent(id: widget.model.id)
                    .then((value) {
                  if (value != null) {
                    if (widget.model.mediaUpdatedAt == value.uniqueNumber) {
                      context.nav.pushNamed(Routes.pdfScreen, arguments: {
                        'id': widget.model.id,
                        'title': widget.model.fileNameWithExtension
                      });
                    } else {
                      showBottomWidget(makeUpdate: true);
                    }
                  }
                });
              } else {
                showBottomWidget();
              }
            } else {
              loadWebByUrl(widget.model.media);
            }
          } else {
            if (widget.model.type == FileSystem.video.name &&
                (widget.model.mediaLink != null &&
                    widget.model.mediaLink!.isNotEmpty)) {
              ref.read(myCourseDetailsController.notifier).setCurrentPlay(
                    CurrentPlay(
                      fileName: widget.model.title,
                      fileSystem: FileSystem.iframe.name,
                      id: widget.model.id,
                      fileLink: widget.model.mediaLink,
                      contents: widget.model,
                      isViewContent: this.isViewContent,
                    ),
                  );
            } else {
              ref.read(myCourseDetailsController.notifier).setCurrentPlay(
                    CurrentPlay(
                      fileName: widget.model.title,
                      fileSystem: widget.model.type,
                      id: widget.model.id,
                      fileLink: widget.model.media,
                    ),
                  );
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 12.h, vertical: 8.h),
          child: Row(
            children: [
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.h),
                  color: widget.isActive
                      ? context.color.primary.withOpacity(.2)
                      : colors(context).hintTextColor!.withOpacity(.1),
                ),
                padding: EdgeInsets.all(6.h),
                child: SvgPicture.asset(
                  ApGlobalFunctions.getFileIcon(widget.model.type),
                  height: 16.h,
                  width: 16.h,
                  color: widget.isActive
                      ? context.color.primary
                      : context.color.inverseSurface,
                ),
              ),
              12.pw,
              Expanded(
                child: Text(
                  widget.model.title,
                  style: AppTextStyle(context).bodyTextSmall.copyWith(
                      fontSize: 12.sp,
                      color: widget.isActive ? context.color.primary : null),
                ),
              ),
              if (!isViewContent)
                Padding(
                  padding: EdgeInsets.only(left: 5.h),
                  child: CustomDot(
                    color: colors(context).primaryColor,
                    size: 6,
                  ),
                )
            ],
          ),
        ),
      ),
    );
  }

  Future<void> downloadFile(
      {required Contents model, bool makeUpdate = false}) async {
    Dio dio = Dio();
    if (mounted) {
      ref.read(myCourseDetailsController.notifier).downloadLoading(true);
    }
    try {
      Response response = await dio.get(
        model.media,
        onReceiveProgress: showDownloadProgress,
        //Received data with List<int>
        options: Options(
            responseType: ResponseType.bytes,
            followRedirects: false,
            validateStatus: (status) {
              return status! < 500;
            }),
      );
      Uint8List pdfBytes = response.data;
      if (makeUpdate) {
        await ref.read(myCourseDetailsController.notifier).updateHiveContent(
            HiveCartModel(
                id: model.id,
                fileExtension: model.fileExtension,
                data: pdfBytes,
                uniqueNumber: model.mediaUpdatedAt,
                fileName: model.title));
      } else {
        await ref.read(myCourseDetailsController.notifier).addContentToHive(
            HiveCartModel(
                id: model.id,
                fileExtension: model.fileExtension,
                data: pdfBytes,
                uniqueNumber: model.mediaUpdatedAt,
                fileName: model.title));
      }

      if (mounted) {
        ref.read(myCourseDetailsController.notifier).downloadLoading(false);
      }
      if (!ref.watch(isViewContent)) {
        makeContentView();
      }
      Future.delayed(const Duration(milliseconds: 500), () {
        context.nav.pushNamed(Routes.pdfScreen,
            arguments: {'id': model.id, 'title': model.title});
      });
    } catch (e) {
      EasyLoading.showError('File download fail');
      if (kDebugMode) {
        print('Error downloading file: $e');
      }
    }
  }

  Future loadWebByUrl(String url) async {
    WebViewController controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Theme.of(context).colorScheme.surface)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {},
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            return NavigationDecision.navigate;
          },
        ),
      )
      ..loadRequest(Uri.parse(url));
    await showDialog(
      context: context,
      builder: (context) => WebViewWidget(controller: controller),
    );
  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      if (mounted) {
        ref.read(downloadPercentage.notifier).state =
            (received / total * 100).toStringAsFixed(0) + "%";
      }
    }
  }

  void showBottomWidget({bool makeUpdate = false}) {
    ApGlobalFunctions.showBottomSheet(
        context: context,
        widget: ContentDetailBottomWidget(
          model: widget.model,
          closeSheet: () {
            context.nav.pop();
          },
          onTap: () {
            downloadFile(model: widget.model, makeUpdate: makeUpdate);
          },
          downloadPercentage: downloadPercentage,
        ));
  }
}
