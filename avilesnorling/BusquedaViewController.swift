//
//  BusquedaViewController.swift
//  avilesnorling
//
//  Created by Mac on 15/5/23.
//

import UIKit
import Foundation
import CheatyXML
import SDWebImage

class BusquedaViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, UITableViewDelegate, UITextViewDelegate {
    
    @IBOutlet weak var precioHasta: UITextView!
    @IBOutlet weak var tipoAnuncio: UIPickerView!
    @IBOutlet weak var superficie: UITextView!
    @IBOutlet weak var precioDesde: UITextView!
    @IBOutlet weak var ubicacion: UIPickerView!
    @IBOutlet weak var referencia: UITextView!
    @IBOutlet weak var dormitorios: UIPickerView!
    @IBOutlet weak var tipoInmueble: UIPickerView!
    
    @IBOutlet weak var pickerIdiomas: UIPickerView!
    @IBOutlet weak var tableViewAnuncios: UITableView!
    weak var delegate : StringSelectionDelegate?
    var ubicacionElegida : String?
    var tipoAnuncioElegido : String?
    var dormitoriosElegidos : String?
    var tipoInmuebleElegido : String?
    
    var tiposAnuncio : [String] = [String]()
    var ubicaciones : [String] = [String]()
    var numerosDormitorios : [String] = [String]()
    var tiposInmueble : [String] = [String]()
    var arrayIdiomas : [String] = [String]()
    
    var arrayPropiedades = [Propiedad]()
    var consulta : [String : String] = [:]
    
    //let url = URL(string: "https://avilesnorling.inmoenter.com/export/all/xcp.xml")
    //var parser : CXMLParser!
    let helper : DatabaseHelper = DatabaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayIdiomas = ["Español", "English", "Deutsch", "Français", "Svenska"]
        changeLanguage(lang: "es")
        // Do any additional setup after loading the view.
        self.referencia.delegate = self
        self.superficie.delegate = self
        self.precioDesde.delegate = self
        self.precioHasta.delegate = self
        
        referencia.text = "Referencia"
        referencia.textColor = UIColor.lightGray
        
        superficie.text = "Sup. Desde"
        superficie.textColor = UIColor.lightGray
        
        precioDesde.text = "Precio Desde"
        precioDesde.textColor = UIColor.lightGray
        
        precioHasta.text = "Precio Hasta"
        precioHasta.textColor = UIColor.lightGray
        
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
        
        //print("Ahora va a parsear")

        //parsing()
        
