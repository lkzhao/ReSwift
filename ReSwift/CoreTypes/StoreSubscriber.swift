//
//  StoreSubscriber.swift
//  ReSwift
//
//  Created by Benjamin Encz on 12/14/15.
//  Copyright © 2015 Benjamin Encz. All rights reserved.
//

import Foundation

public protocol AnyStoreSubscriber: class {
    // swiftlint:disable:next identifier_name
    func _newState(state: Any)
}

public protocol StoreSubscriber: AnyStoreSubscriber {
    associatedtype StoreSubscriberStateType

    func newState(state: StoreSubscriberStateType)
}

private protocol IsOptional {
    var objectValue: AnyObject? { get }
}

extension Optional: IsOptional {

    var objectValue: AnyObject? {
        switch self {
        case .none:
            return nil
        case .some(let wrapped):
            return wrapped as AnyObject
        }
    }

}

extension StoreSubscriber {
    // swiftlint:disable:next identifier_name
    public func _newState(state: Any) {
        if let state = state as? IsOptional {
            newState(state: state.objectValue as! StoreSubscriberStateType)
        } else if let typedState = state as? StoreSubscriberStateType {
            newState(state: typedState)
        }
    }
}
