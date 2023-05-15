//
//  BusquedaViewController.swift
//  avilesnorling
//
//  Created by Mac on 15/5/23.
//

import UIKit

class BusquedaViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITableViewDataSource, XMLParserDelegate {
    
    @IBOutlet weak var precioHasta: UITextView!
    @IBOutlet weak var tipoAnuncio: UIPickerView!
    @IBOutlet weak var superficie: UITextView!
    @IBOutlet weak var precioDesde: UITextView!
    @IBOutlet weak var ubicacion: UIPickerView!
    @IBOutlet weak var referencia: UITextView!
    @IBOutlet weak var dormitorios: UIPickerView!
    @IBOutlet weak var tipoInmueble: UIPickerView!
    
    @IBOutlet weak var tableViewAnuncios: UITableView!
    var datosXML : [DatosPropiedades] = []
    var elementoActual : String = ""
    
    weak var delegate : StringSelectionDelegate?
    var ubicacionElegida : String?
    var tipoAnuncioElegido : String?
    
    var tiposAnuncio : [String] = [String]()
    var ubicaciones : [String] = [String]()
    var numerosDormitorios : [String] = [String]()
    var tiposInmueble : [String] = [String]()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        leerXML()
        
        self.tipoAnuncio.delegate = self
        self.tipoAnuncio.dataSource = self
        
        self.ubicacion.delegate = self
        self.ubicacion.dataSource = self
        
        self.dormitorios.delegate = self
        self.dormitorios.dataSource = self
        
        self.tipoInmueble.delegate = self
        self.tipoInmueble.dataSource = self
        
