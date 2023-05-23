//
//  AnuncioViewController.swift
//  avilesnorling
//
//  Created by Mac on 15/5/23.
//

import UIKit
import CheatyXML
import SDWebImage

class AnuncioViewController: UIViewController {
    var datosRecibidos : Propiedad?
    @IBOutlet weak var referencia: UILabel!
    
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
    var caracteristicasGenerales = ""
    var txtSuperficies = ""
    var txtEquipamientos = ""
    var txtCalidades = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var arrayUrlImagenes : [String] = []
        stackImagenes.distribution = .fillEqually
        scrollImagenes.contentSize = CGSize(width: 1000, height: scrollImagenes.frame.height)
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
                    for imagen in arrayUrlImagenes {
                        let anadir : UIImageView = UIImageView()
                        anadir.sd_setImage(with: URL(string: imagen))
                        anadir.contentMode = .scaleAspectFit
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
        }
        let anchoTotal = CGFloat(arrayUrlImagenes.count) * view.frame.width
        stackImagenes.frame = CGRect(x: 0, y: 100, width: anchoTotal, height: stackImagenes.frame.height)
        scrollImagenes.contentSize = stackImagenes.frame.size
        
        scrollImagenes.isScrollEnabled = true
        scroll.layoutIfNeeded()
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
