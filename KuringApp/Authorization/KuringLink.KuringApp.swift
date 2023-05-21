//
//  KuringLink.KuringApp.swift
//  KuringApp
//
//  Created by Jaesung Lee on 2023/05/21.
//

import KuringLink

extension KuringLink {
    /// `text` 로 시작하는 `kuringID` 들 가져오기
    public static func kuringIDs(startsWith text: String) async throws -> [String] {
        return Bool.random() ? [] : ["", "1"]
    }
}
