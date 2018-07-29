//
//  ScanController.swift
//  TestAR
//

//

import UIKit
import AVFoundation

class ScanController: UIViewController, AVCaptureMetadataOutputObjectsDelegate {
  
  let videoSession = AVCaptureSession()
  var isDownloading: Bool = false
  
  override func viewDidLoad() {
    super.viewDidLoad()
    setupVideoSession()
  }
  
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    videoSession.startRunning()
  }
  
  override func viewWillDisappear(_ animated: Bool) {
    videoSession.stopRunning()
    super.viewWillDisappear(animated)
  }
  
  func setupVideoSession () {
    let discoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera],
                                                            mediaType: .video, position: .back)
    if let captureDevice = discoverySession.devices.first {
      do {
        let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        videoSession.addInput(deviceInput)
        let metadataOutput = AVCaptureMetadataOutput()
        videoSession.addOutput(metadataOutput)
        
        metadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)
        metadataOutput.metadataObjectTypes = [.qr]
        
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: videoSession)
        previewLayer.frame = self.view.bounds
        previewLayer.videoGravity = .resizeAspect
        self.view.layer.addSublayer(previewLayer)
        videoSession.startRunning()
      } catch _ {
        print("Unsupported stuff")
      }
    }
  }
  
  func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
    metadataObjects.forEach({ obj in
      guard let qrObj = obj as? AVMetadataMachineReadableCodeObject else {
        return
      }
      if qrObj.type != .qr {
        return
      }
      
      if let qrStringURL = qrObj.stringValue {
        download(qrStringURL)
      }
    })
  }
  
  func download(_ qrStringURL: String) {
    if isDownloading {
      return
    }
    
    guard let url = URL(string: qrStringURL) else {
      return
    }
    
    isDownloading = true
    
    URLSession.shared.dataTask(with: url) {[weak self] (data, response, error) in
      guard let data = data else {
        self?.isDownloading = false
        return
      }
      if let image = UIImage(data: data) {
        DispatchQueue.main.async {
         self?.displayImage(image)
        }
      }
      }.resume()
  }
  
  func displayImage(_ image: UIImage) {
    isDownloading = false
    let imageController = ImageViewController(nibName: "ImageViewController",
                                              bundle: nil,
                                              model: image)
    navigationController?.show(imageController, sender: self)
  }
  
}
