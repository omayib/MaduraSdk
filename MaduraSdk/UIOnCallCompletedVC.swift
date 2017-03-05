//
//  UIOnCallCompletedVC.swift
//  MaduraSdk
//
//  Created by qiscus on 2/2/17.
//  Copyright © 2017 qiscus. All rights reserved.
//

import UIKit

class UIOnCallCompletedVC: UIViewController {
    init() {
        let nibName:String = "UIOnCallCompletedVC"
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
    
    @IBAction func okButtonDidTap(_ sender: UIButton) {
        self.navigationController?.dismiss(animated: true, completion: nil)
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
