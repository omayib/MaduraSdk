//
//  MDCallObserver.swift
//  MaduraSdk
//
//  Created by qiscus on 1/27/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation

protocol MDCallObserver{
    func addObservedCallEngine(callEngine: CallEngineObserved)
}

protocol MDOngoingCallObserver: MDCallObserver{
    func localVideoDidStreamed(any: Any)
    func remoteVideoDidStreamed(any: Any)
    func callStatusDidChanged(status:String)
    func hangupDidSucceed()
}
protocol MDIncommingCallObserver: MDCallObserver{
    
}
