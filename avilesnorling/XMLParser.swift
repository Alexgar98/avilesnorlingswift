//
//  XMLParser.swift
//  avilesnorling
//
//  Created by Mac on 16/5/23.
//

import UIKit
import Foundation

class CustomXMLParserDelegate : NSObject, XMLParserDelegate {
    var propiedad : Propiedad?
    
    var listaPropiedades : [Propiedad] = []
    
    var elementoActual : String?
    var valorActual : String?
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        elementoActual = elementName
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        valorActual = string.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if let elemento = elementoActual, let valor = valorActual {
            if elemento == "precio" {
                propiedad?.precio = valor
            }
            if elemento == "referencia" {
                propiedad?.referencia = valor
            }
            if elemento == "dormitorios" {
                propiedad?.dormitorios = valor
            }
            if elemento == "superficieConstruida" {
                propiedad?.superficieConstruida = valor
            }
            if elemento == "baños" {
                propiedad?.baños = valor
            }
        }
        
        elementoActual = nil
        valorActual = nil
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        //TODO Recargar
    }
}
