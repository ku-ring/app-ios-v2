//
//  Major.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/05/21.
//

import Foundation
import KuringLink
import ComposableArchitecture

struct Major: ReducerProtocol {
    struct State: Equatable {
        var isLoading: Bool = true
        var onError: Bool = false
        var searchText: String = ""
        var selectedMajor: NoticeProvider?
        var allDepartments: [NoticeProvider] = []
    }
    
    enum Action {
        case fetchAllDepartments
        case allDepartmentsResponse(TaskResult<[NoticeProvider]>)
        case editText(String)
        case selectDepartment(NoticeProvider)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .fetchAllDepartments:
            return .run { send in
                do {
                    let allDepartments = try await KuringLink.allDepartments
                    await send(.allDepartmentsResponse(.success(allDepartments)))
                } catch {
                    await send(.allDepartmentsResponse(.failure(error)))
                }
            }
        case .allDepartmentsResponse(.success(let allDepartments)):
            state.allDepartments = allDepartments
            state.isLoading = false
            return .none
        case .allDepartmentsResponse(.failure(let error)):
            KuringLink.console(error: error)
            state.onError = true
            state.isLoading = false
            return .none
        case .editText(let text):
            state.searchText = text
            state.selectedMajor = state.allDepartments
                .first(where: { $0.korName == text })
            return .none
        case .selectDepartment(let department):
            state.searchText = department.korName
            state.selectedMajor = department
            return .none
        }
    }
}

extension NoticeProvider: Equatable {
    public static func == (lhs: NoticeProvider, rhs: NoticeProvider) -> Bool {
        lhs.id == rhs.id
    }
}
