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

public class MaduraSdk{
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
    
    public init(apiKey:String, userId:String){
        self.apiKey = apiKey
        self.userId = userId
        self.mediator = CallEngineMediator(withDelegate: self,userId: userId)
        
        let callEngineResponse = mediator as! CallEngineResponse
        self.callEngine = MaduraCallEngine(engineVersion: .Bangkalan, responseHandler: callEngineResponse)
        
        let signalEngineResponse = mediator as! SignalEngineResponse
        
        let config = SignalEngineConfig(mqttHost:  "mqtt.qiscus.com", port: 1883)
        self.signalEngine = MaduraSignalEngine(userId: userId, signalResponse: signalEngineResponse, config: config)
        
        self.signalEngineCommand = signalEngine?.signalCommand
        self.callEngineCommand = callEngine?.callEngineCommand
        
        self.signalEngineCommand?.connect()
        self.mediator?.attachCallEngineCommand(callEngineCommand: callEngineCommand!)
        self.mediator?.attachSignalEngineCommand(signalEngineCommand: signalEngineCommand!)
        
    }
    
    deinit {
        print("deinit madura sdk")
        self.mediator = nil
        self.callEngine = nil
        self.signalEngine = nil
    }
    
    public func dial(to calleeId:String, fromViewController: UIViewController){
        
        let timestamp = Date().timeIntervalSince1970
        let callSessionId = UUID().uuidString+self.userId!+String.init(format: "%.0f", timestamp)
        print("session \(callSessionId)")
        call = MDCall(from: self.userId!, to: calleeId, isOutgoing: true, callSessionId: "thisisroomchannel")
        
        self.mediator?.addCall(call: call!)
        
        let ui = UIOngoingCallVC()
        ui.addObservedCallEngine(callEngine: self.mediator!)
        self.mediator?.addObserver(callObserver: ui)
        
        
        let navController = UINavigationController()
        navController.viewControllers = [ui]
        let root = navController
        
       // let target = UIApplication.currentViewController()
        
        fromViewController.navigationController?.present(root, animated: true, completion: nil)
        
        DispatchQueue.main.asyncAfter(deadline: .now()+1) {
            self.mediator?.startCall()
        }
 
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
        ui.addObservedCallEngine(callEngine: self.mediator!)
        self.mediator?.addObserver(callObserver: ui)
        
        
        let navController = UINavigationController()
        navController.viewControllers = [ui]
        let root = navController
        
        let target = UIApplication.getViewController()
        target.navigationController?.present(root, animated: true, completion: nil)
    }
    
    func didAnswer(viewController: UIViewController) {
        print("madura appplication didAnswer1")
        let ui = UIOngoingCallVC()
        ui.addObservedCallEngine(callEngine: self.mediator!)
        self.mediator?.addObserver(callObserver: ui)
        
        let navController = UINavigationController()
        navController.viewControllers = [ui]
        let root = navController
        
        let target = UIApplication.currentViewController()
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
