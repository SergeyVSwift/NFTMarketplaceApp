//
//  CartMainPresenter.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

protocol CartMainPresenterProtocol {
    func attachView(_ view: CartMainVCProtocol)
    func viewWillAppear()
    func displayPaymentVC()
    func createSortAlert() -> UIAlertController
    func numberOfCartItems() -> Int
    func configCell(_ cell: CartMainTableViewCell, at indexPath: IndexPath) -> CartMainTableViewCell
    func displayDeletionConfirmationFor(indexPath: IndexPath)
    func cartTotalPrice() -> Double
    func isCartEmpty() -> Bool
}

final class CartMainPresenter {
    private weak var view: CartMainVCProtocol?
    
    private var cartItems: [CartItem] = [
        CartItem(id: "1", nftName: "April", imageName: "MockNFTCard1", rating: 1, price: 1.80),
        CartItem(id: "3", nftName: "Chloe", imageName: "MockNFTCard3", rating: 3, price: 1.50),
        CartItem(id: "2", nftName: "Betty", imageName: "MockNFTCard2", rating: 5, price: 1.79),
    ]
    
    private let cartSortingMethodStorage = CartSortingMethodStorage()
    
    private func sortBy(_ sortingMethod: CartSortingMethod) {
        switch sortingMethod {
        case .price:
            cartItems.sort { $0.price < $1.price }
        case .rating:
            cartItems.sort { $0.rating < $1.rating }
        case .name:
            cartItems.sort { $0.nftName < $1.nftName }
        }
        cartSortingMethodStorage.savedSortingMethod = sortingMethod
        view?.updateTotals()
    }
}

// MARK: CartItemDeletionPresenterDelegate
extension CartMainPresenter: CartItemDeletionPresenterDelegate {
    func didConfirmDeletionFor(cartItem: CartItem) {
        cartItems.removeAll { $0.id == cartItem.id }
        view?.updateTotals()
    }
}

// MARK: PaymentPresenterDelegate
extension CartMainPresenter: PaymentPresenterDelegate {
    func didPurchaseItems() {
        cartItems = []
        view?.updateTotals()
    }
}

// MARK: CartMainPresenterProtocol
extension CartMainPresenter: CartMainPresenterProtocol {
    func attachView(_ view: CartMainVCProtocol) {
        self.view = view
    }
    
    func viewWillAppear() {
        let sortingMethod = cartSortingMethodStorage.savedSortingMethod ?? .name
        if !cartItems.isEmpty { sortBy(sortingMethod) }
        
        view?.toggleEmptyPlaceholderTo(cartItems.isEmpty)
        view?.updateTotals()
    }
    
    func displayPaymentVC() {
        let paymentPresenter = PaymentPresenter()
        paymentPresenter.delegate = self
        
        let paymentVC = PaymentVC(presenter: paymentPresenter)
        let navigationVC = UINavigationController(rootViewController: paymentVC)
        navigationVC.modalPresentationStyle = .fullScreen
        view?.presentVC(navigationVC)
    }
    
    func createSortAlert() -> UIAlertController {
        let alert = AlertUtility.cartMainScreenSortAlert(
            priceSortCompletion: { [weak self] in self?.sortBy(.price) },
            ratingSortCompletion: { [weak self] in self?.sortBy(.rating) },
            nameSortCompletion: { [weak self] in self?.sortBy(.name) }
        )
        return alert
    }
    
    func numberOfCartItems() -> Int {
        return cartItems.count
    }
    
    func configCell(_ cell: CartMainTableViewCell, at indexPath: IndexPath) -> CartMainTableViewCell {
        cell.configUI(cartItem: cartItems[indexPath.row])
        return cell
    }
    
    func displayDeletionConfirmationFor(indexPath: IndexPath) {
        let cartItem = cartItems[indexPath.row]
        let deletionPresenter = CartItemDeletionPresenter(
            delegate: self,
            cartItem: cartItem
        )
        let deletionVC = CartItemDeletionVC(presenter: deletionPresenter)
        deletionVC.modalPresentationStyle = .overFullScreen
        view?.presentVC(deletionVC)
    }
    
    func cartTotalPrice() -> Double {
        var totalPrice = 0.0
        for cartItem in cartItems {
            totalPrice += cartItem.price
        }
        return totalPrice
    }
    
    func isCartEmpty() -> Bool {
        return cartItems.isEmpty
    }
}
