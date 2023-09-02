//
//  AudioManger.swift
//  Agua
//
//  Created by vikash singh on 9/16/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import Foundation
import Speech
class AudioManger: NSObject {
    class  var shared: AudioManger {
        struct Singleton {
            static let instance = AudioManger()
        }
        return Singleton.instance
    }
    var uttaranceCompleted = false
    var speechRecognitionTaskFinal:(() -> Void)?
    var speechRecognitionTaskFinish:((_ formatedString: String) -> Void)?
    var didHypothesizeTranscription: ((_ formatedString: String, _ subString: [String]) -> Void)?
    var audioEngine: AVAudioEngine!
    var inputNode: AVAudioInputNode!
    var audioSession: AVAudioSession!
    var recognitionRequest: SFSpeechAudioBufferRecognitionRequest?
    let speechRecognizer = SFSpeechRecognizer(locale: Locale.current)
    var recognitionTask: SFSpeechRecognitionTask?
    override init() {
        super.init()
        self.loadComponent()
    }
    func loagoutUser() {
        guard let task = self.recognitionTask,
            let audioEngine = self.audioEngine,
            audioEngine.isRunning   else {
                return
        }
        task.cancel()
        task.finish()
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        // Stop recording.
        audioEngine.pause()
        inputNode.removeTap(onBus: 0) // Call after audio engine is stopped as it modifies the graph.
        // Stop our session.
        if audioSession != nil {
            try? audioSession.setActive(false)
            audioSession = nil
        }
    }
    fileprivate func loadComponent() {
        // MARK: 4. Start recognizing speech.
        do {
            // Activate the session.
            audioSession = AVAudioSession.sharedInstance()
            // actual
          //  try audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: .defaultToSpeaker)
            try audioSession.setCategory(.playAndRecord, mode: .spokenAudio, options: .mixWithOthers)

            debugPrint("audioSession=========", audioSession.isOtherAudioPlaying)
            try audioSession.setActive(true, options: .notifyOthersOnDeactivation)
            try audioSession.overrideOutputAudioPort(.speaker)
            // Start the processing pipeline.
        } catch {
            debugPrint("Exception=========", error)
        }
    }
    func startRecording() {
        stopRecording()
        // MARK: 2. Create a speech recognition request.
        recognitionRequest = SFSpeechAudioBufferRecognitionRequest()
        recognitionRequest?.shouldReportPartialResults = true
        if speechRecognizer?.supportsOnDeviceRecognition == true {
            recognitionRequest?.requiresOnDeviceRecognition =  true
        }
        recognitionTask = speechRecognizer?.recognitionTask(with: recognitionRequest!, delegate: self)
        // MARK: 3. Create a recording and classification pipeline.
        audioEngine = AVAudioEngine()
        inputNode = audioEngine.inputNode
        // Check if microphone is occipied by another app. If Yes return otherwise app will crash
        if inputNode.inputFormat(forBus: 0).channelCount == 0 {
            NSLog("Not enough available inputs!")
            return
        }
        let recordingFormat = inputNode.outputFormat(forBus: 0)
        inputNode.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { [weak self] (buffer, _) in
            self?.recognitionRequest?.append(buffer)
        }
        // Build the graph.
        audioEngine.prepare()
        do {
            try audioEngine.start()
        } catch {
            debugPrint("Exception=========", error)
        }
    }
    func stopRecording() {
        guard let task = self.recognitionTask,
            let audioEngine = self.audioEngine,
            audioEngine.isRunning   else {
                return
        }
        task.cancel()
        task.finish()
        recognitionRequest?.endAudio()
        recognitionRequest = nil
        // Stop recording.
        audioEngine.pause()
        inputNode.removeTap(onBus: 0) // Call after audio engine is stopped as it modifies
    }
}
extension AudioManger: SFSpeechRecognitionTaskDelegate {
    // Called when the task first detects speech in the source audio
    func speechRecognitionDidDetectSpeech(_ task: SFSpeechRecognitionTask) {
    }
    // Called for all recognitions, including non-final hypothesis
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask,
                               didHypothesizeTranscription transcription: SFTranscription) {
        let subStrings = transcription.segments.compactMap {$0.substring.lowercased()}
        self.didHypothesizeTranscription?(transcription.formattedString,
                                          subStrings)
    }
    // Called only for final recognitions of utterances. No more about the utterance will be reported
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask,
                               didFinishRecognition recognitionResult: SFSpeechRecognitionResult) {
        speechRecognitionTaskFinish?(recognitionResult.bestTranscription.formattedString)
    }
    // Called when the task is no longer accepting new audio but may be finishing final processing
    func speechRecognitionTaskFinishedReadingAudio(_ task: SFSpeechRecognitionTask) {
        debugPrint("speechRecognitionTaskFinishedReadingAudio")
    }
    // Called when the task has been cancelled, either by client app, the user, or the system
    func speechRecognitionTaskWasCancelled(_ task: SFSpeechRecognitionTask) {
        debugPrint("speechRecognitionTaskWasCancelled")
    }
    // Called when recognition of all requested utterances is finished.
    // If successfully is false, the error property of the task will contain error information
    func speechRecognitionTask(_ task: SFSpeechRecognitionTask, didFinishSuccessfully successfully: Bool) {
        if !uttaranceCompleted {
            uttaranceCompleted = true
            self.speechRecognitionTaskFinal?()
        }
        debugPrint("didFinishSuccessfully")
        /* self.resetToSpeaking()*/
    }
}
