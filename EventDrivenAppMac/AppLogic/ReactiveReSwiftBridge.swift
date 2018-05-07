//
//  ReactiveReSwiftBridge.swift
//  ReactiveReSwift-RxSwiftExample
//
//  Created by Charlotte Tortorella on 1/12/16.
//  Copyright © 2016 ReSwift. All rights reserved.
//

import ReactiveReSwift
import RxSwift


protocol UserActionProtocol {
    associatedtype ValueType
    
    func send(_ newValue: ValueType);
}

extension Variable: ObservablePropertyType {
    public typealias ValueType = Element
    public typealias DisposeType = DisposableWrapper
    
    public func subscribe(_ function: @escaping (Element) -> Void) -> DisposableWrapper? {
        return DisposableWrapper(disposable: asObservable().subscribe(onNext: function))
    }
}

extension Variable: UserActionProtocol {
    
    public func send(_ newValue: ValueType) {
        value = newValue
    }
}


extension Observable: StreamType {
    public typealias ValueType = Element
    public typealias DisposeType = DisposableWrapper
    
    public func subscribe(_ function: @escaping (Element) -> Void) -> DisposableWrapper? {
        return DisposableWrapper(disposable: subscribe(onNext: function))
    }
}

public struct DisposableWrapper: SubscriptionReferenceType {
    let disposable: Disposable
    
    public func dispose() {
        disposable.dispose()
    }
}

/// Initial Action that is dispatched as soon as the store is created.
/// Reducers respond to this action by configuring their initial state.
public struct ReSwiftInit: Action {}
