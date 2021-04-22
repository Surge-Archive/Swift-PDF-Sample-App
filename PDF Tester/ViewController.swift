//
//  ViewController.swift
//  PDF Tester
//
//  Created by Marwan Elwaraki on 21/04/2021.
//

import UIKit
import PDF_Generator
import PDFKit

class ViewController: UIViewController {
    
    let documentInteractionController = UIDocumentInteractionController()
    var pdfObjects: [PDFObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
    }

    @IBAction func tappedGeneratePDF(_ sender: Any) {
        pdfObjects.removeAll()
        
        appendHeaderLabels()
        appendIcecreamFlavoursTable()
        appendLongTable()
        appendConsolesTable()
        appendRandomTextLabel()
        appendCornerTable()
        
        let pdfCreator = PDFCreator(objects: pdfObjects)
        let pdfDocument = PDFDocument(data: pdfCreator.data)
        
        let fileName = "Test File"
        let url = FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first?.appendingPathComponent("test-file.pdf")
        
        if let url = url {
            pdfDocument?.write(to: url)
        }
        
        documentInteractionController.delegate = self
        documentInteractionController.name = fileName
        documentInteractionController.url = url
        
        _ = documentInteractionController.presentPreview(animated: true)
    }
    
    func appendHeaderLabels() {
        let headerLabel = PDFLabel(text: "Hello, PDFs", rect: CGRect(x: 40, y: 40, width: 200, height: 20), attributes: PDFConstants.h1Attributes)
        pdfObjects.append(headerLabel)
        
        let subheaderLabel = PDFLabel(text: "Generate friendly PDFs with Swift.", rect: CGRect(x: 40, y: 60, width: 200, height: 20), attributes: PDFConstants.h2Attributes)
        pdfObjects.append(subheaderLabel)
    }
    
    func appendIcecreamFlavoursTable() {
        let iceCreamTable = PDFTable(items: [
            // Row 1
            [
                PDFTableItem(header: "Flavour", backgroundColor: .lightGray),
                PDFTableItem(header: "Rating", backgroundColor: .lightGray)
            ],
            // Row 2
            [
                PDFTableItem(body: "Cookie Dough", markerColor: .blue),
                PDFTableItem(body: "9.5")
            ],
            // Row 3
            [
                PDFTableItem(body: "Blueberry"),
                PDFTableItem(body: "8.2")
            ],
            // Row 4
            [
                PDFTableItem(body: "Chocolate"),
                PDFTableItem(body: "7.9")
            ]
        ])
        pdfObjects.append(iceCreamTable)
    }
    
    func appendLongTable() {
        var items: [[PDFTableItem]] = []
        let text = "It will be repeated many times.\nThe PDF creator will automatically take care of continuing the table onto a new page, and even continuing a large cell over multiple pages."
        
        for _ in 0..<20 {
            items.append([PDFTableItem(header: "This is repeating text.", body: text)])
        }
        
        let longTable = PDFTable(items: items)
        pdfObjects.append(longTable)
    }
    
    func appendConsolesTable() {
        let consoles = ["Playstation": "Sony", "Xbox": "Microsoft", "Wii": "Nintendo"]
        var items: [[PDFTableItem]] = []
        consoles.forEach { (key, value) in
            items.append([
                PDFTableItem(body: key),
                PDFTableItem(body: value)
            ])
        }
        
        let consolesTable = PDFTable(leftMargin: 100, yPosition: .newPage, items: items, maxWidth: 150, topMargin: 200)
        pdfObjects.append(consolesTable)
    }
    
    func appendRandomTextLabel() {
        let randomLabel = PDFLabel(text: "You can place tables wherever you like or let the PDF Creator auto place them for you.", rect: CGRect(x: 150, y: 400, width: 400, height: 100), attributes: PDFConstants.cellHeaderAttributes)
        pdfObjects.append(randomLabel)
    }
    
    func appendCornerTable() {
        let items = [[
            PDFTableItem(header: "A large cell", body: "Some cells need more text. So you can use headers, footers, and mark the cell as large", footer: "With footers too", largeCell: true),
            PDFTableItem(body: "This cell will take less room because it's not marked as a large cell")
        ]]
        
        let cornerTable = PDFTable(leftMargin: 200, yPosition: .fixed(500), items: items)
        pdfObjects.append(cornerTable)
    }
    
}

extension ViewController: UIDocumentInteractionControllerDelegate {
    func documentInteractionControllerViewControllerForPreview(_ controller: UIDocumentInteractionController) -> UIViewController {
        return self
    }
}

