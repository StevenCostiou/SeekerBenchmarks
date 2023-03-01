"
Please describe the package using the class comment of the included manifest class. The manifest class also includes other additional metadata for the package. These meta data are used by other tools such as the SmalllintManifestChecker and the critics Browser
"
Class {
	#name : #ManifestSeekerBenchmark,
	#superclass : #PackageManifest,
	#category : #'Seeker-Benchmark-Manifest'
}

{ #category : #'code-critics' }
ManifestSeekerBenchmark class >> ruleCodeCruftLeftInMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGClassDefinition #(#SkBenchmark)) #'2023-02-28T11:05:20.046698+01:00') )
]

{ #category : #'code-critics' }
ManifestSeekerBenchmark class >> ruleCollectionProtocolRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#SkBenchmark #benchForORUR #false)) #'2023-02-28T07:45:34.195411+01:00') #(#(#RGClassDefinition #(#SkBenchmark)) #'2023-02-28T11:05:21.887768+01:00') )
]

{ #category : #'code-critics' }
ManifestSeekerBenchmark class >> ruleLongMethodsRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#SkBenchmark #benchForORUR #false)) #'2023-02-28T07:45:29.345727+01:00') #(#(#RGClassDefinition #(#SkBenchmark)) #'2023-02-28T11:05:17.608976+01:00') )
]

{ #category : #'code-critics' }
ManifestSeekerBenchmark class >> ruleReCompactSourceCodeRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#SkBenchmark #benchForORUR #false)) #'2023-02-28T07:45:32.052994+01:00') #(#(#RGClassDefinition #(#SkBenchmark)) #'2023-02-28T11:05:14.9678+01:00') )
]

{ #category : #'code-critics' }
ManifestSeekerBenchmark class >> ruleTempsReadBeforeWrittenRuleV1FalsePositive [

	<ignoreForCoverage>
	^ #(#(#(#RGMethodDefinition #(#SkBenchmark #benchBruteForceReversal #false)) #'2023-02-28T21:20:49.237487+01:00') )
]
