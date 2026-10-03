import 'package:dio/dio.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../core/services/api_service.dart';
import '../../../data/fallback/fallback_banners.dart';
import '../../../data/fallback/fallback_categories.dart';
import '../../../data/fallback/fallback_refurbished.dart';
import '../../../data/fallback/fallback_rental_cameras.dart';
import '../data/models/responses/banners_response.dart';
import '../data/models/responses/categories_response.dart';
import '../data/repositories/catalog_repository.dart';
import 'home_state.dart';

class HomeCubit extends Cubit<HomeState> {
  final CatalogRepository _catalogRepository;

  HomeCubit({
    CatalogRepository? catalogRepository,
  })  : _catalogRepository = catalogRepository ?? CatalogRepositoryImpl(),
        super(const HomeInitial());

  Future<void> loadHomeData() async {
    emit(const HomeLoading());

    List<BannerModel> banners = FallbackBanners.data
        .map((e) => BannerModel.fromJson(e))
        .toList();
    List<CategoryModel> categories = FallbackCategories.data
        .map((e) => CategoryModel.fromJson(e))
        .toList();
    List<Map<String, dynamic>> refurbished = List<Map<String, dynamic>>.from(FallbackRefurbished.data);
    List<Map<String, dynamic>> rentals = List<Map<String, dynamic>>.from(FallbackRentalCameras.data);

    try {
      final bannersFuture = _catalogRepository.getBanners();
      final categoriesFuture = _catalogRepository.getCategories();
      final refFuture = ApiService.fetchRefurbished();
      final rentFuture = ApiService.fetchRentalCameras();

      final results = await Future.wait([bannersFuture, categoriesFuture, refFuture, rentFuture]);

      final bannersRes = results[0] as Response;
      if (bannersRes.data != null) {
        final bRes = BannersResponse.fromJson(Map<String, dynamic>.from(bannersRes.data as Map));
        if (bRes.banners.isNotEmpty) banners = bRes.banners;
      }

      final catRes = results[1] as Response;
      if (catRes.data != null) {
        final cRes = CategoriesResponse.fromJson(Map<String, dynamic>.from(catRes.data as Map));
        if (cRes.categories.isNotEmpty) categories = cRes.categories;
      }

      if (results[2] is List<Map<String, dynamic>> && (results[2] as List).isNotEmpty) {
        refurbished = results[2] as List<Map<String, dynamic>>;
      }

      if (results[3] is List<Map<String, dynamic>> && (results[3] as List).isNotEmpty) {
        rentals = results[3] as List<Map<String, dynamic>>;
      }
    } catch (_) {}

    emit(HomeLoaded(
      banners: banners,
      categories: categories,
      refurbished: refurbished,
      rentalCameras: rentals,
    ));
  }
}
