//
//
//  Created by Muneesh Chauhan on 13/05/20.
//  Copyright © 2020 Kiwitech. All rights reserved.
//

import Foundation
import UIKit
protocol KTVCFactoryProtocol {
    func instatiateHomeVC() -> AGAHomeVC?
    func instatiateMusicInfo() -> AGASongListVC?
    func instatiateSignUp() -> AGASignUpVC?
    func instatiateSignIn() -> AGALoginVC?
    func instatiateOTP() -> OTPVarificationVC?
    func completeProfileVC() -> CompleteProfileVC?
    func webKitVC() -> WebKitVC?
    func profileVC() -> ProfileVC?
    func welcomeVC() -> AGAWelcomeVC?
    func bookmarkListVC() -> BookmarksVC?
    func spotifyWebView() -> SpotifyWebVC?
    func linkedAccountsVC() -> ConnectedAccountsVC?
    func editProfileVC() -> EditProfileVC?
    func playAdv() -> PlayAdvViewController?
    func popupVC() -> PopUpVC?
}
class KTVCFactory: KTVCFactoryProtocol {
    func popupVC() -> PopUpVC? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.profile,
            identifire: PopUpVC.identifier) as? PopUpVC else { return nil }
        return viewController
    }
    func playAdv() -> PlayAdvViewController? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.songInfo,
            identifire: PlayAdvViewController.identifier) as? PlayAdvViewController else { return nil }
        return viewController
    }
    func editProfileVC() -> EditProfileVC? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.profile,
            identifire: EditProfileVC.identifier) as? EditProfileVC else { return nil }
        return viewController
    }
    func linkedAccountsVC() -> ConnectedAccountsVC? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.profile,
            identifire: ConnectedAccountsVC.identifier) as? ConnectedAccountsVC else { return nil }
        return viewController
    }
    func spotifyWebView() -> SpotifyWebVC? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.profile,
            identifire: SpotifyWebVC.identifier) as? SpotifyWebVC else { return nil }
        return viewController
    }
    func welcomeVC() -> AGAWelcomeVC? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.main,
            identifire: AGAWelcomeVC.identifier) as? AGAWelcomeVC else { return nil }
        return viewController
    }
    func bookmarkListVC() -> BookmarksVC? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.bookmarkList,
            identifire: BookmarksVC.identifier) as? BookmarksVC else { return nil }
        return viewController
    }
    func profileVC() -> ProfileVC? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.profile,
            identifire: ProfileVC.identifier) as? ProfileVC else { return nil }
        return viewController
    }
    func webKitVC() -> WebKitVC? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.main,
            identifire: WebKitVC.identifier) as? WebKitVC else { return nil }
        return viewController
    }
    func completeProfileVC() -> CompleteProfileVC? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.main,
            identifire: CompleteProfileVC.identifier) as? CompleteProfileVC else { return nil }
        return viewController
    }
    func instatiateSignIn() -> AGALoginVC? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.main,
            identifire: AGALoginVC.identifier) as? AGALoginVC else { return nil }
        return viewController
    }
    func instatiateOTP() -> OTPVarificationVC? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.main,
            identifire: OTPVarificationVC.identifier) as? OTPVarificationVC else { return nil }
        return viewController
    }
    func instatiateMusicInfo() -> AGASongListVC? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.main,
            identifire: AGASongListVC.identifier) as? AGASongListVC else { return nil }
        return viewController
    }
    func instatiateHomeVC() -> AGAHomeVC? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.main,
            identifire: AGAHomeVC.identifier) as? AGAHomeVC else { return nil }
        return viewController
    }
    func instatiateSignUp() -> AGASignUpVC? {
        guard let viewController = KTStoryboardCoordinator.getController(
            storyBoardName: AGAStoryboard.main,
            identifire: AGASignUpVC.identifier) as? AGASignUpVC else { return nil }
        return viewController
    }
}
class KTStoryboardCoordinator {
    class func getController(storyBoardName: AGAStoryboard, identifire: String) -> UIViewController? {
        let storyboard = UIStoryboard(name: storyBoardName.filename, bundle: nil)
        return storyboard.instantiateViewController(withIdentifier: identifire)
    }
}
