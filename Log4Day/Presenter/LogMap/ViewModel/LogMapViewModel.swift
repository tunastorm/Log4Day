//
//  LogMapViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/24/24.
//

import Foundation
import Combine
import SwiftUI
import PhotosUI
import NMapsMap
import BottomSheet
import RealmSwift

final class LogMapViewModel: ObservableObject {
    
    private let repository = Repository()
    
    private var canclelables = Set<AnyCancellable>()
    
    var input = Input()
    
    @Published var output = Output()
    
    enum Action {
        case fetchFirstLastDate
        case initialFetch
        case selectDate(date: Date)
    }
    
    struct Input {
        let fetchFirstLastDate = PassthroughSubject<Void, Never>()
        let initialFetch = PassthroughSubject<Void, Never>()
        let selectDate = PassthroughSubject<Date, Never>()
    }
    
    struct Output {
        var category = "전체"
        var firstLastDate: (Date, Date) = (Date(timeIntervalSince1970: 0), Date())
        var selectedDate = Date()
        @ObservedResults(Log.self) var logList
    }
    
    init() {
        input.fetchFirstLastDate
            .sink { [weak self] _ in
                self?.initialFetch()
            }
            .store(in: &canclelables)
        
        input.initialFetch
            .sink { [weak self] _ in
                self?.fetchLogList()
            }
            .store(in: &canclelables)
        
        input.selectDate
            .sink { [weak self] date in
                self?.fetchSelectedDate(date)
            }
            .store(in: &canclelables)
    }
    
    func action(_ action: Action) {
        switch action {
        case .fetchFirstLastDate:
            input.fetchFirstLastDate.send(())
        case .initialFetch:
            input.initialFetch.send(())
        case .selectDate(let date):
            input.selectDate.send(date)
        }
    }
    
    private func initialFetch() {
//        let nowDate = Date().formatted(date: ., time: )
        let sorted = output.logList.sorted(by: {$0.startDate < $1.startDate})
        guard let first = sorted.first?.startDate, let last = sorted.last?.startDate else {
            return
        }
        output.firstLastDate = (first, last)
        output.$logList.where = { [weak self] in
            $0.startDate >= self?.output.firstLastDate.0 ?? Date(timeIntervalSince1970: 0) &&
            $0.startDate <= self?.output.firstLastDate.1 ?? Date()
        }
        output.$logList.sortDescriptor = .init(keyPath: Log.Column.startDate.name, ascending: false)
        output.$logList.update()
    }
    
    private func fetchSelectedDate(_ date: Date) {
        output.selectedDate = date
        fetchLogList()
    }
    
    private func fetchLogList() {
        if output.category == "전체" {
            output.$logList.where = { $0.startDate <= Date() }
        } else {
            output.$logList.where = { [weak self] in
                return $0.owner.title == self?.output.category ?? ""
            }
        }
        output.$logList.sortDescriptor = .init(keyPath: Log.Column.startDate.name, ascending: false)
        
        let nextDate = Calendar.current.date(byAdding: .day, value: 1, to: output.selectedDate)!

        output.$logList.update()
    }
    
}
