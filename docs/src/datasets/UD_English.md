
# UD English

The [UD_English](https://github.com/UniversalDependencies/UD_English-EWT)
Universal Dependencies English Web Treebank dataset is an annotated corpus of morphological features,
POS-tags and syntactic trees. The dataset follows CoNLL-style format.

```julia
traindata = UD_English.traindata()
devdata = UD_English.devdata()
testdata = UD_English.devdata()
```

## Data Size

|    | Train x | Train y | Test x | Test y |
|:--:|:-------:|:-------:|:------:|:------:|
| **UD_English** | 12543 | - | 2077 | - |
