//
//  RequestLoanViewController.swift
//  Loanus
//
//  Created by Ibukunoluwa Soyebo on 28/09/2020.
//

import UIKit
import PKHUD
import Alamofire

class RequestLoanViewController: UIViewController {

    @IBOutlet weak var txtAccountNumber: UITextField!
    @IBOutlet weak var txtLocatoin: UITextField!
    @IBOutlet weak var txtPhoneNumber: UITextField!
    @IBOutlet weak var btnRequestLoan: UIButton!
    let locationImage = UIImageView(image: UIImage(named: "img-location"))
    let dropDownImage = UIImageView(image: UIImage(named: "img-dropdown"))
    
    var pickerLocation: UIPickerView!
    let arrayLocation = ["Lekki","Yaba","Ojota","Okota","Ketu","Magodo","Gbagada"]


    let customleftView = UIView(frame: CGRect(x: 0, y: 0, width: 20, height: 40))
    var arrTxtField: [UITextField]{
        return [txtPhoneNumber,txtAccountNumber]
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        btnRequestLoan.layer.cornerRadius = 5
        congigureTextViews(txtViews: txtAccountNumber,txtLocatoin,txtPhoneNumber)
        configureAccountNumberTextField()
        
        txtAccountNumber.leftView = customleftView
        txtAccountNumber.leftViewMode = .always
        setupPickerLocation()
//        txtPhoneNumber.leftView = customleftView
//        txtPhoneNumber.leftViewMode = .always
    }
    
