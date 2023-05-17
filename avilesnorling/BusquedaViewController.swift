//
//  BusquedaViewController.swift
//  avilesnorling
//
//  Created by Mac on 15/5/23.
//

import UIKit
import Foundation
import CheatyXML

class BusquedaViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, XMLParserDelegate, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var precioHasta: UITextView!
    @IBOutlet weak var tipoAnuncio: UIPickerView!
    @IBOutlet weak var superficie: UITextView!
    @IBOutlet weak var precioDesde: UITextView!
    @IBOutlet weak var ubicacion: UIPickerView!
    @IBOutlet weak var referencia: UITextView!
    @IBOutlet weak var dormitorios: UIPickerView!
    @IBOutlet weak var tipoInmueble: UIPickerView!
    
    @IBOutlet weak var tableViewAnuncios: UITableView!
    weak var delegate : StringSelectionDelegate?
    var ubicacionElegida : String?
    var tipoAnuncioElegido : String?
    
    var tiposAnuncio : [String] = [String]()
    var ubicaciones : [String] = [String]()
    var numerosDormitorios : [String] = [String]()
    var tiposInmueble : [String] = [String]()
    
    //var parser = XMLParser()
    var arrayPropiedades = [Propiedad]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.tipoAnuncio.delegate = self
        self.tipoAnuncio.dataSource = self
        
        self.ubicacion.delegate = self
        self.ubicacion.dataSource = self
        
        self.dormitorios.delegate = self
        self.dormitorios.dataSource = self
        
        self.tipoInmueble.delegate = self
        self.tipoInmueble.dataSource = self
        
        self.tableViewAnuncios.dataSource = self
        self.tableViewAnuncios.delegate = self
        
        tiposAnuncio = ["Oferta", "Venta", "Alquiler", "Vacaciones"]
        ubicaciones = ["Torre del Mar", "Vélez-Málaga", "Algarrobo", "Almáchar", "Almayate", "Benajarafe", "Benamargosa", "Caleta de Vélez", "Canillas de Aceituno", "Torrox", "Málaga", "Málaga oriental"]
        numerosDormitorios = ["Dormitorios", "1+", "2+", "3+", "4+", "5+", "6+", "7+", "8+", "9+", "10+"]
        tiposInmueble = ["Tipo inmueble", "Pisos", "Casas", "Locales"]
        
        print("Ahora va a parsear")
        let url = URL(string: "https://avilesnorling.inmoenter.com/export/all/xcp.xml")
        let parser : CXMLParser! = CXMLParser(contentsOfURL: url!)
        let referencia : String! = parser["listaPropiedades"]["propiedad"][0]["referencia"].stringValue
        let dormitorios : String! = parser["listaPropiedades"]["propiedad"][0]["dormitorios"].stringValue
        let baños : String! = parser["listaPropiedades"]["propiedad"][0]["baños"].stringValue
        let superficieConstruida : String! = parser["listaPropiedades"]["propiedad"][0]["superficieConstruida"].stringValue
        print(referencia!)
        print("Si ha salido A&N Chanquete es que va bien")
        let numeroPropiedades = parser["listaPropiedades"].numberOfChildElements
        print(numeroPropiedades)
        var propiedadPrueba = Propiedad()
        propiedadPrueba.referencia = referencia!
        propiedadPrueba.dormitorios = dormitorios!
        propiedadPrueba.baños = baños!
        propiedadPrueba.superficieConstruida = superficieConstruida!
        print(propiedadPrueba.referencia)
        print("Si ha vuelto a salir A&N Chanquete es que tienes el bug arreglado por fin")
        print(propiedadPrueba.dormitorios!)
        print("Deben salir 2")
        print(propiedadPrueba.baños!)
        print("Deben salir 1")
        print(propiedadPrueba.superficieConstruida!)
        print("Deben salir 70")
        /*self.parser = XMLParser(contentsOf: url!)!
        self.parser.delegate = self
        let success : Bool = self.parser.parse()
        if success {
            print("success. El número de propiedades es ", arrayPropiedades.count)
        } else {
            print("error")
        }*/

    }
    
    @IBAction func buscar(_ sender: Any) {
        //TODO Hacer la búsqueda actually
        tableViewAnuncios.reloadData()
        print("Debería haberse recargado")
    }
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView == tipoAnuncio {
            return tiposAnuncio.count
        }
        else if pickerView == ubicacion {
            return ubicaciones.count
        }
        else if pickerView == dormitorios {
            return numerosDormitorios.count
        }
        else if pickerView == tipoInmueble {
            return tiposInmueble.count
        }
        return 0
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView == tipoAnuncio {
            return tiposAnuncio[row]
        }
        else if pickerView == ubicacion {
            return ubicaciones[row]
        }
        else if pickerView == dormitorios {
            return numerosDormitorios[row]
        }
        else if pickerView == tipoInmueble {
            return tiposInmueble[row]
        }
        return nil
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView == ubicacion {
            ubicacionElegida = ubicaciones[row]
            delegate?.didSelectString(ubicacionElegida!)
            pickerView.selectRow(row, inComponent: component, animated: true)
        }
        else if pickerView == tipoAnuncio {
            tipoAnuncioElegido = tiposAnuncio[row]
            delegate?.didSelectString(tipoAnuncioElegido!)
            pickerView.selectRow(row, inComponent: component, animated: true)
        }
        
        //TODO guardar datos
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indiceUbicacion = ubicaciones.firstIndex(of: ubicacionElegida!) {
            ubicacion.selectRow(indiceUbicacion, inComponent: 0, animated: true)
        }
        if let indiceTipoAnuncio = tiposAnuncio.firstIndex(of: tipoAnuncioElegido!) {
            tipoAnuncio.selectRow(indiceTipoAnuncio, inComponent: 0, animated: true)
        }
        
    }
    
    
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "propiedad" {
            let propiedad = Propiedad()
            for string in attributeDict {
                let strvalue = string.value// as NSString
                switch string.key {
                case "precio":
                    propiedad.precio = strvalue// as String
                    break
                case "referencia":
                    propiedad.referencia = strvalue// as String
                    break
                case "dormitorios":
                    propiedad.dormitorios = strvalue// as String
                    break
                case "superficieConstruida":
                    propiedad.superficieConstruida = strvalue// as String
                    break
                case "baños":
                    propiedad.baños = strvalue// as String
                    break
                default:
                    break
                }
            }
            arrayPropiedades.append(propiedad)
            print(propiedad.referencia)
        }
    }
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        
    }
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        
    }
    func parser(_ parser: XMLParser, parseErrorOccurred parseError: Error) {
        print("error: ", parseError)
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return arrayPropiedades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaAnuncios", for: indexPath) as! BusquedaTableViewCellController
        
        let propiedad = arrayPropiedades[indexPath.row]
        let precio = propiedad.precio
        let referencia = propiedad.referencia
        let dormitorios = propiedad.dormitorios
        let superficieConstruida = propiedad.superficieConstruida
        let baños = propiedad.baños
        cell.precioAnuncio.text = precio
        cell.referenciaAnuncio.text = referencia
        cell.dormitoriosAnuncio.text = dormitorios
        cell.superficieAnuncio.text = superficieConstruida
        cell.bañosAnuncio.text = baños

        // Configure the cell...

        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "aAnuncio" {
            let destino = segue.destination as? AnuncioViewController
            let propiedadClickada = sender as? Propiedad
            print(propiedadClickada?.referencia ?? "Si ves este mensaje es que la has cagao' :D")
        }
    }
}

protocol StringSelectionDelegate : AnyObject {
    func didSelectString(_ string : String)
}
