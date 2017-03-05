//
//  CallEngineObserved.swift
//  MaduraSdk
//
//  Created by qiscus on 1/27/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
protocol CallEngineInteractor{
    func attachUICommand(uiCommand: UIBaseCallCommand)
    func onDecline()
    func onAnswer(from viewController: UIViewController)
    func onCancel()
    func onHangup()
}
