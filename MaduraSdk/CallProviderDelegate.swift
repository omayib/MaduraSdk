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
    init(callManager: CallKitManager) {
        self.callManager = callManager
        provider = CXProvider(configuration: type(of: self).providerConfiguration)
        super.init()
        provider.setDelegate(self, queue: nil)
        
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
        
    }
    func provider(_ provider: CXProvider, perform action: CXAnswerCallAction) {
        //
    }
    func provider(_ provider: CXProvider, perform action: CXEndCallAction) {
        //
    }
    func provider(_ provider: CXProvider, perform action: CXSetHeldCallAction) {
        //
    }
    func provider(_ provider: CXProvider, timedOutPerforming action: CXAction) {
        ///
    }
}
