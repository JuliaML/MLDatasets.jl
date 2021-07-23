# EMNIST

[**EMNIST**](https://www.nist.gov/itl/products-and-services/emnist-dataset) packages 6 different extensions of the MNIST dataset involving letters and digits and variety of test train split options. Each extension has the standard test/train data/labels nested under it as shown below.

```julia
using MLDatasets: EMNIST

traindata = EMNIST.Balanced.traindata()
testdata = EMNIST.Balanced.testdata()
trainlabels = EMNIST.Balanced.trainlabels()
testlabels = EMNIST.Balanced.testlabels()
```

Dataset | Classes | `traindata` | `trainlabels` | `testdata` | `testlabels` | `balanced classes`
:------:|:-------:|:-------------:|:-------------:|:------------:|:------------:|:------------:
**ByClass** | 62 | 697932x28x28 | 697932x1 | 116323x28x28 | 116323x1 | no
**ByMerge** | 47 | 697932x28x28 | 697932x1 | 116323x28x28 | 116323x1 | no
**Balanced** | 47 | 112800x28x28 | 112800x1 | 18800x28x28 | 18800x1 | yes
**Letters** | 26 | 124800x28x28 | 124800x1 | 20800x28x28 | 208000x1 | yes
**Digits** | 10 | 240000x28x28 | 240000x1 | 40000x28x28 | 40000x1 | yes
**MNIST** | 10 | 60000x28x28 | 60000x1 | 10000x28x28 | 10000x1 | yes
