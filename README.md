This repo is phoneme lexicon build from G2P method of paper: 

**Tonal phoneme based model for Vietnamese LVCSR**

Algorithm   that   is   first known  as  a  grapheme-to-phoneme  method  to  transform  any Vietnamese  word  to  a  tonal  phoneme-based  pronunciation.  The tonal  phoneme  set  produced  by  this  algorithm  is  further  used  to develop some acoustic  models  which integrated tone information and   tonal   feature.   The   processes   using   the   Kaldi   toolkit   to develop a LVCSR system and extract a bottleneck feature which is calculated from a trained deep neural network for Vietnamese are  also  presented.

https://www.researchgate.net/publication/308853263_Tonal_phoneme_based_model_for_Vietnamese_LVCSR


Check out the lexicon that generated from Vietnamese syllables at: **Kaldiphon.txt**

### To create new lexicon from your dictionary

```sudo apt install tcl```

```tclsh makeVietnameseDict.tcl input.txt```