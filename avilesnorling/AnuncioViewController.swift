//
//  AnuncioViewController.swift
//  avilesnorling
//
//  Created by Mac on 15/5/23.
//

import UIKit
import CheatyXML
import SDWebImage
import SafariServices
import MessageUI

//Pantalla de anuncio individual
class AnuncioViewController: UIViewController, UIPickerViewDelegate, UIPickerViewDataSource, MFMailComposeViewControllerDelegate {
    
    //Outlets
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
    @IBOutlet weak var pickerIdiomas: UIPickerView!
    
    @IBOutlet weak var campoTelefono: UITextField!
    @IBOutlet weak var campoNombre: UITextField!
    @IBOutlet weak var campoEmail: UITextField!
    @IBOutlet weak var privacidadCheckbox: UISwitch!
    @IBOutlet weak var txtPrivacidad: UILabel!
    @IBOutlet weak var campoMensaje: UITextField!
    //Cosas que me hacen falta más adelante
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
        
        //Lleno el picker de idiomas y selecciono según el idioma que haya llegado a esta pantalla
        arrayIdiomas = ["Español", "English", "Deutsch", "Français", "Svenska"]
        
        changeLanguage(lang: currentLanguage)
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
        
        //Parsing del JSON de reservas
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
        
        //Parsing de los datos del anuncio
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
                    elementoElegido = element
                    changeLanguage(lang: currentLanguage)
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
        //Ajuste de las imágenes
        let anchoImagenes = view.frame.width
        let anchoTotal = CGFloat(arrayUrlImagenes.count) * view.frame.width
        stackImagenes.distribution = .fillEqually
        stackImagenes.frame = CGRect(x: 0, y: 0, width: anchoTotal, height: scrollImagenes.frame.height)
        scrollImagenes.contentSize = CGSize(width: anchoTotal, height: scrollImagenes.frame.height)
        scrollImagenes.isScrollEnabled = true
        scrollImagenes.layoutIfNeeded()
        
