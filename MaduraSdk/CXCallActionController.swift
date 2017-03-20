//
//  CXCallActionController.swift
//  MaduraSdk
//
//  Created by qiscus on 3/12/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import Foundation
protocol CXCallActionController{
    func callActionDidStart(mdCall: MDCall)
    func callActionDidAnswer()
    func callActionDidHeld()
    func callActionDidEnd()
}
