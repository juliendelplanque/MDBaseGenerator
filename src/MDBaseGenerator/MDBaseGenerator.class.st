Class {
	#name : #MDBaseGenerator,
	#superclass : #Object,
	#instVars : [
		'prefix',
		'packageName',
		'projectName',
		'withFooter',
		'withDrawerHeader',
		'rootHtmlClass',
		'title',
		'primaryColor',
		'accentColor'
	],
	#category : #MDBaseGenerator
}

{ #category : #example }
MDBaseGenerator class >> example [
	self new
		prefix: 'MDE';
		packageName: 'MDExample-WebApplication';
		projectName: 'MDExample';
		withFooter: true;
		withDrawerHeader: false;
		rootHtmlClass: 'mdexample';
		title: 'Application example for MDL.';
		primaryColor: MDLColor purple;
		accentColor: MDLColor purple lighter;
		generate
]

{ #category : #accessing }
MDBaseGenerator >> accentColor [
	^ accentColor
]

{ #category : #accessing }
MDBaseGenerator >> accentColor: anObject [
	accentColor := anObject
]

{ #category : #accessing }
MDBaseGenerator >> classGenerators [
	^ {MDComponentClassGenerator.
	MDFileLibraryClassGenerator.
	MDSessionClassGenerator.
	MDPageClassGenerator.
	MDHelloWorldClassGenerator.
	self headerClassGenerator.
	self rootClassGenerator}
]

{ #category : #preprocessing }
MDBaseGenerator >> cleanBeforeGeneration [
	(RPackageOrganizer default packageNamed: self packageName ifAbsent: [ nil ]) ifNotNil: #removeFromSystem
]

{ #category : #accessing }
MDBaseGenerator >> colors [
	^ self primaryColor tint, '-', self accentColor tint
]

{ #category : #generation }
MDBaseGenerator >> generate [
	self validateInformations.
	self cleanBeforeGeneration.
	RPackageOrganizer default createPackageNamed: self packageName.
	self classGenerators do: [ :class | (class generator: self) generate ].
	self openPackage.
	self openLastInstructions.
	self initializeClasses
]

{ #category : #accessing }
MDBaseGenerator >> headerClassGenerator [
	^ self withDrawerHeader ifTrue: [ MDDrawerHeaderClassGenerator ] ifFalse: [ MDTabBarHeaderClassGenerator ]
]

{ #category : #postprocessing }
MDBaseGenerator >> initializeClasses [
	{self rootClassGenerator} do: [ :class | self class environment at: class instance className asSymbol ifPresent: #initialize ]
]

{ #category : #postprocessing }
MDBaseGenerator >> openLastInstructions [
	Transcript
		clear;
		open.
	(String
		streamContents: [ :s | 
			(s
				<<
				'Application generated with success.
Now you can implement the missing parts to get your application!
	1) ')
				<< self rootClassGenerator instance className;
				<<
					'>>style should be updated to match your application color selection (See MDL for Seaside getting started section) or better, should be removed after you move the code to your own CSS.
	2) ';
				<< self rootClassGenerator instance className;
				<<
					'>>updateRoot: should be updated to match your application color selection (See MDL for Seaside getting started section) or better, the color part should be removed after you move the code to your own file library.
	3) Replace  ';
				<< MDHelloWorldClassGenerator instance className;
				<<
					' by your first page.
	4)' ]) logCr
]

{ #category : #postprocessing }
MDBaseGenerator >> openPackage [
	(RPackageOrganizer default packageNamed: self packageName) browse 
]

{ #category : #accessing }
MDBaseGenerator >> packageName [
	^ packageName
]

{ #category : #accessing }
MDBaseGenerator >> packageName: anObject [
	packageName := anObject
]

{ #category : #accessing }
MDBaseGenerator >> prefix [
	^ prefix
]

{ #category : #accessing }
MDBaseGenerator >> prefix: anObject [
	prefix := anObject
]

{ #category : #accessing }
MDBaseGenerator >> prefixed: aString [
	^ self prefix , aString
]

{ #category : #accessing }
MDBaseGenerator >> primaryColor [
	^ primaryColor
]

{ #category : #accessing }
MDBaseGenerator >> primaryColor: anObject [
	primaryColor := anObject
]

{ #category : #accessing }
MDBaseGenerator >> projectName [
	^ projectName
]

{ #category : #accessing }
MDBaseGenerator >> projectName: anObject [
	projectName := anObject
]

{ #category : #accessing }
MDBaseGenerator >> rootClassGenerator [
	^ self withFooter
		ifTrue: [ MDRootWithFooterClassGenerator ]
		ifFalse: [ MDRootClassGenerator ]
]

{ #category : #accessing }
MDBaseGenerator >> rootHtmlClass [
	^ rootHtmlClass
]

{ #category : #accessing }
MDBaseGenerator >> rootHtmlClass: anObject [
	rootHtmlClass := anObject
]

{ #category : #accessing }
MDBaseGenerator >> title [
	^ title
]

{ #category : #accessing }
MDBaseGenerator >> title: anObject [
	title := anObject
]

{ #category : #preprocessing }
MDBaseGenerator >> validateInformations [
	self prefix ifNil: [ self error: 'Generator needs a prefix for the classes to generate. Example: ''MDE'' will generate classes begining with MDE.' ].
	self packageName ifNil: [ self error: 'Generator needs a package name where to generate the code.' ].
	self projectName ifNil: [ self error: 'Generator needs a project name.' ].
	self withFooter ifNil: [ self error: 'Generator needs to know if you want your pages to get a footer or not.' ].
	self withDrawerHeader ifNil: [ self error: 'Generator needs to know if you want your header with a drawer or not.' ].
	self rootHtmlClass ifNil: [ self error: 'Generator needs to have a root html class.' ].
	self title ifNil: [ self error: 'Generator needs to have a title to display in the tab of the browser.' ].
	self class environment at: #MaterialDesignLite ifAbsent: [ self error: 'MDL need to be in the image for the generation.' ].
	self primaryColor ifNil: [ self error: 'Generator needs a primary color set for MDL.' ].
	self accentColor ifNil: [ self error: 'Generator needs a accent color set for MDL.' ].
]

{ #category : #accessing }
MDBaseGenerator >> withDrawerHeader [
	^ withDrawerHeader
]

{ #category : #accessing }
MDBaseGenerator >> withDrawerHeader: anObject [
	withDrawerHeader := anObject
]

{ #category : #accessing }
MDBaseGenerator >> withFooter [
	^ withFooter
]

{ #category : #accessing }
MDBaseGenerator >> withFooter: anObject [
	withFooter := anObject
]
