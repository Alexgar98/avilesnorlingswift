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
    @IBOutlet weak var descripcionTitulo: UILabel!
    @IBOutlet weak var caracteristicasTitulo: UILabel!
    var caracteristicasGenerales = ""
    var txtSuperficies = ""
    var txtEquipamientos = ""
    var txtCalidades = ""
    var txtSituacion = ""
    var txtCercaDe = ""
    var txtComunicaciones = ""
    var txtContacto = ""
    var url = URL(string: "")
    
    var arrayIdiomas : [String] = [String]()
    
    var currentLanguage = ""
    var elementoElegido = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        arrayIdiomas = ["Español", "English", "Deutsch", "Français", "Svenska"]
        changeLanguage(lang: "es")
        
        var arrayUrlImagenes : [String] = []
        
        if let localData = self.leerJson(forName: "propiedades") {
            if let urlParseada = self.parse(jsonData: localData, referencia: datosRecibidos?.referencia ?? "") {
                url = urlParseada
            }
            else {
                reservarBtn.isHidden = true
            }
        }
        else {
            reservarBtn.isHidden = true
        }
        
        if let datos = datosRecibidos {
            referencia.text = "Ref.: \(datos.referencia)"
            if (datos.precio == 0) {
                precio.text = "consultar".localizeString(string: currentLanguage)
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
                        tipoInmueble = "estudio".localizeString(string: currentLanguage)
                    case "2":
                        tipoInmueble = "apartamento".localizeString(string: currentLanguage)
                    case "4":
                        tipoInmueble = "piso".localizeString(string: currentLanguage)
                    case "8":
                        tipoInmueble = "duplex".localizeString(string: currentLanguage)
                    case "16":
                        tipoInmueble = "casa".localizeString(string: currentLanguage)
                    case "64":
                        tipoInmueble = "chalet".localizeString(string: currentLanguage)
                    case "128":
                        tipoInmueble = "villa".localizeString(string: currentLanguage)
                    case "512":
                        tipoInmueble = "local".localizeString(string: currentLanguage)
                    default:
                        tipoInmueble = "propiedad".localizeString(string: currentLanguage)
                    }
                    let localidad = parser["listaPropiedades"]["propiedad"][element]["localidad"].stringValue
                    categoria.text = "\(tipoInmueble) \("en".localizeString(string: currentLanguage)) \(localidad)"

                    descripcion.text = parser["listaPropiedades"]["propiedad"][element]["descripcionPrincipal"]["descripcion"][0]["texto"].string?.trimmingCharacters(in: .whitespacesAndNewlines)
                    for imagen in 0..<parser["listaPropiedades"]["propiedad"][element]["listaImagenes"].numberOfChildElements {
                        arrayUrlImagenes.append(parser["listaPropiedades"]["propiedad"][element]["listaImagenes"]["imagen"][imagen]["url"].stringValue)
                    }
                    for imagen in arrayUrlImagenes {
                        let anadir : UIImageView = UIImageView()
                        anadir.sd_setImage(with: URL(string: imagen))
                        anadir.contentMode = .scaleAspectFit
                        anadir.clipsToBounds = true
                        stackImagenes.addArrangedSubview(anadir)
                    }
                    let codigoTurismo = parser["listaPropiedades"]["propiedad"][element]["registroTurismo"].string
                    if (codigoTurismo != nil) {
                        caracteristicasGenerales.append("- \("codigoTuristico".localizeString(string: currentLanguage)) \(codigoTurismo!)\n")
                    }
                    let plantas = parser["listaPropiedades"]["propiedad"][element]["extensionInmoenter"]["nplantas"].string
                    if (plantas != nil) {
                        caracteristicasGenerales.append("- \(plantas!)ª \("planta".localizeString(string: currentLanguage))\n")
                    }
                    let salones = parser["listaPropiedades"]["propiedad"][element]["extensionInmoenter"]["salones"].string
                    if (salones != nil) {
                        caracteristicasGenerales.append("- \(salones!) \("salones".localizeString(string: currentLanguage))\n")
                    }
                    let dormitorios = parser["listaPropiedades"]["propiedad"][element]["dormitorios"].string
                    if (dormitorios != nil) {
                        caracteristicasGenerales.append("- \(dormitorios!) \("dormitorios".localizeString(string: currentLanguage))\n")
                    }
                    let banos = parser["listaPropiedades"]["propiedad"][element]["baños"].string
                    if (banos != nil) {
                        caracteristicasGenerales.append("- \(banos!) \("banos".localizeString(string: currentLanguage))\n")
                    }
                    let empotrados = parser["listaPropiedades"]["propiedad"][element]["armariosEmpotrados"].string
                    if (empotrados != nil) {
                        caracteristicasGenerales.append("- \(empotrados!) \("empotrados".localizeString(string: currentLanguage))\n")
                    }
                    let terrazas = parser["listaPropiedades"]["propiedad"][element]["terrazas"].string
                    let superficieTerrazas = parser["listaPropiedades"]["propiedad"][element]["superficieTerrazas"].string
                    if (terrazas != nil) {
                        caracteristicasGenerales.append("- \(terrazas!) \("terrazas".localizeString(string: currentLanguage))")
                        if superficieTerrazas != nil {
                            caracteristicasGenerales.append(" (\(superficieTerrazas!) m2)\n")
                        }
                        else {
                            caracteristicasGenerales.append("\n")
                        }
                    }
                    let lavadero = parser["listaPropiedades"]["propiedad"][element]["extensionInmoenter"]["lavadero"].string
                    if (lavadero != nil) {
                        caracteristicasGenerales.append("- \("lavadero".localizeString(string: currentLanguage))")
                    }
                    
                    let construido = parser["listaPropiedades"]["propiedad"][element]["superficieConstruida"].string
                    if (construido != nil) {
                        txtSuperficies.append("- \("construido".localizeString(string: currentLanguage)) \(construido!) m2")
                    }
                    let util = parser["listaPropiedades"]["propiedad"][element]["superficieUtil"].string
                    if (util != nil) {
                        txtSuperficies.append("\n- \("util".localizeString(string: currentLanguage)) \(util!) m2")
                    }
                    
                    let piscina = parser["listaPropiedades"]["propiedad"][element]["piscina"].string
                    if (piscina != nil) {
                        txtEquipamientos.append("\n- \("piscina".localizeString(string: currentLanguage))")
                    }
                    let jardines = parser["listaPropiedades"]["propiedad"][element]["jardines"].string
                    if (jardines != nil) {
                        txtEquipamientos.append("\n- \("jardines".localizeString(string: currentLanguage))")
                    }
                    let cocinaAmueblada = parser["listaPropiedades"]["propiedad"][element]["cocinaAmueblada"].string
                    if (cocinaAmueblada != nil) {
                        txtEquipamientos.append("\n- \("cocinaAmueblada".localizeString(string: currentLanguage))")
                    }
                    let electrodomesticos = parser["listaPropiedades"]["propiedad"][element]["electrodomesticos"].string
                    if (electrodomesticos != nil) {
                        txtEquipamientos.append("\n- \("electrodomesticos".localizeString(string: currentLanguage))")
                    }
                    let portero = parser["listaPropiedades"]["propiedad"][element]["tipoPortero"].string
                    if (portero != nil) {
                        if (portero == "1") {
                            txtEquipamientos.append("\n- \("portero".localizeString(string: currentLanguage))")
                        }
                        else {
                            txtEquipamientos.append("\n- \("videoportero".localizeString(string: currentLanguage))")
                        }
                    }
                    let tipoCocina = parser["listaPropiedades"]["propiedad"][element]["extensionInmoenter"]["tipoCocina"].string
                    if (tipoCocina != nil) {
                        switch tipoCocina {
                        case "1":
                            txtEquipamientos.append("\n- \("cocinaIndependiente".localizeString(string: currentLanguage))")
                        case "2":
                            txtEquipamientos.append("\n- \("cocinaAmericana".localizeString(string: currentLanguage))")
                        default:
                            txtEquipamientos.append("\n- \("cocinaAmueblada".localizeString(string: currentLanguage))")
                        }
                    }
                    let tipoAC = parser["listaPropiedades"]["propiedad"][element]["tipoAireAcondicionado"].string
                    if (tipoAC != nil) {
                        switch tipoAC {
                        case "2":
                            txtEquipamientos.append("\n- \("instalacion".localizeString(string: currentLanguage))")
                        case "3":
                            txtEquipamientos.append("\n- \("climatizador".localizeString(string: currentLanguage))")
                        default:
                            if (parser["listaPropiedades"]["propiedad"][element]["tipoConservacion"].string == "6") {
                                txtEquipamientos.append("\n- \("preinstalacion".localizeString(string: currentLanguage))")
                            }
                            else {
                                txtEquipamientos.append("\n- \("central".localizeString(string: currentLanguage))")
                            }
                        }
                    }
                    
                    let soleria = parser["listaPropiedades"]["propiedad"][element]["tipoSoleria"].string
                    if (soleria != nil) {
                        switch soleria {
                        case "5":
                            txtCalidades.append("\n- \("soleriaCeramica".localizeString(string: currentLanguage))")
                        case "1":
                            txtCalidades.append("\n- \("soleriaParquet".localizeString(string: currentLanguage))")
                        case "6":
                            txtCalidades.append("\n- \("tarima".localizeString(string: currentLanguage))")
                        default:
                            txtCalidades.append("\n- \("soleriaMarmol".localizeString(string: currentLanguage))")
                        }
                    }
                    let zona = parser["listaPropiedades"]["propiedad"][element]["tipoZona"].string
                    if zona != nil {
                        if zona == "1" {
                            txtSituacion.append("\n- \("zonaUrbana".localizeString(string: currentLanguage))")
                        }
                        else {
                            txtSituacion.append("\n- \("urbanizacion".localizeString(string: currentLanguage))")
                        }
                    }
                    let playa = parser["listaPropiedades"]["propiedad"][element]["tipoPlaya"].string
                    if playa != nil {
                        switch playa {
                        case "2":
                            txtSituacion.append("\n- \("metrosPlaya".localizeString(string: currentLanguage))")
                        case "4":
                            txtSituacion.append("\n- \("segundaLinea".localizeString(string: currentLanguage))")
                        case "3":
                            txtSituacion.append("\n- \("zonaCostera".localizeString(string: currentLanguage))")
                        default:
                            txtSituacion.append("\n- \("primeraLinea".localizeString(string: currentLanguage))")
                        }
                    let orientacion = parser["listaPropiedades"]["propiedad"][element]["tipoOrientacion"].string
                        if (orientacion != nil) {
                            switch orientacion {
                            case "3":
                                txtSituacion.append("\n- \("orientacionEste".localizeString(string: currentLanguage))")
                            case "4":
                                txtSituacion.append("\n- \("orientacionOeste".localizeString(string: currentLanguage))")
                            case "2":
                                txtSituacion.append("\n- \("orientacionSur".localizeString(string: currentLanguage))")
                            case "8":
                                txtSituacion.append("\n- \("orientacionSuroeste".localizeString(string: currentLanguage))")
                            case "7":
                                txtSituacion.append("\n- \("orientacionSureste".localizeString(string: currentLanguage))")
                            default:
                                txtSituacion.append("\n- \("orientacionNoroeste".localizeString(string: currentLanguage))")
                            }
                        }
                    }
                    let escuelas = parser["listaPropiedades"]["propiedad"][element]["centrosEscolares"].string
                    if (escuelas != nil) {
                        txtCercaDe.append("\n- \("escuelas".localizeString(string: currentLanguage))")
                    }
                    let deporte = parser["listaPropiedades"]["propiedad"][element]["instalacionesDeportivas"].string
                    if (deporte != nil) {
                        txtCercaDe.append("\n- \("zonasDeportivas".localizeString(string: currentLanguage))")
                    }
                    let verde = parser["listaPropiedades"]["propiedad"][element]["espaciosVerdes"].string
                    if verde != nil {
                        txtCercaDe.append("\n- \("zonasVerdes".localizeString(string: currentLanguage))")
                    }
                    let bus = parser["listaPropiedades"]["propiedad"][element]["autobuses"].string
                    if bus != nil {
                        txtComunicaciones.append("\n- \("bus".localizeString(string: currentLanguage))")
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
                    elementoElegido = element
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
        currentLanguage = lang
        reservarBtn.setTitle("reservar".localizeString(string: lang), for: .normal)
        if !(precio.text?.hasSuffix("€"))! {
            precio.text = "consultar".localizeString(string: lang)
        }
        descripcionTitulo.text = "descripcion".localizeString(string: lang)
        caracteristicasTitulo.text = "caracteristicas".localizeString(string: lang)
        generalesTitulo.text = "generales".localizeString(string: lang)
        superficiesTitulo.text = "superficies".localizeString(string: lang)
        equipamientosTitulo.text = "equipamientos".localizeString(string: lang)
        calidadesTitulo.text = "calidades".localizeString(string: lang)
        situacionTitulo.text = "situacion".localizeString(string: lang)
        cercaDeTitulo.text = "cercaDe".localizeString(string: lang)
        comunicacionesTitulo.text = "comunicaciones".localizeString(string: lang)
        contactoTitulo.text = "contacto".localizeString(string: lang)
        
        generales.text = generales.text?.localizeString(string: lang)
        
        let url = URL(string: "https://avilesnorling.inmoenter.com/export/all/xcp.xml")
        let parser : CXMLParser! = CXMLParser(contentsOfURL: url!)
        
        switch lang {
        case "es":
            descripcion.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["descripcionPrincipal"]["descripcion"][0]["texto"].string?.trimmingCharacters(in: .whitespacesAndNewlines)
        case "en":
            descripcion.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["descripcionPrincipal"]["descripcion"][1]["texto"].string?.trimmingCharacters(in: .whitespacesAndNewlines)
        case "fr":
            descripcion.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["descripcionPrincipal"]["descripcion"][2]["texto"].string?.trimmingCharacters(in: .whitespacesAndNewlines)
        case "de":
            descripcion.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["descripcionPrincipal"]["descripcion"][4]["texto"].string?.trimmingCharacters(in: .whitespacesAndNewlines)
        case "sv":
            descripcion.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["descripcionPrincipal"]["descripcion"][7]["texto"].string?.trimmingCharacters(in: .whitespacesAndNewlines)
        default:
            descripcion.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["descripcionPrincipal"]["descripcion"][0]["texto"].string?.trimmingCharacters(in: .whitespacesAndNewlines)
        }
        
    }
    
    @IBAction func btnReserva(_ sender: Any) {
        abrirUrl(direccion: url)
    }
    
    struct PropiedadEnlaces : Codable {
        let nombre : String
        let cod_an : String
        let id_avail : String
        let id_opinan : String
    }
    
    func leerJson (forName name : String) -> Data? {
        do {
            if let bundlePath = Bundle.main.path(forResource: name, ofType: "json"),
               let jsonData = try String(contentsOfFile: bundlePath).data(using: .utf8) {
                return jsonData
            }
        }
        catch {
            print(error)
        }
        return nil
    }
    
    func parse (jsonData : Data, referencia : String) -> URL? {
        print(referencia)
        do {
            let decodedData = try JSONDecoder().decode([PropiedadEnlaces].self, from: jsonData)
            for propiedad in decodedData {
                if propiedad.cod_an == referencia {
                    return URL(string: "https://www.avaibook.com/reservas/nueva_reserva.php?idw=\(propiedad.id_avail)&cod_propietario=89412&cod_alojamiento=\(propiedad.id_opinan)&lang=es")
                }
            }
        }
        catch {
            print(error)
        }
        return nil
    }
    
    func abrirUrl(direccion : URL?) {
        if let url = direccion {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            }
            else {
                print("No se pudo abrir la url \(url)")
            }
        }
        else {
            print("Formato inválido")
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
