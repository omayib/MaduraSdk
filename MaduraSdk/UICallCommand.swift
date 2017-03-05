//
//  MDCallObserver.swift
//  MaduraSdk
//
//  Created by qiscus on 1/27/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation

protocol UIBaseCallCommand{
    func attachCallEngineInteractor(interactor: CallEngineInteractor)
}

protocol UIOngoingCallCommand: UIBaseCallCommand{
    func localVideoDidStreamed(any: Any)
    func remoteVideoDidStreamed(any: Any)
    func callStatusDidChanged(status:String)
    func hangupDidSucceed()
}
protocol UIIncommingCallCommand: UIBaseCallCommand{
    func callDidCancel()
}
