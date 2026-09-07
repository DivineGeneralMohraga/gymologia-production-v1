import { SupportedLocale } from '../common/utils/locale';

/**
 * The sentence a referrer forwards to a gym owner.
 *
 * This one string is built on the server rather than in the app, and that
 * is deliberate: it is the only user-facing string in the product whose
 * audience is not the person reading the screen. The referrer sees it, but
 * the gym owner is the one who has to understand it, and it travels by
 * WhatsApp into a conversation the app never sees. Shipping it in English
 * to a Marathi-speaking referrer means they forward English to a
 * Marathi-speaking gym owner, or retype it themselves.
 *
 * `Gymologia` and the code itself stay in Latin script in every language.
 * The code is typed into a form that accepts A-Z and digits, so a
 * transliterated one would not be enterable, and a product name that
 * changes spelling per language is not searchable.
 *
 * Percent is written as `10%` throughout rather than spelled out, because
 * every one of these scripts uses Western digits for prices in practice.
 */
type Template = (code: string) => string;

const TEMPLATES: Record<SupportedLocale, Template> = {
  en: (code) =>
    `Use my Gymologia code ${code} when you subscribe your gym and get 10% off.`,
  hi: (code) =>
    `अपने जिम की सदस्यता लेते समय मेरा Gymologia कोड ${code} इस्तेमाल करें और 10% की छूट पाएँ।`,
  bn: (code) =>
    `আপনার জিমের সাবস্ক্রিপশন নেওয়ার সময় আমার Gymologia কোড ${code} ব্যবহার করুন এবং 10% ছাড় পান।`,
  ta: (code) =>
    `உங்கள் ஜிம்முக்குச் சந்தா செலுத்தும்போது எனது Gymologia குறியீடு ${code} பயன்படுத்தி 10% தள்ளுபடி பெறுங்கள்.`,
  te: (code) =>
    `మీ జిమ్‌కు సబ్‌స్క్రిప్షన్ తీసుకునేటప్పుడు నా Gymologia కోడ్ ${code} ఉపయోగించి 10% తగ్గింపు పొందండి.`,
  mr: (code) =>
    `तुमच्या जिमची सदस्यता घेताना माझा Gymologia कोड ${code} वापरा आणि 10% सूट मिळवा.`,
  ml: (code) =>
    `നിങ്ങളുടെ ജിമ്മിന് സബ്‌സ്‌ക്രിപ്ഷൻ എടുക്കുമ്പോൾ എന്റെ Gymologia കോഡ് ${code} ഉപയോഗിച്ച് 10% കിഴിവ് നേടൂ.`,
  kn: (code) =>
    `ನಿಮ್ಮ ಜಿಮ್‌ಗೆ ಚಂದಾದಾರಿಕೆ ಪಡೆಯುವಾಗ ನನ್ನ Gymologia ಕೋಡ್ ${code} ಬಳಸಿ 10% ರಿಯಾಯಿತಿ ಪಡೆಯಿರಿ.`,
  gu: (code) =>
    `તમારા જીમનું સબ્સ્ક્રિપ્શન લેતી વખતે મારો Gymologia કોડ ${code} વાપરો અને 10% છૂટ મેળવો.`,
  pa: (code) =>
    `ਆਪਣੇ ਜਿਮ ਦੀ ਸਬਸਕ੍ਰਿਪਸ਼ਨ ਲੈਂਦੇ ਸਮੇਂ ਮੇਰਾ Gymologia ਕੋਡ ${code} ਵਰਤੋ ਅਤੇ 10% ਛੋਟ ਪਾਓ।`,
};

/**
 * The share sentence in the caller's language.
 *
 * An unsupported locale cannot reach here -- `normalizeLocale` has already
 * collapsed the header to one of the ten -- but the fallback is kept
 * because a locale added to SUPPORTED_LOCALES without a line here would
 * otherwise return `undefined` and put the word "undefined" in front of a
 * gym owner.
 */
export function shareText(code: string, locale: SupportedLocale): string {
  return (TEMPLATES[locale] ?? TEMPLATES.en)(code);
}

/** Exposed for the test that checks every supported language has a line. */
export const SHARE_TEXT_LOCALES = Object.keys(TEMPLATES);
