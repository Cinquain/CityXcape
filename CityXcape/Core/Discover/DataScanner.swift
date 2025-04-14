//
//  DataScanner.swift
//  CityXcape
//
//  Created by James Allan on 9/9/24.
//

import SwiftUI
import VisionKit


struct DataScannerRepresentable: UIViewControllerRepresentable {
    @Environment(\.dismiss) private var dismiss

    @Binding var shouldStartScanning: Bool
    @Binding var scannedText: String
    
    var dataToScanFor: Set<DataScannerViewController.RecognizedDataType>
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, DataScannerViewControllerDelegate {
        var parent: DataScannerRepresentable
        
        init(parent: DataScannerRepresentable) {
            self.parent = parent
        }
        
        
        func dataScanner(_ dataScanner: DataScannerViewController, didTapOn item: RecognizedItem) {
            switch item {
            case .text(let text):
                parent.scannedText = text.transcript
                parent.shouldStartScanning = false 
            case .barcode(let barcode):
                parent.scannedText = barcode.payloadStringValue ?? "Unable to decode scanned code"
            default:
                print("Unexpected Item")
            }
        }
        
    }
    
    @MainActor 
    func makeUIViewController(context: Context) ->  DataScannerViewController {
        let dataScannerVC = DataScannerViewController(
            recognizedDataTypes: dataToScanFor,
            qualityLevel: .accurate,
            recognizesMultipleItems: true,
            isHighFrameRateTrackingEnabled: true,
            isPinchToZoomEnabled: true,
            isGuidanceEnabled: true,
            isHighlightingEnabled: true
        )
        dataScannerVC.delegate = context.coordinator
        return dataScannerVC
    }
    
    @MainActor 
    func updateUIViewController(_ uiViewController: DataScannerViewController, context: Context) {
        if shouldStartScanning {
            try? uiViewController.startScanning()
        } else {
            uiViewController.stopScanning()
            uiViewController.dismiss(animated: true)
        }
    }
        
    
}
