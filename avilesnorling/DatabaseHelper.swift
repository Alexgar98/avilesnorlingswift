//
//  DatabaseHelper.swift
//  avilesnorling
//
//  Created by Mac on 23/5/23.
//

import Foundation
import SQLite
import CheatyXML

class DatabaseHelper {
    init() {
        
    }
    func insertarXML() {
        do {
            let db : Connection?
            let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
            if let libraryPath = paths.first {
                let dbPath = (libraryPath as NSString).appendingPathComponent("database.db")
                db = try Connection(dbPath) // ¿?
                // Use dbPath for your SQLite database operations
            } else {
                print("Hubo un error al generar la base de datos")
                db = nil
            }
            
            let propiedades = Table("propiedades")
            let referencia = Expression<String>("referencia")
            let tipoAnuncio = Expression<String>("tipoAnuncio")
            let tipoInmueble = Expression<String>("tipoInmueble")
            let ubicacion = Expression<String>("ubicacion")
            let dormitorios = Expression<Int>("dormitorios")
            let superficie = Expression<Int>("superficie")
            let precio = Expression<Int>("precio")
            let vacacional = Expression<Bool>("vacacional")
            let banos = Expression<Int>("baños")
            let imagen = Expression<String>("imagen")
            
            try db?.run(propiedades.create { t in
                t.column(referencia, primaryKey: true)
                t.column(tipoAnuncio)
                t.column(tipoInmueble)
                t.column(ubicacion)
                t.column(dormitorios)
                t.column(superficie)
                t.column(precio)
                t.column(vacacional)
                t.column(banos)
                t.column(imagen)
            })
            
            let url = URL(string: "https://avilesnorling.inmoenter.com/export/all/xcp.xml")
            let parser : CXMLParser! = CXMLParser(contentsOfURL: url!)
            
            for element in 0..<parser["listaPropiedades"].numberOfChildElements {
                let referenciaEncontrada = parser["listaPropiedades"]["propiedad"][element]["referencia"].string ?? ""
                let tipoAnuncioEncontrado = parser["listaPropiedades"]["propiedad"][element]["tipoOferta"].string ?? ""
                let tipoInmuebleEncontrado = parser["listaPropiedades"]["propiedad"][element]["tipoInmueble"].string ?? ""
                let ubicacionEncontrada = parser["listaPropiedades"]["propiedad"][element]["localidad"].string ?? ""
                let dormitoriosEncontrados = parser["listaPropiedades"]["propiedad"][element]["dormitorios"].int ?? 0
                let superficieEncontrada = parser["listaPropiedades"]["propiedad"][element]["superficieConstruida"].int ?? 0
                let precioEncontrado = parser["listaPropiedades"]["propiedad"][element]["precio"].int ?? 0
                let vacacionalEncontrado = parser["listaPropiedades"]["propiedad"][element]["tipoOfertaExt"].int == 16
                let banosEncontrados = parser["listaPropiedades"]["propiedad"][element]["baños"].int ?? 0
                let imagenEncontrada = parser["listaPropiedades"]["propiedad"][element]["listaImagenes"]["imagen"][0]["url"].string ?? ""
                
                let insert = propiedades.insert(referencia <- referenciaEncontrada, tipoAnuncio <- tipoAnuncioEncontrado, tipoInmueble <- tipoInmuebleEncontrado, ubicacion <- ubicacionEncontrada, dormitorios <- dormitoriosEncontrados, superficie <- superficieEncontrada, precio <- precioEncontrado, vacacional <- vacacionalEncontrado, banos <- banosEncontrados, imagen <- imagenEncontrada)
                let rowid = try db?.run(insert)
            }
            try print(db!.scalar(propiedades.count))
        }
        catch {
            print(error)
        }
    }
    
    func remake() {
        do {
            let db : Connection?
            let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
            if let libraryPath = paths.first {
                let dbPath = (libraryPath as NSString).appendingPathComponent("database.db")
                db = try Connection(dbPath) // ¿?
                // Use dbPath for your SQLite database operations
            } else {
                print("Hubo un error al generar la base de datos")
                db = nil
            }
            let propiedades = Table("propiedades")
            try db?.run(propiedades.drop(ifExists: true))
            insertarXML()
        }
        catch {
            print(error)
        }
    }
    
    func consultar(consulta : [String : String]) -> [Propiedad] {
        do {
            let aDevolver : [Propiedad] = []
            let db : Connection?
            let paths = NSSearchPathForDirectoriesInDomains(.libraryDirectory, .userDomainMask, true)
            if let libraryPath = paths.first {
                let dbPath = (libraryPath as NSString).appendingPathComponent("database.db")
                db = try Connection(dbPath) // ¿?
                // Use dbPath for your SQLite database operations
            } else {
                print("Hubo un error al generar la base de datos")
                db = nil
            }
            let propiedades = Table("propiedades")
            let referencia = Expression<String>("referencia")
            let tipoAnuncio = Expression<String>("tipoAnuncio")
            let tipoInmueble = Expression<String>("tipoInmueble")
            let ubicacion = Expression<String>("ubicacion")
            let dormitorios = Expression<Int>("dormitorios")
            let superficie = Expression<Int>("superficie")
            let precio = Expression<Int>("precio")
            let vacacional = Expression<Bool>("vacacional")
            let banos = Expression<Int>("baños")
            let imagen = Expression<String>("imagen")
            
            var query : Table
            if (consulta.isEmpty) {
                query = propiedades
            }
            else {
                if consulta.keys.contains("referencia") {
                    let referenciaValue = consulta["referencia"]
                    let filterExpression = referencia.description == Expression<String>(referenciaValue!)
                    query = propiedades.filter(filterExpression)
                }
                else {
                    query = propiedades //TODO resto de cosas
                }
            }
            
            var contador = 0
            for propiedad in try db!.prepare(query) {
                let anadir : Propiedad = Propiedad()
                anadir.referencia = propiedad[referencia]
                anadir.precio = propiedad[precio]
                anadir.dormitorios = propiedad[dormitorios]
                anadir.superficieConstruida = propiedad[superficie]
                anadir.baños = propiedad[banos]
                anadir.imagen = propiedad[imagen]
                
                contador += 1
            }
            print(contador)
            return aDevolver
            
        }
        catch {
            print(error)
            return []
        }
    }
    
}
