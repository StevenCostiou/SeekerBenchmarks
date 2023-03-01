Class {
	#name : #SkBenchmark,
	#superclass : #Object,
	#instVars : [
		'testResults',
		'executedTests'
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

	(testClasses flattened copyFrom: 123 to: testClasses flattened size) do: [ :testMethod |
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

{ #category : #'as yet unclassified' }
SkBenchmark >> outputFileStream [

	^ 'bmark' asFileReference
		  ensureCreateFile;
		  yourself
]

{ #category : #instrumentation }
SkBenchmark >> testMethodsAndClasses [

	^ self testPackages flatCollect: [ :p |
		  (p classes collect: [
			   :c | c -> (c methods select: [ :m | m isTestMethod ]) ])
			  asDictionary ]
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