        tableViewAnuncios.reloadData()
        print(arrayPropiedades.count)
    }
    
    @IBAction func buscar(_ sender: Any) {
        let referenciaElegida = referencia.text
        let superficieElegida = superficie.text
        let precioDesdeElegido = precioDesde.text
        let precioHastaElegido = precioHasta.text
        if ubicacionElegida != "Málaga oriental" {
            consulta["ubicacion"] = ubicacionElegida
        }
        else {
            consulta["ubicacion"] = nil
        }
        if tipoAnuncioElegido != "Oferta" {
            switch tipoAnuncioElegido {
            case "Venta":
                consulta["tipoAnuncio"] = "1"
            case "Alquiler":
                consulta["tipoAnuncio"] = "2"
                consulta["vacacional"] = "false"
            case "Vacaciones":
                consulta["tipoAnuncio"] = "2"
                consulta["vacacional"] = "true"
            default:
                break
            }
        }
        else {
            consulta["tipoAnuncio"] = nil
        }
        if dormitoriosElegidos != "Dormitorios" {
            //consulta["dormitorios"] = dormitoriosElegidos?.drop(while: { $0 == "+" }) as? String
            if let dormitoriosElegidos = dormitoriosElegidos, dormitoriosElegidos.hasSuffix("+") {
                consulta["dormitorios"] = String(dormitoriosElegidos.dropLast())
            }
        }
        else {
            consulta["dormitorios"] = nil
        }
        
        if tipoInmuebleElegido != "Tipo inmueble" {
            switch tipoInmuebleElegido {
            case "Pisos":
                consulta["tipoInmueble"] = "2"
            case "Casas":
                consulta["tipoInmueble"] = "16"
            case "Locales":
                consulta["tipoInmueble"] = "512"
            default:
                break
            }
        }
        else {
            consulta["tipoInmueble"] = nil
        }
        if !referenciaElegida!.isEmpty {
            consulta["referencia"] = referenciaElegida
        }
        else {
            consulta["referencia"] = nil
        }
        if !superficieElegida!.isEmpty {
            consulta["superficie"] = superficieElegida
        }
        else {
            consulta["superficie"] = nil
        }
        if !precioDesdeElegido!.isEmpty {
            consulta["precioDesde"] = precioDesdeElegido
        }
        else {
            consulta["precioDesde"] = nil
        }
        if !precioHastaElegido!.isEmpty {
            consulta["precioHasta"] = precioHastaElegido
        }
        else {
            consulta["precioHasta"] = nil
        }
        arrayPropiedades = helper.consultar(consulta: consulta)
        tableViewAnuncios.reloadData()
        print("Debería haberse recargado")
        print(arrayPropiedades.count)
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
        else if pickerView == pickerIdiomas {
            return arrayIdiomas.count
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
        else if pickerView == pickerIdiomas {
            return arrayIdiomas[row]
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
        else if pickerView == dormitorios {
            dormitoriosElegidos = numerosDormitorios[row]
            delegate?.didSelectString(dormitoriosElegidos!)
            pickerView.selectRow(row, inComponent: component, animated: true)
        }
        else if pickerView == tipoInmueble {
            tipoInmuebleElegido = tiposInmueble[row]
            delegate?.didSelectString(tipoInmuebleElegido!)
            pickerView.selectRow(row, inComponent: component, animated: true)
        }
        
        //TODO guardar datos
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if let indiceUbicacion = ubicaciones.firstIndex(of: ubicacionElegida!) {
            ubicacion.selectRow(indiceUbicacion, inComponent: 0, animated: true)
            consulta["ubicacion"] = ubicacionElegida
        }
        if let indiceTipoAnuncio = tiposAnuncio.firstIndex(of: tipoAnuncioElegido!) {
            tipoAnuncio.selectRow(indiceTipoAnuncio, inComponent: 0, animated: true)
            switch tipoAnuncioElegido {
            case "Venta":
                consulta["tipoAnuncio"] = "1"
            case "Alquiler":
                consulta["tipoAnuncio"] = "2"
                consulta["vacacional"] = "false"
            case "Vacaciones":
                consulta["tipoAnuncio"] = "2"
                consulta["vacacional"] = "true"
            default:
                break
            }
            arrayPropiedades = helper.consultar(consulta: consulta)
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return arrayPropiedades.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "celdaAnuncios", for: indexPath) as! BusquedaTableViewCellController
        
        let propiedad = arrayPropiedades[indexPath.row]
        let precio = propiedad.precio
        let referencia = propiedad.referencia
        let dormitorios = propiedad.dormitorios
        let superficieConstruida = propiedad.superficieConstruida ?? 0
        let baños = propiedad.baños
        let imagen = propiedad.imagen ?? ""
        if precio != 0 {
            cell.precioAnuncio.text = "\(precio!) €"
        }
        else {
            cell.precioAnuncio.text = "A consultar"
        }
        cell.referenciaAnuncio.text = "Ref: \(referencia)"
        if dormitorios != 0 {
            cell.dormitoriosAnuncio.text = "\(dormitorios!)"
        }
        else {
            cell.dormitoriosAnuncio.isHidden = true
            cell.iconoDormitorios.isHidden = true
        }
        if superficieConstruida != 0 {
            cell.superficieAnuncio.text = "\(superficieConstruida) m2"
        }
        else {
            cell.superficieAnuncio.isHidden = true
            cell.iconoSuperficie.isHidden = true
        }
        if baños != 0 {
            cell.bañosAnuncio.text = "\(baños!)"
        }
        else {
            cell.bañosAnuncio.isHidden = true
            cell.iconoBanos.isHidden = true
        }
        cell.imagenAnuncio.sd_setImage(with: URL(string: imagen))

        // Configure the cell...

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let datos = arrayPropiedades[indexPath.row]
        if let destino = storyboard?.instantiateViewController(withIdentifier: "anuncio") as? AnuncioViewController {
            destino.datosRecibidos = datos
            navigationController?.pushViewController(destino, animated: true)
        }
    }
    
    func textViewDidBeginEditing(_ textView : UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = UIColor.white
        }
    }
    
    func textViewDidEndEditing(_ textView : UITextView) {
        if textView.text.isEmpty {
            switch textView {
            case referencia:
                textView.text = "Referencia"
            case superficie:
                textView.text = "Sup. Desde"
            case precioDesde:
                textView.text = "Precio Desde"
            case precioHasta:
                textView.text = "Precio Hasta"
            default:
                textView.text = ""
            }
            textView.textColor = UIColor.lightGray
        }
    }
    
    func changeLanguage(lang: String) {
        
    }
    
}

protocol StringSelectionDelegate : AnyObject {
    func didSelectString(_ string : String)
}
