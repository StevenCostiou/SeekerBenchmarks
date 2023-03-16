Class {
	#name : #BaselineOfSeekerBenchmarks,
	#superclass : #BaselineOf,
	#category : #BaselineOfSeekerBenchmarks
}

{ #category : #actions }
BaselineOfSeekerBenchmarks >> preload: loader package: packageSpec [
	"Install test mutation framework"

	Metacello new
		baseline: 'MuTalk';
		repository: 'github://pharo-contributions/mutalk/src';
		load.
	"Install SeekerDebugger"
	Metacello new
		baseline: 'Seeker';
		repository: 'github://maxwills/SeekerDebugger:main';
		load.
	"remove problematic tests"
	[ (STONReaderTest >> #testClassWithUnderscore) removeFromSystem ]
		onErrorDo: [ :e |
			Transcript
				show:
					'STONReaderTest >> #testClassWithUnderscore method not found';
				cr ].
	[ (STONWriteReadTest >> #testSpecialClassNames) removeFromSystem ]
		onErrorDo: [ :e |
			Transcript
				show:
					'STONWriteReadTest >> #testSpecialClassNames method not found';
				cr ]
]
