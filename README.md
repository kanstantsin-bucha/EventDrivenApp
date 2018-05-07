# EventDrivenApp

This is prototype application to display event driven software architecture in use

Licensed under the Apache License, Version 2.0 

## it based on second rules

- app should maintain state object that represent current state fully
- it should be possible to observe state object changes by subscription
- all ui elements should maintain current app state by relying on subscrybing to state changes only
- all events divided to this three kinds: [user action event, interface event, business logic event]
- app state could be changed only by processing occured events of kind: [user action, business logic]
- app changes it's state by processing event
- to process an event app using previous state and reducer that corresponded to this event type
- the result of processing event by reducer is new app state
- when app achive new app state all subscribed entities should be notified
- user action events could be produced only by user actions
- every user action code that supposed to modify app state should send user action event only
- all user action events should be processed by app logic
- while processing user action app logic produce corresponded interface and business logic events
to be processed by app reducer
- during processing app reducer could produce more postponed events
of kind [interface, business logic] to process them later



## the schema

user -> [user action in ui] -> [user action event] -> [app logic] 
-> [interface or busness logic event] -> [main app reducer]
-> [current state] + [reducer corresponded to this particular event]
-> [new app state] -> [all subscribers get new state notification] 

## stack of used technology

- ReactiveReSwift
- RxSwift
