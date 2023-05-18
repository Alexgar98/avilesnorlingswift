//
//  AnuncioViewController.swift
//  avilesnorling
//
//  Created by Mac on 15/5/23.
//

import UIKit
import CheatyXML

class AnuncioViewController: UIViewController {
    var datosRecibidos : Propiedad?
    @IBOutlet weak var referencia: UILabel!
    
    @IBOutlet weak var descripcion: UILabel!
    @IBOutlet weak var categoria: UILabel!
    @IBOutlet weak var titulo: UILabel!
    @IBOutlet weak var precio: UILabel!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
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

                    descripcion.text = parser["listaPropiedades"]["propiedad"][element]["descripcionPrincipal"]["descripcion"][0]["texto"].string
                    break
                }
            }
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
