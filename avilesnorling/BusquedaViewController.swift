//
//  BusquedaViewController.swift
//  avilesnorling
//
//  Created by Mac on 15/5/23.
//

import UIKit
import Foundation
import CheatyXML

class BusquedaViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate {
    
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
        self.tableViewAnuncios.register(UINib(nibName: "BusquedaTableViewCellController", bundle: nil), forCellReuseIdentifier: "celdaAnuncios")
        
        tiposAnuncio = ["Oferta", "Venta", "Alquiler", "Vacaciones"]
        ubicaciones = ["Torre del Mar", "Vélez-Málaga", "Algarrobo", "Almáchar", "Almayate", "Benajarafe", "Benamargosa", "Caleta de Vélez", "Canillas de Aceituno", "Torrox", "Málaga", "Málaga oriental"]
        numerosDormitorios = ["Dormitorios", "1+", "2+", "3+", "4+", "5+", "6+", "7+", "8+", "9+", "10+"]
        tiposInmueble = ["Tipo inmueble", "Pisos", "Casas", "Locales"]
        
        print("Ahora va a parsear")
        let url = URL(string: "https://avilesnorling.inmoenter.com/export/all/xcp.xml")
        let parser : CXMLParser! = CXMLParser(contentsOfURL: url!)
        
        for element in 0..<parser["listaPropiedades"].numberOfChildElements {
            let referencia : String = parser["listaPropiedades"]["propiedad"][element]["referencia"].string ?? ""
            let dormitorios : String = parser["listaPropiedades"]["propiedad"][element]["dormitorios"].string ?? ""
            let baños : String = parser["listaPropiedades"]["propiedad"][element]["baños"].string ?? ""
            let superficieConstruida : String = parser["listaPropiedades"]["propiedad"][element]["superficieConstruida"].string ?? ""
            let precio : String = parser["listaPropiedades"]["propiedad"][element]["precio"].string ?? ""
            let anadir = Propiedad()
            anadir.referencia = referencia
            anadir.dormitorios = dormitorios
            anadir.baños = baños
            anadir.superficieConstruida = superficieConstruida
            anadir.precio = precio
            arrayPropiedades.append(anadir)
            
        }
        tableViewAnuncios.reloadData()
        let numeroPropiedades : Int = parser["listaPropiedades"].numberOfChildElements
        print(numeroPropiedades)
        for element in arrayPropiedades {
            print(element.referencia)
        }

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
