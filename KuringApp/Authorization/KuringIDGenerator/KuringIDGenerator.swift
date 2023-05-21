//
//  KuringIDGenerator.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/05/21.
//

import Foundation
import KuringLink
import ComposableArchitecture

struct KuringIDGenerator: ReducerProtocol {
    struct State: Equatable {
        var kuringID: String = ""
        var isValid: Bool = false
        var onError: Bool = false
    }
    
    enum Action {
        case editText(String)
        case validationResponse(TaskResult<Bool>)
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .editText(let string):
            state.kuringID = string
            state.isValid = false
            return .run { [kuringID = state.kuringID] send in
                do {
                    let kuringIDs = try await KuringLink.kuringIDs(startsWith: kuringID)
                    await send(.validationResponse(.success(kuringIDs.isEmpty)))
                } catch {
                    await send(.validationResponse(.failure(error)))
                }
            }
        case .validationResponse(.success(let isValid)):
            state.isValid = isValid
            return .none
        case .validationResponse(.failure(let error)):
            state.isValid = false
            KuringLink.console(error: error)
            return .none
        }
    }
}
