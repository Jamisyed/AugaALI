//
//  AGAListenVoice+Ext.swift
//  Agua
//
//  Created by Muneesh Chauhan on 26/08/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import Foundation
import UIKit
import Speech
extension AGAHomeVC {
    func startListening() {
        DispatchQueue.main.async {
            self.audioRecorder.startRecording()
        }
        self.registerClouser()
    }
    func registerClouser() {
        self.audioRecorder.didHypothesizeTranscription = {[weak self] (formattedString, _) in
            guard let `self` = self else {return}
            debugPrint("formattedString", formattedString)
            self.viewModel.speakString = formattedString
            self.isCommandExistInInstructionSet()
        }
    }
    func removeRegisterClouser() {
        self.audioRecorder.didHypothesizeTranscription = { (_, _) in
        }
    }
}