    func setupPickerLocation(){
        let inputView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 240))
        pickerLocation = UIPickerView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 240))
        pickerLocation.dataSource = self
        pickerLocation.delegate = self
        pickerLocation.tag = 0
        inputView.addSubview(pickerLocation)
        txtLocatoin.inputView = inputView
    }

    fileprivate func congigureTextViews(txtViews: UITextField...){
        
        for txtView in txtViews{
            txtView.layer.cornerRadius = 5
            txtView.layer.borderColor = UIColor.init(displayP3Red: 35/255, green: 37/255, blue: 40/255, alpha: 0.3).cgColor
            txtView.layer.borderWidth = 1
//            DispatchQueue.main.async {
//                txtView.rightView = self.customleftView
//                //txtView.rightViewMode = .whileEditing
//            }
        }
    }
    
    fileprivate func configureAccountNumberTextField(){
        locationImage.contentMode = .center
        let leftView = UIView()
        leftView.addSubview(locationImage)
        leftView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        locationImage.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        
        txtLocatoin.leftView = leftView
        txtLocatoin.leftViewMode = .always
        
        dropDownImage.contentMode = .center
        let rightView = UIView()
        rightView.addSubview(dropDownImage)
        rightView.frame = CGRect(x: 0, y: 0, width: 40, height: 40)
        dropDownImage.frame = CGRect(x: 10, y: 10, width: 20, height: 20)
        
        txtLocatoin.rightView = rightView
        txtLocatoin.rightViewMode = .always
        
        
    }
    
    @IBAction func handleRequestLoan(_ sender: Any) {
        if !(txtLocatoin.text!.isEmpty || txtPhoneNumber.text!.isEmpty || txtAccountNumber.text!.isEmpty){
//            if !HelperClass.validate(value: txtPhoneNumber.text!){
//                HUD.flash(.label("Invalid Phone Number"),delay: 1)
//                return
//            }
            sendTextMessage(phoneNumber: "8182929823"){
                status in
                if status{
                    let storyboard = UIStoryboard(name: "Main", bundle: nil)
                    let successVc = storyboard.instantiateViewController(withIdentifier: "SuccessVC")
                    self.navigationController?.pushViewController(successVc, animated: true)
                }
            }
        }else{
            HUD.flash(.label("Please, Fill All fields"),delay: 1)
        }
    }
    
    fileprivate func sendTextMessage(phoneNumber:String, completionHandler: @escaping (Bool) -> Void){
        Connectivity.isConnectedToInternet(viewcontroller: self)
        let sendSMSEdnpoint = "/atlabs/messaging"
        let sendSMSBody:Parameters = ["to":"+2348182929823", "from":"FSI","message":"Hello World"]
        let sendSMSHeaders:HTTPHeaders = ["Sandbox-Key":HelperClass.sandBoxKey]
        HUD.show(.progress)
        AF.request(HelperClass.baseURL + sendSMSEdnpoint, method: .post, parameters: sendSMSBody, headers: sendSMSHeaders)
            .responseJSON{
            response in
            switch response.result{
            case .success:
                guard response.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on /todos/1")
                    print(response.error!)
                    HUD.flash(.labeledError(title: "Network Error", subtitle: "Check internet Connection"),delay: 1)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.error {
                        print("Error: \(error)")
                    }
                    return
                }
                
                HUD.hide()
                print(json)

                let SMSMessageData = json["SMSMessageData"] as? [String:Any]
                let Recipients = SMSMessageData?["Recipients"] as! NSArray
                for recep in Recipients{
                    let recepk = recep as? [String:Any]
                    let status = recepk?["status"] as? String
                    if status == "Success"{
                        completionHandler(true)
                    }else{
                        completionHandler(false)
                    }
                }
                
                
            case .failure:
                print("k")
            }
        }
    }
    
    
    @IBAction func handleBAck(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func accountNumberIsTenDigits(){
        if txtAccountNumber.text!.count == 10{
            validateAccountNumber(accountNumber: txtAccountNumber.text!){
                returnedBool in
                if returnedBool{
                    self.txtPhoneNumber.isEnabled = true
                    HUD.flash(.success)
                }else{
                    HUD.flash(.label("Account Number Does not exist"),delay: 1)
                }
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        txtPhoneNumber.isEnabled = false
//        for txtView in arrTxtField{
//            DispatchQueue.main.async {
//                txtView.leftView = self.customleftView
//                txtView.leftViewMode = .always
//            }
//        }

    }
    
    fileprivate func validateAccountNumber(accountNumber:String, completionhandle: @escaping (Bool) -> Void){
        Connectivity.isConnectedToInternet(viewcontroller: self)
        let validateAccountNumberEndpoint = "/sterling/TransferAPIs/api/Spay/InterbankNameEnquiry?" + "Referenceid=01&RequestType=01&Translocation=01&ToAccount=" + accountNumber + "&destinationbankcode=000001"
        let customheaders:HTTPHeaders = ["Sandbox-Key":HelperClass.sandBoxKey,"Ocp-Apim-Subscription-Key":"t","Ocp-Apim-Trace":"true","Appid":"69","ipval":"0","Content-Type":"application/json"]
        HUD.show(.progress)
        AF.request(HelperClass.baseURL+validateAccountNumberEndpoint,headers: customheaders).responseJSON{
            response in
            switch response.result{
            case .success:
                guard response.error == nil else {
                    // got an error in getting the data, need to handle it
                    print("error calling POST on /todos/1")
                    print(response.error!)
                    HUD.flash(.labeledError(title: "Network Error", subtitle: "Check internet Connection"),delay: 1)
                    return
                }
                // make sure we got some JSON since that's what we expect
                guard let json = response.value as? [String: Any] else {
                    print("didn't get todo object as JSON from API")
                    if let error = response.error {
                        print("Error: \(error)")
                    }
                    return
                }
                HUD.hide()
                print(json)
                let data = json["data"] as? [String:Any]
                let message = data?["message"] as? String
                let response = data?["response"] as? String
                
                if message == "success" && response == "success"{
                    completionhandle(true)
                }else{
                    completionhandle(false)
                }

                
            case .failure:
                print("K")
            }
            
        }
        
    }
    
    

}


extension RequestLoanViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayLocation.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayLocation[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        txtLocatoin.text = arrayLocation[row]
    }
    
}
