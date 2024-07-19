import 'package:danrom/app_localization.dart';
import 'package:danrom/config/routes.dart';
import 'package:danrom/resources/colors.dart';
import 'package:danrom/resources/resources.dart';
import 'package:danrom/resources/themes.dart';
import 'package:danrom/shared/utils/dart_extensions.dart';
import 'package:danrom/shared/widget/logo.dart';
import 'package:danrom/view/chooser/chooser.dart';
import 'package:danrom/view/coin/coin.dart';
import 'package:danrom/view/decision/decision.dart';
import 'package:danrom/view/number/number.dart';
import 'package:danrom/view/wheel/wheel.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  late BannerAd bannerAd;
  int currentPageIndex = 0;
  bool isAdLoaded = false;
  final pages = [const Wheel(), const Chooser(), const Decision(), const Number(), const Coin()];

  @override
  void initState() {
    super.initState();

    bannerAd = BannerAd(
        size: AdSize.banner,
        adUnitId: 'ca-app-pub-3940256099942544/6300978111',
        listener: BannerAdListener(
            onAdLoaded: (ad) => setState(() {
                  isAdLoaded = true;
                }),
            onAdFailedToLoad: (ad, error) {
              ad.dispose();
            }),
        request: const AdRequest());
    bannerAd.load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(actions: [
          IconButton(onPressed: () {}, icon: SvgPicture.asset(Assets.icPro)),
          IconButton(
              onPressed: () => Navigator.pushNamed(context, AppRoute.settings),
              icon: SvgPicture.asset(Assets.icSettings, color: AppColor.gray01))
        ], backgroundColor: AppColor.white, title: const Logo(size: 24)),
        backgroundColor: AppColor.backgroundColor,
        body: pages[currentPageIndex],
        bottomNavigationBar: Column(mainAxisSize: MainAxisSize.min, children: [
          BottomNavigationBar(
              backgroundColor: AppColor.white,
              currentIndex: currentPageIndex,
              items: [
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(currentPageIndex == 0 ? Assets.icWheelSelected : Assets.icWheel),
                    label: AppLocalizations.of(context)?.translate('Wheel')),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(currentPageIndex == 1 ? Assets.icChooserSelected : Assets.icChooser),
                    label: AppLocalizations.of(context)?.translate('Chooser')),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(currentPageIndex == 2 ? Assets.icDecisionSelected : Assets.icDecision),
                    label: AppLocalizations.of(context)?.translate('Decision')),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(currentPageIndex == 3 ? Assets.icNumberSelected : Assets.icNumber),
                    label: AppLocalizations.of(context)?.translate('Number')),
                BottomNavigationBarItem(
                    icon: SvgPicture.asset(currentPageIndex == 4 ? Assets.icCoinSelected : Assets.icCoin),
                    label: AppLocalizations.of(context)?.translate('Coin'))
              ],
              onTap: (value) => setState(() {
                    currentPageIndex = value;
                  }),
              selectedItemColor: AppColor.purple,
              selectedFontSize: 12,
              selectedLabelStyle: AppTextTheme.descriptionSemiBoldSmall.copyWith(color: AppColor.purple),
              showSelectedLabels: true,
              showUnselectedLabels: true,
              unselectedFontSize: 12,
              unselectedItemColor: AppColor.black,
              unselectedLabelStyle: AppTextTheme.descriptionSemiBoldSmall.copyWith(fontWeight: FontWeight.w400)),
          if (isAdLoaded)
            SizedBox(height: bannerAd.size.height.toDouble(), width: context.screenWidth, child: AdWidget(ad: bannerAd))
        ]),
        resizeToAvoidBottomInset: false);
  }
}
