//
//  MyNFTPresenter.swift
//  FakeNFT
//
//  Created by Kirill Sklyarov on 23.05.2024.
//

import Foundation

protocol MyNFTPresenterProtocol {
    func viewDidLoad()
    func sortButtonTapped()
    func getNumberOfRows() -> Int
    func getNFT(with indexPath: IndexPath) -> NFTModel
    func isNFTInFav(_ nft: NFTModel) -> Bool
    func priceSorting()
    func ratingSorting()
    func nameSorting()
    func addOrRemoveNFTFromFav(nft: NFTModel, isNFTFav: Bool)
    func showOrHidePlaceholder()
}

final class MyNFTPresenter {

    // MARK: - ViewController
    weak var view: MyNFTViewProtocol?
    private let network = DefaultNetworkClient()

    // MARK: - Other properties
    private var arrayOfNFT = [NFTModel]()
    private var listOfNFT = [String]()

    // MARK: - Private methods
    private func getDataFromStorage() {
        let data = ProfileStorage.profile
        guard let myNFT = data?.nfts else { print("Ooops"); return }
        listOfNFT = myNFT
    }

    private func uploadNFTFromNetwork() {
        Task {
            for nftID in listOfNFT {
                let request = NFTRequest(id: nftID)

                do {
                    let data = try await network.sendNew(request: request, type: NFTModel.self)
                    // print("✅ Favorite NFT uploaded successfully")
                    guard let data else { return }
                    arrayOfNFT.append(data)
                } catch {
                    print(error.localizedDescription)
                }
            }
            print("arrayOfNFT \(arrayOfNFT)")
            view?.updateTableView()
        }
    }

    func showOrHidePlaceholder() {
        let isDataEmpty = isArrayOfNFTEmpty()
        if isDataEmpty {
            view?.showPlaceholder()
        } else {
            view?.hideTableView()
        }
    }

    private func isArrayOfNFTEmpty() -> Bool {
        return arrayOfNFT.isEmpty
    }

    private func addNFTToFav(_ nft: NFTModel) {
        let storage = MockDataStorage()
        let nftToAddToFav = nft
//        storage.addFavNFT(nftToAddToFav)
    }

    private func removeNFTFromFav(_ nft: NFTModel) {
        let storage = MockDataStorage()
        let nftToRemoveFromFav = nft
//        storage.removeFromFavNFT(nftToRemoveFromFav)
    }

}

// MARK: - MyNFTPresenterProtocol
extension  MyNFTPresenter: MyNFTPresenterProtocol {
    
    func viewDidLoad() {
        getDataFromStorage()
        uploadNFTFromNetwork()
    }

    func sortButtonTapped() {
        view?.showAlert()
    }

    func getNumberOfRows() -> Int {
        return arrayOfNFT.count
    }

    func getNFT(with indexPath: IndexPath) -> NFTModel {
        let nft = arrayOfNFT[indexPath.row]
        return nft
    }

    func priceSorting() {
        arrayOfNFT.sort {
            guard let price1 = $0.price,
                  let price2 = $1.price else { print("Sorting problem"); return false }
            //                  let priceDouble1 = Double(priceString1),
            //                  let priceDouble2 = Double(priceString2) ;
            return price1 > price2
        }
        view?.updateTableView()
    }

    func ratingSorting() {
        arrayOfNFT.sort {
            guard let rating1 = $0.rating,
                  let rating2 = $1.rating else { print("Sorting problem"); return false}
            return rating1 > rating2
        }
        view?.updateTableView()
    }

    func nameSorting() {
        arrayOfNFT.sort {
            guard let rating1 = $0.name,
                  let rating2 = $1.name else { print("Sorting problem"); return false}
            return rating1 > rating2
        }
        view?.updateTableView()
    }

    func isNFTInFav(_ nft: NFTModel) -> Bool {
        //        guard let listOfFav = MockDataStorage.mockData.favoriteNFT else { return false }
        //        if listOfFav.contains(where: { $0.name == nft.name }) {
        //            return true
        //        } else {
                    return false
        //        }
            }

        func addOrRemoveNFTFromFav(nft: NFTModel, isNFTFav: Bool) {
            if isNFTFav {
                removeNFTFromFav(nft)
            } else {
                addNFTToFav(nft)
            }
        }
    }
