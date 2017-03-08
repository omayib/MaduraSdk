//
//  CallKitManager.swift
//  MaduraSdk
//
//  Created by qiscus on 3/7/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
import CallKit

final class CallKitManager: NSObject{
    let callController = CXCallController()
    
    func startCall(to: String, video: Bool = false){
        let handle = CXHandle(type: .phoneNumber, value: to)
        print("handle \(handle)")
        let startCallAction = CXStartCallAction(call:UUID(), handle: handle)
        print("startCallAction-handle \(startCallAction.handle)")
        startCallAction.isVideo = true
        
        let transaction = CXTransaction()
        transaction.addAction(startCallAction)
        
        requestCallTransaction(transaction)
    }
    
    func end(call: MDCall){
        let endCallAction = CXEndCallAction(call: UUID(uuidString: call.callSessionId)!)
        let transaction = CXTransaction()
        transaction.addAction(endCallAction)
        
        requestCallTransaction(transaction)
    }
    
    private func requestCallTransaction(_ transaction: CXTransaction){
        callController.request(transaction){ error in
            
            if let error = error {
                print("error requesting transaction \(error)")
            }else{
                print("transaction requested")
            }
            
        }
    }
}