        let attributedString = NSMutableAttributedString(string: "Condiciones de privacidad")
        let url = URL(string: "https://www.avilesnorling.com/es/privacy")!
        let range = NSRange(location: 0, length: attributedString.length)
        attributedString.addAttribute(.link, value: url, range: range)
        txtPrivacidad.attributedText = attributedString
        txtPrivacidad.isUserInteractionEnabled = true
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(handleLinkTap(_:)))
        txtPrivacidad.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleLinkTap(_ gesture: UITapGestureRecognizer) {
        guard let textView = gesture.view as? UITextView else {
            return
        }
        
        let layoutManager = textView.layoutManager
        let location = gesture.location(in: textView)
        let position = layoutManager.characterIndex(for: location, in: textView.textContainer, fractionOfDistanceBetweenInsertionPoints: nil)
        
        if let url = textView.attributedText.attribute(.link, at: position, effectiveRange: nil) as? URL {
            let safariViewController = SFSafariViewController(url: url)
            present(safariViewController, animated: true, completion: nil)
        }
    }
    
    @IBAction func btnContacto(_ sender: Any) {
        let nombreContactoCampo = campoNombre.text ?? ""
        let emailContactoCampo = campoEmail.text ?? ""
        let telefonoContactoCampo = campoTelefono.text ?? ""
        let mensajeContactoCampo = campoMensaje.text ?? ""
        
        if !privacidadCheckbox.isOn {
            showAlert(message: "Tienes que aceptar la política de privacidad")
        }
        else if nombreContactoCampo.isEmpty || emailContactoCampo.isEmpty || telefonoContactoCampo.isEmpty || mensajeContactoCampo.isEmpty {
            showAlert(message: "Tienes que rellenar todos los campos")
        }
        else {
            let destino = "" //TODO mail de destino
            let asunto = "Ref - \(nombreContactoCampo)"
            let cuerpo = "\(mensajeContactoCampo)\nTel: \(telefonoContactoCampo)"
            
            if MFMailComposeViewController.canSendMail() {
                let mailComposer = MFMailComposeViewController()
                mailComposer.mailComposeDelegate = self
                mailComposer.setToRecipients([destino])
                mailComposer.setSubject(asunto)
                mailComposer.setMessageBody(cuerpo, isHTML: false)
                present(mailComposer, animated: true, completion: nil)
            }
            else {
                showAlert(message: "No se ha encontrado cliente de email")
            }
        }
    }
    
    func showAlert(message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true, completion: nil)
    }
    //Cosas del picker
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return arrayIdiomas.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return arrayIdiomas[row]
    }
    
    //Según lo que se elija se cambia el idioma
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
    
    //Función para cambiar el idioma. Tiene que parsear varias cosas del XML
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
            titulo.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["extensionInmoenter"]["listaTitulos"]["titulo"][0]["texto"].stringValue
        case "en":
            descripcion.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["descripcionPrincipal"]["descripcion"][1]["texto"].string?.trimmingCharacters(in: .whitespacesAndNewlines)
            titulo.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["extensionInmoenter"]["listaTitulos"]["titulo"][1]["texto"].stringValue
        case "fr":
            descripcion.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["descripcionPrincipal"]["descripcion"][2]["texto"].string?.trimmingCharacters(in: .whitespacesAndNewlines)
            titulo.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["extensionInmoenter"]["listaTitulos"]["titulo"][2]["texto"].stringValue
        case "de":
            descripcion.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["descripcionPrincipal"]["descripcion"][4]["texto"].string?.trimmingCharacters(in: .whitespacesAndNewlines)
            titulo.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["extensionInmoenter"]["listaTitulos"]["titulo"][4]["texto"].stringValue
        case "sv":
            descripcion.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["descripcionPrincipal"]["descripcion"][7]["texto"].string?.trimmingCharacters(in: .whitespacesAndNewlines)
            titulo.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["extensionInmoenter"]["listaTitulos"]["titulo"][7]["texto"].stringValue
        default:
            descripcion.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["descripcionPrincipal"]["descripcion"][0]["texto"].string?.trimmingCharacters(in: .whitespacesAndNewlines)
            titulo.text = parser["listaPropiedades"]["propiedad"][elementoElegido]["extensionInmoenter"]["listaTitulos"]["titulo"][0]["texto"].stringValue
        }
        let codigoTipoInmueble = parser["listaPropiedades"]["propiedad"][elementoElegido]["tipoInmueble"].stringValue
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
        let localidad = parser["listaPropiedades"]["propiedad"][elementoElegido]["localidad"].stringValue
        categoria.text = "\(tipoInmueble) \("en".localizeString(string: currentLanguage)) \(localidad)"
        
        caracteristicasGenerales = ""
        let codigoTurismo = parser["listaPropiedades"]["propiedad"][elementoElegido]["registroTurismo"].string
        if (codigoTurismo != nil) {
            caracteristicasGenerales.append("- \("codigoTuristico".localizeString(string: currentLanguage)) \(codigoTurismo!)\n")
        }
        let plantas = parser["listaPropiedades"]["propiedad"][elementoElegido]["extensionInmoenter"]["nplantas"].string
        if (plantas != nil) {
            caracteristicasGenerales.append("- \(plantas!)ª \("planta".localizeString(string: currentLanguage))\n")
        }
        let salones = parser["listaPropiedades"]["propiedad"][elementoElegido]["extensionInmoenter"]["salones"].string
        if (salones != nil) {
            caracteristicasGenerales.append("- \(salones!) \("salones".localizeString(string: currentLanguage))\n")
        }
        let dormitorios = parser["listaPropiedades"]["propiedad"][elementoElegido]["dormitorios"].string
        if (dormitorios != nil) {
            caracteristicasGenerales.append("- \(dormitorios!) \("dormitorios".localizeString(string: currentLanguage))\n")
        }
        let banos = parser["listaPropiedades"]["propiedad"][elementoElegido]["baños"].string
        if (banos != nil) {
            caracteristicasGenerales.append("- \(banos!) \("banos".localizeString(string: currentLanguage))\n")
        }
        let empotrados = parser["listaPropiedades"]["propiedad"][elementoElegido]["armariosEmpotrados"].string
        if (empotrados != nil) {
            caracteristicasGenerales.append("- \(empotrados!) \("empotrados".localizeString(string: currentLanguage))\n")
        }
        let terrazas = parser["listaPropiedades"]["propiedad"][elementoElegido]["terrazas"].string
        let superficieTerrazas = parser["listaPropiedades"]["propiedad"][elementoElegido]["superficieTerrazas"].string
        if (terrazas != nil) {
            caracteristicasGenerales.append("- \(terrazas!) \("terrazas".localizeString(string: currentLanguage))")
            if superficieTerrazas != nil {
                caracteristicasGenerales.append(" (\(superficieTerrazas!) m2)\n")
            }
            else {
                caracteristicasGenerales.append("\n")
            }
        }
        let lavadero = parser["listaPropiedades"]["propiedad"][elementoElegido]["extensionInmoenter"]["lavadero"].string
        if (lavadero != nil) {
            caracteristicasGenerales.append("- \("lavadero".localizeString(string: currentLanguage))")
        }
        generales.text = caracteristicasGenerales
        
        txtSuperficies = ""
        let construido = parser["listaPropiedades"]["propiedad"][elementoElegido]["superficieConstruida"].string
        if (construido != nil) {
            txtSuperficies.append("- \("construido".localizeString(string: currentLanguage)) \(construido!) m2")
        }
        let util = parser["listaPropiedades"]["propiedad"][elementoElegido]["superficieUtil"].string
        if (util != nil) {
            txtSuperficies.append("\n- \("util".localizeString(string: currentLanguage)) \(util!) m2")
        }
        superficies.text = txtSuperficies
        
        txtEquipamientos = ""
        let piscina = parser["listaPropiedades"]["propiedad"][elementoElegido]["piscina"].string
        if (piscina != nil) {
            txtEquipamientos.append("\n- \("piscina".localizeString(string: currentLanguage))")
        }
        let jardines = parser["listaPropiedades"]["propiedad"][elementoElegido]["jardines"].string
        if (jardines != nil) {
            txtEquipamientos.append("\n- \("jardines".localizeString(string: currentLanguage))")
        }
        let cocinaAmueblada = parser["listaPropiedades"]["propiedad"][elementoElegido]["cocinaAmueblada"].string
        if (cocinaAmueblada != nil) {
            txtEquipamientos.append("\n- \("cocinaAmueblada".localizeString(string: currentLanguage))")
        }
        let electrodomesticos = parser["listaPropiedades"]["propiedad"][elementoElegido]["electrodomesticos"].string
        if (electrodomesticos != nil) {
            txtEquipamientos.append("\n- \("electrodomesticos".localizeString(string: currentLanguage))")
        }
        let portero = parser["listaPropiedades"]["propiedad"][elementoElegido]["tipoPortero"].string
        if (portero != nil) {
            if (portero == "1") {
                txtEquipamientos.append("\n- \("portero".localizeString(string: currentLanguage))")
            }
            else {
                txtEquipamientos.append("\n- \("videoportero".localizeString(string: currentLanguage))")
            }
        }
        let tipoCocina = parser["listaPropiedades"]["propiedad"][elementoElegido]["extensionInmoenter"]["tipoCocina"].string
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
        let tipoAC = parser["listaPropiedades"]["propiedad"][elementoElegido]["tipoAireAcondicionado"].string
        if (tipoAC != nil) {
            switch tipoAC {
            case "2":
                txtEquipamientos.append("\n- \("instalacion".localizeString(string: currentLanguage))")
            case "3":
                txtEquipamientos.append("\n- \("climatizador".localizeString(string: currentLanguage))")
            default:
                if (parser["listaPropiedades"]["propiedad"][elementoElegido]["tipoConservacion"].string == "6") {
                    txtEquipamientos.append("\n- \("preinstalacion".localizeString(string: currentLanguage))")
                }
                else {
                    txtEquipamientos.append("\n- \("central".localizeString(string: currentLanguage))")
                }
            }
        }
        equipamientos.text = txtEquipamientos
        
        txtCalidades = ""
        let soleria = parser["listaPropiedades"]["propiedad"][elementoElegido]["tipoSoleria"].string
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
        calidades.text = txtCalidades
        
        txtSituacion = ""
        let zona = parser["listaPropiedades"]["propiedad"][elementoElegido]["tipoZona"].string
        if zona != nil {
            if zona == "1" {
                txtSituacion.append("\n- \("zonaUrbana".localizeString(string: currentLanguage))")
            }
            else {
                txtSituacion.append("\n- \("urbanizacion".localizeString(string: currentLanguage))")
            }
        }
        let playa = parser["listaPropiedades"]["propiedad"][elementoElegido]["tipoPlaya"].string
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
        let orientacion = parser["listaPropiedades"]["propiedad"][elementoElegido]["tipoOrientacion"].string
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
        situacion.text = txtSituacion
        
        txtCercaDe = ""
        let escuelas = parser["listaPropiedades"]["propiedad"][elementoElegido]["centrosEscolares"].string
        if (escuelas != nil) {
            txtCercaDe.append("\n- \("escuelas".localizeString(string: currentLanguage))")
        }
        let deporte = parser["listaPropiedades"]["propiedad"][elementoElegido]["instalacionesDeportivas"].string
        if (deporte != nil) {
            txtCercaDe.append("\n- \("zonasDeportivas".localizeString(string: currentLanguage))")
        }
        let verde = parser["listaPropiedades"]["propiedad"][elementoElegido]["espaciosVerdes"].string
        if verde != nil {
            txtCercaDe.append("\n- \("zonasVerdes".localizeString(string: currentLanguage))")
        }
        cercaDe.text = txtCercaDe
        
        txtComunicaciones = ""
        
        let bus = parser["listaPropiedades"]["propiedad"][elementoElegido]["autobuses"].string
        if bus != nil {
            txtComunicaciones.append("\n- \("bus".localizeString(string: currentLanguage))")
        }
        
        comunicaciones.text = txtComunicaciones
        
        txtContacto = ""
        let nombreContacto = parser["listaPropiedades"]["propiedad"][elementoElegido]["extensionInmoenter"]["nombreContacto"].string
        if nombreContacto != nil {
            txtContacto.append("\n\(nombreContacto!)")
        }
        let emailContacto = parser["listaPropiedades"]["propiedad"][elementoElegido]["extensionInmoenter"]["emailContacto"].string
        if emailContacto != nil {
            txtContacto.append("\n\(emailContacto!)")
        }
        let telefonoContacto = parser["listaPropiedades"]["propiedad"][elementoElegido]["extensionInmoenter"]["telefonoContacto"].string
        if telefonoContacto != nil {
            txtContacto.append("\n\(telefonoContacto!)")
        }
        
        contacto.text = txtContacto
        
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
    
    //Botón para abrir la URL y reservar
    @IBAction func btnReserva(_ sender: Any) {
        abrirUrl(direccion: url)
    }
    
    //Struct que maneja las cosas que hay que coger para generar la URL
    struct PropiedadEnlaces : Codable {
        let nombre : String
        let cod_an : String
        let id_avail : String
        let id_opinan : String
    }
    
    //Función para leer el json y devolver los datos obtenidos
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
    
    //Parser de los datos obtenidos antes. Genera la URL
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
    
    //Función para abrir la URL
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
