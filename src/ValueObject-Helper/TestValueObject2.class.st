Class {
	#name : #TestValueObject2,
	#superclass : #Object,
	#instVars : [
		'var1'
	],
	#category : #'ValueObject-Helper'
}

{ #category : #testing }
TestValueObject2 class >> isValueObjectClass [
	^ true
]

{ #category : #'instance creation' }
TestValueObject2 class >> newVar1: arg1 [ 

	^ self new initVar1: arg1 
]

{ #category : #comparing }
TestValueObject2 >> = anObject [
	"Answer whether the receiver and anObject represent the same object."

	self == anObject
		ifTrue: [ ^ true ].
	self class = anObject class
		ifFalse: [ ^ false ].
	^ var1 = anObject var11
]

{ #category : #comparing }
TestValueObject2 >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ var1 hash
]

{ #category : #initialization }
TestValueObject2 >> initVar1: arg1 [ 

	var1 := arg1.
]

{ #category : #accessing }
TestValueObject2 >> var1 [
	^ var1
]

{ #category : #accessing }
TestValueObject2 >> var11 [
	^ var1
]
