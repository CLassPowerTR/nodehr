part of '../splash_screen.dart';

class _SplashViewBody extends StatefulWidget {
  const _SplashViewBody({super.key});

  @override
  State<_SplashViewBody> createState() => __SplashViewBodyState();
}

class __SplashViewBodyState extends State<_SplashViewBody> {
  bool _busy = true;
  bool _hasConnection = false;
  bool _envLoaded = false;

  @override
  void initState() {
    super.initState();
    _startChecks();
  }

  Future<void> _startChecks() async {
    // arka planda bağlantı ve env yüklemesi yap
    final connection = await _checkConnection();
    final envOk = await _loadEnvFile();

    if (!mounted) return;

    setState(() {
      _hasConnection = connection;
      _envLoaded = envOk;
    });

    // Eğer her iki kontrol de başarılıysa local storage'dan first open seçeneğini oku
    if (connection && envOk) {
      String? option;
      try {
        option = await getFirstOpenOption();
      } catch (_) {
        option = null;
      }

      if (!mounted) return;

      // Gelen veriye göre rota belirle
      if (option == 'isletmeGirisi') {
        Navigator.of(context).pushReplacementNamed(AppRoutes.isletmeGirisi);
      } else if (option == 'musteriGirisi') {
        Navigator.of(context).pushReplacementNamed(AppRoutes.musteriGirisi);
      } else {
        // null veya beklenmeyen değer -> FirstOpenScreen
        Navigator.of(context).pushReplacementNamed(AppRoutes.firstOpen);
      }
      return;
    }

    // bağlantı veya env yüklemesi başarısızsa FirstOpenScreen'e yönlendir
    if (mounted) {
      Navigator.of(context).pushReplacementNamed(AppRoutes.firstOpen);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          _logoAsset(),
          const SizedBox(height: 20),
          if (_busy) _loadingIndicator(context) else const SizedBox.shrink(),
        ],
      ),
    );
  }
}
