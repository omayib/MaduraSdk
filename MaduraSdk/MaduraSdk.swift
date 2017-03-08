//
//  MaduraApplication.swift
//  MaduraSdk
//
//  Created by qiscus on 1/15/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
import MaduraSignalKit
import MaduraCallKit
/**
  The role of this component is like assembling puzzle. Initiate the component then plug into other component.
 */
open class MaduraSdk{
    private var delegate: MDCallDelegate?
    private var signalEngine: MaduraSignalEngine?
    private var signalEngineCommand: SignalEngineCommand?
    private var callEngine: MaduraCallEngine?
    private var callEngineCommand: CallEngineCommand?
    internal var mediator: CallEngineMediator?
    private var apiKey: String?
    internal var userId: String?
    private var uiOutgoingVC: UIViewController?
    private var uiIncommingVC: UIViewController?
    internal(set) public var call:MDCall?
    internal var callManager: CallKitManager = CallKitManager()
    internal var callProvider: CallProviderDelegate?

    
    /**
     intitation for MaduraSdk.
     
    - parameters:
        - apiKey : the *apiKey* generated from your madura account.
        - userId : unique user identifier such as email or phone number.
     
     */
    public init(apiKey:String, userId:String){
        self.apiKey = apiKey
        self.userId = userId
        callProvider = CallProviderDelegate(callManager: callManager)

        /*
        setup the important component : CallEngineMediator. The role of this component is to coordinate among UI, signalEngine and callEngine.
         */
        self.mediator = CallEngineMediator(withDelegate: self,userId: userId)
        
        /*
         CallEngineMediator consits of two part : CallEngineResponse and SignalEngineResponse. Lets separate them.
         */
        let callEngineResponse = mediator as! CallEngineResponse
        let signalEngineResponse = mediator as! SignalEngineResponse

        /*
         initiate the MaduraCallEngine and hold it into calEngine variable.
         */
        self.callEngine = MaduraCallEngine(engineVersion: .Bangkalan, responseHandler: callEngineResponse)
        
        /*
         initiate the MaduraSignalEngine and hold it into signalEngine variable. But before it, we have to declare the configuration.
         */
        let config = SignalEngineConfig(mqttHost:  "mqtt.qiscus.com", port: 1883)
        self.signalEngine = MaduraSignalEngine(userId: userId, signalResponse: signalEngineResponse, config: config)
        
        /*
         take out the signalEngineCommand form signalEngine component. We also need to take out the callEngineCommand from callEngine component.
         */
        self.signalEngineCommand = signalEngine?.signalCommand
        self.callEngineCommand = callEngine?.callEngineCommand
        
        /*
         Plug the callEngineCommand and signalEngineCommand into CallEngineMEdiator.
         */
        self.mediator?.attachCallEngineCommand(callEngineCommand: callEngineCommand!)
        self.mediator?.attachSignalEngineCommand(signalEngineCommand: signalEngineCommand!)
        
        // finally the assambling puzzle activity is done. now lets start to connect.
        self.signalEngineCommand?.connect()
    }
    
    deinit {
        print("deinit madura sdk")
        self.mediator = nil
        self.callEngine = nil
        self.signalEngine = nil
    }
    public func bebek(){
        
    }
    public func dial(to calleeId:String, balance:Double, fromViewController: UIViewController){
          callManager.startCall(to: calleeId)

//        let timestamp = Date().timeIntervalSince1970
//        let callSessionId = UUID().uuidString+self.userId!+String.init(format: "%.0f", timestamp)
//        print("session \(callSessionId)")
//        call = MDCall(from: self.userId!, to: calleeId, isOutgoing: true, callSessionId: "thisisroomchannel")
//        
//        self.mediator?.addCall(call: call!)
//        
//        let ui = UIOngoingCallVC()
//        ui.attachCallEngineInteractor(interactor: self.mediator!)
//        self.mediator?.attachUICommand(uiCommand: ui)
//        
//        
//        let navController = UINavigationController()
//        navController.viewControllers = [ui]
//        let root = navController
//    
//        fromViewController.navigationController?.present(root, animated: true, completion: nil)
//        
//        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
//            self.mediator?.startCall()
//        }
 
    }
    
    public func incommingCall(){
        
        
    }
    
}

extension MaduraSdk: CallEngineMediatorDelegate{
    func didInvited(callSessionId: String, fromUserId: String) {
        if call != nil {
            self.mediator?.isBussy()
        }else{
            
            call = MDCall(from: fromUserId, to: self.userId!, isOutgoing: false, callSessionId: callSessionId)
            self.mediator?.addCall(call: call!)
            self.mediator?.isReady()
        }
    }
    func didDialled(callSessionId:String, fromUserId:String){
        print("calle did dial")
        let ui = UIIncomingCallVC()
        ui.attachCallEngineInteractor(interactor: self.mediator!)
        self.mediator?.attachUICommand(uiCommand: ui)
        
        
        let navController = UINavigationController()
        navController.viewControllers = [ui]
        let root = navController
        
        let target = UIApplication.getViewController()
        target.navigationController?.present(root, animated: true, completion: nil)
    }
    
    func didAnswer(viewController: UIViewController) {
        print("madura appplication didAnswer1")
        let ui = UIOngoingCallVC()
        ui.attachCallEngineInteractor(interactor: self.mediator!)
        self.mediator?.attachUICommand(uiCommand: ui)
        
        viewController.navigationController?.pushViewController(ui, animated: true)
        print("madura appplication didAnswer2")
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.mediator?.startCall()
        }
    }
    func didCompleted() {
        self.call = nil
    }
    func didHangup() {
        print("mediaotr did hangup. goto ui oncall completed")
    }
}

extension UIApplication {
    class func getViewController()-> UIViewController{
        let ui = UIApplication.shared.keyWindow?.rootViewController
        let uiv = ui as? UINavigationController
        print("presented vc : \(uiv?.visibleViewController?.nibName)")
        return (uiv?.visibleViewController)!
    }
    // Get current view controller
    class func currentViewController(base: UIViewController? = UIApplication.shared.keyWindow?.rootViewController) -> UIViewController? {
        
        if let nav = base as? UINavigationController {
            return currentViewController(base: nav.visibleViewController)
        }
        
        if let tab = base as? UITabBarController {
            let moreNavigationController = tab.moreNavigationController
            
            if let top = moreNavigationController.topViewController, top.view.window != nil {
                return currentViewController(base: top)
            } else if let selected = tab.selectedViewController {
                return currentViewController(base: selected)
            }
        }
        
        if let presented = base?.presentedViewController {
            return currentViewController(base: presented)
        }
        
        return base
    }
}

public extension UIWindow {
    public var visibleViewController: UIViewController? {
        return UIWindow.getVisibleViewControllerFrom(vc: self.rootViewController)
    }
    
    public static func getVisibleViewControllerFrom(vc: UIViewController?) -> UIViewController? {
        if let nc = vc as? UINavigationController {
            return UIWindow.getVisibleViewControllerFrom(vc: nc.visibleViewController)
        } else if let tc = vc as? UITabBarController {
            return UIWindow.getVisibleViewControllerFrom(vc: tc.selectedViewController)
        } else {
            if let pvc = vc?.presentedViewController {
                return UIWindow.getVisibleViewControllerFrom(vc: pvc)
            } else {
                return vc
            }
        }
    }
}
