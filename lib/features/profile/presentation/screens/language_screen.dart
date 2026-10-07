import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/services/audio_service.dart';
import '../../../../core/state/app_user_provider.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_dimensions.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/widgets/sb_button.dart';

import '../../../../core/widgets/sb_header.dart';

class LanguageInfo {
  final String code;
  final String name;
  final String nativeName;
  final String region;
  final List<String> countries;
  final String flag;
  final String ttsCode;
  final String sampleText;
  final String offlinePackSize;

  const LanguageInfo({
    required this.code,
    required this.name,
    required this.nativeName,
    required this.region,
    required this.countries,
    required this.flag,
    required this.ttsCode,
    required this.sampleText,
    this.offlinePackSize = '12 Mo',
  });
}

const List<LanguageInfo> kAvailableLanguages = [
  // ── AFRIQUE DE L'OUEST ──────────────────────────────────────────────
  LanguageInfo(
    code: 'fr',
    name: 'Français',
    nativeName: 'Français (Afrique)',
    region: 'Afrique de l\'Ouest',
    countries: [
      'Côte d\'Ivoire',
      'Sénégal',
      'Mali',
      'Burkina Faso',
      'Bénin',
      'Togo',
      'Niger',
      'Guinée',
    ],
    flag: '🌍',
    ttsCode: 'fr-FR',
    sampleText: 'Bienvenue sur SaveBabe. Votre santé et celle de votre bébé sont notre priorité.',
    offlinePackSize: '18 Mo',
  ),
  LanguageInfo(
    code: 'wo',
    name: 'Wolof',
    nativeName: 'Wolof',
    region: 'Afrique de l\'Ouest',
    countries: ['Sénégal', 'Gambie', 'Mauritanie'],
    flag: '🇸🇳',
    ttsCode: 'fr-FR',
    sampleText: 'Dalal ak jàmm ci SaveBabe. Wér-gu-yaramu sa doom ak yaw lañu gënë fiyteel.',
    offlinePackSize: '14 Mo',
  ),
  LanguageInfo(
    code: 'bm',
    name: 'Bambara',
    nativeName: 'Bamanankan',
    region: 'Afrique de l\'Ouest',
    countries: ['Mali', 'Burkina Faso', 'Côte d\'Ivoire'],
    flag: '🇲🇱',
    ttsCode: 'fr-FR',
    sampleText: 'I bisimila SaveBabe kɔnɔ. I kɛnɛya ni i den kɛnɛya de ye an ka fɔlɔfɔlɔ ye.',
    offlinePackSize: '14 Mo',
  ),
  LanguageInfo(
    code: 'dyu',
    name: 'Dioula',
    nativeName: 'Julakan',
    region: 'Afrique de l\'Ouest',
    countries: ['Côte d\'Ivoire', 'Burkina Faso', 'Mali'],
    flag: '🇨🇮',
    ttsCode: 'fr-FR',
    sampleText: 'I ni ce SaveBabe la. An b\'i dɛmɛ k\'i yɛrɛ n\'i den kɛnɛya mara ka ɲa.',
    offlinePackSize: '13 Mo',
  ),
  LanguageInfo(
    code: 'baoul',
    name: 'Baoulé',
    nativeName: 'Bawule',
    region: 'Afrique de l\'Ouest',
    countries: ['Côte d\'Ivoire'],
    flag: '🇨🇮',
    ttsCode: 'fr-FR',
    sampleText: 'Koko ba SaveBabe su. Mo klwa wunmi nin ɔ ba wunmi be jran.',
    offlinePackSize: '11 Mo',
  ),
  LanguageInfo(
    code: 'mos',
    name: 'Mooré',
    nativeName: 'Mòoré',
    region: 'Afrique de l\'Ouest',
    countries: ['Burkina Faso', 'Ghana', 'Côte d\'Ivoire'],
    flag: '🇧🇫',
    ttsCode: 'fr-FR',
    sampleText: 'Ne y beogo SaveBabe pʋgẽ. Yãmb la y bi-bila laafɩ la d tʋʋmde.',
    offlinePackSize: '12 Mo',
  ),
  LanguageInfo(
    code: 'fon',
    name: 'Fon',
    nativeName: 'Fɔ̀ngbè',
    region: 'Afrique de l\'Ouest',
    countries: ['Bénin', 'Togo'],
    flag: '🇧🇯',
    ttsCode: 'fr-FR',
    sampleText: 'Kú àbɔ̀ SaveBabe mɛ. Lanjinmɛ towe kpo vi towe tɔn kpo wɛ nyi nukun ɖeji mǐtɔn.',
    offlinePackSize: '12 Mo',
  ),
  LanguageInfo(
    code: 'yo',
    name: 'Yoruba',
    nativeName: 'Èdè Yorùbá',
    region: 'Afrique de l\'Ouest',
    countries: ['Nigeria', 'Bénin', 'Togo'],
    flag: '🇳🇬',
    ttsCode: 'en-NG',
    sampleText: 'Kaabo si SaveBabe. Ilera rẹ ati ti ọmọ rẹ jẹ ohun pataki julọ fun wa.',
    offlinePackSize: '15 Mo',
  ),
  LanguageInfo(
    code: 'ha',
    name: 'Haoussa',
    nativeName: 'Harshen Hausa',
    region: 'Afrique de l\'Ouest',
    countries: ['Niger', 'Nigeria', 'Ghana', 'Tchad'],
    flag: '🇳🇪',
    ttsCode: 'en-NG',
    sampleText: 'Barka da zuwa SaveBabe. Lafiyar ku da ta jaririnku itace babban abin da muka sa a gaba.',
    offlinePackSize: '15 Mo',
  ),
  LanguageInfo(
    code: 'ewe',
    name: 'Éwé / Mina',
    nativeName: 'Èʋegbe / Gɛngbe',
    region: 'Afrique de l\'Ouest',
    countries: ['Togo', 'Ghana', 'Bénin'],
    flag: '🇹🇬',
    ttsCode: 'fr-FR',
    sampleText: 'Woezɔ le SaveBabe me. Wò lãmesẽ kple viwò tɔ le vevie na mí ŋutɔ.',
    offlinePackSize: '12 Mo',
  ),
  LanguageInfo(
    code: 'ff',
    name: 'Peul / Fulfulde',
    nativeName: 'Pulaar / Fulfulde',
    region: 'Afrique de l\'Ouest',
    countries: ['Guinée', 'Sénégal', 'Mali', 'Cameroun', 'Niger', 'Burkina Faso'],
    flag: '🇬🇳',
    ttsCode: 'fr-FR',
    sampleText: 'Bismillaama e SaveBabe. Cellal ma e cellal suka maa ngoni ko ɓuri himmude e amen.',
    offlinePackSize: '14 Mo',
  ),
  LanguageInfo(
    code: 'ig',
    name: 'Igbo',
    nativeName: 'Asụsụ Igbo',
    region: 'Afrique de l\'Ouest',
    countries: ['Nigeria'],
    flag: '🇳🇬',
    ttsCode: 'en-NG',
    sampleText: 'Nnọọ na SaveBabe. Ahụike gị na nke nwa gị bụ ihe kacha anyị mkpa.',
    offlinePackSize: '13 Mo',
  ),
  LanguageInfo(
    code: 'tw',
    name: 'Twi / Akan',
    nativeName: 'Asante Twi',
    region: 'Afrique de l\'Ouest',
    countries: ['Ghana', 'Côte d\'Ivoire'],
    flag: '🇬🇭',
    ttsCode: 'en-GH',
    sampleText: 'Akwaaba ba SaveBabe. Wo apɔmuden ne wo ba no deɛ na ɛhia yɛn pa ara.',
    offlinePackSize: '13 Mo',
  ),

  // ── AFRIQUE CENTRALE ───────────────────────────────────────────────
  LanguageInfo(
    code: 'ln',
    name: 'Lingala',
    nativeName: 'Lingála',
    region: 'Afrique Centrale',
    countries: ['RD Congo', 'Congo', 'Centrafrique', 'Angola'],
    flag: '🇨🇩',
    ttsCode: 'fr-FR',
    sampleText: 'Boyei bolamu na SaveBabe. Kolɔngɔnɔ ya nzoto na yo mpe ya mwana na yo ezali likambo ya liboso mpo na biso.',
    offlinePackSize: '16 Mo',
  ),
  LanguageInfo(
    code: 'kg',
    name: 'Kikongo',
    nativeName: 'Kikɔ́ɔngɔ / Kituba',
    region: 'Afrique Centrale',
    countries: ['RD Congo', 'Congo', 'Angola'],
    flag: '🇨🇬',
    ttsCode: 'fr-FR',
    sampleText: 'Mbote na SaveBabe. Mavimpi na nge ti ya mwana kele kima ya ntete mpi ya mfunu sambu na beto.',
    offlinePackSize: '13 Mo',
  ),
  LanguageInfo(
    code: 'lua',
    name: 'Tshiluba',
    nativeName: 'Cilubà',
    region: 'Afrique Centrale',
    countries: ['RD Congo'],
    flag: '🇨🇩',
    ttsCode: 'fr-FR',
    sampleText: 'Difika dilenga mu SaveBabe. Makanda eba ne a muana webe ke tshintu tshitudi bakesha kumpala.',
    offlinePackSize: '12 Mo',
  ),
  LanguageInfo(
    code: 'sg',
    name: 'Sango',
    nativeName: 'Yângâ tî Sängö',
    region: 'Afrique Centrale',
    countries: ['Centrafrique', 'RD Congo', 'Tchad'],
    flag: '🇨🇫',
    ttsCode: 'fr-FR',
    sampleText: 'Bara ala na SaveBabe. Sêngo tî terê tî mo na tî kete molenge tî mo ayeke kôzo ye tî e.',
    offlinePackSize: '12 Mo',
  ),
  LanguageInfo(
    code: 'ewo',
    name: 'Ewondo / Beti',
    nativeName: 'Kóló / Ewondo',
    region: 'Afrique Centrale',
    countries: ['Cameroun', 'Gabon', 'Guinée équatoriale'],
    flag: '🇨🇲',
    ttsCode: 'fr-FR',
    sampleText: 'Mbébá na SaveBabe. Nkóbó nnyol wò ai móan wò mbɔ mféb dzam asu dáan.',
    offlinePackSize: '11 Mo',
  ),
  LanguageInfo(
    code: 'dua',
    name: 'Douala',
    nativeName: 'Duala',
    region: 'Afrique Centrale',
    countries: ['Cameroun'],
    flag: '🇨🇲',
    ttsCode: 'fr-FR',
    sampleText: 'Mulema na SaveBabe. Bwambo bwango na muna mɔ́nge bwe nde lambo la njanjo.',
    offlinePackSize: '11 Mo',
  ),
  LanguageInfo(
    code: 'shu',
    name: 'Arabe tchadien',
    nativeName: 'العربية التشادية (Shuwa)',
    region: 'Afrique Centrale',
    countries: ['Tchad', 'Cameroun', 'Centrafrique', 'Nigeria'],
    flag: '🇹🇩',
    ttsCode: 'ar-SA',
    sampleText: 'Marhaba bik fi SaveBabe. Sihitk w sihit janak humma aham shiy lina.',
    offlinePackSize: '12 Mo',
  ),

  // ── AFRIQUE DE L'EST ───────────────────────────────────────────────
  LanguageInfo(
    code: 'sw',
    name: 'Kiswahili',
    nativeName: 'Kiswahili',
    region: 'Afrique de l\'Est',
    countries: [
      'Kenya',
      'Tanzanie',
      'RD Congo',
      'Rwanda',
      'Burundi',
      'Ouganda',
    ],
    flag: '🇹🇿',
    ttsCode: 'sw-KE',
    sampleText: 'Karibu SaveBabe. Afya yako na ya mtoto wako ndiyo kipaumbele chetu kikuu.',
    offlinePackSize: '16 Mo',
  ),
  LanguageInfo(
    code: 'am',
    name: 'Amharique',
    nativeName: 'አማርኛ',
    region: 'Afrique de l\'Est',
    countries: ['Éthiopie'],
    flag: '🇪🇹',
    ttsCode: 'am-ET',
    sampleText: 'ወደ SaveBabe እንኳን በደህና መጡ። የእርስዎ እና የልጅዎ ጤና ለኛ ቅድሚያ የሚሰጠው ጉዳይ ነው።',
    offlinePackSize: '15 Mo',
  ),
  LanguageInfo(
    code: 'om',
    name: 'Oromo',
    nativeName: 'Afaan Oromoo',
    region: 'Afrique de l\'Est',
    countries: ['Éthiopie', 'Kenya'],
    flag: '🇪🇹',
    ttsCode: 'om-ET',
    sampleText: 'Baga nagaan gara SaveBabe dhuftan. Fayyaan keessanii fi kan daa\'ima keessanii nuuf dursa.',
    offlinePackSize: '13 Mo',
  ),
  LanguageInfo(
    code: 'ti',
    name: 'Tigrinya',
    nativeName: 'ትግርኛ',
    region: 'Afrique de l\'Est',
    countries: ['Érythrée', 'Éthiopie'],
    flag: '🇪🇷',
    ttsCode: 'ti-ET',
    sampleText: 'ናብ SaveBabe ብደሓን መጻእኩም። ጥዕናኹምን ጥዕና ቆልዓኹምን ንዓና ቀዳምነት እዩ።',
    offlinePackSize: '13 Mo',
  ),
  LanguageInfo(
    code: 'so',
    name: 'Somali',
    nativeName: 'Af Soomaali',
    region: 'Afrique de l\'Est',
    countries: ['Somalie', 'Djibouti', 'Éthiopie', 'Kenya'],
    flag: '🇸🇴',
    ttsCode: 'so-SO',
    sampleText: 'Kusoo dhowow SaveBabe. Caafimaadkaaga iyo kan ilmahaagu waa mudnaantayada koowaad.',
    offlinePackSize: '13 Mo',
  ),
  LanguageInfo(
    code: 'rw',
    name: 'Kinyarwanda',
    nativeName: 'Ikinyarwanda',
    region: 'Afrique de l\'Est',
    countries: ['Rwanda', 'RD Congo', 'Ouganda'],
    flag: '🇷🇼',
    ttsCode: 'rw-RW',
    sampleText: 'Murakaza neza kuri SaveBabe. Ubuzima bwawe n\'ubw\'umwana wawe nibyo biza imbere ya byose.',
    offlinePackSize: '14 Mo',
  ),
  LanguageInfo(
    code: 'rn',
    name: 'Kirundi',
    nativeName: 'Ikirundi',
    region: 'Afrique de l\'Est',
    countries: ['Burundi', 'RD Congo', 'Tanzanie'],
    flag: '🇧🇮',
    ttsCode: 'rn-BI',
    sampleText: 'Kaze kuri SaveBabe. Amagara yawe n\'ay\'umwana wawe niyo aza imbere.',
    offlinePackSize: '13 Mo',
  ),
  LanguageInfo(
    code: 'lg',
    name: 'Luganda',
    nativeName: 'Oluganda',
    region: 'Afrique de l\'Est',
    countries: ['Ouganda'],
    flag: '🇺🇬',
    ttsCode: 'lg-UG',
    sampleText: 'Tukusanyukidde ku SaveBabe. Obulamu bwo n\'obw\'omwana wo kye kintu ekikulu ennyo gye tuli.',
    offlinePackSize: '12 Mo',
  ),
  LanguageInfo(
    code: 'mg',
    name: 'Malagasy',
    nativeName: 'Fiteny Malagasy',
    region: 'Afrique de l\'Est',
    countries: ['Madagascar'],
    flag: '🇲🇬',
    ttsCode: 'mg-MG',
    sampleText: 'Tongasoa eto amin\'ny SaveBabe. Ny fahasalamanao sy ny an\'ny zanakao no laharam-pahamehanay.',
    offlinePackSize: '13 Mo',
  ),

  // ── AFRIQUE AUSTRALE ───────────────────────────────────────────────
  LanguageInfo(
    code: 'zu',
    name: 'Zoulou',
    nativeName: 'isiZulu',
    region: 'Afrique Australe',
    countries: ['Afrique du Sud', 'Eswatini', 'Lesotho'],
    flag: '🇿🇦',
    ttsCode: 'zu-ZA',
    sampleText: 'Siyakwamukela ku-SaveBabe. Impilo yakho neyomntwana wakho ibaluleke kakhulu kithi.',
    offlinePackSize: '15 Mo',
  ),
  LanguageInfo(
    code: 'xh',
    name: 'Xhosa',
    nativeName: 'isiXhosa',
    region: 'Afrique Australe',
    countries: ['Afrique du Sud'],
    flag: '🇿🇦',
    ttsCode: 'xh-ZA',
    sampleText: 'Wamkelekile kwi-SaveBabe. Impilo yakho neyomntwana wakho yeyona nto iphambili kuthi.',
    offlinePackSize: '14 Mo',
  ),
  LanguageInfo(
    code: 'sn',
    name: 'Shona',
    nativeName: 'chiShona',
    region: 'Afrique Australe',
    countries: ['Zimbabwe', 'Mozambique'],
    flag: '🇿🇼',
    ttsCode: 'sn-ZW',
    sampleText: 'Mauya ku-SaveBabe. Hutano hwenyu nehwe mwana wenyu ndizvo zvatinokoshesa.',
    offlinePackSize: '13 Mo',
  ),
  LanguageInfo(
    code: 'ny',
    name: 'Chichewa',
    nativeName: 'Chichewa / Nyanja',
    region: 'Afrique Australe',
    countries: ['Malawi', 'Zambie', 'Mozambique'],
    flag: '🇲🇼',
    ttsCode: 'ny-MW',
    sampleText: 'Takulandirani ku SaveBabe. Thanzi lanu ndi la mwana wanu ndiwo mtima wathu.',
    offlinePackSize: '13 Mo',
  ),
  LanguageInfo(
    code: 'pt_mz',
    name: 'Português (África)',
    nativeName: 'Português Africano',
    region: 'Afrique Australe',
    countries: ['Mozambique', 'Angola', 'Cap-Vert', 'Guinée-Bissau'],
    flag: '🇲🇿',
    ttsCode: 'pt-PT',
    sampleText: 'Bem-vinda ao SaveBabe. A sua saúde e a do seu bebé são a nossa maior prioridade.',
    offlinePackSize: '16 Mo',
  ),

  // ── AFRIQUE DU NORD ────────────────────────────────────────────────
  LanguageInfo(
    code: 'ar',
    name: 'Arabe standard',
    nativeName: 'العربية الفصحى',
    region: 'Afrique du Nord',
    countries: ['Maroc', 'Algérie', 'Tunisie', 'Égypte', 'Mauritanie'],
    flag: '🇲🇦',
    ttsCode: 'ar-XA',
    sampleText: 'مرحبًا بكِ في SaveBabe. صحتكِ وصحة طفلكِ هي أولويتنا الأولى.',
    offlinePackSize: '18 Mo',
  ),
  LanguageInfo(
    code: 'ber',
    name: 'Tamazight',
    nativeName: 'ⵜⴰⵎⴰⵣⵉⵖⵜ (Tamazight)',
    region: 'Afrique du Nord',
    countries: ['Maroc', 'Algérie'],
    flag: '🇲🇦',
    ttsCode: 'fr-FR',
    sampleText: 'Ansuf yiswen g SaveBabe. Tazmert nwen d tin n llufan nwen d ayen amezwaru yur-nneɣ.',
    offlinePackSize: '12 Mo',
  ),

  // ── INTERNATIONALES ────────────────────────────────────────────────
  LanguageInfo(
    code: 'en',
    name: 'English',
    nativeName: 'English (International)',
    region: 'Internationales',
    countries: ['Nigeria', 'Ghana', 'Kenya', 'Afrique du Sud', 'Monde'],
    flag: '🇬🇧',
    ttsCode: 'en-US',
    sampleText: 'Welcome to SaveBabe. Your health and your baby\'s well-being are our highest priority.',
    offlinePackSize: '18 Mo',
  ),
];

