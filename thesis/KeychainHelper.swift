//
//  KeychainHelper.swift
//  thesis
//
//  Created by Constantine Shterev on 27.03.24.
//

import Foundation
import Security

class KeychainHelper {
    static let standard = KeychainHelper()
    private init() {}

    func save(_ data: Data, service: String, account: String) {
        let query = [
            kSecValueData: data,
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        // Check if item exists, update if it does
        let status = SecItemUpdate(query, [kSecValueData: data] as CFDictionary)

        // Add if item doesn't exist
        if status == errSecItemNotFound {
            let addQuery = query
            let addStatus = SecItemAdd(addQuery, nil)
            // Handle potential errors
        }
    }

    func read(service: String, account: String) -> Data? {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword,
            kSecReturnData: true
        ] as CFDictionary

        var item: CFTypeRef?
        let status = SecItemCopyMatching(query, &item)

        guard status == errSecSuccess else {
            // Handle potential errors
            return nil
        }

        return item as? Data
    }

    func delete(service: String, account: String) {
        let query = [
            kSecAttrService: service,
            kSecAttrAccount: account,
            kSecClass: kSecClassGenericPassword
        ] as CFDictionary

        SecItemDelete(query)
    }
}
