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
    var bluetoothReady = false;
    var centralManager:CBCentralManager!
    var connectedDevice:CBPeripheral! // ! means implicitly unwrapper optional
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startUpCentralManager();
    }

    func startUpCentralManager() {
        centralManager = CBCentralManager(delegate: self, queue: nil)
    }
    
    
    func centralManagerDidUpdateState(central: CBCentralManager!) {
        println("checking state")
        switch(central.state) {
            case .PoweredOff:
                println("Device is powered off")
            case .PoweredOn:
                println("Device is powered on and ready")
                bluetoothReady = true
            case .Resetting:
                println("Device is currently resetting")
            case .Unauthorized:
                println("Device is not authored to use this bluethooth device")
            case .Unknown:
                println("Corebluthooth BLE state is unknown")
            case .Unsupported:
                println("This device is not supported")
        }
        
        if bluetoothReady {
            discoverDevices();
        }
    }
    
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

