//
//  SearchPlaceViewModel.swift
//  Log4Day
//
//  Created by 유철원 on 9/25/24.
//

import Foundation
import Combine

final class SearchPlaceViewModel: ObservableObject {
    
    private var cancelables = Set<AnyCancellable>()
    
    private let repository = Repository.shared
    
    var input = Input()
    
    @Published var output = Output()
    
    enum Action {
        case search
    }
    
    struct Input {
        let search = PassthroughSubject<Void, Never>()
        var searchKeyword: String = ""
        var coordinateList: [(Double,Double)] = []
    }
    
    struct Output {
        var selectedPlace: SearchedPlace?
        var placeList: [SearchedPlace] = []
        var searchError: NetworkError = .idle
    }
    
    init() {
        input.search
            .sink { [weak self] _ in
                self?.searchPlace()
            }
            .store(in: &cancelables)
    }
    
    func action(_ action: Action) {
        switch action {
        case .search:
            input.search.send(())
        }
    }
    
    func checkIsPicked(_ coord: (String, String), _ coordList: [(Double, Double)]) -> Bool {
        let dividen = ((Double(coord.1) ?? 0.0) / 1e7,
                       (Double(coord.0) ?? 0.0) / 1e7)
        return coordList.contains { $0 == dividen }
    }
    
    private func searchPlace() {
        let query = SearchPlaceQuery(
            query: input.searchKeyword,
            sort: SearchPlaceQuery.Sort.random.rawValue
        )
        NetworkManager.request(
            PlaceSearch.self,
            router: .searchPlace(query: query)
        ) { [weak self] result in
            self?.output.placeList = result.items
        } failure: { [weak self] error in
            self?.output.searchError = error
        }
    }
    
}
