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
This code installs the time-traveling debugger and the mutation framework used for the benchmarks.
It also removes the problematics tests, as stated in the detailes below.

## SeekerBenchmarks

Every benchmark writes its results in a csv file named *bench* in the image directory.
Each run appends to the previous file, so be careful to remove the old file before generating new results.
When a test is successfully ran, the last logged entry is the benchark method name (this is a random choice).
If the test under time-travel fails for any reason, an exception is logged instead.

```Smalltalk 
"The benchmark is time-consuming. The following might take around 20 minutes to complete"
"Bench to check for UR and OR effects"
SkBenchmark new benchForORUR.

"Bench for ensuring time-traveling troughout executions produce the same results"
"This benchmark takes more time. It has been divided in bundles, so the user can execute smaller amounts of tests"
"To generate all the results, execute all these calls:"
SkBenchmark new benchBruteForceReversal:1.
SkBenchmark new benchBruteForceReversal:2.
SkBenchmark new benchBruteForceReversal:3.
SkBenchmark new benchBruteForceReversal:4.
SkBenchmark new benchBruteForceReversal:5.

"Bench with mutants introducing mutations"
"this is the fastest benchmark and it is finished in around 10 mins"
SkBenchmark new benchBruteForceReversalWithMutants.

The generated data is written to the file 'bmark' in the same image folder.

"Get the test methods"
SkBenchmark new testMethodsAndClasses flattened.
```

The following test methods must be removed because they use reflective code of the kernel and Seeker is unable (yet) to handle time-travel on executions manipulating objects from there (such as meta classes):
```Smalltalk 
STONReaderTest>>testClassWithUnderscore.
STONWriterTest>>testSpecialClassNames.
```
## Reproducing the benchmark's results

1. Download and run Pharo 11 https://pharo.org/
2. Install the set up baseline. The baseline will automatically:  
   a. Install Seeker https://github.com/maxwills/SeekerDebugger  
   b. Install the mutation framework https://github.com/pharo-contributions/mutalk/  
   c. Install the benchmarks https://github.com/StevenCostiou/SeekerBenchmarks  
   d. Remove the problematic tests  
3. Run the code above
