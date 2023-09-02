//
//  BookmarksVC.swift
//  Agua
//
//  Created by KiwiTech on 30/12/21.
//  Copyright © 2021 Kiwitech. All rights reserved.
//

import UIKit

class BookmarksVC: AGABaseVC {
    var bookMarksProducts: [BookMarksProduct] = [
        BookMarksProduct(productListTitle: "SONGS"),
        BookMarksProduct(productListTitle: "PRODUCTS")
    ]
    @IBOutlet weak var productsBorderLine: UIView!
    @IBOutlet weak var songsBorderLine: UIView!
    @IBOutlet weak var productsButton: KTButton!
    @IBOutlet weak var songsButton: KTButton!
    @IBOutlet weak var tblView: UITableView!
    @IBOutlet weak var bookmarksLabel: UILabel!
    let viewModel = BookMarksViewModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        setGradientBackground()
        getSongsBookMarkList()
        productsBorderLine.isHidden = true
        tblView.register(reuseIdentifier: AGASongTableViewCell.identifire)
    }
    @IBAction func backAction(_ sender: UIButton) {
        if navigationController != nil {
            self.navigationController?.popViewController(animated: true)

        } else {
            dismiss(animated: true, completion: nil)
        }
    }
    @IBAction func productsBtnAction(_ sender: KTButton) {
        songsButton.titleLabel?.textColor = .white
        songsBorderLine.backgroundColor = .white
        productsButton.titleLabel?.textColor = .greenColor
        productsBorderLine.backgroundColor = .greenColor
        productsBorderLine.isHidden = false
        songsBorderLine.isHidden = true
        viewModel.currentPage = 1
        viewModel.loadState = .none
        viewModel.bookmarkListType = .product
        getProductsList()
    }
    @IBAction func songsBtnAction(_ sender: KTButton) {
        songsButton.titleLabel?.textColor = .greenColor
        songsBorderLine.backgroundColor = .greenColor
        productsButton.titleLabel?.textColor = .white
        productsBorderLine.backgroundColor = .white
        productsBorderLine.isHidden = true
        songsBorderLine.isHidden = false
        viewModel.currentPage = 1
        viewModel.loadState = .none
        viewModel.bookmarkListType = .songs
        getSongsBookMarkList()
    }
}

// MARK: - Implement APIS
extension BookmarksVC {
    func getSongsBookMarkList() {
        let apiRouter = APIRouter.getBookmarkSongsList(pageNo: viewModel.currentPage)
        if viewModel.currentPage == 1 {
            Loader.spinnerAnimiation(view: self.view)
        }
        viewModel.getListData(
            route: apiRouter) {[weak self] (response: Swift.Result<BookMarkSongsListModel, CustomError>) in
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
                self?.reloadTableView()
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
    func getProductsList() {
        let apiRouter = APIRouter.getProductsList(pageNo: viewModel.currentPage)
        if viewModel.currentPage == 1 {
            Loader.spinnerAnimiation(view: self.view)
        }
        viewModel.getListData(
            route: apiRouter) {[weak self] (response: Swift.Result<ListResponseModel, CustomError>) in
            Loader.removeLoader()
            switch response {
            case .success(let result):
                self?.viewModel.loadState = .none
                self?.viewModel.lastPage = result.data?.meta?.lastPage ?? 0
                if self?.viewModel.currentPage == 1 {
                    self?.viewModel.productsArr =  result.data?.result ?? []
                } else {
                    let responseArr = result.data?.result ?? []
                    self?.viewModel.productsArr.append(contentsOf: responseArr)
                }
                self?.reloadTableView()
            case .failure(let error):
                self?.showPopNotificationView(notiMessage: error.detail ?? "", notificationType: .error)
            }
        }
    }
}
extension BookmarksVC: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if viewModel.bookmarkListType == .songs {
            return viewModel.resultArr.count
        }
        return viewModel.productsArr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tblView.dequeueReusableCell(
            withIdentifier: AGASongTableViewCell.identifire,
            for: indexPath) as? AGASongTableViewCell else { return UITableViewCell() }
        if viewModel.bookmarkListType == .songs {
            if let result = viewModel.resultArr[indexPath.row].music?.first {
                cell.configureCellForSongs(result: result)
            }
        }
        if viewModel.bookmarkListType == .product {
            if let result = viewModel.productsArr[indexPath.row].product?.first {
                cell.configureCellForProducts(result: result)
            }
        }
        cell.bookMarkBtn.isHidden = true
        return cell
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        CGFloat(AGANumericConstants.fiftyEight)
    }
    func reloadTableView() {
        DispatchQueue.main.async {
            self.tblView.reloadData()
        }
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if viewModel.loadState != .none || viewModel.currentPage == viewModel.lastPage {
            return
        }
        viewModel.loadState = .initiated
        let visibleIndexPaths = tblView.indexPathsForVisibleRows
        if let last = visibleIndexPaths?.last {
            let dataSourceCount = viewModel.bookmarkListType == .songs ? viewModel.resultArr.count : viewModel.productsArr.count
            if last.row == dataSourceCount - 1 {
                viewModel.loadState = .initiated
                if viewModel.currentPage < viewModel.lastPage {
                    viewModel.currentPage += 1
                }
                tblView.tableFooterView = LoadingMoreView.viewFromNib()
                if viewModel.bookmarkListType == .songs {
                    getSongsBookMarkList()
                } else {
                    getProductsList()
                }
            } else {
                viewModel.loadState = .none
            }
        } else {
            viewModel.loadState = .none
        }
    }
}
