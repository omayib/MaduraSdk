//
//  UIOutgoingCallVC.swift
//  MaduraSdk
//
//  Created by qiscus on 1/27/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import UIKit

class UIOngoingCallVC: UIViewController {
    @IBOutlet var remoteVideoView: UIView!
    @IBOutlet var localVideoView: UIView!
    
    @IBOutlet var callStatusLabel: UILabel!
    
    internal var callCommand: CallEngineInteractor?
    init() {
        let nibName:String = "UIOngoingCallVC"
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

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancelButtonDidTap(_ sender: UIButton) {
        print("click cancelButtonDidTap button")
        self.callCommand?.onCancel()
    }
    
    @IBAction func hangupButtonDidTap(_ sender: UIButton) {
        print("click hangup button")
        self.callCommand?.onHangup()
    }
}

extension UIOngoingCallVC: UIOngoingCallCommand{
    // MARK : Three functions below are trigerred by MDCallObserver
    func hangupDidSucceed() {
        print("UIOngoingCallVC hangupDidSucceed")
        let ui = UIOnCallCompletedVC()
        self.navigationController?.pushViewController(ui, animated: true)
    }
    func attachCallEngineInteractor(interactor: CallEngineInteractor){
        self.callCommand = interactor
    }
    func localVideoDidStreamed(any: Any){
        let lovalView = any as! UIView
        self.localVideoView.frame.size = CGSize(width: 84.5, height: 150.0)
        lovalView.frame.size = self.localVideoView.frame.size
        self.localVideoView.addSubview(lovalView)
        self.localVideoView.layoutIfNeeded()
        
    }
    func remoteVideoDidStreamed(any: Any){
        // localView 640 x 360
        let remoteView = any as! UIView
        self.remoteVideoView.frame.size = CGSize(width: 84.5, height: 150.0)
        remoteView.frame.size = self.remoteVideoView.frame.size
        self.remoteVideoView.addSubview(remoteView)
        self.remoteVideoView.layoutIfNeeded()
        
    }
    func callStatusDidChanged(status: String) {
        self.callStatusLabel.text = status
    }
}
