Class {
	#name : #TestValueObject,
	#superclass : #ValueObject,
	#instVars : [
		'name',
		'datumInDienst',
		'datumUitDienst',
		'year'
	],
	#category : #'ValueObject-Helper'
}

{ #category : #'instance creation' }
TestValueObject class >> newName: arg1 datumInDienst: arg2 datumUitDienst: arg3 year: arg4 [ 

	^ self new initName: arg1
			datumInDienst: arg2
			datumUitDienst: arg3
			year: arg4
			
]

{ #category : #accessing }
TestValueObject >> datumInDienst [
	^ datumInDienst
]

{ #category : #accessing }
TestValueObject >> datumUitDienst [
	^ datumUitDienst
]

{ #category : #initialization }
TestValueObject >> initName: arg1 datumInDienst: arg2 datumUitDienst: arg3 year: arg4 [ 

	name := arg1.
	datumInDienst := arg2.
	datumUitDienst := arg3.
	year := arg4.
]

{ #category : #accessing }
TestValueObject >> name [
	^ name
]

{ #category : #accessing }
TestValueObject >> year [
	^ year
]