const List<String> kRegions = [
  'Toutes',
  'Afrique de l\'Ouest',
  'Afrique Centrale',
  'Afrique de l\'Est',
  'Afrique Australe',
  'Afrique du Nord',
  'Internationales',
];

class LanguageScreen extends ConsumerStatefulWidget {
  const LanguageScreen({super.key});

  @override
  ConsumerState<LanguageScreen> createState() => _LanguageScreenState();
}

class _LanguageScreenState extends ConsumerState<LanguageScreen> {
  final TextEditingController _searchController = TextEditingController();
  final AudioServiceImpl _audioService = AudioServiceImpl();

  late String _selectedRegion;
  late String _selectedCountry;
  late String _selectedLanguage;
  String _searchQuery = '';
  bool _isPlayingSample = false;
  String? _playingLanguageCode;

  @override
  void initState() {
    super.initState();
    final user = ref.read(appUserStateProvider);
    _selectedCountry = user.country.isNotEmpty
        ? user.country
        : 'Côte d\'Ivoire';
    _selectedLanguage = user.language.isNotEmpty ? user.language : 'Français';
    _selectedRegion = 'Toutes';

    _searchController.addListener(() {
      setState(() {
        _searchQuery = _searchController.text.trim().toLowerCase();
      });
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _audioService.stopSpeaking();
    super.dispose();
  }

  List<LanguageInfo> get _filteredLanguages {
    return kAvailableLanguages.where((lang) {
      final matchesRegion = _selectedRegion == 'Toutes' || lang.region == _selectedRegion;
      if (!matchesRegion) return false;

      if (_searchQuery.isEmpty) return true;

      final matchesName = lang.name.toLowerCase().contains(_searchQuery);
      final matchesNative = lang.nativeName.toLowerCase().contains(_searchQuery);
      final matchesCountry = lang.countries.any((c) => c.toLowerCase().contains(_searchQuery));
      final matchesCode = lang.code.toLowerCase().contains(_searchQuery);

      return matchesName || matchesNative || matchesCountry || matchesCode;
    }).toList();
  }

  LanguageInfo get _currentLanguageInfo {
    return kAvailableLanguages.firstWhere(
      (l) => l.name == _selectedLanguage,
      orElse: () => kAvailableLanguages.first,
    );
  }

  Future<void> _playVoiceSample(LanguageInfo lang) async {
    if (_isPlayingSample && _playingLanguageCode == lang.code) {
      await _audioService.stopSpeaking();
      setState(() {
        _isPlayingSample = false;
        _playingLanguageCode = null;
      });
      return;
    }

    setState(() {
      _isPlayingSample = true;
      _playingLanguageCode = lang.code;
    });

    try {
      await _audioService.speak(lang.sampleText);
    } catch (_) {}

    if (mounted) {
      setState(() {
        _isPlayingSample = false;
        _playingLanguageCode = null;
      });
    }
  }

  void _save() {
    ref
        .read(appUserStateNotifierProvider.notifier)
        .setLanguage(_selectedLanguage, _selectedCountry);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Langue enregistrée : $_selectedLanguage ($_selectedCountry)',
                style: const TextStyle(fontWeight: FontWeight.w600),
              ),
            ),
          ],
        ),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
    context.pop();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final currentLang = _currentLanguageInfo;
    final languages = _filteredLanguages;

    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            // ── HEADER PRINCIPAL ──────────────────────────────────────
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 8),
              child: SbHeader(
                title: 'Langues & Régions',
                subtitle: 'Choisissez votre langue pour l\'audio et le texte',
                onBack: () => context.pop(),
              ),
            ),

            // ── CONTENU DÉFILABLE ────────────────────────────────────
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.fromLTRB(20, 0, 20, 24),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ── CARTE LANGUE ACTIVE ACTUELLE ──────────────────
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          colors: isDark
                              ? [const Color(0xFF232A55), const Color(0xFF1B2044)]
                              : [const Color(0xFFEFF4FF), const Color(0xFFE5EEFF)],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF38447F)
                              : AppColors.primary.withValues(alpha: 0.2),
                          width: 1.5,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.08),
                            blurRadius: 14,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Row(
                        children: [
                          Container(
                            width: 52,
                            height: 52,
                            decoration: BoxDecoration(
                              color: AppColors.primary,
                              borderRadius: BorderRadius.circular(16),
                              boxShadow: [
                                BoxShadow(
                                  color: AppColors.primary.withValues(alpha: 0.35),
                                  blurRadius: 10,
                                  offset: const Offset(0, 3),
                                ),
                              ],
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              currentLang.flag,
                              style: const TextStyle(fontSize: 26),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.15),
                                        borderRadius: BorderRadius.circular(6),
                                      ),
                                      child: const Text(
                                        'LANGUE ACTIVE',
                                        style: TextStyle(
                                          fontFamily: 'Figtree',
                                          fontSize: 9.5,
                                          fontWeight: FontWeight.w800,
                                          color: AppColors.primary,
                                          letterSpacing: 0.5,
                                        ),
                                      ),
                                    ),
                                    const Spacer(),
                                    const Icon(
                                      Icons.check_circle_rounded,
                                      color: AppColors.success,
                                      size: 18,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  '${currentLang.name} (${currentLang.nativeName})',
                                  style: TextStyle(
                                    fontFamily: 'Figtree',
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: isDark ? Colors.white : const Color(0xFF131938),
                                  ),
                                ),
                                const SizedBox(height: 2),
                                Text(
                                  'Pack audio & conseils hors ligne prêt (${currentLang.offlinePackSize})',
                                  style: TextStyle(
                                    fontFamily: 'Figtree',
                                    fontSize: 11.5,
                                    color: isDark
                                        ? const Color(0xFF9AA7D4)
                                        : const Color(0xFF4B5563),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // ── BARRE DE RECHERCHE DYNAMIQUE ──────────────────
                    Container(
                      decoration: BoxDecoration(
                        color: isDark ? const Color(0xFF1A2040) : Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isDark
                              ? const Color(0xFF2C3668)
                              : const Color(0xFFE2E8F4),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withValues(alpha: 0.03),
                            blurRadius: 10,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        controller: _searchController,
                        style: TextStyle(
                          fontFamily: 'Figtree',
                          fontSize: 14,
                          color: isDark ? Colors.white : Colors.black87,
                        ),
                        decoration: InputDecoration(
                          hintText: 'Rechercher une langue, un pays, un dialecte...',
                          hintStyle: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 13,
                            color: isDark ? const Color(0xFF7A88B4) : const Color(0xFF9CA3AF),
                          ),
                          prefixIcon: const Icon(
                            Icons.search_rounded,
                            color: AppColors.primary,
                            size: 22,
                          ),
                          suffixIcon: _searchQuery.isNotEmpty
                              ? IconButton(
                                  icon: const Icon(Icons.clear_rounded, size: 18),
                                  onPressed: () => _searchController.clear(),
                                )
                              : null,
                          border: InputBorder.none,
                          contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16,
                            vertical: 14,
                          ),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),

                    // ── ONGLETS DE FILTRAGE RÉGIONAL ──────────────────
                    SizedBox(
                      height: 38,
                      child: ListView.separated(
                        scrollDirection: Axis.horizontal,
                        itemCount: kRegions.length,
                        separatorBuilder: (_, __) => const SizedBox(width: 8),
                        itemBuilder: (context, index) {
                          final r = kRegions[index];
                          final isSelected = _selectedRegion == r;
                          return GestureDetector(
                            onTap: () => setState(() => _selectedRegion = r),
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 8,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? AppColors.primary
                                    : (isDark
                                          ? const Color(0xFF1E2448)
                                          : const Color(0xFFF0F4FC)),
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark
                                            ? const Color(0xFF2C3668)
                                            : const Color(0xFFE2E8F4)),
                                ),
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                r,
                                style: TextStyle(
                                  fontFamily: 'Figtree',
                                  fontSize: 12,
                                  fontWeight: isSelected
                                      ? FontWeight.w700
                                      : FontWeight.w600,
                                  color: isSelected
                                      ? Colors.white
                                      : (isDark
                                            ? const Color(0xFFA5B2DD)
                                            : const Color(0xFF4B5563)),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    ),

                    const SizedBox(height: 18),

                    // ── TITRE ET NOMBRE DE LANGUES ────────────────────
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Langues disponibles (${languages.length})',
                          style: TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 14.5,
                            fontWeight: FontWeight.w800,
                            color: isDark ? Colors.white : const Color(0xFF1C244B),
                          ),
                        ),
                        Text(
                          '${kAvailableLanguages.length} langues africaines',
                          style: const TextStyle(
                            fontFamily: 'Figtree',
                            fontSize: 11.5,
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 12),

                    // ── LISTE DES CARTES DE LANGUES ───────────────────
                    if (languages.isEmpty) ...[
                      Container(
                        padding: const EdgeInsets.all(28),
                        alignment: Alignment.center,
                        child: Column(
                          children: [
                            const Icon(
                              Icons.language_rounded,
                              size: 48,
                              color: AppColors.mutedForeground,
                            ),
                            const SizedBox(height: 12),
                            Text(
                              'Aucune langue trouvée pour « $_searchQuery »',
                              textAlign: TextAlign.center,
                              style: AppTypography.bodyM.copyWith(
                                color: isDark ? Colors.white70 : Colors.black54,
                              ),
                            ),
                            const SizedBox(height: 8),
                            OutlinedButton(
                              onPressed: () {
                                _searchController.clear();
                                setState(() => _selectedRegion = 'Toutes');
                              },
                              child: const Text('Réinitialiser la recherche'),
                            ),
                          ],
                        ),
                      ),
                    ] else ...[
                      ListView.separated(
                        shrinkWrap: true,
                        physics: const NeverScrollableScrollPhysics(),
                        itemCount: languages.length,
                        separatorBuilder: (_, __) => const SizedBox(height: 10),
                        itemBuilder: (context, index) {
                          final lang = languages[index];
                          final isSelected = _selectedLanguage == lang.name;
                          final isPlayingThis =
                              _isPlayingSample && _playingLanguageCode == lang.code;

                          return GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedLanguage = lang.name;
                                if (lang.countries.isNotEmpty &&
                                    !lang.countries.contains(_selectedCountry)) {
                                  _selectedCountry = lang.countries.first;
                                }
                              });
                            },
                            child: AnimatedContainer(
                              duration: const Duration(milliseconds: 200),
                              padding: const EdgeInsets.symmetric(
                                horizontal: 14,
                                vertical: 12,
                              ),
                              decoration: BoxDecoration(
                                color: isSelected
                                    ? (isDark
                                          ? const Color(0xFF222B59)
                                          : const Color(0xFFF1F6FF))
                                    : (isDark
                                          ? const Color(0xFF181D3B)
                                          : Colors.white),
                                borderRadius: BorderRadius.circular(16),
                                border: Border.all(
                                  color: isSelected
                                      ? AppColors.primary
                                      : (isDark
                                            ? const Color(0xFF27315E)
                                            : const Color(0xFFE5ECF8)),
                                  width: isSelected ? 2 : 1,
                                ),
                                boxShadow: isSelected
                                    ? [
                                        BoxShadow(
                                          color: AppColors.primary.withValues(
                                            alpha: 0.15,
                                          ),
                                          blurRadius: 10,
                                          offset: const Offset(0, 3),
                                        ),
                                      ]
                                    : null,
                              ),
                              child: Row(
                                children: [
                                  // Drapeau / Icône
                                  Container(
                                    width: 42,
                                    height: 42,
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? AppColors.primary.withValues(
                                              alpha: 0.15,
                                            )
                                          : (isDark
                                                ? const Color(0xFF232A50)
                                                : const Color(0xFFF0F4FC)),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    alignment: Alignment.center,
                                    child: Text(
                                      lang.flag,
                                      style: const TextStyle(fontSize: 20),
                                    ),
                                  ),
                                  const SizedBox(width: 12),

                                  // Noms et pays
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              lang.name,
                                              style: TextStyle(
                                                fontFamily: 'Figtree',
                                                fontSize: 15,
                                                fontWeight: FontWeight.w700,
                                                color: isDark
                                                    ? Colors.white
                                                    : const Color(0xFF192147),
                                              ),
                                            ),
                                            const SizedBox(width: 6),
                                            Flexible(
                                              child: Text(
                                                '(${lang.nativeName})',
                                                overflow: TextOverflow.ellipsis,
                                                style: TextStyle(
                                                  fontFamily: 'Figtree',
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.w500,
                                                  color: isSelected
                                                      ? AppColors.primary
                                                      : (isDark
                                                            ? const Color(
                                                                0xFF8E9BBF,
                                                              )
                                                            : const Color(
                                                                0xFF6B7280,
                                                              )),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          lang.countries.take(3).join(', ') +
                                              (lang.countries.length > 3
                                                  ? '...'
                                                  : ''),
                                          style: TextStyle(
                                            fontFamily: 'Figtree',
                                            fontSize: 11,
                                            color: isDark
                                                ? const Color(0xFF7D8AB4)
                                                : const Color(0xFF808B9F),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Bouton Écouter Prononciation Vocale
                                  IconButton(
                                    tooltip: 'Écouter un extrait vocal',
                                    icon: Icon(
                                      isPlayingThis
                                          ? Icons.stop_circle_rounded
                                          : Icons.volume_up_rounded,
                                      color: isPlayingThis
                                          ? AppColors.pink
                                          : AppColors.primary,
                                      size: 22,
                                    ),
                                    onPressed: () => _playVoiceSample(lang),
                                  ),

                                  // Sélecteur Radio personnalisé
                                  Container(
                                    width: 22,
                                    height: 22,
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      color: isSelected
                                          ? AppColors.primary
                                          : Colors.transparent,
                                      border: Border.all(
                                        color: isSelected
                                            ? AppColors.primary
                                            : (isDark
                                                  ? const Color(0xFF43528A)
                                                  : const Color(0xFFCBD5E1)),
                                        width: 2,
                                      ),
                                    ),
                                    child: isSelected
                                        ? const Icon(
                                            Icons.check,
                                            color: Colors.white,
                                            size: 14,
                                          )
                                        : null,
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
                    ],

                    const SizedBox(height: 24),

                    // ── PAYS D'USAGE PRINCIPAL ────────────────────────
                    Text(
                      'Pays de résidence / Suivi médical',
                      style: AppTypography.labelM.copyWith(
                        color: isDark
                            ? AppColors.darkCardForeground
                            : AppColors.cardForeground,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      decoration: BoxDecoration(
                        color: isDark ? AppColors.darkCard : AppColors.card,
                        borderRadius: BorderRadius.circular(
                          AppDimensions.radiusLg,
                        ),
                        border: Border.all(
                          color: isDark
                              ? AppColors.darkBorder
                              : AppColors.border,
                        ),
                      ),
                      child: DropdownButtonHideUnderline(
                        child: DropdownButton<String>(
                          value: currentLang.countries.contains(_selectedCountry)
                              ? _selectedCountry
                              : (currentLang.countries.isNotEmpty
                                    ? currentLang.countries.first
                                    : 'Côte d\'Ivoire'),
                          isExpanded: true,
                          dropdownColor:
                              isDark ? AppColors.darkCard : Colors.white,
                          items: (currentLang.countries.isNotEmpty
                                  ? currentLang.countries
                                  : [_selectedCountry])
                              .map((c) {
                            return DropdownMenuItem(
                              value: c,
                              child: Text(
                                c,
                                style: AppTypography.bodyM.copyWith(
                                  color: isDark
                                      ? AppColors.darkCardForeground
                                      : AppColors.cardForeground,
                                ),
                              ),
                            );
                          }).toList(),
                          onChanged: (val) {
                            if (val != null) {
                              setState(() => _selectedCountry = val);
                            }
                          },
                        ),
                      ),
                    ),

                    const SizedBox(height: 28),

                    // ── BOUTON D'ENREGISTREMENT ───────────────────────
                    SbButton(
                      text: 'Valider et appliquer cette langue',
                      icon: const Icon(Icons.check_rounded, color: Colors.white),
                      onPressed: _save,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
