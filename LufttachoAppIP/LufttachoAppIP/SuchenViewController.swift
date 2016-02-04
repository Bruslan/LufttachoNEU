//
//  ViewController.swift
//  LufttachoAppIP
//
//  Created by Brus Lan on 09.01.16.
//  Copyright © 2016 Brus Lan. All rights reserved.
//

import UIKit
import CoreBluetooth


var devices = ["Devices:"] 
var PeripheralGeräte = []
var PeripheralGerät : CBPeripheral?
var manager : CBCentralManager!

class SuchenViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, CBCentralManagerDelegate, CBPeripheralDelegate {
   
    @IBOutlet weak var GeräteNameinderZelle: UILabel!
    @IBOutlet weak var tableView: UITableView!
   

    @IBOutlet weak var StatusLabel: UILabel!
    @IBOutlet weak var Indikator: UIActivityIndicatorView!
    @IBOutlet weak var SuchenAussehen: UIButton!
    var Suchenaktiv = Bool()
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        Indikator.alpha = 0

        manager = CBCentralManager(delegate: self, queue: nil)
        devices.removeAll()
        tableView.reloadData()
  
    }
    
    
    
    
    
    
    
    // Suchen Button
    
    
    @IBAction func Suchen(sender: AnyObject) {
        
        devices.removeAll()
        Indikator.alpha = 1
        manager.scanForPeripheralsWithServices(nil, options: nil)
        Indikator.startAnimating()
        StatusLabel.text! = "Suche läuft..."
        
    }
    // Bluetooth Status
    
    
    func centralManagerDidUpdateState(central: CBCentralManager) {
        
        var Nachricht = ""
        
        switch (central.state)
            
        {
        case .PoweredOff:
            Nachricht = "Bluetooth ausgeschaltet"
            SuchenAussehen.enabled = false
            StatusLabel.text = "Schalten sie Bluetooth ein"
            Indikator.alpha = 0
            
        case .PoweredOn:
            
            Nachricht = "Bluetooth eingeschaltet"
            
            SuchenAussehen.enabled = true
            StatusLabel.text = "Status"
           
            

        case .Unsupported:
            
            Nachricht = "Bluetooth nicht unterstützt"
            SuchenAussehen.enabled = false
            StatusLabel.text = "Bluetooth Gerät nicht unterstützt"
            default: break
            
        }
        print("Status: \(Nachricht)")
        
    }

    
    
    
    
  


    
    
    
    
    
    //Geräte Gefunden
    
    
    func centralManager(central: CBCentralManager, didDiscoverPeripheral peripheral: CBPeripheral, advertisementData: [String : AnyObject], RSSI: NSNumber) {
        

        
        if let name = peripheral.name{
        devices.append(name)
            print(devices)
            
        
        }
        PeripheralGeräte = [peripheral]
        

        tableView.reloadData()
        
    }

    func centralManager(central: CBCentralManager, didDisconnectPeripheral peripheral: CBPeripheral, error: NSError?) {
        
        print("Disconnected")
    }
    
    
    
    
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       if devices == ["Devices:"]
       {
        return 0
        }
        
        return devices.count
        
    }
    
    
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("Zelle", forIndexPath: indexPath) as! Zelle
        

        //cell.textLabel?.text = devices[indexPath.row] as String
        cell.LabelName.text = devices[indexPath.row] as String

        return cell
    }
    
    
    
    
    
    
    
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    PeripheralGerät = PeripheralGeräte[indexPath.row] as? CBPeripheral
        if let PeripheralGerät = PeripheralGerät
        {
        PeripheralGerät.delegate = self
            
        }
        if let derManager = manager
        {
        derManager.connectPeripheral(PeripheralGerät!, options: nil)
            print("Verbindet")
            

        }
        
    }


    
    
}

