//
//  AGAListenVoiceVC.swift
//  Agua
//
//  Created by Muneesh Chauhan on 13/08/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import UIKit
import Speech
class AGAHomeVC: AGABaseVC, Identifiable {
    @IBOutlet weak var tapToSpeakView: UIView!
    @IBOutlet weak var micButton: KTButton!
    @IBOutlet weak var bottomView: UIView!
    let vcFactory: KTVCFactoryProtocol = KTVCFactory()
    var viewModel = AGAListenVoiceVM()
    var audioRecorder = AudioManger.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        addGradient(view: self.bottomView)
        startListening()
    }
    deinit {
        debugPrint("AGAListenVoiceVC")
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.audioRecorder = AudioManger.shared
        self.registerClouser()
        let timer = Timer
            .scheduledTimer(
                timeInterval: TimeInterval(AGANumericConstants.three), target: self,
                selector: #selector(AGAHomeVC.restartPlayer),
                userInfo: nil, repeats: false)
        RunLoop.current.add(timer, forMode: .common)
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
    }
    override public func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        checkPermissions()
    }
    @objc func restartPlayer() {
        guard let task = audioRecorder.recognitionTask,
            let audioEngine = audioRecorder.audioEngine,
            audioEngine.isRunning, !task.isCancelled,
            task.error == nil else {
                audioRecorder.stopRecording()
                audioRecorder.startRecording()
                return
        }
    }
}
extension AGAHomeVC {
    @discardableResult
    func isCommandExistInInstructionSet() -> Bool {
        if viewModel.speakString.lowercased()
            .contains(AGAStringConstants.ListenVoice.kAgua.lowercased()) {
            self.navigateToSongListVC()
            return true
        } else if viewModel.speakString.lowercased()
            .contains(AGAStringConstants.ListenVoice.kAguaText.lowercased()) {
            self.navigateToSongListVC()
            return true
        } else   if viewModel.speakString.lowercased()
            .contains(AGAStringConstants.ListenVoice.klisten.lowercased()) {
            self.navigateToSongListVC()
            return true
        }
        return false
    }
    private func navigateToSongListVC() {
        self.removeRegisterClouser()
        guard let viewController = vcFactory.instatiateMusicInfo() else { return }
        self.navigationController?.pushViewController(viewController, animated: false)
    }
    private func checkPermissions() {
        SFSpeechRecognizer.requestAuthorization { authStatus in
            DispatchQueue.main.async {
                switch authStatus {
                case .authorized: break
                default: self.handlePermissionFailed()
                }
            }
        }
    }
    private func handlePermissionFailed() {
        // Present an alert asking the user to change their settings.
        let alertController = UIAlertController(title: AGAStringConstants.ListenVoice.kAccessSpeech,
                                                message: AGAStringConstants.ListenVoice.kUpgradeSetting,
                                                preferredStyle: .alert)
        alertController.addAction(UIAlertAction(
            title: AGAStringConstants.ListenVoice.kOpenSettings,
            style: .default) { _ in
                let url = URL(string: UIApplication.openSettingsURLString)!
                UIApplication.shared.open(url)
        })
        alertController.addAction(UIAlertAction(title: AGAStringConstants.ListenVoice.kClose, style: .cancel))
        present(alertController, animated: true)
    }
}

// MARK: - IBAction
extension AGAHomeVC {
    @IBAction func logoutAction(_ sender: KTButton) {
        if let profileVC = vcFactory.profileVC() {
            self.navigationController?.present(profileVC, animated: true, completion: nil)
        }
    }
    @IBAction func micButtonAction(_ sender: KTButton) {
        debugPrint("Mic Button tap.")
        self.removeRegisterClouser()
        guard let viewController = vcFactory.instatiateMusicInfo() else { return }
        self.navigationController?.pushViewController(viewController, animated: false)
    }
}
