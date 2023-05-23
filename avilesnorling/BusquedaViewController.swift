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
    var dormitoriosElegidos : String?
    var tipoInmuebleElegido : String?
    
    var tiposAnuncio : [String] = [String]()
    var ubicaciones : [String] = [String]()
    var numerosDormitorios : [String] = [String]()
    var tiposInmueble : [String] = [String]()
    
    var arrayPropiedades = [Propiedad]()
    
    let url = URL(string: "https://avilesnorling.inmoenter.com/export/all/xcp.xml")
    var parser : CXMLParser!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        parser = CXMLParser(contentsOfURL: url!)
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
        
        parsing()
        
        tableViewAnuncios.reloadData()
        print(arrayPropiedades.count)
    }
    
    @IBAction func buscar(_ sender: Any) {
        parsing()
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
    
    func propiedadNueva(elemento : Int) {
        let referencia : String = parser["listaPropiedades"]["propiedad"][elemento]["referencia"].string ?? ""
        let dormitorios : Int = parser["listaPropiedades"]["propiedad"][elemento]["dormitorios"].int ?? 0
        let baños : Int = parser["listaPropiedades"]["propiedad"][elemento]["baños"].int ?? 0
        let superficieConstruida : Int = parser["listaPropiedades"]["propiedad"][elemento]["superficieConstruida"].int ?? 0
        let precio : Int = parser["listaPropiedades"]["propiedad"][elemento]["precio"].int ?? 0
        let imagen : String = parser["listaPropiedades"]["propiedad"][elemento]["listaImagenes"]["imagen"]["url"].string ?? ""
        let anadir = Propiedad()
        anadir.referencia = referencia
        anadir.dormitorios = dormitorios
        anadir.baños = baños
        anadir.superficieConstruida = superficieConstruida
        anadir.precio = precio
        anadir.imagen = imagen
        arrayPropiedades.append(anadir)
    }
    
    func parsing()
    {
        arrayPropiedades = []
        for element in 0..<parser["listaPropiedades"].numberOfChildElements {
            if parser["listaPropiedades"]["propiedad"][element]["localidad"].stringValue == ubicacionElegida && ubicacionElegida != "Málaga oriental" {
                switch tipoAnuncioElegido {
                case "Oferta":
                    propiedadNueva(elemento: element)
                case "Venta":
                    if parser["listaPropiedades"]["propiedad"][element]["tipoOferta"].string == "1" {
                        propiedadNueva(elemento: element)
                    }
                case "Alquiler":
                    if parser["listaPropiedades"]["propiedad"][element]["tipoOferta"].string == "2" && parser["listaPropiedades"]["propiedad"][element]["tipoOfertaExt"].string != "16" {
                        propiedadNueva(elemento: element)
                    }
                case "Vacaciones":
                    if parser["listaPropiedades"]["propiedad"][element]["tipoOferta"].string == "2" && parser["listaPropiedades"]["propiedad"][element]["tipoOfertaExt"].string == "16" {
                        propiedadNueva(elemento: element)
                    }
                default:
                    break
                }
            }
            else if ubicacionElegida == "Málaga oriental" {
                switch tipoAnuncioElegido {
                case "Oferta":
                    propiedadNueva(elemento: element)
                case "Venta":
                    if parser["listaPropiedades"]["propiedad"][element]["tipoOferta"].string == "1" {
                        propiedadNueva(elemento: element)
                    }
                case "Alquiler":
                    if parser["listaPropiedades"]["propiedad"][element]["tipoOferta"].string == "2" && parser["listaPropiedades"]["propiedad"][element]["tipoOfertaExt"].string != "16" {
                        propiedadNueva(elemento: element)
                    }
                case "Vacaciones":
                    if parser["listaPropiedades"]["propiedad"][element]["tipoOferta"].string == "2" && parser["listaPropiedades"]["propiedad"][element]["tipoOfertaExt"].string == "16" {
                        propiedadNueva(elemento: element)
                    }
                default:
                    break
                }
            }
        
        }
    }
    
}

protocol StringSelectionDelegate : AnyObject {
    func didSelectString(_ string : String)
}
