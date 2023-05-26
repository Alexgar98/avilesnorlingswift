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
                /*for propiedad in try db!.prepare(propiedades.select(tipoInmueble)) {
                    print(propiedad[tipoInmueble])
                }*/
            }
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
            var aDevolver : [Propiedad] = []
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
            
            var query = propiedades
            if (!consulta.isEmpty) {
                if consulta.keys.contains("referencia") {
                    if let referenciaValue = consulta["referencia"] {
                        query = query.filter(referencia == referenciaValue)
                    }
                }
                if consulta.keys.contains("tipoAnuncio") {
                    if let anuncioValue = consulta["tipoAnuncio"] {
                        query = query.filter(tipoAnuncio == anuncioValue)
                        if (anuncioValue != "1") { //Las ventas no son vacacionales
                            if let vacacionalValue = consulta["vacacional"] {
                                let vacacionalFilter = vacacional == (vacacionalValue == "true")
                                query = query.filter(vacacionalFilter)
                            }
                        }
                    }
                }
                if consulta.keys.contains("tipoInmueble") {
                    if let inmuebleValue = consulta["tipoInmueble"] {
                        query = query.filter(tipoInmueble == inmuebleValue)
                    } //Se descodifica luego
                }
                if consulta.keys.contains("ubicacion") {
                    if let ubicacionValue = consulta["ubicacion"] {
                        query = query.filter(ubicacion == ubicacionValue)
                    }
                }
                if consulta.keys.contains("dormitorios") {
                    if let dormitoriosValue = consulta["dormitorios"] {
                        query = query.filter(dormitorios >= Int(dormitoriosValue)!)
                    }
                }
                if consulta.keys.contains("superficie") {
                    if let superficieValue = consulta["superficie"] {
                        query = query.filter(superficie >= Int(superficieValue)!)
                    }
                }
                if consulta.keys.contains("precioDesde") {
                    if let precioValue = consulta["precioDesde"] {
                        query = query.filter(precio >= Int(precioValue)!)
                    }
                }
                if consulta.keys.contains("precioHasta") {
                    if let precioValue = consulta["precioHasta"] {
                        query = query.filter(precio <= Int(precioValue)!)
                    }
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
                aDevolver.append(anadir)
            }
            return aDevolver
            
        }
        catch {
            print(error)
            return []
        }
    }
    
}
