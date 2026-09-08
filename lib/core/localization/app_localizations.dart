import 'package:flutter/widgets.dart';

class AppLocalizations {
  const AppLocalizations(this.locale);

  final Locale locale;

  static const delegate = _AppLocalizationsDelegate();
  static const supportedLocales = [Locale('en'), Locale('fr')];

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  bool get isFrench => locale.languageCode == 'fr';

  String get appTitle => 'Flutter Backend App';
  String get explorer => isFrench ? 'Explorer' : 'Explore';
  String get profile => isFrench ? 'Profil' : 'Profile';
  String get login => isFrench ? 'Connexion' : 'Sign in';
  String get register => isFrench ? 'Créer un compte' : 'Create an account';
  String get username => isFrench ? 'Nom d utilisateur' : 'Username';
  String get password => isFrench ? 'Mot de passe' : 'Password';
  String get searchProduct =>
      isFrench ? 'Rechercher un produit' : 'Search products';
  String get clearSearch => isFrench ? 'Effacer la recherche' : 'Clear search';
  String get offline => isFrench ? 'Mode hors ligne' : 'Offline mode';
    String get connectionError => isFrench ? 'Connexion impossible.' : 'Unable to connect.';
  String get noProducts =>
      isFrench ? 'Aucun produit trouve.' : 'No products found.';
  String get backendConnection =>
      isFrench ? 'Connexion au backend...' : 'Connecting to backend...';
  String get logout => isFrench ? 'Se deconnecter' : 'Sign out';
  String get authenticated =>
      isFrench ? 'Authentifie par le backend' : 'Authenticated by backend';
    String get activeSession => isFrench ? 'Etat de session' : 'Session status';
  String get identifier => isFrench ? 'Identifiant' : 'Identifier';
  String get noSession =>
      isFrench ? 'Aucune session active.' : 'No active session.';
  String get language => isFrench ? 'Langue' : 'Language';
  String get french => 'Francais';
  String get english => 'English';
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  bool isSupported(Locale locale) => ['en', 'fr'].contains(locale.languageCode);

  @override
  Future<AppLocalizations> load(Locale locale) async =>
      AppLocalizations(locale);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}
