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

    @IBOutlet weak var SwitchAussehen: UISwitch!
    @IBOutlet weak var SliderAussehen: UISlider!
    @IBOutlet weak var VerbundenmitLabel: UILabel!
    @IBOutlet weak var Graph: LineChartView!
    var Characters = [CBCharacteristic]()
    var Entry : ChartDataEntry = ChartDataEntry()
    var Schalter = true
    var yVals = [ChartDataEntry]()
    var firsttime = true
    var DoubleDaten = Double()
    
    var dataFlow : LineChartData = LineChartData()
    
    @IBOutlet weak var SwitschAussehn: UISwitch!
    var xStelle : Int = 0
    var range : CGFloat = 10
    @IBAction func Disconnect(sender: AnyObject) {
        
        manager.cancelPeripheralConnection(PeripheralGerät!)
        
    }
    
    
    override func viewDidLoad() {
        
            super.viewDidLoad()
        Channel1Aussehen.enabled = false
        
            
            manager.delegate = self
            SwitchAussehen.on = false
        
            
        
            
            
            
            
        
            
            
          // Beispiel Chart äußeres
            
            Graph.delegate = self
            Graph.noDataTextDescription = "Keine Daten"
            Graph.dragEnabled = true
            Graph.dragDecelerationEnabled = true //neu
            Graph.drawMarkers = false
        
            Graph.setScaleEnabled(true)
            Graph.pinchZoomEnabled = true
            Graph.drawGridBackgroundEnabled = false
            Graph.maxVisibleValueCount = Int(range)  //es war auf 60
            let xAxis : ChartXAxis = Graph.xAxis
            xAxis.drawGridLinesEnabled = false
            xAxis.spaceBetweenLabels = 1
        
        
            
            let yAxis : ChartYAxis = Graph.leftAxis
            yAxis.setLabelCount(6, force: true)
            yAxis.startAtZeroEnabled = false
            
            yAxis.drawGridLinesEnabled = false
            yAxis.axisLineColor = UIColor.grayColor()
            yAxis.removeAllLimitLines()
            yAxis.axisMaximum = 20
            yAxis.axisMinimum = -20
        
            Graph.rightAxis.enabled =  false
        
            Graph.legend.enabled = false
            let Legende : ChartLegend = Graph.legend
            Legende.enabled = false
            
            yAxis.drawLimitLinesBehindDataEnabled = true
        

        
            Graph.backgroundColor? = UIColor.clearColor()
            Graph.gridBackgroundColor = UIColor.clearColor()
            Graph.xAxis.gridColor = UIColor.grayColor()
        
        
                    // Daten für den Graph
        
                    let DataLineChart : LineChartData = LineChartData()
        
                    //Daten in den Graph geben
        
                    Graph.data = DataLineChart
        
                    //Legende
        
     

    }
    
    
    
    @IBAction func Switsh(sender: AnyObject) {
       
        
        
        
        
    }
    
    
    // XAchsen Verhältnisse verändern
    
    @IBAction func Slider(sender: AnyObject) {
        
        
       if Channel1Double != []
       {
     let Slidervalue = SliderAussehen.value
        
        range = 1 + CGFloat(Slidervalue * 100)
        let Daten : LineChartData? = Graph.lineData
        let set = createSet()
        Daten?.addDataSet(set)
        Graph.notifyDataSetChanged()
        
        Graph.setVisibleXRange(minXRange: range, maxXRange: range)
       
        }
        
        
    }
    
    
    
    
    
    
 // Daten Einfügen
    
    func addEntry()
    {
  
        let Daten : LineChartData? = Graph.lineData

        if Daten != nil
        {
            
            
            
            
            
            
            var set : LineChartDataSet? = Daten?.getDataSetByIndex(0) as? LineChartDataSet
      
            
            if firsttime == true{
            set = createSet()
                Daten?.addDataSet(set)
                    
            }
            
           
               
            Daten?.addXValue("") //XVariablenString[Index]
                
            if Schalter == true
                
            {
            Entry = ChartDataEntry(value: Channel1Double[0], xIndex: xStelle )
                }
                    
            else{
                
            Entry = ChartDataEntry(value: Channel2Double[0], xIndex: xStelle )
                
                }
               
   
            Daten?.addEntry(Entry, dataSetIndex: 0)
                
            print("Entry : \(Entry)")
            xStelle += 1
            
            


            
            
            
            
            Graph.notifyDataSetChanged()
            
            Graph.setVisibleXRange(minXRange: range, maxXRange: range)
          
            
            
            if SwitchAussehen.on
            {
            Graph.moveViewToX((Daten?.xValCount)! - Int(range + 1))
            //Graph.moveViewToX((Daten?.xValCount)! - 1)
            }
            
        }
    }

    


    
    func createSet() -> LineChartDataSet
    {
        let set : LineChartDataSet = LineChartDataSet(yVals: nil, label: "Daten")
              //set.axisDependency = .Left
        set.axisDependency = .Left
        set.drawCubicEnabled = true
        set.drawCirclesEnabled = false
        
        set.setColor(UIColor.grayColor().colorWithAlphaComponent(0.5))
        set.setCircleColor(UIColor.whiteColor())
       // set.circleRadius = 0
        
        set.lineWidth = 2
        set.fillAlpha = 65/255
        set.drawCircleHoleEnabled = true
       // set.cubicIntensity = 0.1
        
        
        return set
        
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
                    
                    addEntry()
                    
                    
                }
                
 
                
               
                print("Channel1 : \(Channel1)")
                print("Channel2 : \(Channel2)")
                print("XVariable für Channel 1 : \(XVariablenString)")
                print("Channel 1 in Double: \(Channel1Double)")
                print("Settings : \(Command1)")
                print("Control: \(Control)")
                
                print("////////////////////////////////////////////")
                print("////////////////////////////////////////////")
                print("////////////////////////////////////////////")
                
                
                
                Beschriften()
                
               // Graph.animate(xAxisDuration: 0.01, yAxisDuration: 0)
            }
        }
    }
    

    
    
    @IBOutlet weak var Channel2Aussehen: UIButton!
    @IBOutlet weak var Channel1Aussehen: UIButton!
   
    
    
    @IBAction func Channel2Button(sender: AnyObject) {
        
        
        Schalter = false
        Channel2Aussehen.enabled = false
        Channel1Aussehen.enabled = true
        
        
    }
    
    

    
    @IBAction func Channel1Button(sender: AnyObject) {
        
        Schalter = true
        Channel1Aussehen.enabled = false
        Channel2Aussehen.enabled = true
        
        
    }
    
    
    

    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
        
        
    
    


}
