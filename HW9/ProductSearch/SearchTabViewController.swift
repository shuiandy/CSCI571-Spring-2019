//
//  SearchTabViewController.swift
//  
//
//  Created by Shuai Hu on 4/10/19.
//

import Foundation
import CoreLocation
import Toast_Swift
import UIKit
import McPicker
import Alamofire
import SwiftyJSON
import SwiftSpinner

class SearchTabViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, CLLocationManagerDelegate, UITextFieldDelegate, UITableViewDelegate, UITableViewDataSource{
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 1
    }
    
    var host = "http://shuaihu-csci571-hw9-server.us-west-1.elasticbeanstalk.com"
    static var keywordInput : String?
    var isNew : Bool = false
    var used : Bool = false
    var unspec : Bool = false
    var free : Bool = false
    var local : Bool = false
    var locationManager = CLLocationManager()
    var currentLocation : String?
    var locationIndicator : String?
    var formInfo : [String : Any]?
    var searchResult : JSON?
    var ItemResult = ItemList()
    var autoCompleteData = [String]()
    @IBOutlet weak var keyword: UITextField!
    @IBOutlet weak var category: McTextField!
    @IBOutlet weak var locationSwitch: UISwitch!
    @IBOutlet weak var customLocation: UITextField!
    @IBOutlet weak var distance: UITextField!
    @IBOutlet weak var newButton: UIButton!
    @IBOutlet weak var usedButton: UIButton!
    @IBOutlet weak var unspecButton: UIButton!
    @IBOutlet weak var localButton: UIButton!
    @IBOutlet weak var freeButton: UIButton!
    @IBOutlet weak var searchButton: UIButton!
    @IBOutlet weak var clearButton: UIButton!
    @IBOutlet weak var autoCompleteTableView: UITableView!
    
    
    @IBAction func isNewButton(_ sender: UIButton) {
        if isNew{
            sender.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
            isNew = false
        }
        else {
            sender.setImage(UIImage(named: "checked"), for: UIControl.State.normal)
            isNew = true
        }
    }
    @IBAction func used(_ sender: UIButton) {
        if used{
            sender.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
            used = false
        }
        else {
            sender.setImage(UIImage(named: "checked"), for: UIControl.State.normal)
            used = true
        }
    }
    @IBAction func unspec(_ sender: UIButton) {
        if unspec{
            sender.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
            unspec = false
        }
        else {
            sender.setImage(UIImage(named: "checked"), for: UIControl.State.normal)
            unspec = true
        }
        
    }
    @IBAction func local(_ sender: UIButton) {
        if local{
            sender.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
            local = false
        }
        else {
            sender.setImage(UIImage(named: "checked"), for: UIControl.State.normal)
            local = true
        }
        
    }
    @IBAction func free(_ sender: UIButton) {
        if free{
            sender.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
            free = false
        }
        else {
            sender.setImage(UIImage(named: "checked"), for: UIControl.State.normal)
            free = true
        }
        
    }
    @IBAction func locSwitch(_ sender: UISwitch) {
        if(locationSwitch.isOn){
            customLocation.isHidden = false;
            locationIndicator = "other"
        } else{
            customLocation.isHidden = true;
            autoCompleteTableView.isHidden = true
            locationIndicator = "current"
            
        }
    }
    
    let data:[[String]] = [["All", "Art", "Baby", "Books", "Clothing, Shoes & Accessories", "Computers/Tablets & Networking", "Health & Beauty", "Music", "Video Games & Consoles"]]

    override func viewDidLoad() {
        super.viewDidLoad()
        self.autoCompleteTableView.delegate = self;
        self.autoCompleteTableView.dataSource = self;
        self.autoCompleteTableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell");
        self.autoCompleteTableView.layer.borderWidth = 2;
        self.autoCompleteTableView.layer.borderColor = UIColor.gray.cgColor;
        self.autoCompleteTableView.layer.cornerRadius = 6
        self.searchButton.layer.cornerRadius = 5
        self.clearButton.layer.cornerRadius = 5
        customLocation.isHidden = true
        locationIndicator = "current"
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
        locationManager.requestWhenInUseAuthorization()
        locationManager.startUpdatingLocation()
        let mcInputView = McPicker(data: data)
        mcInputView.backgroundColor = .gray
        mcInputView.backgroundColorAlpha = 0.25
        category.inputViewMcPicker = mcInputView
        category.text = "All"
        category.doneHandler = {[weak category] (selections) in category?.text = selections[0]!
        }
        category.selectionChangedHandler = { [weak category] (selections, componentThatChanged) in
            category?.text = selections[componentThatChanged]!
        }
        category.cancelHandler = { [weak category] in
            category?.resignFirstResponder()
        }
        category.textFieldWillBeginEditingHandler = { [weak category] (selections) in
            if category?.text == "" {
                // Selections always default to the first value per component
                category?.text = selections[0]
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.autoCompleteTableView.isHidden = true
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
        CLGeocoder().reverseGeocodeLocation(manager.location!, completionHandler: {
            (placemarks, error) -> Void in
            
            if error != nil {
                print("Location Error!")
                return
            }
            
            if let pm = placemarks?.first {
                self.getzip(pm)
                print (self.currentLocation!)
            } else {
                print("Problem with the data received from geocoder")
            }
        })
    }
    @IBAction func zipcode(_ sender: Any) {
        self.autoCompleteTableView.isHidden = true
        if(self.customLocation.text!.count != 0){
            let time: TimeInterval = 0.5
            ViewController.cancelPreviousPerformRequests(withTarget: self)
            self.perform(#selector(autoCompleteRequest), with: nil, afterDelay: time)
        }
    }
    func getzip(_ placemark: CLPlacemark?){
        if let containsPlacemark = placemark{
            locationManager.stopUpdatingLocation()
            self.currentLocation = (containsPlacemark.postalCode != nil) ?
                containsPlacemark.postalCode :""
        }
    }
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error while updating location " + error.localizedDescription)
    }

    @objc func autoCompleteRequest(){
        let suggestionUrl = self.host + "/suggestion?locationKey=\(self.customLocation.text!.replacingOccurrences(of: " ", with: "+"))"
        AF.request(suggestionUrl).validate(contentType:["application/json"]).responseJSON{
            response in
            switch response.result{
            case .success(let zip):
                let zipcodes = JSON(zip)
                print("JSON: \(zipcodes)")
                self.autoCompleteData = []
                var count : Int! = 0
                while(count<zipcodes.count){
                    self.autoCompleteData.append(zipcodes[count].rawString()!)
                    count += 1
                }
                self.autoCompleteTableView.isHidden = false
                self.autoCompleteTableView.reloadData()
            case .failure(let error):
                print(error)
            }
        }
    }
   
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return autoCompleteData.count
    }
    
    //Adding rows in the tableview with the data from dataList
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell")
        cell!.backgroundColor = UIColor.clear
        cell?.textLabel?.text = autoCompleteData[indexPath.row]
        return cell!
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 30.0
    }
    
    // MARK: TableViewDelegate methods
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.customLocation.text = autoCompleteData[indexPath.row]
        autoCompleteTableView.isHidden = true
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


    @IBAction func searchPressed(_ sender: Any) {
        if(keyword.text == ""){
            self.view.makeToast("Keyword is Mandatory", duration: 3.0, position: .bottom)
        } else if(locationSwitch.isOn == true && customLocation.text == ""){

                self.view.makeToast("Zipcode is Mandatory", duration: 3.0, position: .bottom)
        } else if(locationSwitch.isOn == true && isValid(type: "Zip", value: customLocation.text!) == false){
                    self.view.makeToast("Invalid Zipcode!", duration: 3.0, position: .bottom)
                } else if(distance.text != "" && isValid(type: "Distance", value: distance.text!) == false){
                self.view.makeToast("Invalid Distance!", duration: 3.0, position: .bottom)
        }
        else{
            let formInfo : [String :Any] = ["category" : category.text ?? "All", "distance" : distance.text ?? "10", "keyword" : keyword.text ?? "", "location" : locationIndicator ?? "current" , "locationKey" : customLocation.text ?? "", "conditions" : [String(isNew), String(used), String(unspec)], "shipping" : [String(local), String(free)], "zip" : currentLocation!]
            self.formInfo = formInfo
            SwiftSpinner.show("Searching...")
            AF.request(self.host + "/search", method: .post, parameters: formInfo).responseJSON{response in
                switch response.result{
                case .success(let results):
                self.ItemResult = ItemList.unpackItemList(dataJSON: JSON(results))
                    SwiftSpinner.hide()
                case .failure(let failed):
                    self.ItemResult = ItemList.unpackItemList(dataJSON: JSON(failed))
                    print(failed)
                    SwiftSpinner.hide()
                }
                self.performSegue(withIdentifier: "goToResultPage", sender: self)
            }
        
        }
    }
    @IBAction func clearPressed(_ sender: UIButton) {
        keyword.text = ""
        category.text = "All"
        distance.text = ""
        isNew = false
        newButton.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
        used = false
        usedButton.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
        unspec = false
        unspecButton.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
        free = false
        freeButton.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
        local = false
        localButton.setImage(UIImage(named: "unchecked"), for: UIControl.State.normal)
        locationSwitch.isOn = false
        locationIndicator = "current"
        customLocation.isHidden = true
        customLocation.text = ""
        autoCompleteTableView.isHidden = true
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "goToResultPage"){
            SearchTabViewController.keywordInput = self.keyword.text
                        let destinationVC = segue.destination as! SearchResultViewController
                        destinationVC.itemList = self.ItemResult
        }
    }
    func isValid(type: String, value: String) -> Bool {
        var regex = ""
        if (type == "Distance"){
        regex = "^[0-9]*$"
        } else if (type == "Zip"){
            regex = "^[0-9]{5}(?:-[0-9]{4})?$"
        }
        return NSPredicate(format: "SELF MATCHES %@", regex).evaluate(with: value)
    }
}
