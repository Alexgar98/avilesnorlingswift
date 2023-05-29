//
//  AnuncioViewController.swift
//  avilesnorling
//
//  Created by Mac on 15/5/23.
//

import UIKit
import CheatyXML
import SDWebImage

class AnuncioViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource {
    
    
    var datosRecibidos : Propiedad?
    @IBOutlet weak var referencia: UILabel!
    
    @IBOutlet weak var reservarBtn: UIButton!
    @IBOutlet weak var scrollImagenes: UIScrollView!
    @IBOutlet weak var stackImagenes: UIStackView!
    @IBOutlet weak var scroll: UIScrollView!
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var categoria: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var precio: UILabel!
    @IBOutlet weak var generales: UILabel!
    @IBOutlet weak var superficies: UILabel!
    @IBOutlet weak var equipamientos: UILabel!
    @IBOutlet weak var calidades: UILabel!
    @IBOutlet weak var generalesTitulo: UILabel!
    @IBOutlet weak var superficiesTitulo: UILabel!
    @IBOutlet weak var equipamientosTitulo: UILabel!
    @IBOutlet weak var calidadesTitulo: UILabel!
    @IBOutlet weak var situacionTitulo: UILabel!
    @IBOutlet weak var situacion: UILabel!
    @IBOutlet weak var cercaDeTitulo: UILabel!
    @IBOutlet weak var cercaDe: UILabel!
    @IBOutlet weak var comunicacionesTitulo: UILabel!
    @IBOutlet weak var comunicaciones: UILabel!
    @IBOutlet weak var contactoTitulo: UILabel!
    @IBOutlet weak var contacto: UILabel!
    var caracteristicasGenerales = ""
    var txtSuperficies = ""
    var txtEquipamientos = ""
    var txtCalidades = ""
    var txtSituacion = ""
    var txtCercaDe = ""
    var txtComunicaciones = ""
    var txtContacto = ""
    
    var arrayIdiomas : [String] = [String]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        arrayIdiomas = ["Español", "English", "Deutsch", "Français", "Svenska"]
        changeLanguage(lang: "es")
        
        var arrayUrlImagenes : [String] = []
        
