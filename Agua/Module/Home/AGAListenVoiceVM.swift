//
//  AGAListenVoiceVM.swift
//  Agua
//
//  Created by Muneesh Chauhan on 17/08/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import Foundation

class AGAListenVoiceVM {
    var speakString = ""
    var listeningMode: AGAListeningMode?
    var timerForUserNoSpeak = Timer()
    var timerForUserCompleteCommand = Timer()
    var detectionTimer = Timer()
    var timerToHandleNotFindInfo = Timer()
    func invalidateAllTimer() {
        self.timerForUserNoSpeak.invalidate()
        self.timerForUserCompleteCommand.invalidate()
        self.detectionTimer.invalidate()
        self.timerToHandleNotFindInfo.invalidate()

    }
}
