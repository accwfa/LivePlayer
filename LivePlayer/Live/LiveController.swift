

//
//  ViewController.swift
//  LivePlayer
//
//  Created by yuan on 2018/10/22.
//  Copyright © 2018年 com.liveplayer. All rights reserved.
//

import UIKit
import LFLiveKit


class LiveController: UIViewController, LFLiveSessionDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.hidesBackButton = false
         cameraBack()
        session.delegate = self
        session.preView = self.view
        
        self.requestAccessForVideo()
        self.requestAccessForAudio()
        self.view.backgroundColor = UIColor.clear
        self.view.addSubview(containerView)
        containerView.addSubview(stateLabel)
        containerView.addSubview(closeButton)
        containerView.addSubview(beautyButton)
        containerView.addSubview(cameraButton)
        containerView.addSubview(startLiveButton)
        
        
        cameraButton.addTarget(self, action: #selector(didTappedCameraButton(_:)), for:.touchUpInside)
        beautyButton.addTarget(self, action: #selector(didTappedBeautyButton(_:)), for: .touchUpInside)
        startLiveButton.addTarget(self, action: #selector(didTappedStartLiveButton(_:)), for: .touchUpInside)
        closeButton.addTarget(self, action: #selector(didTappedCloseButton(_:)), for: .touchUpInside)
        
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    //MARK: AccessAuth
    
    func requestAccessForVideo() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for: AVMediaType.video);
        switch status  {
        // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.video, completionHandler: { (granted) in
                if(granted){
                    DispatchQueue.main.async {
                        self.session.running = true
                    }
                }
            })
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            session.running = true;
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    func requestAccessForAudio() -> Void {
        let status = AVCaptureDevice.authorizationStatus(for:AVMediaType.audio)
        switch status  {
        // 许可对话没有出现，发起授权许可
        case AVAuthorizationStatus.notDetermined:
            AVCaptureDevice.requestAccess(for: AVMediaType.audio, completionHandler: { (granted) in
                
            })
            break;
        // 已经开启授权，可继续
        case AVAuthorizationStatus.authorized:
            break;
        // 用户明确地拒绝授权，或者相机设备无法访问
        case AVAuthorizationStatus.denied: break
        case AVAuthorizationStatus.restricted:break;
        default:
            break;
        }
    }
    
    //MARK: - Callbacks
    
    // 回调
    func liveSession(_ session: LFLiveSession?, debugInfo: LFLiveDebug?) {
        print("debugInfo: \(debugInfo?.currentBandwidth)")
    }
    
    func liveSession(_ session: LFLiveSession?, errorCode: LFLiveSocketErrorCode) {
        print("errorCode: \(errorCode.rawValue)")
    }
    
    func liveSession(_ session: LFLiveSession?, liveStateDidChange state: LFLiveState) {
        print("liveStateDidChange: \(state.rawValue)")
        switch state {
        case LFLiveState.ready:
            stateLabel.text = "未连接"
            break;
        case LFLiveState.pending:
            stateLabel.text = "连接中"
            break;
        case LFLiveState.start:
            stateLabel.text = "已连接"
            break;
        case LFLiveState.error:
            stateLabel.text = "连接错误"
            break;
        case LFLiveState.stop:
            stateLabel.text = "未连接"
            break;
        default:
            break;
        }
    }
    
    //MARK: - Events
    
    // 开始直播
    @objc func didTappedStartLiveButton(_ button: UIButton) -> Void {
        startLiveButton.isSelected = !startLiveButton.isSelected;
        if (startLiveButton.isSelected) {
            startLiveButton.setTitle("结束", for: UIControlState())
            let stream = LFLiveStreamInfo()
            //            stream.url = "rtmp://live.hkstv.hk.lxdns.com:1935/live/stream153"
            stream.url = "rtmp://45.32.201.195:1935/rtmplive/stream153"
            session.startLive(stream)
        } else {
            startLiveButton.setTitle("开始", for: UIControlState())
            session.stopLive()
        }
    }
    
    // 美颜
    @objc func didTappedBeautyButton(_ button: UIButton) -> Void {
        session.beautyFace = !session.beautyFace;
        beautyButton.isSelected = !session.beautyFace
    }
    
    // 摄像头
    @objc func didTappedCameraButton(_ button: UIButton) -> Void {
        cameraBack()
    }
    func cameraBack(){
        let devicePositon = session.captureDevicePosition;
        session.captureDevicePosition = (devicePositon == AVCaptureDevice.Position.back) ? AVCaptureDevice.Position.front : AVCaptureDevice.Position.back;
    }
    // 关闭
    @objc func didTappedCloseButton(_ button: UIButton) -> Void  {
        if startLiveButton.currentTitle == "结束" {
            session.stopLive()
        }
        self.navigationController?.popViewController(animated: true)
    }
    
    //MARK: - Getters and Setters
    
    //  默认分辨率368 ＊ 640  音频：44.1 iphone6以上48  双声道  方向竖屏
    var session: LFLiveSession = {
        let audioConfiguration = LFLiveAudioConfiguration.defaultConfiguration(for: LFLiveAudioQuality.high)
        let videoConfiguration = LFLiveVideoConfiguration.defaultConfiguration(for: LFLiveVideoQuality.low3)
        let session = LFLiveSession(audioConfiguration: audioConfiguration, videoConfiguration: videoConfiguration)
        return session!
    }()
    
    // 视图
    var containerView: UIView = {
        let containerView = UIView(frame: CGRect(x: 0, y: 0 , width: kScreenW, height: kScreenH))
        containerView.backgroundColor = UIColor.clear
        containerView.autoresizingMask = [UIViewAutoresizing.flexibleHeight, UIViewAutoresizing.flexibleHeight]
        return containerView
    }()
    
    // 状态Label
    var stateLabel: UILabel = {
        let stateLabel = UILabel(frame: CGRect(x: 20, y: kStatusBarH, width: 80, height: 40))
        stateLabel.text = "未连接"
        stateLabel.textColor = UIColor.white
        stateLabel.font = UIFont.systemFont(ofSize: 14)
        return stateLabel
    }()
    
    // 关闭按钮
    var closeButton: UIButton = {
        let closeButton = UIButton(frame: CGRect(x: kScreenW - 10 - 44, y: kStatusBarH, width: 50, height: 45))
        closeButton.setImage(UIImage(named: "close_preview"), for: UIControlState())
        return closeButton
    }()
    
    // 摄像头
    var cameraButton: UIButton = {
        let cameraButton = UIButton(frame: CGRect(x: kScreenW - 54 * 2, y: kStatusBarH, width: 50, height: 45))
        cameraButton.setImage(UIImage(named: "camra_preview"), for: UIControlState())
        return cameraButton
    }()
    
    // 摄像头
    var beautyButton: UIButton = {
        let beautyButton = UIButton(frame: CGRect(x: kScreenW - 54 * 3, y: kStatusBarH, width: 50, height: 45))
        beautyButton.setImage(UIImage(named: "camra_beauty"), for: UIControlState.selected)
        beautyButton.setImage(UIImage(named: "camra_beauty_close"), for: UIControlState())
        return beautyButton
    }()
    
    // 开始直播按钮
    var startLiveButton: UIButton = {
        let startLiveButton = UIButton(frame: CGRect(x: 30, y: kScreenH - kTabbarH, width: kScreenW - 10 - 44, height: 45))
        startLiveButton.layer.cornerRadius = 22
        startLiveButton.setTitleColor(UIColor.black, for:UIControlState())
        startLiveButton.setTitle("开始", for: UIControlState())
        startLiveButton.titleLabel!.font = UIFont.systemFont(ofSize: 28)
        startLiveButton.backgroundColor = UIColor.clear
        return startLiveButton
    }()
    
}


