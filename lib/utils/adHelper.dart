import 'package:flutter/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static BannerAd? bannerAd;

  static void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-8062280195070034/6461433775', // Ganti dengan ID unit iklan Anda
      size: AdSize.banner,
      request: AdRequest(),
      listener: BannerAdListener(
        onAdLoaded: (_) {
          print('Banner Ad Loaded');
        },
        onAdFailedToLoad: (ad, error) {
          ad.dispose();
          print('Banner Ad Failed to Load: $error');
        },
      ),
    );
    bannerAd!.load();
  }
}

