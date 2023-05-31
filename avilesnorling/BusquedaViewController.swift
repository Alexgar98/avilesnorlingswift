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
    @IBOutlet weak var btnBuscar: UIButton!
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
    var currentLanguage = ""
    
    let helper : DatabaseHelper = DatabaseHelper()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        arrayIdiomas = ["Español", "English", "Deutsch", "Français", "Svenska"]
        changeLanguage(lang: currentLanguage)
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
        
        self.pickerIdiomas.delegate = self
        self.pickerIdiomas.dataSource = self
        
        switch currentLanguage {
        case "es":
            pickerIdiomas.selectRow(0, inComponent: 0, animated: true)
        case "en":
            pickerIdiomas.selectRow(1, inComponent: 0, animated: true)
        case "fr":
            pickerIdiomas.selectRow(3, inComponent: 0, animated: true)
        case "de":
            pickerIdiomas.selectRow(2, inComponent: 0, animated: true)
        case "sv":
            pickerIdiomas.selectRow(4, inComponent: 0, animated: true)
        default:
            pickerIdiomas.selectRow(0, inComponent: 0, animated: true)
        }
        
        tiposAnuncio = ["Oferta", "Venta", "Alquiler", "Vacaciones"]
        ubicaciones = ["Torre del Mar", "Vélez-Málaga", "Algarrobo", "Almáchar", "Almayate", "Benajarafe", "Benamargosa", "Caleta de Vélez", "Canillas de Aceituno", "Torrox", "Málaga", "Málaga oriental"]
        numerosDormitorios = ["Dormitorios", "1+", "2+", "3+", "4+", "5+", "6+", "7+", "8+", "9+", "10+"]
        tiposInmueble = ["Tipo inmueble", "Pisos", "Casas", "Locales"]
        tableViewAnuncios.reloadData()
        
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
        if tipoAnuncioElegido != "oferta".localizeString(string: currentLanguage) {
            switch tipoAnuncioElegido {
            case "venta".localizeString(string: currentLanguage):
                consulta["tipoAnuncio"] = "1"
            case "alquiler".localizeString(string: currentLanguage):
                consulta["tipoAnuncio"] = "2"
                consulta["vacacional"] = "false"
            case "vacaciones".localizeString(string: currentLanguage):
                consulta["tipoAnuncio"] = "2"
                consulta["vacacional"] = "true"
            default:
                break
            }
        }
        else {
            consulta["tipoAnuncio"] = nil
        }
        if dormitoriosElegidos != "dormitorios".localizeString(string: currentLanguage) {
            if let dormitoriosElegidos = dormitoriosElegidos, dormitoriosElegidos.hasSuffix("+") {
                consulta["dormitorios"] = String(dormitoriosElegidos.dropLast())
            }
        }
        else {
            consulta["dormitorios"] = nil
        }
        
        if tipoInmuebleElegido != "tipoInmueble".localizeString(string: currentLanguage) {
            switch tipoInmuebleElegido {
            case "pisos".localizeString(string: currentLanguage):
                consulta["tipoInmueble"] = "2"
            case "casas".localizeString(string: currentLanguage):
                consulta["tipoInmueble"] = "16"
            case "locales".localizeString(string: currentLanguage):
                consulta["tipoInmueble"] = "512"
            default:
                break
            }
        }
        else {
            consulta["tipoInmueble"] = nil
        }
        if !referenciaElegida!.isEmpty && referenciaElegida != "referencia".localizeString(string: currentLanguage) {
            consulta["referencia"] = referenciaElegida
        }
        else {
            consulta["referencia"] = nil
        }
        if !superficieElegida!.isEmpty && superficieElegida != "superficie".localizeString(string: currentLanguage) {
            consulta["superficie"] = superficieElegida
        }
        else {
            consulta["superficie"] = nil
        }
        if !precioDesdeElegido!.isEmpty && precioDesdeElegido != "precioDesde".localizeString(string: currentLanguage) {
            consulta["precioDesde"] = precioDesdeElegido
        }
        else {
            consulta["precioDesde"] = nil
        }
        if !precioHastaElegido!.isEmpty && precioHastaElegido != "precioHasta".localizeString(string: currentLanguage) {
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
        else if pickerView == pickerIdiomas {
            switch arrayIdiomas[row] {
            case "Español":
                changeLanguage(lang: "es")
                currentLanguage = "es"
            case "English":
                changeLanguage(lang: "en")
                currentLanguage = "en"
            case "Français":
                changeLanguage(lang: "fr")
                currentLanguage = "fr"
            case "Deutsch":
                changeLanguage(lang: "de")
                currentLanguage = "de"
            case "Svenska":
                changeLanguage(lang: "sv")
                currentLanguage = "sv"
            default:
                changeLanguage(lang: "es")
                currentLanguage = "es"
            }
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
        changeLanguage(lang: currentLanguage)
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
            cell.precioAnuncio.text = "consultar".localizeString(string: currentLanguage)
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
            destino.currentLanguage = currentLanguage
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
            textView.text = "referencia".localizeString(string: currentLanguage)
            case superficie:
            textView.text = "superficie".localizeString(string: currentLanguage)
            case precioDesde:
            textView.text = "precioDesde".localizeString(string: currentLanguage)
            case precioHasta:
            textView.text = "precioHasta".localizeString(string: currentLanguage)
                    default:
                        textView.text = ""
            }
            textView.textColor = UIColor.lightGray
        }
    }
    
    func changeLanguage(lang: String) {
        btnBuscar.setTitle("buscar".localizeString(string: lang), for: .normal)
        
            referencia.text = "referencia".localizeString(string: lang)
            referencia.textColor = UIColor.lightGray
        
            superficie.text = "superficie".localizeString(string: lang)
            superficie.textColor = UIColor.lightGray
        
            precioDesde.text = "precioDesde".localizeString(string: lang)
            precioDesde.textColor = UIColor.lightGray
        
            precioHasta.text = "precioHasta".localizeString(string: lang)
            precioHasta.textColor = UIColor.lightGray
        
        tiposAnuncio = ["oferta".localizeString(string: lang), "venta".localizeString(string: lang), "alquiler".localizeString(string: lang), "vacaciones".localizeString(string: lang)]
        numerosDormitorios = ["dormitorios".localizeString(string: lang), "1+", "2+", "3+", "4+", "5+", "6+", "7+", "8+", "9+", "10+"]
        tiposInmueble = ["tipoInmueble".localizeString(string: lang), "pisos".localizeString(string: lang), "casas".localizeString(string: lang), "locales".localizeString(string: lang)]
        dormitorios.reloadAllComponents()
        tipoAnuncio.reloadAllComponents()
        tipoInmueble.reloadAllComponents()
        let celda = tableViewAnuncios.dequeueReusableCell(withIdentifier: "celdaAnuncios") as! BusquedaTableViewCellController
        if !(celda.precioAnuncio.text?.hasSuffix("€"))! {
            celda.precioAnuncio.text = "consultar".localizeString(string: lang)
        }
        currentLanguage = lang
        tableViewAnuncios.reloadData()
    }
    
}

protocol StringSelectionDelegate : AnyObject {
    func didSelectString(_ string : String)
}
