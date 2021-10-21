# Mutagenesis

The `Mutagenesis` dataset comprises 188 molecules trialed for mutagenicity on Salmonella typhimurium, available from
 [relational.fit.cvut.cz](https://relational.fit.cvut.cz/dataset/Mutagenesis) and
 [CTUAvastLab/datasets](https://github.com/CTUAvastLab/datasets/tree/main/mutagenesis). 

Train, test and validation data can be loaded using:
```julia
train_x, train_y = Mutagenesis.traindata()
test_x, test_y = Mutagenesis.testdata()
val_x, val_y = Mutagenesis.valdata()
```

```@docs
Mutagenesis
```
