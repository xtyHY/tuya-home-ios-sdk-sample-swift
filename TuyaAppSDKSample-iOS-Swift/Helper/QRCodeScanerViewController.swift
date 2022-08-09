//
//  QRCodeScanerViewController.swift
//  TuyaAppSDKSample-iOS-Swift
//
//  Copyright (c) 2014-2022 Tuya Inc. (https://developer.tuya.com/)

import UIKit
import SGQRCode

class QRCodeScanerViewController: UIViewController {

    public var scanCallback: ((_ code: String?) -> Void)?
    
    let scanCode = SGScanCode()
    lazy var scanView: SGScanView? = {
        let config = SGScanViewConfigure()
        config.isShowBorder = true
        config.borderColor = UIColor.clear
        config.cornerColor = UIColor.white
        config.cornerWidth = 3
        config.cornerLength = 15
        config.isFromTop = true
        config.scanline = "SGQRCode.bundle/scan_scanline_qq"
        config.color = UIColor.clear
        
        let frame = CGRect(x: 0, y: 0, width: view.frame.size.width, height: view.frame.size.height)
        let v = SGScanView(frame: frame, configure: config)
        v?.startScanning()
        v?.scanFrame = frame
        return v
    }()
    
    deinit {
        stop()
    }
    
    func start() {
        scanCode.startRunning()
        scanView!.startScanning()
    }
    
    func stop() {
        scanCode.stopRunning()
        scanView!.stopScanning()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureNav()
        configureUI()
        configureQRCode()
    }
    
    func configureNav() {
        navigationItem.title = "Scan QRCode"
    }
    
    func configureUI() {
        view.addSubview(scanView!)
    }
    
    func configureQRCode() {
        scanCode.preview = view
        scanCode.delegate = self
        scanCode.startRunning()
    }

}

extension QRCodeScanerViewController: SGScanCodeDelegate {
    func scanCode(_ scanCode: SGScanCode!, result: String!) {
        stop()
        
        if let cb = scanCallback {
            cb(result)
        }
        
        if let nav = navigationController {
            nav.popViewController(animated: true)
        } else {
            dismiss(animated: true)
        }
    }
}