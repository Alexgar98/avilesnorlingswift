//
//  ViewController.swift
//  avilesnorling
//
//  Created by Mac on 12/5/23.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet weak var twitter: UIImageView!
    @IBOutlet weak var facebook: UIImageView!
    @IBOutlet weak var instagram: UIImageView!
    @IBOutlet weak var youtube: UIImageView!
    @IBOutlet weak var whatsapp: UIImageView!
    @IBOutlet weak var linkedin: UIImageView!
    @IBOutlet weak var numeroMovil: UIButton!
    @IBOutlet weak var numeroTelefono: UIButton!
    @IBOutlet weak var mail: UIButton!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let tapGestureRecognizerWhatsapp = UITapGestureRecognizer(target: self, action: #selector(imageTappedWhatsapp(tapGestureRecognizer:)))
        whatsapp.isUserInteractionEnabled = true
        whatsapp.addGestureRecognizer(tapGestureRecognizerWhatsapp)
        
        let tapGestureRecognizerFacebook = UITapGestureRecognizer(target: self, action: #selector(imageTappedFacebook(tapGestureRecognizer:)))
        facebook.isUserInteractionEnabled = true
        facebook.addGestureRecognizer(tapGestureRecognizerFacebook)
        
        let tapGestureRecognizerTwitter = UITapGestureRecognizer(target: self, action: #selector(imageTappedTwitter(tapGestureRecognizer:)))
        twitter.isUserInteractionEnabled = true
        twitter.addGestureRecognizer(tapGestureRecognizerTwitter)
        
        let tapGestureRecognizerLinkedin = UITapGestureRecognizer(target: self, action: #selector(imageTappedLinkedin(tapGestureRecognizer:)))
        linkedin.isUserInteractionEnabled = true
        linkedin.addGestureRecognizer(tapGestureRecognizerLinkedin)
        
        let tapGestureRecognizerYoutube = UITapGestureRecognizer(target: self, action: #selector(imageTappedYoutube(tapGestureRecognizer:)))
        youtube.isUserInteractionEnabled = true
        youtube.addGestureRecognizer(tapGestureRecognizerYoutube)
        
        let tapGestureRecognizerInstagram = UITapGestureRecognizer(target: self, action: #selector(imageTappedInstagram(tapGestureRecognizer:)))
        instagram.isUserInteractionEnabled = true
        instagram.addGestureRecognizer(tapGestureRecognizerInstagram)
    }
    
    @objc func imageTappedWhatsapp(tapGestureRecognizer : UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        abrirUrl(direccion: "https://api.whatsapp.com/send?phone=34643672547")
    }
    @objc func imageTappedFacebook(tapGestureRecognizer : UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        abrirUrl(direccion: "https://www.facebook.com/aviles.norling.investment/")
    }
    @objc func imageTappedTwitter(tapGestureRecognizer : UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        abrirUrl(direccion: "https://twitter.com/inv_aviles")
    }
    @objc func imageTappedLinkedin(tapGestureRecognizer : UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        abrirUrl(direccion: "https://www.linkedin.com/in/carlos-avil%Ce%A9s-54a8245a/")
    }
    @objc func imageTappedYoutube(tapGestureRecognizer : UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        abrirUrl(direccion: "https://www.youtube.com/channel/UCiKSK6yU5XM82nfbOczOMuQ/videos")
    }
    @objc func imageTappedInstagram(tapGestureRecognizer : UITapGestureRecognizer) {
        let tappedImage = tapGestureRecognizer.view as! UIImageView
        abrirUrl(direccion: "https://www.instagram.com/avilesnorling2020")
    }
                    
    @IBAction func llamarTelefono(_ sender: Any) {
        guard let numero = numeroTelefono.titleLabel?.text?.replacingOccurrences(of: " ", with: "") else {return}
        abrirUrl(direccion: "tel://\(numero)")
    }
    @IBAction func llamarMovil(_ sender: Any) {
        guard let numero = numeroMovil.titleLabel?.text?.replacingOccurrences(of: " ", with: "") else {return}
        abrirUrl(direccion: "tel://\(numero)")
    }
    @IBAction func mandarMail(_ sender: Any) {
        guard let email = mail.titleLabel?.text else {return}
        abrirUrl (direccion: "mailto://\(email)")
        
    }
    
    let alertController = UIAlertController(title: "Ubicación", message: "Selecciona una ubicación", preferredStyle: .actionSheet)
    @IBAction func btnVenta(_ sender: Any) {
        let alertController = UIAlertController(title: "Ubicación", message: "Selecciona una ubicación", preferredStyle: .actionSheet)
        let torre = UIAlertAction(title: "Torre del Mar", style: .default) {_ in
            print ("Eliges Torre del Mar")
        }
        alertController.addAction(torre)
        let velez = UIAlertAction(title: "Vélez-Málaga", style: .default) {_ in
            print ("Eliges Vélez")
        }
        alertController.addAction(velez)
        let algarrobo = UIAlertAction(title: "Algarrobo", style: .default) {_ in
            print ("Eliges Algarrobo")
        }
        alertController.addAction(algarrobo)
        let almachar = UIAlertAction(title: "Almáchar", style: .default) {_ in
            print ("Eliges Almáchar")
        }
        alertController.addAction(almachar)
        let almayate = UIAlertAction(title: "Almayate", style: .default) {_ in
            print ("Eliges Almayate")
        }
        alertController.addAction(almayate)
        let benajarafe = UIAlertAction(title: "Benajarafe", style: .default) {_ in
            print ("Eliges Benajarafe")
        }
        alertController.addAction(benajarafe)
        let benamargosa = UIAlertAction(title: "Benamargosa", style: .default) {_ in
            print ("Eliges Benamargosa")
        }
        alertController.addAction(benamargosa)
        let caleta = UIAlertAction(title: "Caleta de Vélez", style: .default) {_ in
            print ("Eliges Caleta")
        }
        alertController.addAction(caleta)
        let canillas = UIAlertAction(title: "Canillas de Aceituno", style: .default) {_ in
            print ("Eliges Canillas")
        }
        alertController.addAction(canillas)
        let torrox = UIAlertAction(title: "Torrox", style: .default) {_ in
            print ("Eliges Torrox")
        }
        alertController.addAction(torrox)
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelar)
        present(alertController, animated: true, completion: nil)
    }
    
    @IBAction func alquiler(_ sender: Any) {
        let alertController = UIAlertController(title: "Ubicación", message: "Selecciona una ubicación", preferredStyle: .actionSheet)
        let torre = UIAlertAction(title: "Torre del Mar", style: .default) {_ in
            print ("Eliges Torre del Mar")
        }
        alertController.addAction(torre)
        let velez = UIAlertAction(title: "Vélez-Málaga", style: .default) {_ in
            print ("Eliges Vélez")
        }
        alertController.addAction(velez)
        let caleta = UIAlertAction(title: "Caleta de Vélez", style: .default) {_ in
            print ("Eliges Caleta")
        }
        alertController.addAction(caleta)
        let canillas = UIAlertAction(title: "Canillas de Aceituno", style: .default) {_ in
            print ("Eliges Canillas")
        }
        alertController.addAction(canillas)
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelar)
        present(alertController, animated: true, completion: nil)
    }
    @IBAction func vacaciones(_ sender: Any) {
        let torre = UIAlertAction(title: "Torre del Mar", style: .default) {_ in
            print ("Eliges Torre del Mar")
        }
        alertController.addAction(torre)
        let almayate = UIAlertAction(title: "Almayate", style: .default) {_ in
            print ("Eliges Almayate")
        }
        alertController.addAction(almayate)
        let caleta = UIAlertAction(title: "Caleta de Vélez", style: .default) {_ in
            print ("Eliges Caleta")
        }
        alertController.addAction(caleta)
        let malaga = UIAlertAction(title: "Málaga", style: .default) {_ in
            print ("Eliges Málaga")
        }
        alertController.addAction(malaga)
        let malagaOriental = UIAlertAction(title: "Málaga oriental", style: .default) {_ in
            print ("Eliges Málaga oriental")
        }
        alertController.addAction(malagaOriental)
        let cancelar = UIAlertAction(title: "Cancelar", style: .cancel, handler: nil)
        alertController.addAction(cancelar)
        present(alertController, animated: true, completion: nil)
    }
    func abrirUrl(direccion : String) {
        if let url = URL(string: direccion) {
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
    
}

