import 'package:ready_lms/config/app_constants.dart';
import 'package:ready_lms/service/base_service/certificate.dart';
import 'package:ready_lms/utils/api_client.dart';
import 'package:dio/src/response.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CertificateService extends Certificate {
  final Ref ref;
  CertificateService(this.ref);

  @override
  Future<Response> getCertificateList(
      {required int currentPage, int? parPage}) async {
    final response = await ref
        .read(apiClientProvider)
        .get(AppConstants.certificateList, query: {
      AppConstants.page: '$currentPage',
      AppConstants.perPage: '$parPage'
    });
    return response;
  }
}

final certificateServiceProvider = Provider((ref) => CertificateService(ref));
