Class {
	#name : #SkSharedObject,
	#superclass : #Object,
	#instVars : [
		'privateCounter',
		'sharedCounter'
	],
	#classVars : [
		'Counter'
	],
	#category : #'Seeker-Benchmark'
}

{ #category : #accessing }
SkSharedObject class >> reset [
	<script>
	Counter := nil.
	self sharedCounter
]

{ #category : #accessing }
SkSharedObject class >> sharedCounter [

	^ Counter ifNil: [ Counter := self new ]
]

{ #category : #initialization }
SkSharedObject >> initialize [

	privateCounter := 0.
	sharedCounter := 0
]

{ #category : #initialization }
SkSharedObject >> privateCount [

	privateCounter := privateCounter + 1
]

{ #category : #accessing }
SkSharedObject >> privateCounter [

	^ privateCounter
]

{ #category : #initialization }
SkSharedObject >> sharedCount [

	sharedCounter := sharedCounter + 1
]

{ #category : #accessing }
SkSharedObject >> sharedCounter [

	^ sharedCounter
]

{ #category : #accessing }
SkSharedObject >> sharedCounter: anObject [

	sharedCounter := anObject
]
