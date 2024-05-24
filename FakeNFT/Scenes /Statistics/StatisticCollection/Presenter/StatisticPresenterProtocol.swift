//
//  StatisticPresenter.swift
//  FakeNFT
//
//  Created by Сергей Ващенко on 20.05.24.
//

import Foundation

protocol StatisticPresenterProtocol: AnyObject {
    var onSortButtonTap: (() -> Void)? { get set }
    var onUsersListChange: (() -> Void)? { get set }
    var onUserProfileDidTap: ((User) -> Void)? { get set }
    var allUsers: [User] { get }
    func sortButtonDidTap()
    func sortByNameDidTap()
    func sortByRatingDidTap()
    func userProfileDidTap(withIndex indexPath: IndexPath)
}

final class StatisticPresenter: StatisticPresenterProtocol {
    var onSortButtonTap: (() -> Void)?
    var onUsersListChange: (() -> Void)?
    var onUserProfileDidTap: ((User) -> Void)?

    private(set) var allUsers: [User] = [] {
        didSet {
            onUsersListChange?()
        }
    }

    private let userModel: UserModel

    init(for model: UserModel) {
        userModel = model
        allUsers = userModel.getUsers()
    }

    func sortButtonDidTap() {
        onSortButtonTap?()
    }

    func sortByNameDidTap() {
        allUsers = userModel.sortUsersByName()
    }

    func sortByRatingDidTap() {
        allUsers = userModel.sortUsersByRating()
    }
    
    func userProfileDidTap(withIndex indexPath: IndexPath) {
        let userInfo = allUsers[indexPath.row]
        onUserProfileDidTap?(userInfo)
    }
}
