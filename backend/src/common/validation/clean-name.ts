import { registerDecorator, ValidationOptions } from 'class-validator';

/**
 * Names that must not be allowed: profanity, sexual terms, slurs, and names
 * that pass for the platform itself.
 *
 * A name is not private. A member's name appears in their gym's chat and
 * staff lists, a gym's name in the public gym browser. One account named
 * something obscene put that in front of everyone who could see it -- so
 * the check is on the server, where the app cannot be talked around.
 *
 * The hard part is not the list, it is the names it must NOT catch. Indian
 * names contain these strings all the time: Dik-SHIT, SHIT-al, RANDI-p,
 * GAND-hi, h-ASS-an, ASS-am, Sa-XENA. So every term is matched one of
 * three ways, chosen per term:
 *
 *   WORD   -- the whole word is the term: "sex" blocks "Sex Bot" but not
 *             "Essex". Most terms are this.
 *   PREFIX -- a word that starts with the term: "sexbot", "porn4u". Only
 *             for terms no real name starts with.
 *   ANYWHERE -- the term inside anything, spaces and punctuation removed:
 *             long compounds like "madarchod" that are in no real name.
 *
 * Matching tolerates the usual disguises: letter repeats ("seeexxx"),
 * look-alike digits and symbols ("s3x", "$ex"), and spaced-out letters
 * ("s e x", "s.e.x"). Repeats are matched per letter rather than by
 * collapsing them, because collapsing turns "boob" into "bob" -- a name.
 *
 * The error never repeats the word back: echoing it would put it on screen
 * anyway.
 */

// ── Lists ────────────────────────────────────────────────────────────────

/** The whole word only. */
const WORD = [
  // English
  'sex', 'sexy', 'ass', 'asshole', 'arse', 'fuck', 'fck', 'fuk', 'shit',
  'dick', 'cock', 'cum', 'porn', 'nude', 'nudes', 'boob', 'boobs', 'tit',
  'tits', 'pussy', 'penis', 'vagina', 'slut', 'whore', 'bitch', 'bastard',
  'rape', 'rapist', 'nigger', 'nigga', 'fag', 'faggot', 'xxx', 'milf',
  'horny', 'wank', 'twat', 'cunt', 'bollocks', 'dildo', 'hentai',
  // Hindi / Hinglish, Latin script. Left out on purpose: "mc", "bc" and
  // "mkc" (initials -- M. C. Mary Kom, B. C. Roy), "kutti" (an everyday
  // Tamil and Malayalam name, "little one"), "saali", "rand", "loda".
  'bsdk', 'chut', 'choot', 'lund', 'lauda', 'lawda', 'lavda', 'lodu',
  'gand', 'gaand', 'gandu', 'randi', 'randwa', 'harami', 'haramzada',
  'haramzadi', 'kutta', 'kuttiya', 'bhadwa', 'bhadwe', 'chinal', 'chod',
  'chodu', 'chudai', 'jhant', 'jhaatu', 'tatte', 'suar',
];

/** Any word starting with it. None of these begins a real name. */
const PREFIX = ['sex', 'porn', 'fuck', 'nude', 'xxx', 'boob', 'pussy', 'horny'];

/** Anywhere, even run together with other words or split by symbols. */
const ANYWHERE = [
  'fuck', 'motherfucker', 'madarchod', 'maderchod', 'madharchod',
  'madarjaat', 'behenchod', 'bhenchod', 'benchod', 'bhenchodd', 'behnchod',
  'bhosdi', 'bhosda', 'bhosadi', 'bhosdike', 'chutiya', 'chutiye',
  'chootiya', 'gaandu', 'bhadwa', 'randibaaz', 'pornhub', 'xvideos',
  'onlyfans',
  // Not "chutia": that is how the Assamese Chutia community -- a real
  // surname -- is usually spelled.
];

/**
 * Devanagari, matched anywhere -- these spellings are unambiguous. Not
 * गांड (inside गांडीव, a name) or लंड (लंडन, London).
 */