        tiposAnuncio = ["Oferta", "Venta", "Alquiler", "Vacaciones"]
        ubicaciones = ["Torre del Mar", "Vélez-Málaga", "Algarrobo", "Almáchar", "Almayate", "Benajarafe", "Benamargosa", "Caleta de Vélez", "Canillas de Aceituno", "Torrox", "Málaga", "Málaga oriental"]
        numerosDormitorios = ["Dormitorios", "1+", "2+", "3+", "4+", "5+", "6+", "7+", "8+", "9+", "10+"]
        tiposInmueble = ["Tipo inmueble", "Pisos", "Casas", "Locales"]
    }
    
    @IBAction func buscar(_ sender: Any) {
    }
    
    func leerXML() {
        guard let url = URL(string: "https://avilesnorling.inmoenter.com/export/all/xcp.xml") else {
            print("URL inválida")
            return
        }
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            
            guard let httpResponse = response as? HTTPURLResponse else {
                print("Respuesta inválida")
                return
            }
            
            guard (200...299).contains(httpResponse.statusCode) else {
                print("Código inválido: \(httpResponse.statusCode)")
                return
            }
            
            guard let data = data else {
                print("No se recibieron datos")
                return
            }
            
            let parser = XMLParser(data: data)
            parser.delegate = self
            parser.parse()
            
            DispatchQueue.main.async {
                self.tableViewAnuncios.reloadData()
            }
        }
        
        task.resume()
                
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
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return datosXML.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let datos = datosXML[indexPath.row]
        return cell
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        if elementName == "propiedad" {
            let referencia = attributeDict["referencia"] ?? ""
            let fecha = attributeDict["fecha"] ?? ""
            let url = attributeDict["url"] ?? ""
            let tipoInmueble = attributeDict["tipoInmueble"] ?? ""
            let tipoOferta = attributeDict["tipoOferta"] ?? ""
            let descripcionPrincipal = attributeDict["descripcionPrincipal"] ?? ""
            let codigoPostal = attributeDict["codigoPostal"] ?? ""
            let provincia = attributeDict["provincia"] ?? ""
            let localidad = attributeDict["localidad"] ?? ""
            let direccion = attributeDict["direccion"] ?? ""
            let geoLocalizacion = attributeDict["geoLocalizacion"] ?? ""
            let registroTurismo = attributeDict["registroTurismo"] ?? ""
            let tipoOfertaExt = attributeDict["tipoOfertaExt"] ?? ""
            let superficieConstruida = attributeDict["superficieConstruida"] ?? ""
            let superficieTerrazas = attributeDict["superficieTerrazas"] ?? ""
            let consumoEnergetico = attributeDict["consumoEnergetico"] ?? ""
            let mostrarDireccion = attributeDict["mostrarDireccion"] ?? ""
            let tipoArea = attributeDict["tipoArea"] ?? ""
            let tipoZona = attributeDict["tipoZona"] ?? ""
            let tipoPlaya = attributeDict["tipoPlaya"] ?? ""
            let dormitorios = attributeDict["dormitorios"] ?? ""
            let baños = attributeDict["baños"] ?? ""
            let aseos = attributeDict["aseos"] ?? ""
            let armariosEmpotrados = attributeDict["armariosEmpotrados"] ?? ""
            let terrazas = attributeDict["terrazas"] ?? ""
            let tipoOrientacion = attributeDict["tipoOrientacion"] ?? ""
            let tipoAireAcondicionado = attributeDict["tipoAireAcondicionado"] ?? ""
            let electrodomesticos = attributeDict["electrodomesticos"] ?? ""
            let tipoPorteria = attributeDict["tipoPorteria"] ?? ""
            let ascensor = attributeDict["ascensor"] ?? ""
            let instalacionesDeportivas = attributeDict["instalacionesDeportivas"] ?? ""
            let tipoSoleria = attributeDict["tipoSoleria"] ?? ""
            let autobuses = attributeDict["autobuses"] ?? ""
            let centrosEscolares = attributeDict["centrosEscolares"] ?? ""
            let espaciosVerdes = attributeDict["espaciosVerdes"] ?? ""
            let listaImagenes = attributeDict["listaImagenes"] ?? ""
            let listaVideos = attributeDict["listaVideos"] ?? ""
            let extensionInmoenter = attributeDict["extensionInmoenter"] ?? ""
            
            let datosPropiedades = DatosPropiedades(referencia: referencia, fecha: fecha, url: url, tipoInmueble: tipoInmueble, tipoOferta: tipoOferta, descripcionPrincipal: descripcionPrincipal, codigoPostal: codigoPostal, provincia: provincia, localidad: localidad, direccion: direccion, geoLocalizacion: geoLocalizacion, registroTurismo: registroTurismo, tipoOfertaExt: tipoOfertaExt, superficieConstruida: superficieConstruida, superficieTerrazas: superficieTerrazas, consumoEnergetico: consumoEnergetico, mostrarDireccion: mostrarDireccion, tipoArea: tipoArea, tipoZona: tipoZona, tipoPlaya: tipoPlaya, dormitorios: dormitorios, baños: baños, aseos: aseos, armariosEmpotrados: armariosEmpotrados, terrazas: terrazas, tipoOrientacion: tipoOrientacion, tipoAireAcondicionado: tipoAireAcondicionado, electrodomesticos: electrodomesticos, tipoPorteria: tipoPorteria, ascensor: ascensor, instalacionesDeportivas: instalacionesDeportivas, tipoSoleria: tipoSoleria, autobuses: autobuses, centrosEscolares: centrosEscolares, espaciosVerdes: espaciosVerdes, listaImagenes: listaImagenes, listaVideos: listaVideos, extensionInmoenter: extensionInmoenter)
            
            datosXML.append(datosPropiedades)
        }
    }
    
    func parserDidEndDocument(_ parser: XMLParser) {
        DispatchQueue.main.async {
            self.tableViewAnuncios.reloadData()
        }
    }

}

struct DatosPropiedades {
    let referencia : String
    let fecha : String
    let url : String
    let tipoInmueble : String
    let tipoOferta : String
    let descripcionPrincipal : String
    let codigoPostal : String
    let provincia : String
    let localidad : String
    let direccion : String
    let geoLocalizacion : String
    let registroTurismo : String
    let tipoOfertaExt : String
    let superficieConstruida : String
    let superficieTerrazas : String
    let consumoEnergetico : String
    let mostrarDireccion : String
    let tipoArea : String
    let tipoZona : String
    let tipoPlaya : String
    let dormitorios : String
    let baños : String
    let aseos : String
    let armariosEmpotrados : String
    let terrazas : String
    let tipoOrientacion : String
    let tipoAireAcondicionado : String
    let electrodomesticos : String
    let tipoPorteria : String
    let ascensor : String
    let instalacionesDeportivas : String
    let tipoSoleria : String
    let autobuses : String
    let centrosEscolares : String
    let espaciosVerdes : String
    let listaImagenes : String
    let listaVideos : String
    let extensionInmoenter : String
}

protocol StringSelectionDelegate : AnyObject {
    func didSelectString(_ string : String)
}
