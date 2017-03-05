//
//  CallEngineMediator.swift
//  MaduraSdk
//
//  Created by qiscus on 1/27/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
import MaduraCallKit
import MaduraSignalKit

protocol CallEngineMediatorDelegate{
    func didDialled(callSessionId:String, fromUserId:String)
    func didInvited(callSessionId:String, fromUserId:String)
    func didAnswer(viewController: UIViewController)
    func didHangup()
    func didCompleted()
}

class CallEngineMediator {
    internal weak var timer: Timer?
    internal var callEngineCommand: CallEngineCommand?
    internal var signalEngineCommand: SignalEngineCommand?
    internal var uiCallCommand: UIBaseCallCommand?
    internal var call:MDCall?
    internal var delegate: CallEngineMediatorDelegate
    internal var userId:String?
    
    init(withDelegate:CallEngineMediatorDelegate, userId:String) {
        self.delegate = withDelegate
        self.userId = userId
    }
    func attachCallEngineCommand(callEngineCommand: CallEngineCommand){
        self.callEngineCommand = callEngineCommand
        
    }
    func attachSignalEngineCommand(signalEngineCommand: SignalEngineCommand){
        self.signalEngineCommand = signalEngineCommand
        
    }
    
    func addCall(call:MDCall){
        self.call = call
    }
    func startCall(){
        print("start call \(call?.callSessionId)")
        self.signalEngineCommand?.subscribe(toCallSession: (self.call?.callSessionId)!)
        callEngineCommand?.joinSession(callSessionId: (call?.callSessionId)!)
    }
    
    func isBussy(){
        try! self.signalEngineCommand?.publish(event: .bussy, to: (self.call?.callerId)!, message: "")
        
    }
    func isReady(){
        try! self.signalEngineCommand?.publish(event: .ready, to: (self.call?.callerId)!, message: "")
        self.delegate.didDialled(callSessionId: (self.call?.callSessionId)!, fromUserId: (self.call?.callerId)!)
    }
    
    func startPresence(){
        print("start to presence")
        timer = Timer.scheduledTimer(withTimeInterval: 10.0, repeats: true) { [weak self] _ in
            
            try! self?.signalEngineCommand?.publish(event: .presence, to: (self?.call?.callSessionId)!)
        }
    }
    func stopPresence() {
        print("stop to presence")
        timer?.invalidate()
        timer = nil
    }
}

extension CallEngineMediator: CallEngineInteractor{
    func attachUICommand(uiCommand: UIBaseCallCommand) {
        self.uiCallCommand = uiCommand
    }
    
    func onDecline() {
        
    }
    func onAnswer(from viewController: UIViewController) {
        print("mediator answer")
        self.delegate.didAnswer(viewController: viewController)
    }
    
    func onCancel(){
        print("mediator cancel")
        self.callEngineCommand?.leaveSession()
        
    }
    func onHangup(){
        print("mediator hangup")
        self.callEngineCommand?.leaveSession()
    }
}

extension CallEngineMediator: CallEngineResponse{
    public func userDidLeave() {
        print("mediator user did leave")
        stopPresence()
        try! self.signalEngineCommand?.publish(event: .leave, to: (self.call?.callSessionId)!)
        try! self.signalEngineCommand?.publish(event: .hangup, to: (self.call?.callSessionId)!)
        let uiOngoingCallCommand: UIOngoingCallCommand = uiCallCommand as! UIOngoingCallCommand
        uiOngoingCallCommand.hangupDidSucceed()
    }
    func userDidOffline() {
        
    }
    func localVideoDidLoad(any: Any?){
        let uiOngoingCallCommand: UIOngoingCallCommand = uiCallCommand as! UIOngoingCallCommand
        uiOngoingCallCommand.localVideoDidStreamed(any: any!)
        try! self.signalEngineCommand?.publish(event: .join, to: (self.call?.callSessionId)!)
        
        if (self.call?.isOutgoing)! {
            try! self.signalEngineCommand?.publish(event: .dial, to: (self.call?.callSessionId)!)
            try! self.signalEngineCommand?.publish(event: .invite, to: (self.call?.calleeId)!, message: (self.call?.callSessionId)!)
        }else{
            try! self.signalEngineCommand?.publish(event: .accept, to: (self.call?.callSessionId)!)
        }
        
        startPresence()
    }
    func remoteVideoDidLoad(any: Any?){
        let uiOngoingCallCommand: UIOngoingCallCommand = uiCallCommand as! UIOngoingCallCommand
        uiOngoingCallCommand.remoteVideoDidStreamed(any: any!)
    }
}
extension CallEngineMediator: SignalEngineResponse{
    public func onCallCompleted() {
        
    }

    
    func onConnected(){
        
    }
    func onDisconnected(){
        
    }
    func userSessionDidSubscribe(){
        
    }
    func userSessionDidUnsubscribe(){
        
    }
    func callSessionDidSubscribe(){
        
    }
    func callSessionDidUnsubscribe(){
        
    }
    func onReceiveDial() {
        
        try! self.signalEngineCommand?.publish(event: .wait, to: (self.call?.callSessionId)!)
        self.delegate.didDialled(callSessionId: (self.call?.callSessionId)!, fromUserId:  (self.call?.callerId)!)
    }
    func calleeDidWaitingAnswer() {
        //uiCallCommand.callStatusDidChanged(status: "waiting...")
    }
    func callerDidCancel() {
        
    }
    func peopleDidJoin() {
        print("a people did join")
        
    }
    func peopleDidLeave() {
        print("a people did leave")
        
        //uiCallCommand?.callStatusDidChanged(status: "He is leaved.")
    }
    func peopleDidReject() {
        print("a people did reject")
        
        //uiCallCommand?.callStatusDidChanged(status: "Rejected")
    }
    func peopleDidAnswer() {
        
        print("a people did answer")
        //start timer
    }
    func peopleDidHangup() {
        print("a people did hangup")
        self.callEngineCommand?.leaveSession()
    }
    func peopleDidPing() {
        try! self.signalEngineCommand?.publish(event: .pong, to: (self.call?.callSessionId)!)
    }
    func onCompleted() {
        
        print("on complete")
    }
    func onReceiveInvitation(message: String, from: String) {
        self.delegate.didInvited(callSessionId: message, fromUserId: from)
    }
    
    func onCalleeIsBussy(){
        print("calle is bussy")
    }
    func onCalleeIsReady(){
        print("calle is ready")
    }
}
