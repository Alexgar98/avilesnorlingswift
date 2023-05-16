//
//  BusquedaTableViewCellController.swift
//  avilesnorling
//
//  Created by Mac on 16/5/23.
//

import UIKit

class BusquedaTableViewCellController: UITableViewCell {
    @IBOutlet weak var imagenAnuncio: UIImageView!
    @IBOutlet weak var precioAnuncio: UILabel!
    @IBOutlet weak var referenciaAnuncio: UILabel!
    @IBOutlet weak var personasAnuncio: UILabel!
    @IBOutlet weak var dormitoriosAnuncio: UILabel!
    @IBOutlet weak var bañosAnuncio: UILabel!
    @IBOutlet weak var superficieAnuncio: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
