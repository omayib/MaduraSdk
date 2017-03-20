//
//  CallProviderDelegate.swift
//  MaduraSdk
//
//  Created by qiscus on 3/7/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
import UIKit
import CallKit

final class CallProviderDelegate: NSObject{
    let callManager: CallKitManager
    private let provider: CXProvider
    let callActionController: CXCallActionController
    
    /// The app's provider configuration, representing its CallKit capabilities
    static var providerConfiguration: CXProviderConfiguration {
        let localizedName = NSLocalizedString("APPLICATION_NAME", comment: "Name of application")
        let providerConfiguration = CXProviderConfiguration(localizedName: localizedName)
        
        providerConfiguration.supportsVideo = true
        
        providerConfiguration.maximumCallsPerCallGroup = 1
        
        providerConfiguration.supportedHandleTypes = [.phoneNumber]
        
        if let iconMaskImage = UIImage(named: "IconMask") {
            providerConfiguration.iconTemplateImageData = UIImagePNGRepresentation(iconMaskImage)
        }
        
        providerConfiguration.ringtoneSound = "Ringtone.caf"
        
        return providerConfiguration
    }
    init(callManager: CallKitManager, callActionController: CXCallActionController) {
        self.callActionController = callActionController
        self.callManager = callManager
        provider = CXProvider(configuration: type(of: self).providerConfiguration)
        super.init()
        provider.setDelegate(self, queue: nil)
        
    }
    /// Use CXProvider to report the incoming call to the system
    func reportIncomingCall(uuid: UUID, handle: String, hasVideo: Bool = false, completion: ((NSError?) -> Void)? = nil) {
        // Construct a CXCallUpdate describing the incoming call, including the caller.
        print("report incomming 1")
        let update = CXCallUpdate()
        update.remoteHandle = CXHandle(type: .phoneNumber, value: handle)
        update.hasVideo = hasVideo
        
        // Report the incoming call to the system
        provider.reportNewIncomingCall(with: uuid, update: update) { error in
            /*
             Only add incoming call to the app's list of calls if the call was allowed (i.e. there was no error)
             since calls may be "denied" for various legitimate reasons. See CXErrorCodeIncomingCallError.
             */
            if error == nil {
                print("report incomming 2")
                let call = MDCall(callSessionId: uuid, isOutgoing: false)
                call.handle = handle
                self.callManager.addCall(call)
            }
            
            print("report incomming 3")
            completion?(error as? NSError)
        }
    }
}
extension CallProviderDelegate: CXProviderDelegate{
    func providerDidBegin(_ provider: CXProvider) {
        //
    }
    func providerDidReset(_ provider: CXProvider) {
    }
    func provider(_ provider: CXProvider, perform action: CXStartCallAction) {
        print("delegate CXStartCallAction")
        
        let callSessionId = action.callUUID
     
        let mdCall = MDCall(callSessionId: callSessionId)
        mdCall.handle = action.handle.value
        
        
        mdCall.hasStartedConnectingDidChange = { [weak self] in
            provider.reportOutgoingCall(with: callSessionId, startedConnectingAt: mdCall.connectingDate)
        }
        mdCall.hasConnectedDidChange = { [weak self] in
            provider.reportOutgoingCall(with: callSessionId, connectedAt: mdCall.connectDate)
        }
        
        action.fulfill()
        self.callManager.addCall(mdCall)
        
        self.callActionController.callActionDidStart(mdCall: mdCall)
        
    }
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        action.fulfill(withDateConnected: Date())
        print("provider answerCallAction")
        callActionController.callActionDidAnswer()
        
    }
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        action.fulfill(withDateEnded: Date())
        print("provider CXEndCallAction")
        //
    }
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        //
    }
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        ///
    }
}
