# SeekerBenchmarks

Every benchmark writes its results in a csv file named *bench* in the image directory.
Each run appends to the previous file, so be careful to remove the old file before generating new results.

```Smalltalk 
"Bench to check for UR and OR effects"
SkBenchmark new benchForORUR.

"Bench for ensuring time-traveling troughout executions produce the same results"
SkBenchmark new benchBruteForceReversal.
```

TODO: bench with mutants
