//
//  UIIncomingCallVC.swift
//  MaduraSdk
//
//  Created by qiscus on 1/27/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import UIKit

class UIIncomingCallVC: UIViewController{
    internal var callCommand: CallEngineInteractor?
    init() {
        let nibName:String = "UIIncomingCallVC"
        let nibBundle = Bundle(for: type(of: self))
        
        super.init(nibName: nibName, bundle: nibBundle)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func declineButtonDidTap(_ sender: UIButton) {
        print("deline button did tap")
        self.callCommand?.onDecline()
    }
    
    @IBAction func answerButtonDidTap(_ sender: UIButton) {
        print("answer button did tap")
        self.callCommand?.onAnswer(from: self)
    }
}

extension UIIncomingCallVC: UIIncommingCallCommand{
    func attachCallEngineInteractor(interactor: CallEngineInteractor) {
        self.callCommand = interactor
    }
    func callDidCancel() {
        //
    }
}
