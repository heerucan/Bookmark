//
//  SettingViewModel.swift
//  Bookmark
//
//  Created by heerucan on 2022/10/23.
//

import Foundation

import RxSwift

final class SettingViewModel {
    let settingList = Observable<[Setting]>.of(Setting.allCases)
}
