//
//  ViewModel.swift
//  IlluminareanTest
//
//  Created by yjc on 2023/05/17.
//

import Foundation

protocol ViewModel {
    associatedtype Input
    associatedtype Output
    /// 데이터 바인딩
    func transform(input: Input) -> Output
}
