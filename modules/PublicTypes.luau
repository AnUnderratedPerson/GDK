--> @Use: Types for internal and external use of the module

--> Interace Public Types
--> CoreType: InteractCore

export type InteractPublicInterface = {
	create: (any, Instance?, string?) -> (
	({ any }) -> (Instance)
	),

	createComponent: (string, (InteractPublicInterface) -> (Instance)) -> (),
}

export type InteractCore = InteractPublicInterface & {
	_warn: (string, ...any) -> (),
	_assert: (any, string, number, ...any) -> (),
	_components: {}
}