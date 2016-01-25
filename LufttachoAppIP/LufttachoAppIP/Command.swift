
import UIKit

var Command1 = Int16()
var Channeleins = [NSData]()
var Channelzwei = [NSData]()
 var Channel1 = [UInt16](count: 4, repeatedValue: 0)
 var Channel2 = [UInt16](count: 4, repeatedValue: 0)
var Control = Int()

var Channel11 = []
var Channel22 = []

var double : Double = 0
var XVariable : Double = 0
var XVariablegerundet  = [Double]()

var Channel1Double = [Double]()

func Command (data: NSData)
    

    
{

    // Die Stelle der BYtes bestimmen: Range(Die stelle der Bytes, und ihre LÄnge!!)
    
    
        Channel11 = [data.subdataWithRange(NSMakeRange(2, 2)),data.subdataWithRange(NSMakeRange(6, 2)),data.subdataWithRange(NSMakeRange(10, 2)),data.subdataWithRange(NSMakeRange(14, 2))]
        Channel22 = [data.subdataWithRange(NSMakeRange(4, 2)),data.subdataWithRange(NSMakeRange(8, 2)),data.subdataWithRange(NSMakeRange(12, 2)),data.subdataWithRange(NSMakeRange(16, 2))]
    
    
    //Die erste und die letzte Stelle im ankommenden Value
    
    data.getBytes(&Control, range: NSMakeRange(19,1))
        data.getBytes(&Command1, range: NSMakeRange(0,1))
    
        // die RheienFolge ändern
    
        Channeleins = [swap(Channel11[0] as! NSData, UInt8.self),swap(Channel11[1] as! NSData, UInt8.self),swap(Channel11[2] as! NSData, UInt8.self),swap(Channel11[3] as! NSData, UInt8.self)]
        Channelzwei = [swap(Channel22[0] as! NSData, UInt8.self),swap(Channel22[1] as! NSData, UInt8.self),swap(Channel22[2] as! NSData, UInt8.self),swap(Channel22[3] as! NSData, UInt8.self)]
    
    
    

    
    
   // in UInT16 Umwandeln
    
    
    for var i = 0; i < 4; ++i {
        
    Channeleins[i].getBytes(&Channel1[i], length: 2)
 
    }
    
    
    
    for var i = 0; i < 4; ++i {
        
        Channelzwei[i].getBytes(&Channel2[i], length: 2)
        
    }
    for var i = 0; i < 4; i++
    {
        
        var double2 = Double(Channel1[i])
        double = double2/600
      
        
        
        Channel1Double.insert(double, atIndex: i)
        
        XVariable += 0.01
        var Xgerundet = Double(round(100*XVariable)/100)
       XVariablegerundet.insert(Xgerundet, atIndex: i)
        
        //Verwandle die MiliSekunden in ein String, (für den Graphen)
        var StringausDouble : String = String(format: "%.2f", Xgerundet)
        XVariablenString.insert(StringausDouble, atIndex: i)
        

        
        
    }
        
        
        

   
    
  
    
    
    /*
    data.getBytes(&Channel1[0], range: NSMakeRange(2,2))
     data.getBytes(&Channel2[0], range: NSMakeRange(4,2))
     data.getBytes(&Channel1[1], range: NSMakeRange(6,2))
     data.getBytes(&Channel2[1], range: NSMakeRange(8,2))
     data.getBytes(&Channel1[2], range: NSMakeRange(10,2))
     data.getBytes(&Channel2[2], range: NSMakeRange(12,2))
     data.getBytes(&Channel1[3], range: NSMakeRange(14,2))
     data.getBytes(&Channel2[3], range: NSMakeRange(16,2))
    
    
    data.getBytes(&Control, range: NSMakeRange(19,1))
    
 
    print("Channel1 Values: \(Channel1)")
    
    print(" Channel 2 Values: \(Channel2)")
    print("Control Values: \(Control)")
    
    */

}
// Inversion der Bytes

func swap<U:IntegerType>(data:NSData,_ :U.Type) -> NSData{
    var length = data.length / sizeof(U)
    
    var bytes = [U](count: length, repeatedValue: 0)
    data.getBytes(&bytes, length: data.length)
    // since byteSwapped isn't declare in any protocol, so we have do it by ourselves manually.
    var inverse = bytes.enumerate().reduce([U](count: length, repeatedValue: 0)) { (var pre, ele) -> [U] in
        pre[length - 1 - ele.index] = ele.element
        return pre
    }
    return NSData(bytes: inverse, length: data.length)
}
