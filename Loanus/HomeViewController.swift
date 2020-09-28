//
//  ViewController.swift
//  Loanus
//
//  Created by Ibukunoluwa Soyebo on 28/09/2020.
//

import UIKit
import Alamofire
import PKHUD

class HomeViewController: UIViewController {

    @IBOutlet weak var btnTransfer: UIButton!
    @IBOutlet weak var btnRequestLoan: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        btnTransfer.layer.borderWidth = 1
        btnTransfer.layer.borderColor = UIColor.black.cgColor
        btnTransfer.layer.cornerRadius = 5
        btnRequestLoan.layer.cornerRadius = 5
        
    }
    
    
    
   


}

