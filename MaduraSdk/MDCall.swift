//
//  MDCall.swift
//  MaduraSdk
//
//  Created by qiscus on 1/27/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
public enum MDCallType{
    case audio
    case video
}
public protocol MDCallAction{
    func dial(to userId:String, currentBalance balance:String, callType type:MDCallType)
}
public class MDCall{
    private(set) public var callerId: String = ""
    private(set) public var calleeId: String = ""
    private(set) public var isOutgoing: Bool = false
    private(set) public var callSessionId: String = ""
    var startingAt: Date?
    var startedAt: Date?
    var completedAt: Date?
    
    var connectingDate: Date? {
        didSet {
            stateDidChange?()
            hasStartedConnectingDidChange?()
        }
    }
    var connectDate: Date? {
        didSet {
            stateDidChange?()
            hasConnectedDidChange?()
        }
    }
    var endDate: Date? {
        didSet {
            stateDidChange?()
            hasEndedDidChange?()
        }
    }
    var isOnHold = false {
        didSet {
            stateDidChange?()
        }
    }
    
    // MARK: State change callback blocks
    
    var stateDidChange: (() -> Void)?
    var hasStartedConnectingDidChange: (() -> Void)?
    var hasConnectedDidChange: (() -> Void)?
    var hasEndedDidChange: (() -> Void)?
    
    // MARK: Derived Properties
    
    var hasStartedConnecting: Bool {
        get {
            return connectingDate != nil
        }
        set {
            connectingDate = newValue ? Date() : nil
        }
    }
    var hasConnected: Bool {
        get {
            return connectDate != nil
        }
        set {
            connectDate = newValue ? Date() : nil
        }
    }
    var hasEnded: Bool {
        get {
            return endDate != nil
        }
        set {
            endDate = newValue ? Date() : nil
        }
    }
    var duration: TimeInterval {
        guard let connectDate = connectDate else {
            return 0
        }
        
        return Date().timeIntervalSince(connectDate)
    }
    
    init(from callerId:String, to calleeId:String, isOutgoing:Bool, callSessionId:String) {
        self.callerId = callerId
        self.calleeId = calleeId
        self.isOutgoing = isOutgoing
        self.callSessionId = callSessionId
    }
    
    func startMDCall(completion:((_ success:Bool) -> Void)?){
        completion?(true)
        
        /*
         Simulate the "started connecting" and "connected" states using artificial delays, since
         the example app is not backed by a real network service
         */
        DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 3) {
            self.hasStartedConnecting = true
            
            DispatchQueue.main.asyncAfter(wallDeadline: DispatchWallTime.now() + 1.5) {
                self.hasConnected = true
            }
        }
    }
    
    func answerMDCall(){
        hasConnected = true
    }
    
    func endMDCall(){
        hasEnded = true
    }
}
