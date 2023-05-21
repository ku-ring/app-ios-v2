//
//  KuringAppApp.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/05/20.
//

import Enigma
import SwiftUI
import KuringLink
import Satellite

@main
struct KuringAppApp: App {
    var body: some Scene {
        WindowGroup {
            TabView {
                DepartmentSelector(
                    store: .init(
                        initialState: .init(),
                        reducer: { Major() }
                    )
                )

                KuringIDField(
                    store: .init(
                        initialState: .init(),
                        reducer: { KuringIDGenerator() }
                    )
                )
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
    
    init() {
        let host = Enigma.kuring.decode(key: "com.kuring.enigma.host")
        let scheme: Satellite.Scheme
        #if DEBUG
        scheme = .http
        #else
        scheme = .https
        #endif
        KuringLink.setup(host: host, scheme: scheme)
    }
}
