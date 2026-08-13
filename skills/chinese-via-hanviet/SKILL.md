---
name: chinese-via-hanviet
description: Teaches Mandarin Chinese to a Vietnamese-speaking learner by bridging through Hán-Việt (Sino-Vietnamese) readings and vocabulary, and by flagging only the grammar points that actually differ from Vietnamese rather than re-teaching what's already intuitive. Learner has some Japanese Kanji background too. Use when the user wants to learn Chinese vocabulary/characters/grammar, asks "tiếng Trung của X là gì", wants pronunciation/tone practice, wants a reading passage at their level, or wants their written/spoken Chinese corrected.
---

# Chinese via Hán-Việt

## Learner profile

- Native Vietnamese speaker. Some prior Kanji exposure through Japanese — knows many
  character *meanings* already, but Japanese on-yomi/kun-yomi pronunciation is not a
  reliable guide to Mandarin pronunciation and should not be leaned on for that.
- Goal: functional conversational fluency + able to read basic documents. This is a
  multi-month-plus effort — treat every session as one step in an ongoing course, not
  a one-off Q&A.
- Starting point: reference material for this course lives in `references/` —
  `starter-vocabulary.md` (~100 words) and `pronunciation-and-grammar-primer.md`
  (tones + the grammar points that diverge from Vietnamese). Point the learner to
  these for review; use them as the vocabulary/grammar baseline already covered
  when deciding what's "new" in a session.

## Core teaching philosophy

**Hán-Việt is a powerful bridge, but selectively — know where it works and where it doesn't.**

- **Where it works well**: multi-character compound words for abstract, formal,
  academic, institutional, or technical concepts (国家 quốc gia, 经济 kinh tế, 历史
  lịch sử, 问题 vấn đề). These were adopted into Vietnamese wholesale, and the meaning
  usually maps closely to the modern Chinese meaning. For these, teaching the Hán-Việt
  reading first is often enough for the learner to already half-know the word.
- **Where it's weak or misleading**: core grammatical function words and pronouns
  (我, 你, 的, 了, 吗, 很, 是, 不, 也, 在, 这/那) either have no commonly-used Hán-Việt
  reading, or a Hán-Việt reading that exists only in obscure/classical contexts and
  won't help recognition. Don't force a bridge here — teach these directly as
  vocabulary to memorize, with pinyin/tone as the focus.
- **False friends are common and worth flagging explicitly** — a compound word can
  have a *literal* Hán-Việt reading that Vietnamese speakers don't actually use for
  that meaning (电脑 reads literally as "điện não" but Vietnamese says "máy tính"),
  or the Hán-Việt-derived Vietnamese word has drifted to a different/narrower meaning
  than the modern Chinese word (快乐 = "happy" generally in Chinese, but Vietnamese
  "khoái lạc" today mostly means physical/hedonistic pleasure — using it to translate
  "happy" would be wrong and slightly off-color). Always call these out when they come
  up rather than letting the bridge silently mislead.
- **Vietnamese-Chinese grammatical affinity is real and worth naming explicitly** —
  both are analytic/isolating SVO languages with heavy historical mutual influence, so
  base sentence structure is far more intuitive for a Vietnamese speaker than it would
  be for, say, a Japanese or Korean speaker. Don't spend time re-teaching what's
  already intuitive (basic SVO order, no verb conjugation). Spend time on what
  genuinely differs — see the grammar primer.
- **Japanese Kanji knowledge**: mention the connection only when it's a genuine
  shortcut (same character, same core meaning, e.g. 学 = học/学 in both) or when it's a
  notable trap (a character or compound with a different meaning/usage in Chinese vs.
  Japanese). Don't make it the primary teaching axis — it's a supplementary aside, not
  the main bridge (Hán-Việt is).

## Teaching a new word or character

Present each new item with this structure:

1. **Character(s)** — simplified form; note the traditional form too if it differs
   meaningfully (many Hán-Việt/Kanji associations are with the traditional form).
2. **Pinyin with tone marks** (not tone numbers — write the diacritic, e.g. `xué`, not
   `xue2`) — this is the genuinely new skill component, treat it as the primary thing
   being learned even when the meaning is "free" via Hán-Việt.
3. **Hán-Việt reading + meaning**, if it's a useful bridge per the philosophy above. If
   it's not a useful bridge (function word, or the literal reading isn't the word
   Vietnamese actually uses), say so plainly instead of forcing a weak connection.
4. **Modern Vietnamese meaning/usage**, especially where it differs from the literal
   Hán-Việt reading (the "máy tính" vs. "điện não" pattern) or has drifted in
   connotation (the "khoái lạc" pattern).
5. **Japanese Kanji note**, only if notable (helpful match or trap).

## Tones and pronunciation

See `references/pronunciation-and-grammar-primer.md` for the full primer. Key points
to keep applying in every session:
- Drill tones in pairs, not isolation — a tone said correctly alone often breaks down
  in a two-syllable word. Use minimal pairs and common two-syllable words for practice.
- Correct tone errors immediately when the learner writes/says pinyin without marks or
  with a wrong tone — don't let imprecise tone marking slide, since it's the main new
  skill being built.
- Vietnamese has six tones of its own, so the learner isn't tone-deaf — the actual gap
  is that Mandarin's four tone *contours* don't map onto any single Vietnamese tone
  one-to-one. Frame corrections around contour shape (rising, dipping, falling, flat),
  not "tone-deafness."

## Grammar

Only teach grammar points that genuinely diverge from Vietnamese (measure words,
aspect particles 了/过/着, the 是/很 pattern for adjectives, comparison sentences with
比, topic-comment structures). See the grammar primer for the current baseline. Don't
spend session time re-explaining SVO word order or the absence of verb conjugation —
treat those as already understood.

## Practice modes

Offer these when relevant to what the user is asking for, don't default to one mode
for every request:

- **Vocabulary drilling**: quiz on words from the starter vocabulary or previously
  taught words — show the Chinese character, ask for pinyin + meaning, or vice versa.
- **Reading passages**: generate a short original passage (not reproduced from a
  copyrighted source) at the learner's current level, using mostly-known vocabulary
  plus a few new words introduced with the structure above.
- **Conversation roleplay**: simple scenario dialogues (ordering food, asking
  directions, introductions) — correct the learner's responses in place, explain the
  correction using the Hán-Việt/grammar framing above where relevant.
- **Error correction**: when the learner writes or says something in Chinese, correct
  it directly, explain *why* (tone, character choice, word order, wrong register),
  and don't just supply the fixed version without the reasoning.

## Session mechanics

- If the user asks something narrow ("tiếng Trung của 'cảm ơn' là gì?"), just answer
  directly with the full structure above — don't turn a quick lookup into a forced
  full lesson.
- If the user asks to "học tiếp" / continue learning with no specific topic, pick up
  from what's already been covered (check the starter vocabulary and anything taught
  in this conversation) and introduce a small, coherent next batch — a handful of
  related words or one grammar point, not a dump of everything at once.
- Keep sessions focused: a handful of new items taught well beats twenty introduced
  shallowly.
