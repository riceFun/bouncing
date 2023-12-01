//
//  screen_recording.swift
//  Runner
//
//  Created by 秀吉 on 2023/11/30.
//

import Foundation
import ReplayKit
import FlutterMacOS

class ScreenRecording: NSObject, RPPreviewViewControllerDelegate {
    // 静态常量用于保存唯一实例
    static let shared = ScreenRecording()
    var recording = false
    var outputDirectory: URL?
    
    private var previewViewController: RPPreviewViewController?

    
    override init() {
//        setupAudioEngine()
    }
    
    
    func startRecording() {
        guard RPScreenRecorder.shared().isAvailable else {
            print("ReplayKit is not available on this device.")
            return
        }
        
        outputDirectory = getOutputDirectory()
        RPScreenRecorder.shared().isMicrophoneEnabled = true
        RPScreenRecorder.shared().startRecording { [weak self] (error) in
            if let error = error {
                print("Error starting recording: \(error.localizedDescription)")
            } else {
                print("Recording started")
                self?.recording = true
            }
        }
    }
    
    func stopRecording() {
        if (recording == false) {
            return
        }
        recording = false;
        RPScreenRecorder.shared().stopRecording { [weak self] (previewController, error) in
            if let error = error {
                print("Error stopping recording: \(error.localizedDescription)")
                return
            } else if let previewController = previewController {
                // 显示预览界面
                previewController.previewControllerDelegate = self
                flutterViewController.presentAsModalWindow(previewController)
            }
        
//            self?.previewViewController = previewController
//            previewController?.previewControllerDelegate = self
//            
//            // Present the preview controller
//            
//            flutterViewController.present(previewController! as RPPreviewViewController, animated: true, completion: nil)
            
            
            
//            if let outputDirectory = self?.outputDirectory {
//                let desktopDirectory = try? FileManager.default.url(for: .desktopDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
//                let videoURL = outputDirectory.appendingPathComponent("saved_video.mp4")
//                let destinationURL = desktopDirectory?.appendingPathComponent("saved_video.mp4")
//                
//                
//                do {
//                    try FileManager.default.moveItem(at: videoURL, to: destinationURL!)
//                    print("Video saved to desktop. \(String(describing: destinationURL))")
//                } catch {
//                    print("Error moving video file: \(error.localizedDescription)")
//                }
//            }
        }
    }
    
    func getOutputDirectory() -> URL? {
        do {
            let documentsDirectory = try FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: true)
            let outputDirectory = documentsDirectory.appendingPathComponent("Recordings")
            try FileManager.default.createDirectory(at: outputDirectory, withIntermediateDirectories: true, attributes: nil)
            return outputDirectory
        } catch {
            print("Error creating output directory: \(error.localizedDescription)")
            return nil
        }
    }
    
    //        func saveVideoToLocal(url: URL) {
    //            do {
    //                let savedVideoPath = try FileManager.default.copyItem(at: url, to: outputDirectory!.appendingPathComponent("saved_video.mp4"))
    //                print("Video saved to: \(savedVideoPath.path)")
    //                // Display an alert or take further actions as needed
    //            } catch {
    //                print("Error saving video: \(error.localizedDescription)")
    //            }
    //        }
    //
    //        func previewControllerDidFinish(_ previewController: RPPreviewViewController) {
    //            dismiss(animated: true, completion: nil)
    //            if let outputDirectory = outputDirectory {
    //                saveVideoToLocal(url: outputDirectory)
    //            }
    //        }
    
}
