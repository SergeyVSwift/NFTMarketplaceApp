//
//  CartMainPresenter.swift
//  FakeNFT
//
//  Created by Vlad Vintenbakh on 21/5/24.
//

import UIKit

protocol CartMainPresenterProtocol {
    
}

final class CartMainPresenter {
    weak private var view: CartMainVC?
    
    private var cartItems: [CartItem] = [
        CartItem(id: "1", nftName: "April", imageName: "MockNFTCard1", rating: 1, price: 1.80),
        CartItem(id: "2", nftName: "Betty", imageName: "MockNFTCard2", rating: 5, price: 1.79),
        CartItem(id: "3", nftName: "Chloe", imageName: "MockNFTCard3", rating: 3, price: 1.50),
    ]
    
    func attachView(_ view: CartMainVC) {
        self.view = view
    }
    
    func viewWillAppear() {
        view?.toggleEmptyPlaceholderTo(cartItems.isEmpty)
        view?.updateTotals()
    }
    
    func isCartEmpty() -> Bool {
        return cartItems.isEmpty
    }
    
    func numberOfCartItems() -> Int {
        return cartItems.count
    }
    
    func cartTotalPrice() -> Double {
        var totalPrice = 0.0
        for cartItem in cartItems {
            totalPrice += cartItem.price
        }
        return totalPrice
    }
    
    func configCell(_ cell: CartMainTableViewCell, at indexPath: IndexPath) -> CartMainTableViewCell {
        cell.configUI(cartItem: cartItems[indexPath.row])
        return cell
    }
    
    func createSortAlert() -> UIAlertController {
        let alert = AlertUtility.cartMainScreenSortAlert(
            priceSortCompletion: { [weak self] in self?.sortBy(.price) },
            ratingSortCompletion: { [weak self] in self?.sortBy(.rating) },
            nameSortCompletion: { [weak self] in self?.sortBy(.name) }
        )
        return alert
    }
    
    private func sortBy(_ sortingMethod: CartSortingMethod) {
        switch sortingMethod {
        case .price:
            cartItems.sort { $0.price < $1.price }
        case .rating:
            cartItems.sort { $0.rating < $1.rating }
        case .name:
            cartItems.sort { $0.nftName < $1.nftName }
        }
        view?.updateTotals()
    }
}
