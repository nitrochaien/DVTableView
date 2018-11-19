//
//  SampleDVTableViewController.swift
//  AlamofireSample
//
//  Created by Nam Vu on 11/18/18.
//  Copyright © 2018 Nam Vu. All rights reserved.
//

import UIKit

class SampleDVTableViewController: DVTableViewController<SampleDVCell, ItemSource> {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setHeaderView(withView: CustomHeaderGift(reuseIdentifier: "CustomHeaderGift"), height: 80)
//        setFooterView(withView: CustomHeaderGift(reuseIdentifier: "CustomHeaderGift"))
        
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
//        view.heightAnchor.constraint(equalToConstant: 300).isActive = true
        view.backgroundColor = .blue
//        setRefreshControl(view)
//        setNoDataView(view)
        
        setData(Array(repeating: ItemSource(title: "Hey"), count: 20))
    }
    
    override func loadMore() {
        DispatchQueue.global(qos: .userInitiated).async {
            let array = Array(repeating: ItemSource(title: "Yo"), count: 10)
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                self.appendData(array)
            }
        }
    }
}

class SampleDVCell: DVGenericCell<ItemSource> {
    override var item: ItemSource! {
        didSet {
            textLabel?.text = item.title
        }
    }
}

class ItemSource {
    let title: String!
    
    init(title: String) {
        self.title = title
    }
}
