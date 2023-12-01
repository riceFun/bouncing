import Cocoa
import FlutterMacOS
import AVFoundation


@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
    var window: NSWindow?
    override func applicationDidFinishLaunching(_ notification: Notification) {
        window = NSApplication.shared.windows.first
        //        ///channel-Rtmp
        //        let channelRtmp = FlutterMethodChannel(name: "com.push.rtmp", binaryMessenger: flutterViewController.engine.binaryMessenger)
        //        channelRtmp.setMethodCallHandler { (call, result) in
        //            if call.method == "push" {
        //                if let args = call.arguments as? Dictionary<String, Any>,
        //                   let videoPath = args["videoPath"] as? String,
        //                   let pushUrl = args["pushUrl"] as? String {
        //                    print("videoPath: \(videoPath) \n pushUrl:\(pushUrl)")
        //                    FFmpegKit.execute("-re -i \(videoPath) -c:v copy -c:a aac -b:a 192k -strict -2 -f flv \(pushUrl)")
        //                    result("rtmp-----------")
        //                } else {
        //                    result(FlutterError(code: "UNAVAILABLE", message: "Cannot resize the window", details: nil))
        //                }
        //            }
        //        }
        
        let channelCenter = FlutterMethodChannel(name: "bouncing", binaryMessenger: flutterViewController.engine.binaryMessenger)
        channelCenter.setMethodCallHandler { (call, result) in
            if call.method == "preConfig" {
                Mp3PlayCenter.shared;
                ScreenRecording.shared;
                
                result("\(call.method) ok")
            } else if call.method == "resizeWindow" {
                if let args = call.arguments as? Dictionary<String, Any>,
                   let width = args["width"] as? Double,
                   let height = args["height"] as? Double {
                    self.window?.setContentSize(NSSize(width: width, height: height))
                    result("\(call.method) ok")
                } else {
                    result(FlutterError(code: "UNAVAILABLE", message: "Cannot \(call.method)", details: nil))
                }
            } else if call.method == "audioPlay" {
                if let index = call.arguments as? Int {
                    Mp3PlayCenter.shared.play(index: index)
                    result("\(call.method) ok")
                } else {
                    result(FlutterError(code: "UNAVAILABLE", message: "Cannot \(call.method)", details: nil))
                }
            } else if call.method == "startVideoRecord" {
                ScreenRecording.shared.startRecording();
                result("\(call.method) ok")
            } else if call.method == "stopVideoRecord" {
                ScreenRecording.shared.stopRecording();
                result("\(call.method) ok")
            }
        }
    }
    
    override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

class Mp3PlayCenter {
    static let shared = Mp3PlayCenter()
    var audioPlayerList: [AVAudioPlayer] = []
    let audioNum = 108
    
    private init() {
        for index in 1...audioNum {
            var audioPlayer: AVAudioPlayer
            var pIndex = index % 7
            if (pIndex == 0) {
                pIndex = 7
            }
            print("The number is: \(pIndex)")
            
            do {
                audioPlayer = try AVAudioPlayer.init(contentsOf: URL(fileURLWithPath:Bundle.main.path(forResource: "\(pIndex)", ofType: "mp3")!))
                audioPlayer.prepareToPlay()
            } catch {
                audioPlayer = AVAudioPlayer()
                // 或者使用默认初始化
                print("Error creating audioPlayer1: \(error.localizedDescription)")
            }
            audioPlayerList.append(audioPlayer)
        }
    }
    var curIndex: Int = 0;
    
    func play(index: Int) {
        audioPlayerList[curIndex].play();
        curIndex = curIndex + 1;
        if (curIndex > audioNum - 1) {
            curIndex = 0
        }
    }
}

