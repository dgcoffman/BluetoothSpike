//
//  ViewController.swift
//  BluetoothSpike
//
//  Created by dcoffman on 3/17/15.
//  Copyright (c) 2015 ThoughtWorks. All rights reserved.
//

import UIKit
import CoreBluetooth

class ViewController: UIViewController, CBCentralManagerDelegate, CBPeripheralDelegate{
    
    @IBOutlet weak var StatusBox: UITextView!
    
    var bluetoothReady = false;
    var centralManager:CBCentralManager!
    var connectedDevice:CBPeripheral! // ! means implicitly unwrapper optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        StatusBox.text = "Loading..."
        
        startUpCentralManager();
    }

    func startUpCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    //Outputting to the console and to a text field in the UI
    //Tried to simplify with a function below but it was crashing
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        
        println("checking state")
        StatusBox.text = StatusBox.text + ("\nchecking state")
        
        switch(central.state) {
            case .PoweredOff:
                println("Device is powered off")
                StatusBox.text = StatusBox.text + ("\nDevice is powered off")
            case .PoweredOn:
                println("Device is powered on and ready")
                StatusBox.text = StatusBox.text + ("\nDevice is powered on and ready")
                bluetoothReady = true
            case .Resetting:
                println("Device is currently resetting")
                StatusBox.text = StatusBox.text + ("\nDevice is currently resetting")
            case .Unauthorized:
                println("Device is not authorized to use this bluethoth device")
                StatusBox.text = StatusBox.text + ("\nDevice is not authoreized to use this bluetooth device")
            case .Unknown:
                println("Corebluthooth BLE state is unknown")
                StatusBox.text = StatusBox.text + ("\nCore Bluretooth BLE state is unknown")
            case .Unsupported:
                println("This device is not supported")
                StatusBox.text = StatusBox.text + ("\nThis device is not supported")
        }
        
        if bluetoothReady {
            discoverDevices();
        }
    }
    
// Tried using this function above but it was intermitantly crashing with an (lldb) message
//    func refreshStatusBox(line: String) {
//        StatusBox.text = StatusBox.text + "\n\(line)"
//    }

    func discoverDevices() {
        println("Currently attempting to discover what devices are available")
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }

    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
                println("discovered a device \(peripheral.identifier)")
                centralManager.stopScan()
                connectedDevice = peripheral
                peripheral.delegate = self
                centralManager.connectPeripheral(peripheral, options: nil)
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        println("Connected to peripheral")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

