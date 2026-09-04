/**
 * Which language to answer in.
 *
 * The app sends a bare code it already resolved (`hi`), so for our own
 * client this is nearly a no-op. Anything else speaking to the API sends a
 * real `Accept-Language` header, and that is a weighted list rather than a
 * single value: `en;q=0.5,hi;q=0.9` means "Hindi if you have it, English
 * otherwise". Reading the first entry and stopping would serve English to
 * a Hindi speaker who asked plainly for Hindi.
 *
 * The languages the interface itself ships in. A tag outside this list is
 * not refused -- it simply loses to English, which is what the caller
 * would have got anyway.
 */
export const SUPPORTED_LOCALES = [
  'en',
  'hi',
  'bn',
  'ta',
  'te',
  'mr',
  'ml',
  'kn',
  'gu',
  'pa',
] as const;

export type SupportedLocale = (typeof SUPPORTED_LOCALES)[number];

const DEFAULT_LOCALE: SupportedLocale = 'en';

/**
 * `hi-IN,hi;q=0.9,en;q=0.8` becomes `hi`. Falls back to English for a
 * missing, malformed, or unsupported header.
 */
export function normalizeLocale(header?: string): SupportedLocale {
  if (!header) return DEFAULT_LOCALE;

  const ranked = header
    .split(',')
    .map((part, index) => {
      const [tag, ...params] = part.trim().split(';');
      const language = tag?.split('-')[0]?.trim().toLowerCase() ?? '';

      // A malformed q is treated as absent rather than as zero: a client
      // that garbles the weight still means to ask for the language.
      const raw = params
        .map((p) => p.trim())
        .find((p) => p.toLowerCase().startsWith('q='))
        ?.slice(2);
      const parsed = raw === undefined ? 1 : Number(raw);
      const quality = Number.isFinite(parsed) ? parsed : 1;

      return { language, quality, index };
    })
    .filter((entry) => /^[a-z]{2}$/.test(entry.language) && entry.quality > 0)
    // Highest weight wins; ties keep the order the client wrote them in,
    // which is what the header means when weights are equal.
    .sort((a, b) => b.quality - a.quality || a.index - b.index);

  const match = ranked.find((entry) =>
    (SUPPORTED_LOCALES as readonly string[]).includes(entry.language),
  );
  return (match?.language as SupportedLocale) ?? DEFAULT_LOCALE;
}
