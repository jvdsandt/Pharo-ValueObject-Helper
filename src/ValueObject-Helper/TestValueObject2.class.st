Class {
	#name : #TestValueObject2,
	#superclass : #Object,
	#instVars : [
		'var1',
		'var2',
		'varX',
		'varZ'
	],
	#classVars : [
		'cvar1'
	],
	#category : #'ValueObject-Helper'
}

{ #category : #testing }
TestValueObject2 class >> isValueObjectClass [
	^ true
]

{ #category : #'instance creation' }
TestValueObject2 class >> newVar1: arg1 var2: arg2 varX: arg3 varZ: arg4 [ 

	^ self new initVar1: arg1
			var2: arg2
			varX: arg3
			varZ: arg4
			
]

{ #category : #initialization }
TestValueObject2 >> initVar1: arg1 var2: arg2 varX: arg3 varZ: arg4 [ 

	var1 := arg1.
	var2 := arg2.
	varX := arg3.
	varZ := arg4.
]

{ #category : #accessing }
TestValueObject2 >> var1 [
	^ var1
]

{ #category : #accessing }
TestValueObject2 >> var2 [
	^ var2
]

{ #category : #accessing }
TestValueObject2 >> varX [
	^ varX
]

{ #category : #accessing }
TestValueObject2 >> varZ [
	^ varZ
]
