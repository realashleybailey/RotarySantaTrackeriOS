//
//  DocumentPicker.swift
//  iOS Santa Tracker
//
//  Created by Ashley Bailey on 16/11/2022.
//

import SwiftUI

struct DocumentPicker: UIViewControllerRepresentable {
    
    @Binding var fileContent: String
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<DocumentPicker>) -> UIDocumentPickerViewController {
        
        let controller = UIDocumentPickerViewController(forOpeningContentTypes: [.text], asCopy: true)
        controller.delegate = context.coordinator
        
        return controller
    }
    
    func makeCoordinator() -> DocumentPickerCoordinator {
        return DocumentPickerCoordinator(parent: self)
    }
    
    func updateUIViewController(_ uiViewController: UIDocumentPickerViewController, context: UIViewControllerRepresentableContext<DocumentPicker>) {
        
    }
}

class DocumentPickerCoordinator: NSObject, UIDocumentPickerDelegate, UINavigationControllerDelegate {
    
    var parent: DocumentPicker
    
    init(parent: DocumentPicker) {
        self.parent = parent
    }
    
    func documentPicker(_ controller: UIDocumentPickerViewController, didPickDocumentsAt urls: [URL]) {
        
        let fileURL = urls[0]
        
        do {
            parent.fileContent = try String(contentsOf: fileURL, encoding: .utf8)
        } catch {
            print(error.localizedDescription)
        }
    }
}