//class Mp3PlayCenter {
//    static let shared = Mp3PlayCenter()
//    var audioPlayer1: AVAudioPlayer
//    var audioPlayer2: AVAudioPlayer
//    var audioPlayer3: AVAudioPlayer
//    var audioPlayer4: AVAudioPlayer
//    var audioPlayer5: AVAudioPlayer
//    var audioPlayer6: AVAudioPlayer
//    var audioPlayer7: AVAudioPlayer
//
//    private init() {
//        do {
//            audioPlayer1 = try AVAudioPlayer.init(contentsOf: URL(fileURLWithPath:Bundle.main.path(forResource: "1", ofType: "mp3")!))
//            audioPlayer2 = try AVAudioPlayer.init(contentsOf: URL(fileURLWithPath:Bundle.main.path(forResource: "2", ofType: "mp3")!))
//            audioPlayer3 = try AVAudioPlayer.init(contentsOf: URL(fileURLWithPath:Bundle.main.path(forResource: "3", ofType: "mp3")!))
//            audioPlayer4 = try AVAudioPlayer.init(contentsOf: URL(fileURLWithPath:Bundle.main.path(forResource: "4", ofType: "mp3")!))
//            audioPlayer5 = try AVAudioPlayer.init(contentsOf: URL(fileURLWithPath:Bundle.main.path(forResource: "5", ofType: "mp3")!))
//            audioPlayer6 = try AVAudioPlayer.init(contentsOf: URL(fileURLWithPath:Bundle.main.path(forResource: "6", ofType: "mp3")!))
//            audioPlayer7 = try AVAudioPlayer.init(contentsOf: URL(fileURLWithPath:Bundle.main.path(forResource: "7", ofType: "mp3")!))
//
//            audioPlayer1.prepareToPlay()
//            audioPlayer2.prepareToPlay()
//            audioPlayer3.prepareToPlay()
//            audioPlayer4.prepareToPlay()
//            audioPlayer5.prepareToPlay()
//            audioPlayer6.prepareToPlay()
//            audioPlayer7.prepareToPlay()
//        } catch {
//            audioPlayer1 = AVAudioPlayer()  
//            audioPlayer1 = AVAudioPlayer()
//            audioPlayer2 = AVAudioPlayer()
//            audioPlayer3 = AVAudioPlayer()
//            audioPlayer4 = AVAudioPlayer()
//            audioPlayer5 = AVAudioPlayer()
//            audioPlayer6 = AVAudioPlayer()
//            audioPlayer7 = AVAudioPlayer()
//            // 或者使用默认初始化
//            print("Error creating audioPlayer1: \(error.localizedDescription)")
//        }
//    }
//    
//    func play(index: Int) {
//        if (index == 0) {
//            audioPlayer1.play()
//        } else if (index == 1) {
//            audioPlayer2.play()
//        } else if (index == 2) {
//            audioPlayer3.play()
//        } else if (index == 3) {
//            audioPlayer4.play()
//        } else if (index == 4) {
//            audioPlayer5.play()
//        } else if (index == 5) {
//            audioPlayer6.play()
//        } else if (index == 6) {
//            audioPlayer7.play()
//        }
//        
//    }
//}
    
    
    //class Mp3PlayCenter {
    //    static let shared = Mp3PlayCenter()
    //    let audioPlayerList: [AVAudioPlayer]
    //    let audioPlayer1: AVAudioPlayer = AVAudioPlayer()
    //    let audioPlayer2: AVAudioPlayer = AVAudioPlayer()
    //    let audioPlayer3: AVAudioPlayer = AVAudioPlayer()
    //    let audioPlayer4: AVAudioPlayer = AVAudioPlayer()
    //    let audioPlayer5: AVAudioPlayer = AVAudioPlayer()
    //    let audioPlayer6: AVAudioPlayer = AVAudioPlayer()
    //    let audioPlayer7: AVAudioPlayer = AVAudioPlayer()
    //    let urlList: [URL]
    //    init() {
    ////        audioPlayerList = [
    ////            //            AVAudioPlayer.init(contentsOf: URL(fileURLWithPath:Bundle.main.path(forResource: "1", ofType: "mp3")!)),
    ////            AVAudioPlayer(),
    ////            AVAudioPlayer(),
    ////            AVAudioPlayer(),
    ////            AVAudioPlayer(),
    ////            AVAudioPlayer(),
    ////            AVAudioPlayer(),
    ////        ]
    ////        urlList = [
    ////            URL(fileURLWithPath:Bundle.main.path(forResource: "1", ofType: "mp3")!),
    ////            URL(fileURLWithPath:Bundle.main.path(forResource: "2", ofType: "mp3")!),
    ////            URL(fileURLWithPath:Bundle.main.path(forResource: "3", ofType: "mp3")!),
    ////            URL(fileURLWithPath:Bundle.main.path(forResource: "4", ofType: "mp3")!),
    ////            URL(fileURLWithPath:Bundle.main.path(forResource: "5", ofType: "mp3")!),
    ////            URL(fileURLWithPath:Bundle.main.path(forResource: "6", ofType: "mp3")!),
    ////            URL(fileURLWithPath:Bundle.main.path(forResource: "7", ofType: "mp3")!),
    ////        ]
    //    }
    //    //    var audioPlayerList: [AVAudioPlayer]
    //    //    init() {
    //    //        audioPlayerList.add(AVAudioPlayer())
    //    //        audioPlayerList.add(AVAudioPlayer())
    //    //        audioPlayerList.add(AVAudioPlayer())
    //    //        audioPlayerList.add(AVAudioPlayer())
    //    //        audioPlayerList.add(AVAudioPlayer())
    //    //        audioPlayerList.add(AVAudioPlayer())
    //    //        audioPlayerList.add(AVAudioPlayer())
    //    //    }
    //
    //     func play(index:Int) {
    //        audioPlayer1.play()
    //    }
    //}
