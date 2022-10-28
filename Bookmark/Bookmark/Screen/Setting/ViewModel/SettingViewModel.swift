//
//  SettingViewModel.swift
//  Bookmark
//
//  Created by heerucan on 2022/10/23.
//

import Foundation

import RxSwift
import RxRelay

final class SettingViewModel {
    let settingList = BehaviorRelay(value: Setting.allCases)
}
