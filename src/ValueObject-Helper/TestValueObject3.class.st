Class {
	#name : #TestValueObject3,
	#superclass : #TestValueObject2,
	#category : #'ValueObject-Helper'
}

{ #category : #'instance creation' }
TestValueObject3 class >> newVar1: arg1 [ 

	^ self new initVar1: arg1 
]

{ #category : #comparing }
TestValueObject3 >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ var1 = anObject var1
]

{ #category : #comparing }
TestValueObject3 >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ var1 hash
]

{ #category : #initialization }
TestValueObject3 >> initVar1: arg1 [ 

]

{ #category : #printing }
TestValueObject3 >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' var1: ';
		print: var1.
	aStream
		nextPutAll: ' varX: ';
		print: varX.
	aStream
		nextPutAll: ' varY: ';
		print: varY.
	aStream
		nextPutAll: ' varZ: ';
		print: varZ.
	aStream
		nextPutAll: ' varK: ';
		print: varK.
	aStream
		nextPutAll: ' varM: ';
		print: varM.
	aStream
		nextPutAll: ' varL: ';
		print: varL
]

{ #category : #accessing }
TestValueObject3 >> var1 [
	^ var1
]
