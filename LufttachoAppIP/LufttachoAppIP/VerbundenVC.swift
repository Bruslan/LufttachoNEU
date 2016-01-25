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
   
    var DatenfürdenGraph = [Double]()
    var Characters = [CBCharacteristic]()
    
    @IBAction func Disconnect(sender: AnyObject) {
        
        manager.cancelPeripheralConnection(PeripheralGerät!)
        
    }
    
    
        override func viewDidLoad() {
        super.viewDidLoad()
            

            
            
            
            
            manager.delegate = self
            
            
            
            
          // Beispiel Chart
            
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
            
            
        
            let l : ChartLegend = Graph.legend
            Graph.invalidateIntrinsicContentSize()
           
            //var Xachse = [Int](count: DatenfürdenGraph.count, repeatedValue: 1)
    
          
  
            
            
            Graph.backgroundColor? = UIColor.clearColor()
            Graph.gridBackgroundColor = UIColor.clearColor()
            Graph.xAxis.gridColor = UIColor.whiteColor()



    }
    
    func initialiseChart()
    
    {
        //var set1 : ChartDataSet = ChartDataSet(yVals: "Volume")
        
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
        
        //if let PeripheralGerät = PeripheralGerät
        //{
        
        PeripheralGerät.discoverServices(nil)
        }
        //}
        
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
    func Beschriften ()
    {
        
        
        for i in Characters
        {
            
            var value = NSInteger(9223372036854775807)
            
            let valueData : NSData = NSData(bytes: &value, length: 1)
            PeripheralGerät!.writeValue(valueData, forCharacteristic: i, type: CBCharacteristicWriteType.WithResponse)
        }
        
    }
    

    

    
    func peripheral(peripheral: CBPeripheral, didUpdateValueForCharacteristic characteristic: CBCharacteristic, error: NSError?) {
        if let Value = characteristic.value
        {
            if characteristic.UUID == CBUUID(string:"00000002-0000-1000-8000-008025000000"){
            
          print("Raw NSData Value :\(Value)") //
          



                
                
                
                
                
                if Value.length == 20
                {
                Channel1Double.removeAll()
                XVariablegerundet.removeAll()
                XVariablenString.removeAll()
                Command(Value)

                    
                }
                


                
                print("Channel1 : \(Channel1)")
                print("Channel2 : \(Channel2)")
                print(XVariablenString)
                print(Channel1Double)
                
                Beschriften()
                
                
      

    
                
   //setChart(XVariablegerundet, values: Channel1Double)
                setChart2(XVariablenString)
             
                
                Graph.animate(xAxisDuration: 0.01, yAxisDuration: 0.01)


      
               // let Xachse = [String](count: DatenfürdenGraph.count, repeatedValue:"1")
                
                
                //var Xachse = [Double]()
              
              
                
            
                

                
                

            }
        }
    }
    

    
    
    
    func addEntry()
    {
        
        
        
    }
    
    
    
    
    
    
    func setChart2(Xachse : [String])
    {
        var yAchse : [ChartDataEntry] = [ChartDataEntry]()
        for var i = 0; i < Xachse.count; i++
        {
            yAchse.append(ChartDataEntry(value: Channel1Double[i], xIndex: i))  //Channel1Double[i]
            
        }
        
        
        let set1: LineChartDataSet = LineChartDataSet(yVals: yAchse, label: "Daten")
        set1.axisDependency = .Left
        set1.setColor(UIColor.redColor().colorWithAlphaComponent(0.5))
        set1.setCircleColor(UIColor.redColor())
        set1.circleRadius = 6
        set1.lineWidth = 2
        set1.fillAlpha = 65/255
        set1.drawCircleHoleEnabled = true
        
        var DataSets : [LineChartDataSet] = [LineChartDataSet]()
        DataSets.append(set1)
        var data2 : LineChartData = LineChartData(xVals: Xachse, dataSets: DataSets)
        
        
        
        self.Graph.data = data2
        
        
        
         Graph.notifyDataSetChanged()
        
        
        
        
    }

    
    

    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    
    func setChart(Xwerte: [Double], values: [Double]) {
        
        var dataEntries: [ChartDataEntry] = []
        
        for var i = 0; i < Xwerte.count; i++ {
            
            
            
            let dataEntry = ChartDataEntry(value: values[i], xIndex: i)

            dataEntries.append(dataEntry)
        

        let lineChartDataSet = LineChartDataSet(yVals: dataEntries, label: "Daten")
            lineChartDataSet.circleRadius = 3
        let lineChartData = LineChartData(xVals: Xwerte, dataSet: lineChartDataSet)
            lineChartDataSet.lineWidth = 2
            lineChartDataSet.drawCircleHoleEnabled = true
            
            
            
            
            
            
            
            
            
            Graph.data = lineChartData
            
            
            
        }
        
        
        
    
    }


}
