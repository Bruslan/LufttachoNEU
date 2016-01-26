//
//  VerbundenVC.swift
//  LufttachoAppIP
//
//  Created by Brus Lan on 11.01.16.
//  Copyright © 2016 Brus Lan. All rights reserved.
//


import UIKit
import CoreBluetooth
import Charts
var XVariablenString = [String]()

class VerbundenVC: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate, ChartViewDelegate {

    @IBOutlet weak var VerbundenmitLabel: UILabel!
    @IBOutlet weak var Graph: LineChartView!
    var Characters = [CBCharacteristic]()
    
    @IBAction func Disconnect(sender: AnyObject) {
        
        manager.cancelPeripheralConnection(PeripheralGerät!)
        
    }
    
    
    override func viewDidLoad() {
        
            super.viewDidLoad()

            
            manager.delegate = self
            
            
            
            
            
            
            
            
            
            
            
          // Beispiel Chart äußeres
            
            Graph.delegate = self
            Graph.noDataTextDescription = "Keine Daten"
            Graph.dragEnabled = true
            Graph.dragDecelerationEnabled = true //neu
            Graph.drawMarkers = false
        
            Graph.setScaleEnabled(true)
            Graph.pinchZoomEnabled = true
            Graph.drawGridBackgroundEnabled = false
            Graph.maxVisibleValueCount = 60  //es war auf 60
            let xAxis : ChartXAxis = Graph.xAxis
            xAxis.drawGridLinesEnabled = false
            xAxis.spaceBetweenLabels = 1
            
            
            let yAxis : ChartYAxis = Graph.leftAxis
            yAxis.setLabelCount(6, force: true)
            yAxis.startAtZeroEnabled = false
            
            yAxis.drawGridLinesEnabled = false
            yAxis.axisLineColor = UIColor.whiteColor()
            yAxis.removeAllLimitLines()
            Graph.rightAxis.enabled =  false
            Graph.legend.enabled = false
            let Legende : ChartLegend = Graph.legend
            Legende.enabled = false
            
            yAxis.drawLimitLinesBehindDataEnabled = true
            
            
        
      
            Graph.invalidateIntrinsicContentSize()
            Graph.backgroundColor? = UIColor.clearColor()
            Graph.gridBackgroundColor = UIColor.clearColor()
            Graph.xAxis.gridColor = UIColor.whiteColor()


            

    }
    
 
    
    override func viewDidAppear(animated: Bool) {
        manager.delegate = self
      
        
        
    }
    
    
    
    
    func centralManager(central: CBCentralManager, didConnectPeripheral peripheral: CBPeripheral) {
        print("Vebunden :D ")
        VerbundenmitLabel.text = "Verbunden mit: \(PeripheralGerät!.name!)"
       
        
        
        if let PeripheralGerät = PeripheralGerät
        {
                PeripheralGerät.delegate = self
                PeripheralGerät.discoverServices(nil)
        }
 
        
    }
    

    func centralManagerDidUpdateState(central: CBCentralManager) {
        
    }
    
    func peripheral(peripheral: CBPeripheral, didDiscoverServices error: NSError?) {
        if let peripheralservices = peripheral.services
        {
                for i in peripheralservices{
                print("Services: \(i)")
                peripheral.discoverCharacteristics(nil, forService: i)
                
            }
        }
    }
    
    
    
    
    
    
    
    // Characteristics rauslesen
    
    func peripheral(peripheral: CBPeripheral, didDiscoverCharacteristicsForService service: CBService, error: NSError?) {
        if let Characteristics = service.characteristics
        {
            Characters = Characteristics
            
        for i in Characteristics
        {
            print("Characteristics gefunden: \(i)")

            var value = NSInteger(9223372036854775807)
            //var value = [NSData()]
            
            let valueData : NSData = NSData(bytes: &value, length: 1)
            peripheral.writeValue(valueData, forCharacteristic: i, type: CBCharacteristicWriteType.WithResponse)

            peripheral.setNotifyValue(true, forCharacteristic: i)
            peripheral.setNotifyValue(true, forCharacteristic: i)
            
           
            
            }
        
        }
    }
    
    
    
    
    
    // Funktion zur beschriftung des Moduls NSinter(...) die Maximale beschriftung
    
    func Beschriften ()
    {
        for i in Characters
        {
            
            var value = NSInteger(9223372036854775807)
            
            let valueData : NSData = NSData(bytes: &value, length: 1)
            PeripheralGerät!.writeValue(valueData, forCharacteristic: i, type: CBCharacteristicWriteType.WithResponse)
        }
        
    }
    

    

    // Funktion wird ausgeführ, wenn Daten eingegangen sind, diese werden bei Command.swift in Arrays aus Double und Strings verwandelt!
    // Verwandle NSData in Double und Speichere es in Channel1  und Channel2 
    // Verwandle Channel1[NSdata] in Channel1double[Double]
    // Immer wenn neue Daten eingehen, wird das alte Array gelöscht, und mit neuen Daten überspielt!
    
    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let Value = characteristic.value
        {
            if characteristic.UUID == CBUUID(string:"00000002-0000-1000-8000-008025000000"){
            
                print("Raw NSData Value :\(Value)") //

                
                // Nur Vollständige Daten annehmen!!!
                
                if Value.length == 20
                {
                    
                Channel1Double.removeAll()
                XVariablegerundet.removeAll()
                XVariablenString.removeAll()
                
                    // Die Eingehende Daten werden in dieser Funktion Umgewandelt und in Arrays (Channel1 und Channel2) aufgeteilt!
                    Command(Value)

                    
                }
                


               
                print("Channel1 : \(Channel1)")
                print("Channel2 : \(Channel2)")
                print("XVariable für Channel 1 : \(XVariablenString)")
                print("Channel 1 in DOuble: \(Channel1Double)")
                
                
                Beschriften()
            }
        }
    }
    

    
    
    

    
    
    
    
    
    

    
    
    
    

    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        
        
    
    


}
