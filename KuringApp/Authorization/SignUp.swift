//
//  SignUp.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/05/21.
//

import Foundation
import KuringLink
import ComposableArchitecture

struct SignUp: ReducerProtocol {
    struct State: Equatable {
        var text: String = ""
        var currentStep: Step = .major
        var major: String?
        var profileImage: Data?
        var kuringID: String?
        var isPermissionPresented: Bool = false
    }
    
    enum Step {
        case major
        case profileImage
        case kuringID
        case permissionCheck
        case done
    }
    
    enum Action {
        case editText(String)
        case selectMajor(String)
        case tapProfileImageButton
        case pickProfileImage(Data?)
        case kuringIDRespone(String?)
        case tapNextButton
    }
    
    func reduce(into state: inout State, action: Action) -> EffectTask<Action> {
        switch action {
        case .editText(let string):
            state.text = string
            switch state.currentStep {
            case .kuringID:
                return .run { [text = state.text] send in
                    let kuringIDs = try await KuringLink.kuringIDs(startsWith: text)
                    await send(.kuringIDRespone(kuringIDs.isEmpty ? text : nil))
                }
            default:
                return .none
            }
        case .selectMajor(let majorName):
            state.text = majorName
            state.major = majorName
            return .none
        case .tapProfileImageButton:
            return .none
        case .pickProfileImage(let imageData):
            state.profileImage = imageData
            return .none
        case .kuringIDRespone(let validID):
            if let validID {
                state.kuringID = validID
            }
            return .none
        case .tapNextButton:
            state.text = ""
            switch state.currentStep {
            case .major:
                state.currentStep = .profileImage
            case .profileImage:
                state.currentStep = .kuringID
            case .kuringID:
                state.currentStep = .permissionCheck
            case .permissionCheck, .done:
                state.currentStep = .done
            }
            return .none
        }
    }
}
