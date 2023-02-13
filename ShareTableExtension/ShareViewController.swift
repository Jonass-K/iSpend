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
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        print("did select post")
        
        // this gets the incoming information from the share sheet
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
            print("loads")
            let url = data as! URL
            print(url)
            guard url.lastPathComponent.hasPrefix("Zettl") else {
                return
            }
            print("has prefix")
            
            guard let data = try? Data(contentsOf: url) else { return }
            print("got data")
            UserDefaults(suiteName: "group.iSpend")?.set(data, forKey: "zettl")
            print("saved data")
            
            self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
        }
    }

    override func configurationItems() -> [Any]! {
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        print("configuration items")
        return []
    }

}
