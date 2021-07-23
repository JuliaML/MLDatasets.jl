# PTBLM

The `PTBLM` dataset consists of Penn Treebank sentences for
language modeling, available from
[tomsercu/lstm](https://github.com/tomsercu/lstm). The unknown
words are replaced with `<unk>` so that the total vocabulary size
becomes 10000.

This is the first sentence of the PTBLM dataset.

```julia
x, y = PTBLM.traindata()

x[1]
> ["no", "it", "was", "n't", "black", "monday"]
y[1]
> ["it", "was", "n't", "black", "monday", "<eos>"]
```

where `MLDataset` adds the special word: `<eos>` to the end of `y`.
