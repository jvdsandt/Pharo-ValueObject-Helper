Class {
	#name : #ValueObjectHelper,
	#superclass : #Object,
	#instVars : [
		'valueClass'
	],
	#category : #'ValueObject-Helper'
}

{ #category : #actions }
ValueObjectHelper class >> checkValueClass: aClass [

	^self new 
		valueClass: aClass;
		check
]

{ #category : #'system announcements' }
ValueObjectHelper class >> classModificationApplied: anAnnouncement [

	(self isValueObjectClass: anAnnouncement classAffected)
		ifTrue: [ self checkValueClass: anAnnouncement classAffected ].
]

{ #category : #testing }
ValueObjectHelper class >> isValueObjectClass: aClass [

	^aClass isMeta not and: [ 
		([ aClass isValueObjectClass ] on: MessageNotUnderstood do: [ :ex | ex return: false ]) and: [ 
			aClass superclass isNil or: [ 
				aClass superclass allInstVarNames isEmpty or: [ 
					self isValueObjectClass: aClass superclass ] ] ] ]
]

{ #category : #'announcement registration' }
ValueObjectHelper class >> registerToSystemAnnouncements [
						
	SystemAnnouncer uniqueInstance weak
		when: ClassModificationApplied send: #classModificationApplied: to: self
]

{ #category : #'announcement registration' }
ValueObjectHelper class >> unregisterToSystemAnnouncements [

	SystemAnnouncer uniqueInstance unsubscribe: self.
]

{ #category : #actions }
ValueObjectHelper >> check [

	self checkAccessors.
	self checkInitialization.
	self checkInstanceCreation.
	
	self installEqualHashMethods
]

{ #category : #'actions--private' }
ValueObjectHelper >> checkAccessor: aVarName [

	(self valueClass selectors includes: aVarName asSymbol)
		ifFalse: [ self installReader: aVarName ]
]

{ #category : #actions }
ValueObjectHelper >> checkAccessors [

	"Make sure there is a read accessor method for all instance variables"
	valueClass instVarNames do: [ :eachName |
		self checkAccessor: eachName ].
	
	"Remove accessor methods that reference variables that no longer exist."
	(valueClass methods select: [ :each | each protocol = 'accessing' ])
		do: [ :eachMethod |
			(self hasUndeclaredVariable: eachMethod)
				ifTrue: [ valueClass removeSelector: eachMethod selector ] ]
]

{ #category : #actions }
ValueObjectHelper >> checkInitialization [

	self installInitMethod.
	
	"Remove init methods that reference variables that no longer exist."
	(valueClass methods select: [ :each | each protocol = 'initialization' ])
		do: [ :eachMethod |
			(self hasUndeclaredVariable: eachMethod)
				ifTrue: [ valueClass removeSelector: eachMethod selector ] ]
]

{ #category : #actions }
ValueObjectHelper >> checkInstanceCreation [

	self installNewMethod.
	self removeObsoleteNewMethods.
]

{ #category : #testing }
ValueObjectHelper >> hasInstanceVariables [

	^valueClass allInstVarNames notEmpty
]

{ #category : #testing }
ValueObjectHelper >> hasUndeclaredVariable: aMethod [

	^ aMethod ast allChildren anySatisfy: [ :n | n isVariable and: [ n isUndeclared ] ]
]

{ #category : #'actions--private' }
ValueObjectHelper >> initArgumentNames [

	^valueClass allInstVarNames collect: [ :eachName |
		self variableAsArgumentName: eachName ]
]

{ #category : #'actions--private' }
ValueObjectHelper >> initSelector [

	^(String streamContents: [ :str |
		str nextPutAll: 'init'.
		valueClass allInstVarNames doWithIndex: [ :eachName :index |
			str
				nextPutAll: (index = 1 ifTrue: [ eachName capitalized ] ifFalse: [ eachName ]);
				nextPut: $: ] ]) asSymbol
]

{ #category : #'actions--private' }
ValueObjectHelper >> installEqualHashMethods [

	| r |	
		
	self hasInstanceVariables
		ifFalse: [ ^ self ].

	r := RBGenerateEqualHashRefactoring 
		className: valueClass name
		variables: valueClass allInstVarNames.
	
	r execute
]

{ #category : #'actions--private' }
ValueObjectHelper >> installInitMethod [

	| source | 
	
	self hasInstanceVariables
		ifFalse: [ ^ self ].
	
	source := String streamContents: [ :str |
		| selectorStream argumentsStream |
		selectorStream := self initSelector readStream.
		argumentsStream := self initArgumentNames readStream.
		[ selectorStream atEnd ]
			whileFalse: [ 
				str
					nextPutAll: (selectorStream upTo: $:);
					nextPutAll: ': ';
					nextPutAll: argumentsStream next;
					space ].
		str cr.
		valueClass instVarNames do: [ :eachName |
			str 
				cr; tab; 
				nextPutAll: eachName; 
				nextPutAll: ' := '; 
				nextPutAll: (self variableAsArgumentName: eachName);
				nextPut: $. ] ].
				
	self valueClass compile: source classified: 'initialization'
]

{ #category : #'actions--private' }
ValueObjectHelper >> installNewMethod [

	| source | 
	
	self hasInstanceVariables
		ifFalse: [ ^ self ].
	
	source := String streamContents: [ :str |
		| selectorStream argumentsStream extraCr |
		selectorStream := self newSelector readStream.
		argumentsStream := self newArgumentNames readStream.
		[ selectorStream atEnd ]
			whileFalse: [ 
				str
					nextPutAll: (selectorStream upTo: $:);
					nextPutAll: ': ';
					nextPutAll: argumentsStream next;
					space ].
		str 
			cr; cr; tab;
			nextPutAll: '^ self new '.
		extraCr := self newArgumentNames size > 3.
		selectorStream := self initSelector readStream.
		argumentsStream := self newArgumentNames readStream.
		[ selectorStream atEnd ]
			whileFalse: [ 
				str
					nextPutAll: (selectorStream upTo: $:);
					nextPutAll: ': ';
					nextPutAll: argumentsStream next.
				extraCr
					ifTrue: [ str cr; tab; tab; tab ]
					ifFalse: [ str space ] ] ].
				
	self valueClass class compile: source classified: 'instance creation'
]

{ #category : #'actions--private' }
ValueObjectHelper >> installReader: aVarName [

	| reader | 
	
	reader := String streamContents: [ :str |
		str 
			nextPutAll: aVarName;
			cr;tab;
			nextPutAll: '^ ';
			nextPutAll: aVarName ].
		
	self valueClass compile: reader classified: 'accessing'
]

{ #category : #'actions--private' }
ValueObjectHelper >> newArgumentNames [

	^self initArgumentNames
]

{ #category : #'actions--private' }
ValueObjectHelper >> newSelector [

	^(String streamContents: [ :str |
		str nextPutAll: 'new'.
		valueClass allInstVarNames doWithIndex: [ :eachName :index |
			str
				nextPutAll: (index = 1 ifTrue: [ eachName capitalized ] ifFalse: [ eachName ]);
				nextPut: $: ] ]) asSymbol
]

{ #category : #'actions--private' }
ValueObjectHelper >> removeObsoleteNewMethods [
	"Remove the instance creation class methods that uses an init method that no longer exists."

	(valueClass class methods select: [ :each | each protocol = 'instance creation' ])
		do: [ :eachMethod |
			| messages initMessage |
			messages := eachMethod messages.
			((messages includes: #new) and: [ messages size = 2 ])
				ifTrue: [ 
					initMessage := (messages copyWithout: #new) anyOne.
					((initMessage beginsWith: #init) and: [ valueClass includesSelector: initMessage ])
						ifFalse: [ valueClass class removeSelector: eachMethod selector ] ] ]
]

{ #category : #accessing }
ValueObjectHelper >> valueClass [
	^ valueClass
]

{ #category : #accessing }
ValueObjectHelper >> valueClass: aClass [
	valueClass := aClass
]

{ #category : #'actions--private' }
ValueObjectHelper >> variableAsArgumentName: aVarName [

	^'arg', (valueClass allInstVarNames indexOf: aVarName) asString
]
