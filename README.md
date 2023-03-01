# SeekerBenchmarks

Every benchmark writes its results in a csv file named *bench* in the image directory.
Each run appends to the previous file, so be careful to remove the old file before generating new results.
When a test is successfully ran, the last logged entry is the benchark method name (this is a random choice).
If the test under time-travel fails for any reason, an exception is logged instead.

```Smalltalk 
"Bench to check for UR and OR effects"
SkBenchmark new benchForORUR.

"Bench for ensuring time-traveling troughout executions produce the same results"
SkBenchmark new benchBruteForceReversal.

"Get the test methods"
SkBenchmark new testMethodsAndClasses flattened.
```

The following test methods must be removed because they use reflective code of the kernel and Seekr is unable (yet) to handle time-travel on executions manipulating objects from there (such as meta classes):
```Smalltalk 
STONReaderTest>>testClassWithUnderscore.
STONWriterTest>>testSpecialClassNames.
```

TODO: bench with mutants
