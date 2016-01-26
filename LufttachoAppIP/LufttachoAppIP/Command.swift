
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
var Channel2Double = [Double]()






// Verwandle NSDATA in UIint16 in Channel1/2 und Double! in Channel1/2Double

func Command (data: NSData)  
{

    // Die Stelle der Bytes bestimmen: Range(Die stelle der Bytes, und ihre LÄnge!!)
    // UNd in DIe Arrays Channel11 und Channel22 aufteilen
    // Z.B. data = Array aus 20 Bytes (NSDATA)! Index 2 mit Länge 2 (also index 2 und 3) sollen in Index 0 von dem Array Channel11!
    
    
        Channel11 = [data.subdataWithRange(NSMakeRange(2, 2)),data.subdataWithRange(NSMakeRange(6, 2)),data.subdataWithRange(NSMakeRange(10, 2)),data.subdataWithRange(NSMakeRange(14, 2))]
        Channel22 = [data.subdataWithRange(NSMakeRange(4, 2)),data.subdataWithRange(NSMakeRange(8, 2)),data.subdataWithRange(NSMakeRange(12, 2)),data.subdataWithRange(NSMakeRange(16, 2))]
    
    
    //Die erste und die letzte Stelle im ankommenden Value (data)
    
    
        data.getBytes(&Control, range: NSMakeRange(19,1))
        data.getBytes(&Command1, range: NSMakeRange(0,1))
    
        // die RheienFolge ändern
    // Bevor wir diese in Int16 umwandeln können, müssen wir die RheienFolge ändern!
    // Speichern die Spiegelverkehrte Daten aus Channel11 in Channeleins!!
    
        Channeleins = [swap(Channel11[0] as! NSData, UInt8.self),swap(Channel11[1] as! NSData, UInt8.self),swap(Channel11[2] as! NSData, UInt8.self),swap(Channel11[3] as! NSData, UInt8.self)]
        Channelzwei = [swap(Channel22[0] as! NSData, UInt8.self),swap(Channel22[1] as! NSData, UInt8.self),swap(Channel22[2] as! NSData, UInt8.self),swap(Channel22[3] as! NSData, UInt8.self)]
    
    
    

    
    
   // in UInT16 Umwandeln
    // Nun Wandeln wir die Spiegelverkehrte Daten aus Channeleins in Uint16 Zahlen um und schmeißen diese in Channel1/2
    
    for var i = 0; i < 4; ++i {
        
    Channeleins[i].getBytes(&Channel1[i], length: 2)
 
    }
    
    
    
    for var i = 0; i < 4; ++i {
        
        Channelzwei[i].getBytes(&Channel2[i], length: 2)
        
    }
    
    
    
    
    
    // DIe Daten in Channel1 und Channel2 muss ich nun durch 10 teilen 
    // DIe Daten in Channel 1 und Channel 2 teile ich auch durch 60 für Sekunden
    // Die Daten runde ich auf 2 NachkommerStelle
    // Schmiße de Gerundete Channel1 Daten ind das Array Channel1Double!!
    // Erstelle für jedes Channel1 Double Wert ein miliSekunden WErt! Jeweils 0.01
    
    
    for var i = 0; i < 4; i++
    {
        
        var double2 = Double(Channel1[i])
        double2 = double2/600
        
        // Runde double2 auf 2 stellen nachm Komma!
        let double = Double(round(double2*100)/100)
        
        
        //adde die umgewandelte Zahlen in ein Array
        Channel1Double.insert(double, atIndex: i)
        
        // Xvariable, welche unsere Zeit in ms angibt
        
        XVariable += 0.01
        let Xgerundet = Double(round(100*XVariable)/100)
        // Schmeisse sie in ein Array
        XVariablegerundet.insert(Xgerundet, atIndex: i)
        
        //Verwandle die MiliSekunden in ein String, (für den Graphen)
        let StringausDouble : String = String(format: "%.2f", Xgerundet)
        XVariablenString.insert(StringausDouble, atIndex: i)
        

        
        
    }
        

    


}

// Ändere die RheienFolge der Bytes um sie in Int16 umzuwandeln!

// Inversion der Bytes

func swap<U:IntegerType>(data:NSData,_ :U.Type) -> NSData{
    let length = data.length / sizeof(U)
    
    var bytes = [U](count: length, repeatedValue: 0)
    data.getBytes(&bytes, length: data.length)
    // since byteSwapped isn't declare in any protocol, so we have do it by ourselves manually.
    let inverse = bytes.enumerate().reduce([U](count: length, repeatedValue: 0)) { (var pre, ele) -> [U] in
        pre[length - 1 - ele.index] = ele.element
        return pre
    }
    return NSData(bytes: inverse, length: data.length)
}
