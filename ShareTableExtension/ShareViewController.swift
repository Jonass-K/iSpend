//
//  ShareViewController.swift
//  ShareTableExtension
//
//  Created by Jonas Kaiser on 13.02.23.
//

import UIKit
import UniformTypeIdentifiers
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem else {
            return false
        }
        
        guard let attachment = item.attachments?.first else {
            return false
        }
        
        let csvType = UTType.commaSeparatedText.identifier
        guard attachment.hasItemConformingToTypeIdentifier(csvType) else {
            return false
        }
        
        return true
    }

    override func didSelectPost() {
        guard let item = extensionContext?.inputItems.first as? NSExtensionItem else {
            return
        }
        
        guard let attachment = item.attachments?.first else {
            return
        }
        
        let csvType = UTType.commaSeparatedText.identifier
        guard attachment.hasItemConformingToTypeIdentifier(csvType) else {
            return
        }
        
        attachment.loadItem(forTypeIdentifier: csvType) { data, error in
            let url = data as! URL
            guard url.lastPathComponent.hasPrefix("Zettl") else {
                return
            }
            
            guard let data = try? Data(contentsOf: url) else { return }
            UserDefaults(suiteName: "group.iSpend")?.set(data, forKey: "zettl")
            
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    override func configurationItems() -> [Any]! {
        return []
    }

}
