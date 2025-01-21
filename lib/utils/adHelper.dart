import 'package:google_mobile_ads/google_mobile_ads.dart';

class AdHelper {
  static BannerAd? bannerAd;

  static void loadBannerAd() {
    bannerAd = BannerAd(
      adUnitId: 'ca-app-pub-8062280195070034/6461433775', 
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

  static void refreshBannerAd() {
    bannerAd?.dispose();
    loadBannerAd();
  }

  static InterstitialAd? interstitialAd;
  static bool isAdLoaded = false;

  static void loadInterstitialAd() {
    InterstitialAd.load(
      adUnitId: 'ca-app-pub-8062280195070034/2323230213', 
      request: AdRequest(),
      adLoadCallback: InterstitialAdLoadCallback(
        onAdLoaded: (InterstitialAd ad) {
          interstitialAd = ad;
          isAdLoaded = true;
          print('Interstitial Ad Loaded');
        },
        onAdFailedToLoad: (LoadAdError error) {
          print('Interstitial Ad Failed to Load: $error');
          isAdLoaded = false;
        },
      ),
    );
  }  

  static void showInterstitialAd(Function onAdClosed) {
    if (isAdLoaded && interstitialAd != null) {
      interstitialAd!.show();
      interstitialAd!.fullScreenContentCallback = FullScreenContentCallback(
        onAdDismissedFullScreenContent: (ad) {
          print('Interstitial Ad Dismissed');
          ad.dispose();
          loadInterstitialAd(); // Muat ulang iklan
          onAdClosed(); // Panggil callback saat iklan ditutup
        },
        onAdFailedToShowFullScreenContent: (ad, error) {
          print('Failed to Show Interstitial Ad: $error');
          ad.dispose();
          loadInterstitialAd(); // Muat ulang iklan
          onAdClosed(); // Tetap panggil callback meskipun gagal
        },
      );
      isAdLoaded = false; // Reset status
    } else {
      print('Interstitial Ad is not ready yet');
      onAdClosed(); // Lanjutkan tanpa menampilkan iklan jika tidak tersedia
    }
  }
}

