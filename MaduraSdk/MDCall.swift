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
    
    init(from callerId:String, to calleeId:String, isOutgoing:Bool, callSessionId:String) {
        self.callerId = callerId
        self.calleeId = calleeId
        self.isOutgoing = isOutgoing
        self.callSessionId = callSessionId
    }
}
