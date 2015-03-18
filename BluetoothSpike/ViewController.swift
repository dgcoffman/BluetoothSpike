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
    var jawboneUUID = "EEC0756D-6EC2-BF6F-6355-90430D968088"
    var jawboneService = "0012"
    var deviceInfoService = "180A"
    
    override func viewDidLoad() {
        super.viewDidLoad()
                
        startUpCentralManager();
    }
    
    func startUpCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    //Outputting to the console and to a text field in the UI
    //Tried to simplify with a function below but it was crashing
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        
        logMessage("checking state")
        
        switch(central.state) {
        case .PoweredOff:
            logMessage("Device is powered off")
        case .PoweredOn:
            logMessage("Device is powered on and ready")
            bluetoothReady = true
        case .Resetting:
            logMessage("Device is currently resetting")
        case .Unauthorized:
            logMessage("Device is not authorized to use this bluethoth device")
        case .Unknown:
            logMessage("Corebluethooth BLE state is unknown")
        case .Unsupported:
            logMessage("This device is not supported")
        }
        
        if bluetoothReady {
            discoverDevices();
        }
    }
    
    func logMessage(message: String) {
        println(message)
        StatusBox.text = StatusBox.text + "\n\(message)"
    }
    
    func discoverDevices() {
        logMessage("Currently attempting to discover what devices are available")
        centralManager.scanForPeripheralsWithServices(nil, options: nil)
    }
    
    func centralManager(central: CBCentralManager!, didDiscoverPeripheral peripheral: CBPeripheral!, advertisementData: [NSObject : AnyObject]!, RSSI: NSNumber!) {
        logMessage("discovered a device \(peripheral.identifier.description) \(peripheral.name)")
        if(peripheral.identifier.UUIDString == jawboneUUID){
            connectedDevice = peripheral
            peripheral.delegate = self
            centralManager.connectPeripheral(peripheral, options: nil)
        }
    }
    
    func centralManager(central: CBCentralManager!, didConnectPeripheral peripheral: CBPeripheral!) {
        logMessage("Found:  \(peripheral.name)")
        centralManager.stopScan()
        logMessage("Stopped scanning for devices. \nDiscovering services.")
        peripheral.discoverServices(nil)
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverServices error: NSError!) {
        for service in peripheral.services {
            logMessage("We discovered a service \(service.UUID) on \(peripheral.name)")
            if(service.UUID.description == jawboneService ){
                logMessage("found device info about \(peripheral.name)")
                peripheral.discoverCharacteristics(nil, forService: service as CBService)
            }
            
        }
    }
    
    func peripheral(peripheral: CBPeripheral!, didDiscoverCharacteristicsForService service: CBService!, error: NSError!) {
        
        logMessage("found service info about \(service)")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}

