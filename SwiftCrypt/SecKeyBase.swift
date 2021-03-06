//
//  SecKeyService.swift
//  SwiftCrypt
//
//  Created by Rafael Almeida on 16/10/14.
//  Copyright (c) 2014 ISWE. All rights reserved.
//
// To asemble the library
// http://railsware.com/blog/2014/06/26/creation-of-pure-swift-module

import Foundation
import Security

class SecKeyBase {

    let NYES = NSNumber(bool: true)
    
    var keyType: AnyObject
    
    init(keyType:AnyObject){
        self.keyType = keyType
    }
    
    func deleteItem(query:NSMutableDictionary) -> Bool{
        let sanityCheck = SecItemDelete(query as CFDictionaryRef)
        
        if(sanityCheck == noErr || sanityCheck == errSecItemNotFound){
            println("Item deleted with success!");
            return true
        }
        else{
            println("Could not delete key.")
            return false
        }
    }
    
    func createBaiscKeyQueryParams(tag:NSData) -> NSMutableDictionary {
        let query: NSMutableDictionary = NSMutableDictionary()
        query.setObject(kSecClassKey, forKey:kSecClass as String)
        query.setObject(tag, forKey:kSecAttrApplicationTag as String)
        query.setObject(keyType, forKey:kSecAttrKeyType as String)
        return query
    }
    
    func queryObject(query:NSMutableDictionary) -> AnyObject? {
        var uObject: Unmanaged<AnyObject>?
        var result: AnyObject?
        
        // Get the key.
        let sanityCheck = SecItemCopyMatching(query as CFDictionaryRef, &uObject)
        
        if (sanityCheck == noErr){
            result = uObject?.takeUnretainedValue()
        }
        else{
            println("Error on SecItemCopyMatching")
        }
        return result
    }
    
    func getKeyBits(tag:NSData) -> NSData? {
        let query = createBaiscKeyQueryParams(tag)
        query.setObject(NYES, forKey: kSecReturnData as String)
        let keyBits = queryObject(query) as? NSData
        return keyBits
    }
    
    func getPersistentKeyRef(keyRef:SecKeyRef) -> CFTypeRef? {
        let query: NSMutableDictionary = NSMutableDictionary()
        query.setObject(keyRef, forKey:kSecValueRef as String)
        query.setObject(NYES, forKey:kSecReturnPersistentRef as String)
        
        let persistentRef: CFTypeRef? = queryObject(query) as CFTypeRef?
        return persistentRef
    }

}