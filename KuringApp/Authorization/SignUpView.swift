//
//  SignUpView.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/05/21.
//

import SwiftUI
import ComposableArchitecture

struct SignUpView: View {
    let store: StoreOf<SignUp>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack {
                
            }
        }
    }
}
