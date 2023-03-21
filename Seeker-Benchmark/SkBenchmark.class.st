Class {
	#name : #SkBenchmark,
	#superclass : #Object,
	#instVars : [
		'testResults',
		'executedTests',
		'mutants'
	],
	#classVars : [
		'Counter'
	],
	#category : #'Seeker-Benchmark'
}

{ #category : #instrumentation }
SkBenchmark >> b9ytecodesToTimeTravelFrom: start to: max [

	| step bytecodes |
	step := (max / 10) rounded.
	bytecodes := OrderedCollection new.
	bytecodes add:
		(self nextBytecodeToTimeTravelFrom: start to: max by: step).
	10 timesRepeat: [
		bytecodes add:
			(self nextBytecodeToTimeTravelFrom: bytecodes last to: max by: step) ].
	^ bytecodes
]

{ #category : #benchmarking }
SkBenchmark >> bench [

		| testClasses test tcu tracer privateCounter endContext|
	self instrumentTestMethods.
	testResults := Dictionary new.
	executedTests := OrderedCollection new.
	testClasses := self testMethodsAndClasses.
	privateCounter := 0.
	SkSharedObject reset.
	
	testClasses flattened do: [ :testMethod |
			test := testMethod methodClass new.
			test setTestSelector: testMethod selector.
			test setUp.
			executedTests add: testMethod.
			
			tcu := SeekerDebugger headlessDebugBlock: [ test runCase ].
			
			tracer := tcu tracer.
			"[ tracer currentContext selector = #performTest ] whileFalse:[tracer step]."
		
			tracer stepToEnd.

			endContext := tcu tracer currentContext.
			testResults
				at: tracer executedBytecode
				put: endContext method method name.

			1 to: tracer executedBytecode by: 500 do: [ :i |
				
				tracer timeTravelToBytecodeIndex: i.
				tracer stepToEnd.
				testResults at: i put: endContext method method name ] ].

	self inspect
]

{ #category : #benchmarking }
SkBenchmark >> benchBruteForceReversal [

	| output testClasses test tcu tracer privateCounter testStartingBytecode endContext bytecodes |
	testClasses := self testMethodsAndClasses.
	privateCounter := 0.

	testClasses flattened do: [ :testMethod |
		output := self outputFileStream writeStream.
		output << self outputFileStream readStream contents.
		output cr.

		test := testMethod methodClass new.
		test timeLimit: 50 years.
		test setTestSelector: testMethod selector.
		test setUp.

		tcu := SeekerDebugger headlessDebugBlock: [ test runCase ].
		tracer := tcu tracer.

		[ tracer currentContext selector = #performTest ] whileFalse: [
			tracer step ].
		testStartingBytecode := tracer executedBytecode.
		tracer stepToEnd.

		privateCounter := privateCounter + 1.

		bytecodes := self
			             bytecodesToTimeTravelFrom: testStartingBytecode
			             to: tracer executedBytecode.

		bytecodes do: [ :i |
			tracer timeTravelToBytecodeIndex: i.
			tracer stepToEnd.
			endContext := tcu tracer currentContext.

			output << privateCounter printString.
			output << $;.
			output << testMethod printString.
			output << $;.
			output << 'bytecode'.
			output space.
			output << i printString.
			output << $;.
			output << endContext method method name.
			output cr ].
		output close ]
]

{ #category : #benchmarking }
SkBenchmark >> benchBruteForceReversal: bundleIndex [

	| output testClasses test tcu tracer privateCounter testStartingBytecode endContext bytecodes fromTo |
	fromTo := {  { 1. 60 }.
		          { 61. 77 }.
		          { 78. 114 }.{ 115. 120 }.
		          { 121. self testMethodsAndClasses size } } at: bundleIndex.
	testClasses := self testMethodsAndClasses.
	privateCounter := 0.

	(testClasses flattened copyFrom: fromTo first to: fromTo second) do: [
		:testMethod |
		output := self outputFileStream writeStream.
		output << self outputFileStream readStream contents.
		output cr.

		test := testMethod methodClass new.
		test timeLimit: 50 years.
		test setTestSelector: testMethod selector.
		test setUp.

		tcu := SeekerDebugger headlessDebugBlock: [ test runCase ].
		tracer := tcu tracer.

		[ tracer currentContext selector = #performTest ] whileFalse: [
			tracer step ].
		testStartingBytecode := tracer executedBytecode.
		tracer stepToEnd.

		privateCounter := privateCounter + 1.

		bytecodes := self
			             bytecodesToTimeTravelFrom: testStartingBytecode
			             to: tracer executedBytecode.

		bytecodes do: [ :i |
			tracer timeTravelToBytecodeIndex: i.
			tracer stepToEnd.
			endContext := tcu tracer currentContext.

			output << privateCounter printString.
			output << $;.
			output << testMethod printString.
			output << $;.
			output << 'bytecode'.
			output space.
			output << i printString.
			output << $;.
			output << endContext method method name.
			output cr ].
		output close ]
]

{ #category : #benchmarking }
SkBenchmark >> benchBruteForceReversalForMutants [

	| output testClasses test tcu tracer privateCounter testStartingBytecode endContext bytecodes |
	testClasses := self testMethodsAndClasses.
	privateCounter := 0.

	(testClasses flattened copyFrom: 1 to: 53) do: [ :testMethod |
		output := self outputFileStream writeStream.
		output << self outputFileStream readStream contents.
		output cr.

		test := testMethod methodClass new.
		test timeLimit: 50 years.
		test setTestSelector: testMethod selector.
		test setUp.

		tcu := SeekerDebugger headlessDebugBlock: [ test runCase ].
		tracer := tcu tracer.

		[ tracer currentContext selector = #performTest ] whileFalse: [
			tracer step ].
		testStartingBytecode := tracer executedBytecode.
		tracer stepToEnd.

		privateCounter := privateCounter + 1.

		bytecodes := self
			             bytecodesToTimeTravelFrom: testStartingBytecode
			             to: tracer executedBytecode.

		bytecodes do: [ :i |
			tracer timeTravelToBytecodeIndex: i.
			tracer stepToEnd.
			endContext := tcu tracer currentContext.

			output << privateCounter printString.
			output << $;.
			output << testMethod printString.
			output << $;.
			output << 'bytecode'.
			output space.
			output << i printString.
			output << $;.
			output << endContext receiver printString.
			output cr ].
		output close ]
]

{ #category : #benchmarking }
SkBenchmark >> benchBruteForceReversalMethodRevert [

	| output testClasses test tcu tracer privateCounter testStartingBytecode bytecodes result |
	testClasses := self testMethodsAndClasses.
	privateCounter := 0.

	(testClasses flattened withIndexSelect: [ :e :i |
		 (#( testToString testSTON testEmpty testError testDictionaryWithIndirectReferenceKeys testIllegalCharacterEscapes testWideSymbol ) includes: e selector) not ]) do: [ :testMethod |
		output := self outputFileStream writeStream.
		output setToEnd.
		output
			cr;
			cr.

		test := testMethod methodClass new.
		test timeLimit: 50 years.
		test setTestSelector: testMethod selector.
		test setUp.

		tcu := SeekerDebugger headlessDebugBlock: [ test runCase ].
		tracer := tcu tracer.

		[ tracer currentContext selector = #performTest ] whileFalse: [
			tracer step ].
		testStartingBytecode := tracer executedBytecode.
		tracer stepToEnd.

		privateCounter := privateCounter + 1.

		"Execute once with seeker to get the bytecodes to step to and the contexts"
		bytecodes := self
			             bytecodesToTimeTravelFrom: testStartingBytecode
			             to: tracer executedBytecode.

		bytecodes do: [ :i |
			| targetToComplete sentinelProcess processToRestart |
			Stdio stdout nextPutAll: test asString; nextPutAll: ' '; nextPutAll: i asString; crlf.
			
			Stdio stdout nextPutAll: 'Seeker is travelling...'; crlf.
			tcu := SeekerDebugger headlessDebugBlock: [ test runCase ].
			tracer := tcu tracer.
			tracer timeTravelToBytecodeIndex: i.
			
			Stdio stdout nextPutAll: 'Seeker traveled'; crlf.
			"Get a copy of the stack at the point of time travel"
			sentinelProcess := Process
				                   forContext:
				                   tracer debuggedProcess suspendedContext
					                   copyStack
				                   priority: 41.
			processToRestart := Process
				                    forContext:
				                    tracer debuggedProcess suspendedContext
					                    copyStack
				                    priority: 41.

			Stdio stdout nextPutAll: 'Sentinel is travelling ...'; crlf.
			[ "Run sentinel until #runCase or error to make it change state"
			targetToComplete := sentinelProcess suspendedContext bottomContext.
			[ targetToComplete selector ~= #runCase ] whileTrue: [
				targetToComplete := sentinelProcess calleeOf: targetToComplete ].
			Processor activeProcess
				evaluate: [
					sentinelProcess suspendedContext runUntilErrorOrReturnFrom:
						targetToComplete ]
				onBehalfOf: sentinelProcess.

			Stdio stdout nextPutAll: 'Sentinel arrived.'; crlf; nextPutAll: 'Voyager is travelling ...'; crlf.
			"Restart process that will be witness of the previous side effects, and execute it until the end"
			processToRestart restartTop.
			targetToComplete := processToRestart suspendedContext bottomContext.
			[ targetToComplete selector ~= #runCase ] whileTrue: [
				targetToComplete := processToRestart calleeOf: targetToComplete ].
			result := Processor activeProcess
				          evaluate: [
					          processToRestart suspendedContext
						          runUntilErrorOrReturnFrom: targetToComplete ]
				          onBehalfOf: processToRestart.

			Stdio stdout nextPutAll: 'Voyager arrived.'; crlf.
			
			output << privateCounter printString.
			output << $;.
			output << testMethod printString.
			output << $;.
			output << 'bytecode'.
			output space.
			output << i printString.
			output << $;.
			output << processToRestart suspendedContext method method name.
			output << $;.
			output << result printString.
			output flush ]
				on: Error
				do: [ :error |
					output << privateCounter printString.
					output << $;.
					output << testMethod printString.
					output << $;.
					output << 'bytecode'.
					output space.
					output << i printString.
					output << $;.
					output << 'BENCHMARK ERROR: '.
					output << error asString.
					output flush ] ].
		output close ]
]

{ #category : #benchmarking }
SkBenchmark >> benchBruteForceReversalWithMutants [
	self generateMutants.
	mutants do: #install.
	self benchBruteForceReversalForMutants.
	mutants do: #uninstall
]

{ #category : #benchmarking }
SkBenchmark >> benchForORUR [

	| output testClasses test tcu tracer privateCounter sharedCounter testStartingBytecode endContext assertionsPassed|
	
	self instrumentTestMethods.
	testResults := Dictionary new.
	executedTests := OrderedCollection new.
	testClasses := self testMethodsAndClasses.
	privateCounter := 0.
	SkSharedObject reset.
	
	testClasses flattened do: [ :testMethod |
			output := self outputFileStream writeStream.
			output << self outputFileStream readStream contents.
			output cr.
			assertionsPassed := true.
		
			test := testMethod methodClass new.
			test timeLimit: 50 years.
			test setTestSelector: testMethod selector.
			test setUp.
			executedTests add: testMethod.			
			
			tcu := SeekerDebugger headlessDebugBlock: [ test runCase ].
			tracer := tcu tracer.
			
			[ tracer currentContext selector = #performTest ] whileFalse:[tracer step].
			testStartingBytecode := tracer executedBytecode.
			
			[ 		
			self assert: SkSharedObject sharedCounter privateCounter = privateCounter.
			self assert: SkSharedObject sharedCounter sharedCounter = 0.
			] on: Error do: [ assertionsPassed := false ].			
			tracer stepToEnd.
			
			privateCounter := privateCounter + 1.
			SkSharedObject sharedCounter privateCount.
			sharedCounter := SkSharedObject sharedCounter sharedCounter.
			
			[ 
			self assert: tracer executedBytecode > testStartingBytecode.
			self assert: SkSharedObject sharedCounter privateCounter = privateCounter.
			self assert: sharedCounter > 0.
			] on: Error do: [ assertionsPassed := false ].

			tracer timeTravelToBytecodeIndex: testStartingBytecode.
				
			[ 
			self assert: tracer executedBytecode = testStartingBytecode.
			self assert: SkSharedObject sharedCounter privateCounter = privateCounter.
			self assert: SkSharedObject sharedCounter sharedCounter = 0.
			] on: Error do: [ assertionsPassed := false ].
		
			tracer stepToEnd.
		
			[ 	
			self assert: SkSharedObject sharedCounter privateCounter = privateCounter.
			self assert: SkSharedObject sharedCounter sharedCounter = sharedCounter.
			] on: Error do: [ assertionsPassed := false ].
		
			SkSharedObject sharedCounter sharedCounter: 0.			
			endContext := tcu tracer currentContext.
			
			output << privateCounter printString.
			output << $;.
			output << testMethod printString.
			output << $;.
			output << assertionsPassed printString.
			output << $;.
			output << tracer executedBytecode printString.
			output << $;.
			output << endContext method method name.		
			output close.
			
			testResults
				at: tracer executedBytecode
				put: endContext method method name.
			
			
			]
]

{ #category : #benchmarking }
SkBenchmark >> benchUnder [

	| testClasses test tcu tracer endContext ctx ctx2 p|
	self instrumentTestMethods.
	testResults := Dictionary new.
	testClasses := self testMethodsAndClasses.
	testClasses keysAndValuesDo: [ :class :testMethods |
		test := testMethods first methodClass new.
		test setTestSelector: testMethods first selector.
		test setUp.
		ctx := 
		[ test runCase ] asContext.
	p := Process forContext: ctx priority: 10.

		100 timesRepeat: [ p step ].
			self halt.
	

		tcu := SeekerDebugger headlessDebugBlock: [ test runCase ].
		tracer := tcu tracer.
		tracer stepToEnd.

		endContext := tcu tracer currentContext.
		self halt.
		
		testResults
			at: tracer executedBytecode
			put: endContext method method name.

		1 to: tracer executedBytecode do: [ :i |
			tracer timeTravelToBytecodeIndex: i.
			tracer stepToEnd.
			testResults at: i put: endContext method method name ].
		^self inspect].

	self inspect
]

{ #category : #instrumentation }
SkBenchmark >> bytecodesToTimeTravelFrom: start to: max [

	| step bytecodes lastBytecode |
	step := (max / 12) rounded.
	bytecodes := OrderedCollection new.
	lastBytecode := start.
	10 timesRepeat: [
		lastBytecode := lastBytecode + step.
		bytecodes add: lastBytecode ].
	^ bytecodes
]

{ #category : #instrumentation }
SkBenchmark >> generateMutants [

	| classesToMutate analysis |
	classesToMutate := 'STON-Core' asPackage definedClasses.
	analysis := MutationTestingAnalysis
		            testCasesFrom: {  }
		            mutating: classesToMutate
		            using: MutantOperator contents
		            with: AllTestsMethodsRunningMutantEvaluationStrategy new.

	mutants := (analysis generateMutations mutations groupedBy:
		            #originalMethod) collect: [ :e | e atRandom ]
]

{ #category : #instrumentation }
SkBenchmark >> instrumentTestMethods [

	self testMethodsAndClasses keysAndValuesDo: [ :class :methods |
		methods do: [ :method |
			| firstStatementAST |
			firstStatementAST := method ast statements first.
			firstStatementAST sourceCode
			= 'SkSharedObject sharedCounter sharedCount' ifFalse: [
				| newSrcStr |
				newSrcStr := WriteStream on: String new.
				newSrcStr << (method sourceCode
					 copyFrom: 1
					 to: firstStatementAST start - 1).
				newSrcStr space.
				newSrcStr << 'SkSharedObject sharedCounter sharedCount.'.
				newSrcStr cr.
				newSrcStr << (method sourceCode
					 copyFrom: firstStatementAST start
					 to: method sourceCode size).
				class compile: newSrcStr contents ] ] ]
]

{ #category : #instrumentation }
SkBenchmark >> nextBytecodeToTimeTravelFrom: start to: max by: step [

	^ start + step min: max
]

{ #category : #'as"yet"unclassified' }
SkBenchmark >> outputFileStream [

	^ 'bmark' asFileReference
		  ensureCreateFile;
		  yourself
]

{ #category : #instrumentation }
SkBenchmark >> testMethodsAndClasses [

	| classesAndMethods |
	classesAndMethods := Dictionary new.
	((self testPackages flatCollect: [ :p |
		  (p classes collect: [ :c |
			   c -> (c methods select: [ :m | m isTestMethod ]) ]) asDictionary ])
		 select: [ :a | a isNotEmpty ]) do: [ :a |
		classesAndMethods at: a first methodClass put: a ].
	^ classesAndMethods
]

{ #category : #instrumentation }
SkBenchmark >> testPackages [

	^ self testPackagesNames collect: [ :pName |
		  RPackageOrganizer default packageNamed: pName ]
]

{ #category : #instrumentation }
SkBenchmark >> testPackagesNames [

	^ { #'STON-Tests'
	  
	
	  }
	"DONE
	 #'ProfStef-Tests'. #'NumericInterpolator-Tests'.
	"
	"#'STON-Tests'."
	" #'Roassal3-Shapes-Tests'."
	" #'Rubric-Tests'. "
]
