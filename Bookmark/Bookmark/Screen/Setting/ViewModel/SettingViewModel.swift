//
//  SettingViewModel.swift
//  Bookmark
//
//  Created by heerucan on 2022/10/23.
//

import Foundation

final class SettingViewModel {
    var settingList: Observable<[Setting]> = Observable(Setting.allCases)
}
