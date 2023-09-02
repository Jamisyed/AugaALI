//
//  AGASongListVC.swift
//  Agua
//
//  Created by vikash singh on 9/29/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import UIKit
import RxSwift
import RxRealm
import RealmSwift
import RxRealmDataSources
import Speech
import SDWebImage
import SwiftyJSON

class AGASongListVC: AGABaseVC {
    @IBOutlet weak var viewBookmarkView: UIView!
    @IBOutlet weak var listeningSearchingLbl: UILabel!
    @IBOutlet weak var listenView: UIView!
    @IBOutlet weak var listenHeightCons: NSLayoutConstraint!
    @IBOutlet weak var listenCenterCons: NSLayoutConstraint!
    @IBOutlet weak var soundImgView: UIImageView!
    @IBOutlet weak var simmerImgView: UIImageView!
    @IBOutlet weak var waitView: UIView!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var brandNameLbl: KTLabel!
    @IBOutlet weak var productnameLbl: KTLabel!
    @IBOutlet weak var productDetailView: UIView!
    @IBOutlet weak var songDetailView: UIView!
    let vcFactory: KTVCFactoryProtocol = KTVCFactory()
    let synthesizer = AVSpeechSynthesizer()
    var holdTimer: Timer?
    var client: ACRCloudRecognition?
    var blurImage: UIImage?
    var resultNotFoundCount = 0
    let viewModel = SongsListViewModel()
    var speechDone = false
    /* Card IBOutlet START*/
    @IBOutlet weak var dimView: UIView!
    @IBOutlet weak var cardBgImageView: UIImageView!
    @IBOutlet weak var artistLbl: UILabel!
    @IBOutlet weak var cardBookMarkBtn: KTButton!
    @IBOutlet weak var cardSongName: UILabel!
    @IBOutlet weak var cardAlbumImage: UIImageView!
    @IBOutlet weak var cardSongTitle: UILabel!
    /* Card IBOutlet END*/
    let pulsator = Pulsator()
    let bag = DisposeBag()
    var audioRecorder = AudioManger.shared
    var startRecording = true
    override func viewDidLoad() {
        super.viewDidLoad()
        getSongsList()
        self.acrSetup()
    }
    func getSongsList() {
        if viewModel.currentPage == 1 {
            Loader.addLoader(self.view)
            listenView.isHidden = false
        }
        let apiRouter = APIRouter.songsList(pageNo: viewModel.currentPage)
        viewModel.hitAPI(
            route: apiRouter) {[weak self] (response: Swift.Result<ListResponseModel, CustomError>) in
                Loader.removeLoader()
                switch response {
                case .success(let result):
                    self?.viewModel.loadState = .none
                    self?.viewModel.lastPage = result.data?.meta?.lastPage ?? 0
                    if self?.viewModel.currentPage == 1 {
                        self?.viewModel.resultArr =  result.data?.result ?? []
                    } else {
                        let responseArr = result.data?.result ?? []
                        self?.viewModel.resultArr.append(contentsOf: responseArr)
                    }
                    self?.setTableLengthBasedOnSongsList()
                    self?.reloadTableView()
                case .failure(let error):
                    self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
                }
            }
    }
    private func setTableLengthBasedOnSongsList() {
        if viewModel.resultArr.count == 0 {
            self.listenHeightCons.constant =
            CGFloat(self.view.frame.height) -
            CGFloat(AGANumericConstants.listenViewSpace)
            self.listenCenterCons.constant = .zero
            viewBookmarkView.isHidden = true
        } else {
            listeningSearchingLbl.text = ""
            self.listenHeightCons.constant = CGFloat(AGANumericConstants.listenViewHeight)
           self.listenCenterCons.constant = -50 // CGFloat(AGANumericConstants.thirty)
            viewBookmarkView.isHidden = false
        }
    }
    @IBAction func viewBookmarkTapped(_ sender: KTButton) {
        guard let bookmarkVC = vcFactory.bookmarkListVC() else { return }
        self.navigationController?.pushViewController(bookmarkVC, animated: true)
    }
    @IBAction func cardCloseBtnTapped(_ sender: UIButton) {
        dimView.isHidden = true
    }
    @IBAction func purchaseAction(_ sender: KTButton) {
    }
    @IBAction func bookmarkproductAction(_ sender: KTButton) {
        saveProductData()
    }
    @IBAction func productDetailCrossActionTapped(_ sender: UIButton) {
        onProductDetailCrossTapped()
    }
    func onProductDetailCrossTapped() {
        dimView.isHidden = true
        waitView.isHidden = true
        listenView.isHidden = false
        registerClouser()
    }
    private func populateUIComponent() {
        blurImage = #imageLiteral(resourceName: "Img-headphones-blur.png").blurImage()
        self.setAnimatedImage()
        self.listenView.isHidden = false
        self.waitView.isHidden = true
        addGradient(view: self.view)
        self.tblView.register(UINib(nibName: "\(AGASongTableViewCell.self)",
                                    bundle: nil),
                              forCellReuseIdentifier: "\(AGASongTableViewCell.self)")
        self.dimView.isHidden = true
        self.pulsatorSetup()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.populateUIComponent()
        registerClouser()
    }
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        view.layer.layoutIfNeeded()
        pulsator.position = simmerImgView.layer.position
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
       // resetAllComponents()
    }
    func  resetAllComponents() {
        self.startRecording = false
        self.client?.stopRecordRec()
        self.synthesizer.stopSpeaking(at: .immediate)
        holdTimer?.invalidate()
        holdTimer = nil
    }
    @IBAction func backBtnTap(_ sender: Any) {
        self.resetAllComponents()
        self.navigationController?.popViewController(animated: false)
    }
    @IBAction func bookmarkSongAction(_ sender: KTButton) {
        let selectedRecord = viewModel.resultArr[viewModel.selectedRow]
        let bookmarkStatus = selectedRecord.bookmark?.isSubscribed ?? false
        if !bookmarkStatus {
            addToBookMarkAPI(musicId: selectedRecord.songId ?? 0)
        } else {
            if let bookmarkId = viewModel.resultArr[viewModel.selectedRow].bookmark?.bookmarkId {
                removeBookmarkAPI(bookmarkId: bookmarkId)
            }
        }
    }
    private func addToBookMarkAPI(musicId: Int) {
        let apiRouter = APIRouter.addToBookMark(musicId: musicId)
        Loader.addLoader(self.view)
        viewModel.hitAPI(route: apiRouter) {[weak self] (response: Swift.Result<AddToBookMarkModel, CustomError>) in
            Loader.removeLoader()
            switch response {
            case .success(let result):
                DispatchQueue.main.async {
                    self?.dimView.isHidden = true
                }
                self?.viewModel.resultArr[self?.viewModel.selectedRow ?? 0].bookmark?.isSubscribed = true
                self?.viewModel
                    .resultArr[self?.viewModel.selectedRow ?? 0].bookmark?.bookmarkId = result.data?.bookmarkId
                self?.reloadTableView()
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
    private func removeBookmarkAPI(bookmarkId: Int) {
        let apiRouter = APIRouter.removeBookmark(bookmarkId: bookmarkId)
        Loader.addLoader(self.view)
        viewModel.hitAPI(route: apiRouter) {[weak self] (response: Swift.Result<RemoveBookMarkModel, CustomError>) in
            Loader.removeLoader()
            switch response {
            case .success:
                DispatchQueue.main.async {
                    self?.dimView.isHidden = true
                }
                self?.viewModel.resultArr[self?.viewModel.selectedRow ?? 0].bookmark?.isSubscribed = false
                self?.viewModel.resultArr[self?.viewModel.selectedRow ?? 0].bookmark?.bookmarkId = nil
                self?.reloadTableView()
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
    func loadCardDetail(song: Result) {
        self.dimView.isHidden = false
        songDetailView.isHidden = false
        productDetailView.isHidden = true
        self.cardBgImageView.image = self.blurImage
        self.cardAlbumImage.image = #imageLiteral(resourceName: "Img-headphones")
        self.cardSongName.text = song.title
        self.artistLbl.text = song.artists?.first?.name
        self.cardSongTitle.text = song.title
        let unBookMarkSongText = AGAStringConstants.MusicInfo.kUnBookMarkThisSong
        let bookMarkSong = AGAStringConstants.MusicInfo.kBookMarkThisSong
        let buttonTitle = song.bookmark?
            .isSubscribed ?? false ? unBookMarkSongText : bookMarkSong
        self.cardBookMarkBtn.setTitle(buttonTitle, for: .normal)
    }
    private func pulsatorSetup() {
        simmerImgView.layer.superlayer?.insertSublayer(pulsator, below: simmerImgView.layer)
        pulsator.numPulse = AGANumericConstants.eight
        pulsator.radius = CGFloat(AGANumericConstants.oneFifty)
        pulsator.animationDuration = TimeInterval(AGANumericConstants.five)
        pulsator.backgroundColor = UIColor.pulseColor.cgColor
        pulsator.start()
    }
}
extension AGASongListVC {
    private func acrSetup() {
        let config = ACRCloudConfig()
    
        config.accessKey = ACRConstants.kAccessKey
        config.accessSecret = ACRConstants.kAccessSecret
        config.host = ACRConstants.kHost
        // if you want to identify your offline db, set the recMode to "rec_mode_local"
        config.recMode = rec_mode_remote
        config.requestTimeout = AGANumericConstants.ten
        config.protocol = ACRConstants.kProtocol
        /* used for local model */
        if config.recMode == rec_mode_local || config.recMode == rec_mode_both {
            config.homedir = Bundle.main.resourcePath!.appending(ACRConstants.kLocalPath)
        }
        config.volumeBlock = { volume in
            debugPrint(volume)
        }
        config.resultBlock = { result, resType in
            self.handleResult(result!, resType: resType)
        }
        self.client = ACRCloudRecognition(config: config)
        self.startRecording = true
        self.client?.startRecordRec()
    }
    @objc func restartRecording() {
        DispatchQueue.main.async {
            debugPrint("Restart Recording.")
            self.client?.startRecordRec()
            self.startRecording = true
            self.pulsator.numPulse = AGANumericConstants.eight
        }
    }
    func setAnimatedImage() {
        soundImgView.animationImages = [#imageLiteral(resourceName: "eq4"), #imageLiteral(resourceName: "eq3"), #imageLiteral(resourceName: "eq2")]
        soundImgView.animationDuration = TimeInterval(AGANumericConstants.animationDuration)
        soundImgView.animationRepeatCount = AGANumericConstants.zero
        soundImgView.image = soundImgView.animationImages?.first
        self.soundImgView.startAnimating()
    }
    func handleResult(_ result: String, resType: ACRCloudResultType) {
        guard resType.rawValue >= 0  else {
            debugPrint("result", result)
            self.startRecording = false
            self.client?.stopRecordRec()
            DispatchQueue.main.async {
                self.registerClouser()
            }
            self.resultNotFoundCount += 1
            if self.resultNotFoundCount > AGANumericConstants.eighteen {
                self.resetAllComponents()
                DispatchQueue.main.async {
                    self.navigationController?.popViewController(animated: false)
                }
            }
            DispatchQueue.main.async {
                self.showPopNotificationView(
                    notiMessage: AGAStringConstants.MusicInfo.kNoResultFromACR,
                    notificationType: .error)
            }
            return
        }
        self.startRecording = false
        self.client?.stopRecordRec()
        DispatchQueue.main.async {
            self.showMusicInfo(result: result)
            // this condition for for if user did't command anything save song info without bookmark
            DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(20)) {
                if !self.viewModel.isSongInfoSaved && self.viewModel.recognitionType == .songs {
                    self.perforUserSpeechAction(false)
                }
            }
        }
    }
    func showMusicInfo(result: String) {
        let data = Data(result.utf8)
        let decoder = JSONDecoder()
        do {
            let model = try decoder.decode(AGAMusicTrack.self, from: data)
            self.showMusicInfo(model)
        } catch let error {
            print("\(error)")
        }
    }
    fileprivate func uttaranceVoice(_ trackID: String,
                                    _ artistName: String,
                                    _ titleName: String,
                                    _ vid: String?,
                                    _ label: String) {
        self.startRecording = false
        self.client?.stopRecordRec()
        self.resultNotFoundCount = .zero
        self.listenView.isHidden = true
        self.waitView.isHidden = false
        viewModel.songJustIdentified = true
        if UIApplication.shared.applicationState == .background {
            let text = "its \(titleName) by" +
                "\(artistName)."
            self.speechWithText(text: text, true)
        } else {
            let text = "its \(titleName) by" +
                "\(artistName).       " +
            "\(AGAStringConstants.MusicInfo.wantTobookMark)"
            speechWithText(text: text, false)
        }
    }
    private func showMusicInfo(_ model: AGAMusicTrack) {
        // this is adv data
        if model.metadata?.customFiles?.count ?? 0 > 0 {
            viewModel.recognitionType = .products
            if let customFileData = model.metadata?.customFiles?.first {
                let productDetailModel = ProductFieldModel(productName: customFileData.productName,
                                                           brandName: customFileData.brandName,
                                                           vId: "",
                                                           acrId: customFileData.acrid, isSubscribed: false)
                viewModel.productDetailFieldsModel = productDetailModel
                viewModel.songJustIdentified = true
                DispatchQueue.main.async {
                    self.showProductDetailUI()
                }
            }
        } else { // this is music data
            viewModel.recognitionType = .songs
            var externalMetaData: ExternalMetadata?
            if let metaData = model.metadata?.music?[AGANumericConstants.zero].externalMetadata {
                externalMetaData = metaData
            } else if model.metadata?.music?.count ?? 0 > Int(AGANumericConstants.one) {
                if let metaData = model.metadata?.music?[Int(AGANumericConstants.one)].externalMetadata {
                    externalMetaData = metaData
                }
            }
             viewModel.titleName = externalMetaData?
                 .spotify?.track?.name ?? model.metadata?.music?[AGANumericConstants.zero].title ?? ""
             // song name
             viewModel.artistName = externalMetaData?
                 .spotify?.artists?[AGANumericConstants.zero].name ??
             model.metadata?.music?[AGANumericConstants.zero].artists?[AGANumericConstants.zero].name ?? ""
            viewModel.vid = externalMetaData?.spotify?.track?.trackId?.stringValue ?? ""
             viewModel.label = model.metadata?.music?[AGANumericConstants.zero].label ?? ""
            viewModel.trackID = externalMetaData?.spotify?.track?.trackId?.stringValue ?? ""
             uttaranceVoice(viewModel.trackID,
                                      viewModel.artistName,
                                      viewModel.titleName,
                                      viewModel.vid,
                                      viewModel.label)
        }
    }
    func saveProductData() {
        Loader.spinnerAnimiation(view: self.view)
        let apiRouter = APIRouter.saveProductData(productName: viewModel.productDetailFieldsModel?.productName ?? "",
                                                  brandName: viewModel.productDetailFieldsModel?.brandName ?? "",
                                                  vId: viewModel.productDetailFieldsModel?.vId ?? "",
                                                  acrId: viewModel.productDetailFieldsModel?.acrId ?? "")
        viewModel.hitAPI(route: apiRouter) {[weak self] (response: Swift.Result<SaveProductModel, CustomError>) in
            Loader.removeLoader()
            self?.viewModel.isSongInfoSaved = true
            switch response {
            case .success:
                DispatchQueue.main.async {
                    self?.onProductDetailCrossTapped()
                }
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
    private func showProductDetailUI() {
        dimView.isHidden = false
        songDetailView.isHidden = true
        productDetailView.isHidden = false
        self.resultNotFoundCount = .zero
        self.listenView.isHidden = true
        self.waitView.isHidden = false
        productnameLbl.text = viewModel.productDetailFieldsModel?.productName ?? ""
        brandNameLbl.text = viewModel.productDetailFieldsModel?.brandName ?? ""
        speechWithText(text: AGAStringConstants.MusicInfo.bookmarkProduct, false)
    }
    func perforUserSpeechAction(_ isBookMark: Bool) {
        self.listenView.isHidden = false
        self.waitView.isHidden = true
        saveSongInfo(isBookMark: isBookMark)
        self.holdTimer?.invalidate()
        self.holdTimer = nil
    }
    private func speechWithText(text: String, _ isbackGround: Bool) {
        if synthesizer.isSpeaking { return }
        synthesizer.delegate = isbackGround == false ? self : nil
        let utterance = AVSpeechUtterance(string: text)
        utterance.voice = AVSpeechSynthesisVoice(language: AVSpeechSynthesisVoice.currentLanguageCode()) // en-GB
        utterance.rate = 0.5
        synthesizer.speak(utterance)
    }
    func saveSongInfo(isBookMark: Bool) {
        viewModel.isSongInfoSaved = true
        speechDone = false
        Loader.spinnerAnimiation(view: self.view)
        let apiRouter = APIRouter.saveSongInfo(viewModel.trackID,
                                               viewModel.artistName,
                                               viewModel.titleName,
                                               viewModel.vid,
                                               viewModel.label,
                                               isBookMark)
        viewModel.hitAPI(
            route: apiRouter) {[weak self] (response: Swift.Result<SaveSongsInfoModel, CustomError>) in
                Loader.removeLoader()
                self?.startRecording = false
                self?.client?.stopRecordRec()
                switch response {
                case .success(let result):
                    let bookmark = Bookmark(isSubscribed: isBookMark, bookmarkId: result.data?.bookmark?.bookmarkId)
                    let resultData = Result(songId: result.data?.songId,
                                        title: result.data?.title,
                                        artists: result.data?.artists, product: nil,
                                        bookmark: bookmark,
                                        vid: result.data?.vid,
                                        acrid: result.data?.acrid,
                                        trackID: result.data?.trackID)
                    if self?.viewModel.resultArr.count == 0 {
                        self?.viewModel.resultArr.append(resultData)
                    } else {
                        if self?.viewModel.resultArr.filter({$0.title == resultData.title}).count == 0 {
                            self?.viewModel.resultArr.insert(resultData, at: 0)
                        }
                    }
                     self?.reloadTableView()
                    if self?.viewModel.resultArr.count == 1 {
                        self?.setTableLengthBasedOnSongsList()
                    }
                case .failure(let error):
                    self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
                }
            }
    }
}


extension Int{
    var stringValue: String {
        return String(self)
        }
    }

