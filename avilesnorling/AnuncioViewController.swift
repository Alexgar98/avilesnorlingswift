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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        var arrayUrlImagenes : [String] = []
        stackImagenes.distribution = .fillEqually
        scrollImagenes.contentSize = CGSize(width: 1000, height: scrollImagenes.frame.height)
        if let datos = datosRecibidos {
            referencia.text = "Ref.: \(datos.referencia)"
            if (datos.precio == "") {
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
                    break
                }
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
