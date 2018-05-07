# EventDrivenApp

This is prototype application to display event driven software architecture in use
Licensed under the Apache License, Version 2.0 

## it based on second rules

- app should maintain state object that represent current state fully
- state object changes should be possible to observe by subscription
- all ui elements should maintain current app state by relying on subscrybing to state changes only
- all events divided to this three kinds: user action event, interface event, business logic event
- app could change state only when some event occures [user action, business logic]
- app changes it's state using reducer that corresponded to this event
- the result of processing event by reducer is new app state
- when app achive new app state all subscribed entities should be notified
- user action events could be produced only by user actions
- every user action code that modifing app state should send user action event
- all user action events should be processed by app logic that produce corresponded
interface events and business logic events
- during processing of interface or business logic event reducer could produce more delayed to process events
of kind [interface, business logic]


## the schema

user -> [user action in ui] -> [user action event] -> [app logic] 
-> [interface or busness logic event] -> [main app reducer]
-> [current state] + [reducer corresponded to this particular event]
-> [new app state] -> [all subscribers get new state notification] 

## stack of used technology

- ReactiveReSwift
- RxSwift
