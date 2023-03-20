The following instructions detail how to install and run the benchmarks.
WARNING: PLEASE NOTE THAT PART OF THESE INSTRUCTIONS MIGHT CONTAIN INFORMATION BREAKING ANONYMITY.

## Set up the image

Execute the following in a new Pharo 11 64bit image.

```Smalltalk 
Metacello new
    baseline: 'SeekerBenchmarks';
    repository: 'github://StevenCostiou/SeekerBenchmarks:main';
    load.
```
This code install the time-traveling debugger and the mutation framework used for the benchmarks.

## SeekerBenchmarks

Every benchmark writes its results in a csv file named *bench* in the image directory.
Each run appends to the previous file, so be careful to remove the old file before generating new results.
When a test is successfully ran, the last logged entry is the benchark method name (this is a random choice).
If the test under time-travel fails for any reason, an exception is logged instead.

```Smalltalk 
"Bench to check for UR and OR effects"
SkBenchmark new benchForORUR.

"Bench for ensuring time-traveling troughout executions produce the same results"
SkBenchmark new benchBruteForceReversal.

"Bench with mutants introducing mutations"
SkBenchmark new benchBruteForceReversalWithMutants.

"Get the test methods"
SkBenchmark new testMethodsAndClasses flattened.
```

The following test methods must be removed because they use reflective code of the kernel and Seekr is unable (yet) to handle time-travel on executions manipulating objects from there (such as meta classes):
```Smalltalk 
STONReaderTest>>testClassWithUnderscore.
STONWriterTest>>testSpecialClassNames.
```
## Reproducing the benchmark's results

1 - Download and run Pharo 11 https://pharo.org/
2 - Install Seeker https://github.com/maxwills/SeekerDebugger
3 - Install the mutation framework https://github.com/pharo-contributions/mutalk/
4 - Install the benchmarks https://github.com/StevenCostiou/SeekerBenchmarks
5 - Run the code above