        if let datos = datosRecibidos {
            referencia.text = "Ref.: \(datos.referencia)"
            if (datos.precio == 0) {
                precio.text = "A consultar"
            }
            else {
                precio.text = "\(datos.precio!) €"
            }
            
            print("Ahora va a parsear")
            let url = URL(string: "https://avilesnorling.inmoenter.com/export/all/xcp.xml")
            let parser : CXMLParser! = CXMLParser(contentsOfURL: url!)
            
            for element in 0..<parser["listaPropiedades"].numberOfChildElements {
                if parser["listaPropiedades"]["propiedad"][element]["referencia"].stringValue == datos.referencia {
                    titulo.text = parser["listaPropiedades"]["propiedad"][element]["extensionInmoenter"]["listaTitulos"]["titulo"][0]["texto"].stringValue
                    let codigoTipoInmueble = parser["listaPropiedades"]["propiedad"][element]["tipoInmueble"].stringValue
                    let tipoInmueble : String
                    switch codigoTipoInmueble {
                    case "1":
                        tipoInmueble = "Estudio"
                    case "2":
                        tipoInmueble = "Apartamento"
                    case "4":
                        tipoInmueble = "Piso"
                    case "8":
                        tipoInmueble = "Dúplex"
                    case "16":
                        tipoInmueble = "Casa"
                    case "64":
                        tipoInmueble = "Chalet"
                    case "128":
                        tipoInmueble = "Villa"
                    case "512":
                        tipoInmueble = "Local"
                    default:
                        tipoInmueble = "Propiedad"
                    }
                    let localidad = parser["listaPropiedades"]["propiedad"][element]["localidad"].stringValue
                    categoria.text = "\(tipoInmueble) en \(localidad)"

                    descripcion.text = parser["listaPropiedades"]["propiedad"][element]["descripcionPrincipal"]["descripcion"][0]["texto"].string?.trimmingCharacters(in: .whitespacesAndNewlines)
                    for imagen in 0..<parser["listaPropiedades"]["propiedad"][element]["listaImagenes"].numberOfChildElements {
                        arrayUrlImagenes.append(parser["listaPropiedades"]["propiedad"][element]["listaImagenes"]["imagen"][imagen]["url"].stringValue)
                    }
                    /*for subview in stackImagenes.arrangedSubviews {
                        stackImagenes.removeArrangedSubview(subview)
                        subview.removeFromSuperview()
                    }*/
                    
                    for imagen in arrayUrlImagenes {
                        let anadir : UIImageView = UIImageView()
                        anadir.sd_setImage(with: URL(string: imagen))
                        anadir.contentMode = .scaleAspectFit
                        anadir.clipsToBounds = true
                        stackImagenes.addArrangedSubview(anadir)
                    }
                    let codigoTurismo = parser["listaPropiedades"]["propiedad"][element]["registroTurismo"].string
                    if (codigoTurismo != nil) {
                        caracteristicasGenerales.append("- Código turístico: \(codigoTurismo!)\n")
                    }
                    let plantas = parser["listaPropiedades"]["propiedad"][element]["extensionInmoenter"]["nplantas"].string
                    if (plantas != nil) {
                        caracteristicasGenerales.append("- \(plantas!)ª planta\n")
                    }
                    let salones = parser["listaPropiedades"]["propiedad"][element]["extensionInmoenter"]["salones"].string
                    if (salones != nil) {
                        caracteristicasGenerales.append("- \(salones!) salones\n")
                    }
                    let dormitorios = parser["listaPropiedades"]["propiedad"][element]["dormitorios"].string
                    if (dormitorios != nil) {
                        caracteristicasGenerales.append("- \(dormitorios!) dormitorios\n")
                    }
                    let banos = parser["listaPropiedades"]["propiedad"][element]["baños"].string
                    if (banos != nil) {
                        caracteristicasGenerales.append("- \(banos!) baños\n")
                    }
                    let empotrados = parser["listaPropiedades"]["propiedad"][element]["armariosEmpotrados"].string
                    if (empotrados != nil) {
                        caracteristicasGenerales.append("- \(empotrados!) armarios empotrados\n")
                    }
                    let terrazas = parser["listaPropiedades"]["propiedad"][element]["terrazas"].string
                    let superficieTerrazas = parser["listaPropiedades"]["propiedad"][element]["superficieTerrazas"].string
                    if (terrazas != nil) {
                        caracteristicasGenerales.append("- \(terrazas!) terrazas")
                        if superficieTerrazas != nil {
                            caracteristicasGenerales.append(" (\(superficieTerrazas!) m2)\n")
                        }
                        else {
                            caracteristicasGenerales.append("\n")
                        }
                    }
                    let lavadero = parser["listaPropiedades"]["propiedad"][element]["extensionInmoenter"]["lavadero"].string
                    if (lavadero != nil) {
                        caracteristicasGenerales.append("- Lavadero")
                    }
                    
                    let construido = parser["listaPropiedades"]["propiedad"][element]["superficieConstruida"].string
                    if (construido != nil) {
                        txtSuperficies.append("- Const.: \(construido!) m2")
                    }
                    let util = parser["listaPropiedades"]["propiedad"][element]["superficieUtil"].string
                    if (util != nil) {
                        txtSuperficies.append("\n- Útil: \(util!) m2")
                    }
                    
                    let piscina = parser["listaPropiedades"]["propiedad"][element]["piscina"].string
                    if (piscina != nil) {
                        txtEquipamientos.append("\n- Piscina")
                    }
                    let jardines = parser["listaPropiedades"]["propiedad"][element]["jardines"].string
                    if (jardines != nil) {
                        txtEquipamientos.append("\n- Jardines")
                    }
                    let cocinaAmueblada = parser["listaPropiedades"]["propiedad"][element]["cocinaAmueblada"].string
                    if (cocinaAmueblada != nil) {
                        txtEquipamientos.append("\n- Cocina amueblada")
                    }
                    let electrodomesticos = parser["listaPropiedades"]["propiedad"][element]["electrodomesticos"].string
                    if (electrodomesticos != nil) {
                        txtEquipamientos.append("\n- Electrodomésticos")
                    }
                    let portero = parser["listaPropiedades"]["propiedad"][element]["tipoPortero"].string
                    if (portero != nil) {
                        if (portero == "1") {
                            txtEquipamientos.append("\n- Portero automático")
                        }
                        else {
                            txtEquipamientos.append("\n- Video-portero")
                        }
                    }
                    let tipoCocina = parser["listaPropiedades"]["propiedad"][element]["extensionInmoenter"]["tipoCocina"].string
                    if (tipoCocina != nil) {
                        switch tipoCocina {
                        case "1":
                            txtEquipamientos.append("\n- Cocina independiente")
                        case "2":
                            txtEquipamientos.append("\n- Cocina americana")
                        default:
                            txtEquipamientos.append("\n- COcina amueblada")
                        }
                    }
                    let tipoAC = parser["listaPropiedades"]["propiedad"][element]["tipoAireAcondicionado"].string
                    if (tipoAC != nil) {
                        switch tipoAC {
                        case "2":
                            txtEquipamientos.append("\n- Aire Acondicionado / Instalación")
                        case "3":
                            txtEquipamientos.append("\n- A/C Climatizador")
                        default:
                            if (parser["listaPropiedades"]["propiedad"][element]["tipoConservacion"].string == "6") {
                                txtEquipamientos.append("\n- Aire Acondicionado / Preinstalación")
                            }
                            else {
                                txtEquipamientos.append("\n- Aire acondicionado central")
                            }
                        }
                    }
                    
                    let soleria = parser["listaPropiedades"]["propiedad"][element]["tipoSoleria"].string
                    if (soleria != nil) {
                        switch soleria {
                        case "5":
                            txtCalidades.append("\n- Solería de cerámica")
                        case "1":
                            txtCalidades.append("\n- Solería de parquet")
                        case "6":
                            txtCalidades.append("\n- Tarima")
                        default:
                            txtCalidades.append("\n- Solería de mármol")
                        }
                    }
                    let zona = parser["listaPropiedades"]["propiedad"][element]["tipoZona"].string
                    if zona != nil {
                        if zona == "1" {
                            txtSituacion.append("\n- Zona urbana")
                        }
                        else {
                            txtSituacion.append("\n- Urbanización")
                        }
                    }
                    let playa = parser["listaPropiedades"]["propiedad"][element]["tipoPlaya"].string
                    if playa != nil {
                        switch playa {
                        case "2":
                            txtSituacion.append("\n- A 500 metros de la playa")
                        case "4":
                            txtSituacion.append("\n- 2ª Línea de playa")
                        case "3":
                            txtSituacion.append("\n- En zona costera")
                        default:
                            txtSituacion.append("\n- 1ª Línea de playa")
                        }
                    let orientacion = parser["listaPropiedades"]["propiedad"][element]["tipoOrientacion"].string
                        if (orientacion != nil) {
                            switch orientacion {
                            case "3":
                                txtSituacion.append("\n- Orientación este")
                            case "4":
                                txtSituacion.append("\n- Orientación oeste")
                            case "2":
                                txtSituacion.append("\n- Orientación sur")
                            case "8":
                                txtSituacion.append("\n- Orientación suroeste")
                            case "7":
                                txtSituacion.append("\n- Orientación sureste")
                            default:
                                txtSituacion.append("\n- Orientación noroeste")
                            }
                        }
                    }
                    let escuelas = parser["listaPropiedades"]["propiedad"][element]["centrosEscolares"].string
                    if (escuelas != nil) {
                        txtCercaDe.append("\n- Escuelas")
                    }
                    let deporte = parser["listaPropiedades"]["propiedad"][element]["instalacionesDeportivas"].string
                    if (deporte != nil) {
                        txtCercaDe.append("\n- Zonas deportivas")
                    }
                    let verde = parser["listaPropiedades"]["propiedad"][element]["espaciosVerdes"].string
                    if verde != nil {
                        txtCercaDe.append("\n- Zonas verdes")
                    }
                    let bus = parser["listaPropiedades"]["propiedad"][element]["autobuses"].string
                    if bus != nil {
                        txtComunicaciones.append("\n- Bus")
                    }
                    let nombreContacto = parser["listaPropiedades"]["propiedad"][element]["extensionInmoenter"]["nombreContacto"].string
                    if nombreContacto != nil {
                        txtContacto.append("\n\(nombreContacto!)")
                    }
                    let emailContacto = parser["listaPropiedades"]["propiedad"][element]["extensionInmoenter"]["emailContacto"].string
                    if emailContacto != nil {
                        txtContacto.append("\n\(emailContacto!)")
                    }
                    let telefonoContacto = parser["listaPropiedades"]["propiedad"][element]["extensionInmoenter"]["telefonoContacto"].string
                    if telefonoContacto != nil {
                        txtContacto.append("\n\(telefonoContacto!)")
                    }
                    break
                }
            }
            if (caracteristicasGenerales != "") {
                generales.text = caracteristicasGenerales
            }
            else {
                generales.isHidden = true
                generalesTitulo.isHidden = true
            }
            if (txtSuperficies != "") {
                superficies.text = txtSuperficies
            }
            else {
                superficies.isHidden = true
                superficiesTitulo.isHidden = true
            }
            if (txtEquipamientos != "") {
                equipamientos.text = txtEquipamientos
            }
            else {
                equipamientos.isHidden = true
                equipamientosTitulo.isHidden = true
            }
            if (txtCalidades != "") {
                calidades.text = txtCalidades
                print(txtCalidades)
            }
            else {
                calidades.isHidden = true
                calidadesTitulo.isHidden = true
            }
            if (txtSituacion != "") {
                situacion.text = txtSituacion
            }
            else {
                situacion.isHidden = true
                situacionTitulo.isHidden = true
            }
            if (txtCercaDe != "") {
                cercaDe.text = txtCercaDe
            }
            else {
                cercaDe.isHidden = true
                cercaDeTitulo.isHidden = true
            }
            if (txtComunicaciones != "") {
                comunicaciones.text = txtComunicaciones
            }
            else {
                comunicaciones.isHidden = true
                comunicacionesTitulo.isHidden = true
            }
            if (txtContacto != "") {
                contacto.text = txtContacto
            }
            else {
                contacto.isHidden = true
                contactoTitulo.isHidden = true
            }
        }
        /*stackImagenes.distribution = .fillEqually
        let anchoTotal = CGFloat(arrayUrlImagenes.count) * view.frame.width
        stackImagenes.frame = CGRect(x: 0, y: 100, width: anchoTotal, height: scrollImagenes.frame.height)
        
        scrollImagenes.isScrollEnabled = true
        scroll.layoutIfNeeded()*/
        //let spacing : CGFloat = 10.0
        let anchoImagenes = view.frame.width
        let anchoTotal = CGFloat(arrayUrlImagenes.count) * view.frame.width
        stackImagenes.distribution = .fillEqually
        stackImagenes.frame = CGRect(x: 0, y: 0, width: anchoTotal, height: scrollImagenes.frame.height)
        //stackImagenes.removeAllArrangedSubviews()
        scrollImagenes.contentSize = CGSize(width: anchoTotal, height: scrollImagenes.frame.height)
        scrollImagenes.isScrollEnabled = true
        scrollImagenes.layoutIfNeeded()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayIdiomas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayIdiomas[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch arrayIdiomas[row] {
        case "Español":
            changeLanguage(lang: "es")
        case "English":
            changeLanguage(lang: "en")
        case "Français":
            changeLanguage(lang: "fr")
        case "Deutsch":
            changeLanguage(lang: "de")
        case "Svenska":
            changeLanguage(lang: "sv")
        default:
            changeLanguage(lang: "es")
        }
    }
    
    func changeLanguage(lang: String) {
        reservarBtn.setTitle("reservar".localizeString(string: lang), for: .normal)
    }
    
    @IBAction func btnReserva(_ sender: Any) {
        jsonParser()
    }
    
    func jsonParser()
    {
        if let url = URL(string: "https://raw.githubusercontent.com/Alexgar98/AvilesNorling/main/app/src/main/assets/propiedades.json?token=GHSAT0AAAAAACCSMJOUJTKCSJM5AVGNN3USZDU25EA") {
            var request = URLRequest(url: url)
            request.setValue("Bearer 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", forHTTPHeaderField: "Authorization")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("Error fetching JSON: \(error)")
                    return
                }

                guard let data = data else {
                    print("No data received.")
                    return
                }

                if let jsonString = String(data: data, encoding: .utf8) {
                    print(jsonString)
                } else {
                    print("Failed to convert data to string.")
                }
            }

            task.resume()
        } else {
            print("Invalid URL")
        }
        
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
