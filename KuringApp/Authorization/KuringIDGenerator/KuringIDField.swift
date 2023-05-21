//
//  KuringIDField.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/05/21.
//

import SwiftUI
import KuringLink
import ComposableArchitecture

struct KuringIDField: View {
    let store: StoreOf<KuringIDGenerator>
    
    var body: some View {
        WithViewStore(self.store, observe: { $0 }) { viewStore in
            VStack(alignment: .leading, spacing: 12) {
                Text("아이디를 알려주세요")
                    .font(.title3.bold())
                
                Text("@사용자 아이디는 고유한 나만의 쿠링 아이디입니다. 변경할 수 없습니다.")
                
                Text("User ID")
                    .font(.subheadline)
                
                HStack {
                    Text("@")
                        .font(.subheadline)
                    
                    TextField(
                        "아이디",
                        text: viewStore.binding(
                            get: \.kuringID,
                            send: { .editText($0) }
                        )
                    )
                    .textInputAutocapitalization(.never)
                    .textCase(.lowercase)
                    
                    Image(systemName: "checkmark.diamond.fill")
                        .opacity(viewStore.isValid ? 1.0 : 0.0)
                }
                .foregroundColor(.green)
                
                Divider()
                
                if viewStore.onError {
                    Label("네트워크 연결 에러", systemImage: "exclamationmark.triangle")
                        .foregroundColor(.red)
                }
            }
            .padding(.horizontal, 20)
        }
    }
}
