//
//  AGASongListVC+Ext.swift
//  Agua
//
//  Created by vikash singh on 10/5/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import Foundation
import Speech
import MessageUI

extension AGASongListVC: AVSpeechSynthesizerDelegate {
    func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer,
                           didFinish utterance: AVSpeechUtterance) {
        self.registerClouser()
    }
}
extension AGASongListVC: MFMailComposeViewControllerDelegate {
    @discardableResult
    func isCommandExistInInstructionSet(_ text: String) -> Bool {
        let listenCommand1 = AGAStringConstants.ListenVoice.kWhatSongPlaying.lowercased()
        let listenCommand2 = AGAStringConstants.ListenVoice.kWhatSongIsThis.lowercased()
        let listenCommand3 = AGAStringConstants.ListenVoice.kWhatProductIsThis.lowercased()
        if text.lowercased()
            .contains(AGAStringConstants.MusicInfo.yes.lowercased()) {
            if viewModel.songJustIdentified {
                if viewModel.recognitionType == .songs {
                   self.perforUserSpeechAction(true)
                } else {
                    saveProductData()
                }
                viewModel.songJustIdentified = false
            }
            return true
        } else if text.lowercased()
                    .contains(AGAStringConstants.MusicInfo.noBookMark.lowercased()) {
            if viewModel.songJustIdentified {
                if viewModel.recognitionType == .songs {
                    self.perforUserSpeechAction(false)
                } else {
                    DispatchQueue.main.async {
                        self.onProductDetailCrossTapped()
                    }
                }
                viewModel.songJustIdentified = false
            }
            return true
        } else if text.lowercased().contains(listenCommand1) || text.lowercased().contains(listenCommand2) || text.lowercased().contains(listenCommand3) {
            // start acr client
            restartRecording()
        }
        return false
    }
    // get playlist 
    func registerClouser() {
        if UIApplication.shared.applicationState != .background {
              self.audioRecorder.startRecording()
        }
        self.audioRecorder.didHypothesizeTranscription = {[weak self] (formattedString, _) in
            guard let `self` = self else {return}
            debugPrint("formattedString", formattedString)
            let listenCommand1 = AGAStringConstants.ListenVoice.kWhatSongPlaying.lowercased()
            let listenCommand2 = AGAStringConstants.ListenVoice.kWhatSongIsThis.lowercased()
            let listenCommand3 = AGAStringConstants.ListenVoice.kWhatProductIsThis.lowercased()
            if formattedString.lowercased().contains("do you want") {
                self.speechDone = true
            }
            if self.speechDone {
                let searchText = formattedString.components(separatedBy: "do you want").last ?? formattedString
                debugPrint("recognize text", searchText)
                self.isCommandExistInInstructionSet(searchText)
            } else if self.startRecording == false {
                if (formattedString.lowercased().contains(listenCommand1)
                          || formattedString.lowercased().contains(listenCommand2)
                          || formattedString.lowercased().contains(listenCommand3)) {
                  // start acr client
                  self.restartRecording()
              }
            }
                     
        }
        self.audioRecorder.speechRecognitionTaskFinal = {[weak self] in
            if UIApplication.shared.applicationState != .background {
                self?.audioRecorder.startRecording()
            }
        }
    }
    func removeRegisterClouser() {
        self.audioRecorder.didHypothesizeTranscription = { (formattedString, _) in
        }
    }
}

// MARK: - UITableView delegate and dataSource

extension AGASongListVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        viewModel.resultArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(
            withIdentifier: AGASongTableViewCell.identifire,
            for: indexPath) as? AGASongTableViewCell else { return UITableViewCell() }
        cell.configureCellForSongs(result: viewModel.resultArr[indexPath.row])
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return CGFloat(AGANumericConstants.fiftyEight)
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectedRow = indexPath.row
        loadCardDetail(song: viewModel.resultArr[indexPath.row])
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel.loadState != .none || viewModel.currentPage == viewModel.lastPage {
            return
        }
        viewModel.loadState = .initiated
        let visibleIndexPaths = tblView.indexPathsForVisibleRows
        if let last = visibleIndexPaths?.last {
            if last.row == viewModel.resultArr.count - 1 {
                viewModel.loadState = .initiated
                if viewModel.currentPage < viewModel.lastPage {
                    viewModel.currentPage += 1
                }
                 tblView.tableFooterView = LoadingMoreView.viewFromNib()
                self.getSongsList()
            } else {
                viewModel.loadState = .none
            }
        } else {
            viewModel.loadState = .none
        }

    }
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
}
// MARK: - Spotify APIS
extension AGASongListVC {
    func saveTrackInSpotify(uri: String) {
        if !AuthManager.shared.isSignIn {
            showPopNotificationView(notiMessage: "Please connect to spotify from settings to save song in spotify playlist.", notificationType: .error)
            return
        }
        AuthManager.shared.refreshAccessTokenIfNeeded {[weak self] successs in
            if successs {
                self?.getPlayList(uri: uri)
            }
        }
    }
    func getPlayList(uri: String) {
        let apiRouter = APIRouter.getSpotifyPlayList
        viewModel.hitAPI(
            route: apiRouter) {[weak self] (response: Swift.Result<PlayListModel, CustomError>) in
                Loader.removeLoader()
                switch response {
                case .success(let result):
                    if result.items?.count ?? 0 > 0 {
                        let record = result.items?.first {$0.name == "My Agua Tracks"}
                        if let data = record {
                            self?.addSongInPlayList(playListId: data.id ?? "", uri: uri)
                        } else {
                            self?.getSpotifyUserId(uri: uri)
                        }
                    } else {
                        self?.getSpotifyUserId(uri: uri)
                    }
                case .failure(let error):
                    self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
                }
            }
    }
    func createPlayList(uri: String, spotifyUserId: String) {
        let apiRouter = APIRouter.createPlayList(userId: spotifyUserId)
        viewModel.hitAPI(
            route: apiRouter) {[weak self] (response: Swift.Result<CreatePlayListModel, CustomError>) in
                Loader.removeLoader()
                switch response {
                case .success(let result):
                    print("playlist created \(result)")
                    let playListId = result.id ?? ""
                    self?.addSongInPlayList(playListId: playListId, uri: uri)
                case .failure(let error):
                    self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
                }
            }
    }
    func addSongInPlayList(playListId: String, uri: String) {
        let urlStr = "\(spotifyBaseURL)playlists/\(playListId)/tracks"
        guard let url = URL(string: urlStr)  else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        var inputParams = [String: Any]()
        inputParams["uris"] = ["spotify:track:\(uri)"]
        inputParams["position"] = 0
        do {
            let postData = try JSONSerialization.data(withJSONObject: inputParams, options: .prettyPrinted)
            request.httpBody = postData
            let authorizationToken = "Bearer " + (AuthManager.shared.accessToken ?? "")
            request.setValue(authorizationToken, forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) {[weak self] data, urlResponse, error in
                guard let data = data, error == nil else { return }
                do {
                    let model = try JSONDecoder().decode(AddSongInPlayListModel.self, from: data)
                    print(model)
                } catch {
                    print(error.localizedDescription)
                }
            }
            task.resume()
        } catch {
            print(error)
        }
    }
    func getSpotifyUserId(uri: String) {
        let apiRouter = APIRouter.getSpotifyUserId
        viewModel.hitAPI(route: apiRouter) {[weak self] (response: Swift.Result<UserProfileModel, CustomError>) in
            Loader.removeLoader()
            switch response {
            case .success(let result):
                self?.createPlayList(uri: uri, spotifyUserId: result.id ?? "")
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
}



