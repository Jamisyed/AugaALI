//
//  AGASongInfoVC.swift
//  Agua
//
//  Created by Muneesh Chauhan on 14/08/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import UIKit
import Speech
import MessageUI
class AGASongInfoVC: AGABaseVC {
    @IBOutlet weak var bgImgView: UIImageView!
    @IBOutlet weak var micButton: KTButton!
    @IBOutlet weak var artistNameLbl: KTLabel!
    @IBOutlet weak var albumNameLbl: KTLabel!
    @IBOutlet weak var titleLbl: KTLabel!
    @IBOutlet weak var bookmarkView: UIView!
    @IBOutlet weak var animatedImgView: UIImageView!
    var model: AGAMusicTrack?
    var restartTimer: Timer?
    var viewModel = SongsListViewModel()
    var commandDetected = false
    var deviceSpeaked = false
    let synthesizer = AVSpeechSynthesizer()
    var isPopupDisplayed = false
    var audioRecorder = AudioManger.shared
    override func viewDidLoad() {
        super.viewDidLoad()
        bgImgView.image = #imageLiteral(resourceName: "Img-headphones-blur.png").blurImage()
        showMusicInfo()
        addGradient(view: bookmarkView)
        synthesizer.delegate = self
    }
    deinit {
        debugPrint("Dinit AGASongInfoVC")
    }
    @IBAction func crossButtonAction(_ sender: KTButton) {
        synthesizer.stopSpeaking(at: .immediate)
        self.audioRecorder.stopRecording()
        self.restartTimer?.invalidate()
        self.restartTimer = nil
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func micButtonTapped(_ sender: KTButton) {
        self.commandDetected = false
        self.micButton.setImage(#imageLiteral(resourceName: "group"), for: .normal)
        animatedImgView.animationImages = [#imageLiteral(resourceName: "eq4"), #imageLiteral(resourceName: "eq3"), #imageLiteral(resourceName: "eq2")]
        animatedImgView.animationDuration = TimeInterval(AGANumericConstants.animationDuration)
        animatedImgView.animationRepeatCount = AGANumericConstants.zero
        animatedImgView.image = animatedImgView.animationImages?.first
        animatedImgView.isHidden = false
        DispatchQueue.main.async {
            self.audioRecorder.startRecording()
        }
    }
    @IBAction func bookmarkSongAction(_ sender: KTButton) {
    }
}
// MARK: - private methods
extension AGASongInfoVC {
    private func showMusicInfo() {
        if let externalMetaData = model?.metadata?.music?[AGANumericConstants.zero].externalMetadata {
            titleLbl.text = externalMetaData
                .spotify?.album?.name ?? model?.metadata?.music?[AGANumericConstants.zero].label
            // album name
            albumNameLbl.text = externalMetaData
                .spotify?.track?.name ?? model?.metadata?.music?[AGANumericConstants.zero].title
            // song name
            artistNameLbl.text = externalMetaData
                .spotify?.artists?[AGANumericConstants.zero].name ?? model?
                    .metadata?.music?[AGANumericConstants.zero].artists?[AGANumericConstants.zero].name
            viewModel.nameOfSong = albumNameLbl.text ?? ""
            viewModel.nameOfArtist = artistNameLbl.text ?? ""
            // artists
        } else {
            if model?.metadata?.music?.count ?? 0 > Int(AGANumericConstants.one) {
                if let externalMetaData = model?.metadata?.music?[Int(AGANumericConstants.one)].externalMetadata {
                    titleLbl.text = externalMetaData
                        .spotify?.album?.name ?? model?.metadata?.music?[AGANumericConstants.zero].label// album name
                    albumNameLbl.text = externalMetaData
                        .spotify?.track?.name ?? model?.metadata?.music?[AGANumericConstants.zero].title
                    // song name
                    artistNameLbl.text = externalMetaData
                        .spotify?.artists?[AGANumericConstants.zero].name ?? model?.metadata?
                            .music?[AGANumericConstants.zero].artists?[AGANumericConstants.zero].name
                    // artists
                    viewModel.nameOfSong = albumNameLbl.text ?? ""
                    viewModel.nameOfArtist = artistNameLbl.text ?? ""
                }
            }
        }
        if !viewModel.nameOfSong.isEmpty,
            !viewModel.nameOfArtist.isEmpty {
            let text = "its \(viewModel.nameOfSong) by" +
                "\(viewModel.nameOfArtist).       " +
            "\(AGAStringConstants.MusicInfo.wantTobookMark)"
            speechWithText(text: text)
        }
    }
}
extension AGASongInfoVC {
    private func speechWithText(text: String) {
        if synthesizer.isSpeaking { return }
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode()) // en-GB
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.audioRecorder.stopRecording()
        self.restartTimer = nil
        debugPrint("stopRecording 181")
    }
    @objc func restartPlayer() {
        guard let task = self.audioRecorder.recognitionTask,
            let audioEngine = self.audioRecorder.audioEngine,
            audioEngine.isRunning, !task.isCancelled,
            task.error == nil else {
                self.audioRecorder.stopRecording()
                self.audioRecorder.startRecording()
                return
        }
    }
    @objc func handlingForUserCompleteCommand() {
        animatedImgView.stopAnimating()
        if !viewModel.speakString.isEmpty && isCommandExistInInstructionSet(),
            (self.audioRecorder.audioEngine?.isRunning ?? true) {
            commandDetected = true
            viewModel.timerForUserCompleteCommand.invalidate()
            self.restartTimer?.invalidate()
            self.restartTimer = nil
            self.audioRecorder.stopRecording()
            debugPrint("stopRecording 208")
            if viewModel.subStringArray
                .contains(AGAStringConstants.MusicInfo.noBookMark.lowercased()) {
                    self.navigationController?.popViewController(animated: true)
                return
            }
            self.micButton.setImage(#imageLiteral(resourceName: "microphone"), for: .normal)
            self.animatedImgView.stopAnimating()
            self.animatedImgView.isHidden = true
            DispatchQueue.main.async {
                if self.isPopupDisplayed == true {
                    self.speechWithText(text: AGAStringConstants.ListenVoice.alreadyBookMark)
                    return
                }
                self.isPopupDisplayed = true
            }
        }
    }
    private func isCommandExistInInstructionSet() -> Bool {
        if viewModel.subStringArray
            .contains(AGAStringConstants.MusicInfo.kBookMarkThisSong.lowercased()) {
            return true
        } else if viewModel.subStringArray
            .contains(AGAStringConstants.MusicInfo.kBookMark.lowercased()) {
            return true
        } else if viewModel.subStringArray
            .contains(AGAStringConstants.MusicInfo.yes.lowercased()) {
            return true
        } else if viewModel.subStringArray
            .contains(AGAStringConstants.MusicInfo.noBookMark.lowercased()) {
            return true
        }
        return false
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
extension AGASongInfoVC: MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate,
AVSpeechSynthesizerDelegate {
    func messageComposeViewController(
        _ controller: MFMessageComposeViewController,
        didFinishWith result: MessageComposeResult) {
    }
    func mailComposeController(
        _ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        // Dismiss the mail compose view controller.
        controller.dismiss(animated: true, completion: nil)
    }
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        guard self.commandDetected == false else { return }
        DispatchQueue.main.async {
            self.restartTimer = nil
            self.registerClouser()
            self.audioRecorder.startRecording()
            self.commandDetected = true
        }
        let timer = Timer
            .scheduledTimer(
                timeInterval: TimeInterval(AGANumericConstants.three), target: self,
                selector: #selector(AGASongInfoVC.restartPlayer),
                userInfo: nil, repeats: true)
        self.restartTimer = timer
        RunLoop.current.add(timer, forMode: .common)
    }
    func registerClouser() {
        self.audioRecorder.didHypothesizeTranscription = {[weak self](formattedString, segments) in
            guard let `self` = self else {return}
            debugPrint("ReadText", formattedString)
            self.viewModel.subStringArray = segments
            self.animatedImgView.startAnimating()
            self.viewModel.speakString = formattedString
            self.handlingForUserCompleteCommand()
        }
    }
}
