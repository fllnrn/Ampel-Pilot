//
//  VisualFeedbackView.swift
//  Ampel Pilot
//
//  Created by Patrick Valenta on 24.10.17.
//  Copyright © 2017 Patrick Valenta. All rights reserved.
//

import UIKit

class VisualFeedbackView: UIView {
    
    private let phaseLabel: UILabel = {
        let l = UILabel()
        l.font = UIFont.preferredFont(forTextStyle: .headline)
        l.textColor = .black
        l.adjustsFontForContentSizeCategory = true
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = NSLocalizedString("Keine Ampel erkannt", comment: "Keine Ampel erkannt")
        l.accessibilityTraits = UIAccessibilityTraitUpdatesFrequently
        
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        translatesAutoresizingMaskIntoConstraints = false
        backgroundColor = .clear
        setupViews()
    }
    
    public func setPhase(_ phase: LightPhaseManager.Phase) {
        switch phase {
        case .green:
            backgroundColor = .green
            phaseLabel.text = NSLocalizedString("Grün", comment: "Grün")
        case .red:
            backgroundColor = .red
            phaseLabel.text = NSLocalizedString("Rot", comment: "Rot")
        case .none:
            backgroundColor = .clear
            phaseLabel.text = NSLocalizedString("Keine Ampel erkannt", comment: "Keine Ampel erkannt")
        }
    }
    
    private func setupViews() {
        addSubview(phaseLabel)
        
        phaseLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        phaseLabel.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
