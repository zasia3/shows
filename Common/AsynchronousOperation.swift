//
//  AsynchronousOperation.swift
//  Common
//
//  Created by Joanna Zatorska on 25/04/2021.
//

import Foundation

open class AsynchronousOperation: Operation {
    public enum State: String {
        case ready = "isReady"
        case executing = "isExecuting"
        case finished = "isFinished"

        fileprivate var keyPath: String {
            return rawValue
        }
    }

    public var state = State.ready {
        willSet {
            willChangeValue(forKey: newValue.keyPath)
            willChangeValue(forKey: state.keyPath)
        }
        didSet {
            didChangeValue(forKey: oldValue.keyPath)
            didChangeValue(forKey: state.keyPath)
        }
    }

    override public var isReady: Bool {
        return super.isReady && state == .ready
    }

    override public var isExecuting: Bool {
        return state == .executing
    }

    override public var isFinished: Bool {
        return state == .finished
    }

    override public var isAsynchronous: Bool {
        return true
    }

    override public func start() {
        if isCancelled {
            state = .finished
            return
        }

        main()
        state = .executing
    }
}
