//
//  TableViewCell.swift
//  weltAppleHealthETL
//
//  Created by jo on 2021/05/15.
//

import UIKit

class TableViewCell: UITableViewCell {

    @IBOutlet weak var analysisView: UIView!
    @IBOutlet weak var inbedText: UILabel!
    @IBOutlet weak var inbedInfo: UILabel!
    @IBOutlet weak var asleepText: UILabel!
    @IBOutlet weak var asleepInfo: UILabel!
    @IBOutlet weak var inbedTotalTime: UILabel!
    @IBOutlet weak var asleepTotalTime: UILabel!
    @IBOutlet weak var sol: UILabel!
    @IBOutlet weak var tasafa: UILabel!
    @IBOutlet weak var waso: UILabel!
    
    @IBOutlet weak var frequency: UILabel!
    
    @IBOutlet weak var se: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