const DEVANAGARI = [
  'सेक्स', 'चूतिया', 'चुतिया', 'मादरचोद', 'भेनचोद', 'बहनचोद',
  'भोसड़ी', 'भोसडी', 'भोसड़ा', 'रंडी', 'गांडू', 'लौड़ा', 'लौडा',
  'हरामी', 'हरामज़ादा', 'हरामजादा', 'चोद', 'कुत्ती', 'भड़वा', 'भडवा',
  'चुदाई', 'छिनाल',
];

/**
 * Names that pass for the platform or its staff. Someone called
 * "Gymologia Support" messaging members in a gym chat is how phishing
 * starts. Whole words, except where noted.
 */
const RESERVED_WORD = ['gymologia', 'admin', 'administrator', 'moderator'];
const RESERVED_PHRASE = ['customer care', 'customer support', 'support team', 'help desk', 'helpdesk'];

// ── Matching ─────────────────────────────────────────────────────────────

/** Look-alikes people substitute for letters. */
const LEET: Record<string, string> = {
  '0': 'o', '1': 'i', '3': 'e', '4': 'a', '5': 's', '7': 't', '8': 'b',
  '9': 'g', '@': 'a', '$': 's', '!': 'i', '|': 'i', '€': 'e',
};

/** "sex" -> /s+e+x+/ so "seeexxx" matches and "sx" does not. */
function repeatTolerant(term: string): string {
  return [...term].map((c) => `${c.replace(/[.*+?^${}()|[\]\\]/g, '\\$&')}+`).join('');
}

const WORD_RE = WORD.map((t) => new RegExp(`^${repeatTolerant(t)}$`));
const PREFIX_RE = PREFIX.map((t) => new RegExp(`^${repeatTolerant(t)}`));
const ANYWHERE_RE = ANYWHERE.map((t) => new RegExp(repeatTolerant(t)));
const RESERVED_RE = RESERVED_WORD.map((t) => new RegExp(`^${repeatTolerant(t)}$`));

/** Lowercase, width-folded, with look-alikes mapped to letters. */
function fold(value: string): string {
  return [...value.normalize('NFKC').toLowerCase()]
    .map((c) => LEET[c] ?? c)
    .join('');
}

/**
 * Words, with runs of single letters joined back together -- so
 * "s e x bot" and "s.e.x" read as "sex bot" and "sex".
 */
function words(folded: string): string[] {
  const raw = folded.split(/[^\p{L}\p{M}]+/u).filter(Boolean);
  const out: string[] = [];
  let run = '';
  for (const w of raw) {
    if ([...w].length === 1) {
      run += w;
      continue;
    }
    if (run) out.push(run);
    run = '';
    out.push(w);
  }
  if (run) out.push(run);
  return out;
}

/** True when the name contains something that must not be allowed. */
export function isBlockedName(value: unknown): boolean {
  if (typeof value !== 'string') return false;
  const folded = fold(value);
  const tokens = words(folded);
  const squashed = folded.replace(/[^\p{L}\p{M}]+/gu, '');
  const spaced = tokens.join(' ');

  if (tokens.some((w) => WORD_RE.some((re) => re.test(w)))) return true;
  if (tokens.some((w) => PREFIX_RE.some((re) => re.test(w)))) return true;
  if (ANYWHERE_RE.some((re) => re.test(squashed))) return true;
  if (DEVANAGARI.some((t) => value.normalize('NFC').includes(t))) return true;
  if (tokens.some((w) => RESERVED_RE.some((re) => re.test(w)))) return true;
  if (RESERVED_PHRASE.some((p) => spaced.includes(p))) return true;
  return false;
}

export const IsCleanName =
  (options?: ValidationOptions) =>
  function (object: object, propertyName: string): void {
    registerDecorator({
      name: 'isCleanName',
      target: object.constructor,
      propertyName,
      options,
      validator: {
        validate: (value: unknown) => !isBlockedName(value),
        // Deliberately does not quote the value back.
        defaultMessage: () =>
          'This name is not allowed. Please choose a different one.',
      },
    });
  };
