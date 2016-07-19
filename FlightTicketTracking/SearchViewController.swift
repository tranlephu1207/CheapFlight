//
//  ViewController.swift
//  FlightTicketTracking
//
//  Created by lephu on 7/15/16.
//  Copyright © 2016 lephu. All rights reserved.
//

import UIKit
import SnapKit

class SearchViewController: UIViewController {

    private var upperView:UIView!
    private var titleLabel:UILabel!
    private var fromView:UIView!
    private var toView:UIView!
    private var centerView:UIView!
    private var planeImgView:UIImageView!
    private var segmentedControl:UISegmentedControl!
    
    private var fromLabel:UILabel!
    private var fromPlusImgView:UIImageView!
    private var fromCityView:UIView!
    private var fromSignNameCityLabel:UILabel!
    private var fromCityNameLabel:UILabel!
    
    private var toLabel:UILabel!
    private var toPlusImgView:UIImageView!
    private var toCityView:UIView!
    private var toSignNameCityLabel:UILabel!
    private var toCityNameLabel:UILabel!
    
    //Select Itinerary View
    private var selectItineraryView:UIView!
    private var containSelectIntineraryView:UIView!
    private var upperSelectItineraryView:UIView!
    private var centerSelectItineraryView:UIView!
    private var centerHiddenSelectItineraryView:UIView!
    private var bottomHiddenSelectItineraryView:UIView!
    private var bottomSelectItineraryView:UIView!
    
    private var departureDateLabel:UILabel!
    private var leftDateLabel:UILabel!
    private var departurePlaneImgView:UIImageView!
    private var departureWeekDayLabel:UILabel!
    
    private var returnDateLabel:UILabel!
    private var rightDateLabel:UILabel!
    private var returnPlaneImgView:UIImageView!
    private var returnWeekDayLabel:UILabel!
    
    private var selectDatePlaneImgView:UIImageView!
    private var daySelectCollectionView:UICollectionView!
    private var monthSelectScrollView:UIScrollView!
    
    private var didChangeToSelectDate:Bool = false
    
    
    private var visibleBtnsInScrollView:[UIButton] = []
    private var hiddenBtnsInScrollView:[UIButton] = []
    private var didStopScrollView:Bool = true
    private var selectReturn:Bool = false
    private var indexSelected: Int!
    private var isReturnTrip:Bool = true
    
    private var departureDate:(year:Int, month:Int, day:Int, weekday:Int)!
    private var returnDate:(year:Int, month:Int, day:Int, weekday:Int)!
    
    private var selectedWeekday:Int?
    private var selectedDay:Int?
    private var selectedMonth:Int? {
        didSet {
            if oldValue == nil {
                for btn in self.monthSelectScrollView.subviews as! [UIButton] {
                    if btn.tag == self.selectedMonth {
                        btn.setTitleColor(UIColor(hexString: "#65B4CE"), forState: .Normal)
                        self.setDaysInSelectedMonth(self.selectedMonth!)
                        break
                    }
                }

            } else {
                if oldValue != self.selectedMonth {
                    for btn in self.monthSelectScrollView.subviews as! [UIButton] {
                        if btn.tag == oldValue {
                            btn.setTitleColor(UIColor.grayColor(), forState: .Normal)
                        }
                        if btn.tag == self.selectedMonth {
                            btn.setTitleColor(UIColor(hexString: "#65B4CE"), forState: .Normal)
                            self.setDaysInSelectedMonth(self.selectedMonth!)
                        }
                    }
                }
            }
        }
    }
    private var selectedYear:Int?
    private var numOfDaysInSelectedMonth:Int? {
        didSet {
            if daySelectCollectionView != nil {
                daySelectCollectionView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        indexSelected = 1001
        self.updateTabbarItems()
        self.createUpperView()
        self.createSelectItineraryView()
        self.createSelectItineraryHiddenViews()
    }
    
    private func updateTabbarItems() {
        self.tabBarController?.tabBar.hidden = false
        let tabbarItems = ["Search", "Watch", "Flights", "Profile"]
        let tabBarImages = [UIImage(named: "SearchIcon"), UIImage(named: "WatchIcon"), UIImage(named: "PlaneIcon2"), UIImage(named: "ProfileIcon")]
        let tabBarController = self.tabBarController! as UITabBarController
        var items = tabBarController.tabBar.items
        
        for i in 0..<items!.count {
            let item:UITabBarItem = items![i]
            item.titlePositionAdjustment = UIOffsetMake(0, -5)
            items![i].image = tabBarImages[i]
            items![i].title = tabbarItems[i]
        }
    }
    
    private func createUpperView() {
        upperView = UIView()
        upperView.backgroundColor = UIColor(hexString: "#65B4CE")
        self.view.addSubview(upperView)
        upperView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(self.view.frame.size.height/3)
        }
        upperView.layoutIfNeeded()
        
        titleLabel = UILabel()
        titleLabel.frame = CGRectMake(0, 0, 150, 30)
        titleLabel.text = "Cheap Flights"
        titleLabel.textColor = UIColor.whiteColor()
        titleLabel.font.fontWithSize(60)
        titleLabel.sizeToFit()
        upperView.addSubview(titleLabel)
        titleLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.upperView.frame.size.height*0.1)
            make.centerX.equalTo(self.upperView.snp_centerX)
            make.height.equalTo(self.upperView.snp_height).multipliedBy(0.15)
        }
        
        //Create Segmented Control
        segmentedControl = UISegmentedControl(items: ["One Way", "Round Trip"]  )
        segmentedControl.layer.cornerRadius = 5.0
        segmentedControl.backgroundColor = UIColor.clearColor()
        segmentedControl.tintColor = UIColor.whiteColor()
        segmentedControl.selectedSegmentIndex = 1
        segmentedControl.addTarget(self, action: #selector(SearchViewController.segmentChanged(_:)), forControlEvents: UIControlEvents.ValueChanged)
        upperView.addSubview(segmentedControl)
        segmentedControl.snp_makeConstraints { (make) in
            make.top.equalTo(self.titleLabel.snp_bottom).offset(self.upperView.frame.size.height*0.05)
            make.centerX.equalTo(self.upperView.snp_centerX)
            make.width.equalTo(self.upperView.snp_width).multipliedBy(0.8)
            make.height.equalTo(self.upperView.snp_height).multipliedBy(0.1)
        }
        
        
        //Create From View
        fromView = UIView()
//        fromView.backgroundColor = UIColor.redColor()
        upperView.addSubview(fromView)
        fromView.snp_makeConstraints { (make) in
            make.top.equalTo(self.segmentedControl.snp_bottom).offset(self.upperView.frame.size.height*0.05)
            make.leading.equalTo(self.upperView.frame.size.width*0.1)
            make.width.equalTo(self.upperView.snp_width).multipliedBy(0.3)
            make.height.equalTo(self.upperView.snp_height).multipliedBy(0.5)
        }
        fromView.layoutIfNeeded()
        
        fromLabel = UILabel()
        fromLabel.text = "FROM"
        fromLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        fromLabel.textAlignment = .Center
        fromLabel.font = UIFont(name: (fromLabel.font?.fontName)!, size: 13)
        fromView.addSubview(fromLabel)
        fromLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.fromView.snp_top).offset(self.fromView.frame.size.height*0.1)
            make.centerX.equalTo(self.fromView.snp_centerX)
            make.height.equalTo(self.fromView.snp_height).multipliedBy(0.15)
        }
        
        fromPlusImgView = UIImageView(image: UIImage(named: "PlusIcon"))
        fromPlusImgView.contentMode = .ScaleAspectFit
        fromView.addSubview(fromPlusImgView)
        fromPlusImgView.snp_makeConstraints { (make) in
            make.center.equalTo(self.fromView.snp_center)
            make.width.equalTo(self.fromView.snp_width).multipliedBy(0.25)
            make.height.equalTo(fromPlusImgView.snp_width)
        }
        fromPlusImgView.hidden = true
        
        fromCityView = UIView()
        fromView.addSubview(fromCityView)
        fromCityView.snp_makeConstraints { (make) in
            make.top.equalTo(self.fromLabel.snp_bottom).offset(self.fromView.frame.size.height*0.05)
            make.centerX.equalTo(self.fromView.snp_centerX)
            make.width.equalTo(self.fromView.snp_width)
            make.bottom.equalTo(0)
        }
        
        fromSignNameCityLabel = UILabel()
        fromSignNameCityLabel.text = "SGN"
        fromSignNameCityLabel.textAlignment = .Center
        fromSignNameCityLabel.textColor = UIColor.whiteColor()
        fromCityView.addSubview(fromSignNameCityLabel)
        fromSignNameCityLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.fromCityView.snp_top)
            make.height.equalTo(self.fromCityView.snp_height).multipliedBy(0.5)
            make.centerX.equalTo(self.fromCityView.snp_centerX)
            make.width.equalTo(self.fromCityView.snp_width)
        }
        fromSignNameCityLabel.font = UIFont(name: fromSignNameCityLabel.font.fontName, size: 35)
        fromSignNameCityLabel.adjustsFontSizeToFitWidth = true

        
        fromCityNameLabel = UILabel()
        fromCityNameLabel.text = "HO CHI MINH CITY"
        fromCityNameLabel.textColor = UIColor.whiteColor()
        fromCityNameLabel.adjustsFontSizeToFitWidth = true
        fromCityNameLabel.font = UIFont(name: (fromCityNameLabel.font?.fontName)!, size: 12)
        fromCityNameLabel.textAlignment = .Center
        fromCityView.addSubview(fromCityNameLabel)
        fromCityNameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.fromSignNameCityLabel.snp_bottom)
            make.centerX.equalTo(self.fromCityView.snp_centerX)
            make.height.equalTo(self.fromCityView.snp_height).multipliedBy(0.2)
            make.width.equalTo(self.fromCityView.snp_width)
        }
//        fromCityView.hidden = true
        
        //Create Center View
        centerView = UIView()
        upperView.addSubview(centerView)
        centerView.snp_makeConstraints { (make) in
            make.top.equalTo(fromView.snp_top)
            make.left.equalTo(self.fromView.snp_right)
            make.width.equalTo(self.upperView.snp_width).multipliedBy(0.2)
            make.height.equalTo(self.upperView.snp_height).multipliedBy(0.5)
        }
        centerView.layoutIfNeeded()
        
        planeImgView = UIImageView()
        planeImgView.contentMode = .ScaleAspectFit
        planeImgView.image = UIImage(named: "PlaneIcon")
        centerView.addSubview(planeImgView)
        planeImgView.snp_makeConstraints { (make) in
            make.center.equalTo(centerView.snp_center)
            make.width.equalTo(self.centerView.snp_width).multipliedBy(0.35)
            make.height.equalTo(self.centerView.snp_height).multipliedBy(0.35)
        }
        
        
        // Create To View
        toView = UIView()
        upperView.addSubview(toView)
        toView.snp_makeConstraints { (make) in
            make.top.equalTo(centerView.snp_top)
            make.left.equalTo(self.centerView.snp_right)
            make.width.equalTo(self.upperView.snp_width).multipliedBy(0.3)
            make.height.equalTo(self.upperView.snp_height).multipliedBy(0.5)
        }
        toView.layoutIfNeeded()
        
        toLabel = UILabel()
        toLabel.text = "TO"
        toLabel.textColor = UIColor.whiteColor().colorWithAlphaComponent(0.5)
        toLabel.font = UIFont(name: (fromLabel.font?.fontName)!, size: 13)
        toLabel.textAlignment = .Center
        toView.addSubview(toLabel)
        toLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.toView.snp_top).offset(self.toView.frame.size.height*0.1)
            make.centerX.equalTo(self.toView.snp_centerX)
            make.height.equalTo(self.toView.snp_height).multipliedBy(0.15)
        }
        
        toPlusImgView = UIImageView(image: UIImage(named: "PlusIcon"))
        toPlusImgView.contentMode = .ScaleAspectFit
        toView.addSubview(toPlusImgView)
        toPlusImgView.snp_makeConstraints { (make) in
            make.center.equalTo(self.toView.snp_center)
            make.width.equalTo(self.toView.snp_width).multipliedBy(0.25)
            make.height.equalTo(toPlusImgView.snp_width)
        }
        
        toCityView = UIView()
        toView.addSubview(toCityView)
        toCityView.snp_makeConstraints { (make) in
            make.top.equalTo(self.toLabel.snp_bottom).offset(self.toView.frame.size.height*0.05)
            make.centerX.equalTo(self.toView.snp_centerX)
            make.width.equalTo(self.toView.snp_width)
            make.bottom.equalTo(0)
        }
        
        toSignNameCityLabel = UILabel()
        toSignNameCityLabel.text = "HAN"
        toSignNameCityLabel.textAlignment = .Center
        toSignNameCityLabel.textColor = UIColor.whiteColor()
        toCityView.addSubview(toSignNameCityLabel)
        toSignNameCityLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.toCityView.snp_top)
            make.height.equalTo(self.toCityView.snp_height).multipliedBy(0.5)
            make.centerX.equalTo(self.toCityView.snp_centerX)
            make.width.equalTo(self.toCityView.snp_width)
        }
        toSignNameCityLabel.font = UIFont(name: toSignNameCityLabel.font.fontName, size: 35)
        toSignNameCityLabel.adjustsFontSizeToFitWidth = true
        
        
        toCityNameLabel = UILabel()
        toCityNameLabel.text = "HANOI"
        toCityNameLabel.textColor = UIColor.whiteColor()
        toCityNameLabel.adjustsFontSizeToFitWidth = true
        toCityNameLabel.textAlignment = .Center
        toCityNameLabel.font = UIFont(name: (toCityNameLabel.font?.fontName)!, size: 12)
        toCityView.addSubview(toCityNameLabel)
        toCityNameLabel.snp_makeConstraints { (make) in
            make.top.equalTo(self.toSignNameCityLabel.snp_bottom)
            make.centerX.equalTo(self.toCityView.snp_centerX)
            make.height.equalTo(self.toCityView.snp_height).multipliedBy(0.2)
            make.width.equalTo(self.toCityView.snp_width)
        }
        toCityView.hidden = true
    }
    
    func segmentChanged(sender:UISegmentedControl) {
        if sender.selectedSegmentIndex == 0 {
            self.isReturnTrip = false
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.rightDateLabel.alpha = 0.0
                self.returnPlaneImgView.alpha = 0.0
                self.returnDateLabel.alpha = 0.0
                self.returnWeekDayLabel.alpha = 0.0
                }, completion: nil)
        } else if sender.selectedSegmentIndex == 1 {
            self.isReturnTrip = true
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.returnPlaneImgView.alpha = 1.0
                self.returnDateLabel.alpha = 1.0
                if self.didChangeToSelectDate == false {
                    self.rightDateLabel.alpha = 1.0
                    self.returnWeekDayLabel.alpha = 1.0
                }
                }, completion: nil)
        }
    }
    
    private func createSelectItineraryView() {
        selectItineraryView = UIView()
        selectItineraryView.layer.borderWidth = 0.5
        selectItineraryView.layer.borderColor = UIColor.lightGrayColor().CGColor
        self.view.addSubview(selectItineraryView)
        selectItineraryView.snp_makeConstraints { (make) in
            make.top.equalTo(self.upperView.snp_bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(self.view.snp_height).multipliedBy(0.15)
        }
        selectItineraryView.layoutIfNeeded()
        
        containSelectIntineraryView = UIView()
        self.selectItineraryView.addSubview(containSelectIntineraryView)
        containSelectIntineraryView.snp_makeConstraints { (make) in
            make.width.equalTo(self.selectItineraryView.snp_width).multipliedBy(0.8)
            make.height.equalTo(self.selectItineraryView.snp_height).multipliedBy(0.6)
            make.center.equalTo(self.selectItineraryView.snp_center)
        }
        containSelectIntineraryView.layoutIfNeeded()
        
        upperSelectItineraryView = UIView()
        containSelectIntineraryView.addSubview(upperSelectItineraryView)
        upperSelectItineraryView.snp_makeConstraints { (make) in
            make.top.left.right.equalTo(0)
            make.height.equalTo(containSelectIntineraryView.snp_height).multipliedBy(0.2)
        }
        upperSelectItineraryView.layoutIfNeeded()
        
        centerSelectItineraryView = UIView()
        containSelectIntineraryView.addSubview(centerSelectItineraryView)
        centerSelectItineraryView.snp_makeConstraints { (make) in
            make.top.equalTo(upperSelectItineraryView.snp_bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(containSelectIntineraryView.snp_height).multipliedBy(0.6)
        }
        centerSelectItineraryView.layoutIfNeeded()
        
        bottomSelectItineraryView = UIView()
        containSelectIntineraryView.addSubview(bottomSelectItineraryView)
        bottomSelectItineraryView.snp_makeConstraints { (make) in
            make.top.equalTo(centerSelectItineraryView.snp_bottom)
            make.left.right.equalTo(0)
            make.height.equalTo(containSelectIntineraryView.snp_height).multipliedBy(0.2)
        }
        bottomSelectItineraryView.layoutIfNeeded()
        
        /*
        Create Departure Labels
        */
        leftDateLabel = UILabel()
        leftDateLabel.text = "DEPARTURE DATE"
        leftDateLabel.textColor = UIColor.grayColor()
        leftDateLabel.textAlignment = .Left
        leftDateLabel.font = UIFont(name: (leftDateLabel.font?.fontName)!, size: 12)
        upperSelectItineraryView.addSubview(leftDateLabel)
        leftDateLabel.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.bottom.equalTo(upperSelectItineraryView.snp_bottom)
            make.height.equalTo(upperSelectItineraryView.snp_height).multipliedBy(1.0)
        }
        leftDateLabel.layoutIfNeeded()
        
        departurePlaneImgView = UIImageView(image: UIImage(named: "PlaneIcon"))
        departurePlaneImgView.image = departurePlaneImgView.image?.imageWithRenderingMode(.AlwaysTemplate)
        departurePlaneImgView.tintColor = UIColor(hexString: "#65B4CE")
        departurePlaneImgView.contentMode = .ScaleAspectFit
        let selectDepartureDateGesture = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.departurePlaneImgViewDidTapped(_:)))
        departurePlaneImgView.addGestureRecognizer(selectDepartureDateGesture)
        departurePlaneImgView.userInteractionEnabled = true
        centerSelectItineraryView.addSubview(departurePlaneImgView)
        departurePlaneImgView.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.centerY.equalTo(centerSelectItineraryView.snp_centerY)
            make.height.equalTo(centerSelectItineraryView.snp_height).multipliedBy(0.5)
            make.width.equalTo(departurePlaneImgView.snp_height)
        }
        
        departureDateLabel = UILabel()
        departureDateLabel.text = "JULY 16"
        departureDateLabel.textAlignment = .Left
        let selectDepartureDateGesture2 = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.deparetureDateLblDidTapped(_:)))
        departureDateLabel.addGestureRecognizer(selectDepartureDateGesture2)
        departureDateLabel.userInteractionEnabled = true
        departureDateLabel.font = UIFont(name: (departureDateLabel.font?.fontName)!, size: 15)
        centerSelectItineraryView.addSubview(departureDateLabel)
        departureDateLabel.snp_makeConstraints { (make) in
            make.left.equalTo(departurePlaneImgView.snp_right).offset(10)
            make.centerY.equalTo(centerSelectItineraryView.snp_centerY)
            make.height.equalTo(departurePlaneImgView.snp_height)
        }
        
        departureWeekDayLabel = UILabel()
        departureWeekDayLabel.text = "SATURDAY"
        departureWeekDayLabel.textAlignment = .Left
        departureWeekDayLabel.font = UIFont(name: (departureWeekDayLabel.font?.fontName)!, size: 12)
        departureWeekDayLabel.textColor = UIColor.grayColor()
        bottomSelectItineraryView.addSubview(departureWeekDayLabel)
        departureWeekDayLabel.snp_makeConstraints { (make) in
            make.top.left.equalTo(0)
            make.height.equalTo(bottomSelectItineraryView.snp_height)
        }
        
        /*
         Create Return Labels
         */
        rightDateLabel = UILabel()
        rightDateLabel.text = "RETURN DATE"
        rightDateLabel.textColor = UIColor.grayColor()
        rightDateLabel.textAlignment = .Left
        rightDateLabel.font = UIFont(name: (rightDateLabel?.font?.fontName)!, size: 12)
        upperSelectItineraryView.addSubview(rightDateLabel)
        rightDateLabel.snp_makeConstraints { (make) in
            make.left.equalTo(upperSelectItineraryView.snp_centerX)
            make.bottom.equalTo(upperSelectItineraryView.snp_bottom)
            make.height.equalTo(upperSelectItineraryView.snp_height).multipliedBy(1.0)
        }
        
        returnPlaneImgView = UIImageView(image: UIImage(named: "PlaneIcon"))
        returnPlaneImgView.image = returnPlaneImgView.image?.imageWithRenderingMode(.AlwaysTemplate)
        returnPlaneImgView.tintColor = UIColor(hexString: "#65B4CE")
        departurePlaneImgView.contentMode = .ScaleAspectFit
        let returnDateSelectGesture = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.returnPlaneImgViewDidTapped(_:)))
        returnPlaneImgView.addGestureRecognizer(returnDateSelectGesture)
        returnPlaneImgView.userInteractionEnabled = true
        centerSelectItineraryView.addSubview(returnPlaneImgView)
        returnPlaneImgView.snp_makeConstraints { (make) in
            make.left.equalTo(centerSelectItineraryView.snp_centerX)
            make.centerY.equalTo(centerSelectItineraryView.snp_centerY)
            make.height.equalTo(centerSelectItineraryView.snp_height).multipliedBy(0.5)
            make.width.equalTo(returnPlaneImgView.snp_height)
        }
        
        returnDateLabel = UILabel()
        returnDateLabel.text = "JULY 21"
        returnDateLabel.textAlignment = .Left
        let returnDateSelectGesture2 = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.returnDatelblDidTapped(_:)))
        returnDateLabel.addGestureRecognizer(returnDateSelectGesture2)
        returnDateLabel.userInteractionEnabled = true
        returnDateLabel.font = UIFont(name: (returnDateLabel.font?.fontName)!, size: 15)
        centerSelectItineraryView.addSubview(returnDateLabel)
        returnDateLabel.snp_makeConstraints { (make) in
            make.left.equalTo(returnPlaneImgView.snp_right).offset(10)
            make.centerY.equalTo(centerSelectItineraryView.snp_centerY)
            make.height.equalTo(returnPlaneImgView.snp_height)
        }
        
        returnWeekDayLabel = UILabel()
        returnWeekDayLabel.text = "THURSDAY"
        returnWeekDayLabel.textAlignment = .Left
        returnWeekDayLabel.font = UIFont(name: (returnWeekDayLabel.font?.fontName)!, size: 12)
        returnWeekDayLabel.textColor = UIColor.grayColor()
        bottomSelectItineraryView.addSubview(returnWeekDayLabel)
        returnWeekDayLabel.snp_makeConstraints { (make) in
            make.top.equalTo(0)
            make.left.equalTo(bottomSelectItineraryView.snp_centerX)
            make.height.equalTo(bottomSelectItineraryView.snp_height)
        }
    }
    
    private func createSelectItineraryHiddenViews() {
        centerHiddenSelectItineraryView = UIView()
        self.selectItineraryView.addSubview(centerHiddenSelectItineraryView)
        centerHiddenSelectItineraryView.snp_makeConstraints { (make) in
            make.left.equalTo(self.selectItineraryView.snp_right).offset(self.selectItineraryView.frame.size.width*0.1)
            make.top.equalTo(self.centerSelectItineraryView.snp_top)
            make.height.equalTo(self.centerSelectItineraryView.snp_height)
            make.width.equalTo(self.centerSelectItineraryView.snp_width)
        }
        centerHiddenSelectItineraryView.layoutIfNeeded()
        
        selectDatePlaneImgView = UIImageView(image: UIImage(named: "PlaneIcon"))
        selectDatePlaneImgView.contentMode = .ScaleAspectFit
        selectDatePlaneImgView.image = selectDatePlaneImgView.image?.imageWithRenderingMode(.AlwaysTemplate)
        selectDatePlaneImgView.tintColor = UIColor(hexString: "#65B4CE")
        centerHiddenSelectItineraryView.addSubview(selectDatePlaneImgView)
        selectDatePlaneImgView.snp_makeConstraints { (make) in
            make.left.equalTo(0)
            make.centerY.equalTo(centerHiddenSelectItineraryView.snp_centerY)
            make.height.equalTo(centerHiddenSelectItineraryView.snp_height).multipliedBy(0.5)
            make.width.equalTo(selectDatePlaneImgView.snp_height)
        }
        let returnItineraryViewGesture = UITapGestureRecognizer(target: self, action: #selector(SearchViewController.selectDatePlaneImgViewDidTapped(_:)))
        selectDatePlaneImgView.addGestureRecognizer(returnItineraryViewGesture)
        selectDatePlaneImgView.userInteractionEnabled = true
        
        let layout = UICollectionViewFlowLayout()
        daySelectCollectionView = UICollectionView(frame: CGRectZero, collectionViewLayout: layout)
        daySelectCollectionView.translatesAutoresizingMaskIntoConstraints = false
        daySelectCollectionView.frame = CGRectMake(0, 0, 100, 100)
        daySelectCollectionView.backgroundColor = UIColor.clearColor()
        daySelectCollectionView.dataSource = self
        daySelectCollectionView.delegate = self
        daySelectCollectionView.showsVerticalScrollIndicator = false
        daySelectCollectionView.showsHorizontalScrollIndicator = false
        daySelectCollectionView.registerClass(DayCollectionViewCell.self, forCellWithReuseIdentifier: "reusableCell")
        centerHiddenSelectItineraryView.addSubview(daySelectCollectionView)
        daySelectCollectionView.snp_makeConstraints { (make) in
            make.left.equalTo(selectDatePlaneImgView.snp_right).offset(5)
            make.centerY.equalTo(centerHiddenSelectItineraryView.snp_centerY)
            make.height.equalTo(centerHiddenSelectItineraryView.snp_height).multipliedBy(0.7)
            make.right.equalTo(centerHiddenSelectItineraryView.snp_right)
        }
        daySelectCollectionView.layoutIfNeeded()
        layout.itemSize = CGSizeMake(daySelectCollectionView.frame.size.height, daySelectCollectionView.frame.size.height)
        layout.scrollDirection = .Horizontal
        layout.sectionInset = UIEdgeInsetsMake(0, 0, 0, 0)
        daySelectCollectionView.allowsSelection = true
        daySelectCollectionView.reloadData()
        
        
        
        //Create ScrollView
        monthSelectScrollView = UIScrollView()
        self.selectItineraryView.addSubview(monthSelectScrollView)
        monthSelectScrollView.snp_makeConstraints { (make) in
            make.top.equalTo(centerHiddenSelectItineraryView.snp_bottom)
            make.leading.equalTo(centerHiddenSelectItineraryView.snp_leading)
            make.trailing.equalTo(centerHiddenSelectItineraryView.snp_trailing)
            make.height.equalTo(self.selectItineraryView.frame.size.height - self.centerHiddenSelectItineraryView.frame.origin.y - self.centerHiddenSelectItineraryView.frame.size.height)
        }
        monthSelectScrollView.layoutIfNeeded()
        monthSelectScrollView.showsHorizontalScrollIndicator = false
        monthSelectScrollView.showsVerticalScrollIndicator = false
        monthSelectScrollView.delegate = self
        monthSelectScrollView.tag = 21
        
        let currentDate = NSDate().getCurrentYearMonthDay()
        var scrollViewContentSize:CGFloat = 0
        for i in currentDate.month...currentDate.month+11 {
            var month = i
            if i > 12 {
                month -= 12
            }
            
            let button = UIButton(type: .Custom)
            button.tag = month
            self.monthSelectScrollView.addSubview(button)
            switch month {
            case 1:
                button.setTitle(LocalizableString().getString(January), forState: .Normal)
                break
            case 2:
                button.setTitle(LocalizableString().getString(February), forState: .Normal)
                break
            case 3:
                button.setTitle(LocalizableString().getString(March), forState: .Normal)
                break
            case 4:
                button.setTitle(LocalizableString().getString(April), forState: .Normal)
                break
            case 5:
                button.setTitle(LocalizableString().getString(May), forState: .Normal)
                break
            case 6:
                button.setTitle(LocalizableString().getString(June), forState: .Normal)
                break
            case 7:
                button.setTitle(LocalizableString().getString(July), forState: .Normal)
                break
            case 8:
                button.setTitle(LocalizableString().getString(August), forState: .Normal)
                break
            case 9:
                button.setTitle(LocalizableString().getString(September), forState: .Normal)
                break
            case 10:
                button.setTitle(LocalizableString().getString(October), forState: .Normal)
                break
            case 11:
                button.setTitle(LocalizableString().getString(November), forState: .Normal)
                break
            case 12:
                button.setTitle(LocalizableString().getString(December), forState: .Normal)
                break
            default:
                break
            }
            
            button.sizeToFit()
            button.titleLabel?.font = UIFont(name: (button.titleLabel!.font?.fontName)!, size: 13)
            button.setTitleColor(UIColor.grayColor(), forState: .Normal)
            button.addTarget(self, action: #selector(SearchViewController.monthBtnDidTapped(_:)), forControlEvents: UIControlEvents.TouchUpInside)
            let title = (button.titleLabel?.text)! as String as NSString
            let size = title.sizeWithAttributes([NSFontAttributeName:(button.titleLabel?.font)!])
            let width = size.width

            button.frame = CGRectMake(scrollViewContentSize, self.monthSelectScrollView.bounds.size.height + 10, width, bottomSelectItineraryView.frame.size.height)
            button.alpha = 0.0
            scrollViewContentSize += button.frame.size.width + 11
            for z in currentDate.month...currentDate.month+4 {
                if i == z {
                    visibleBtnsInScrollView.append(button)
                }
            }
            for y in currentDate.month+5...currentDate.month+11 {
                if i == y {
                    hiddenBtnsInScrollView.append(button)
                }
            }
            
            if month == currentDate.month {
                self.selectedMonth = month
            }
        }
        monthSelectScrollView.contentSize = CGSizeMake(scrollViewContentSize, monthSelectScrollView.frame.size.height)
        
    }
    
    func monthBtnDidTapped(sender:UIButton) {
        self.selectedMonth = sender.tag
    }
    
    func setDaysInSelectedMonth(month:Int) {
        let currentDate = NSDate().getCurrentYearMonthDay()
        selectedYear = currentDate.year
        if month < currentDate.month {
            selectedYear = selectedYear! + 1
        }
        let numOfDays = NSDate().getNumOfDaysInMonth(selectedYear!, month: month)
        if month == currentDate.month {
//            if self.selectedDay != nil {
//                self.selectedDay! -= currentDate.day - 1
//            }
           numOfDaysInSelectedMonth = numOfDays - currentDate.day + 1
        } else {
//            if self.selectedDay != nil {
//                self.selectedDay! += currentDate.day - 1
//            }
            numOfDaysInSelectedMonth = numOfDays
        }
    }
    
    func deparetureDateLblDidTapped(sender:UITapGestureRecognizer) {
        self.departurePlaneImgViewDidTapped(sender)
    }
    
    func departurePlaneImgViewDidTapped(sender:UITapGestureRecognizer) {
        if didChangeToSelectDate == false && didStopScrollView == true {
            
            UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.leftDateLabel.frame.origin.y -= self.upperSelectItineraryView.bounds.size.height
            }) { (completed) in
                if self.selectReturn == true {
                    self.leftDateLabel.text = "RETURN DATE"
                }
                UIView.animateWithDuration(0.25, animations: {
                    self.leftDateLabel.frame.origin.y += self.upperSelectItineraryView.bounds.size.height
                    
                })
            }
            
            UIView.animateWithDuration(0.5) {
                self.rightDateLabel.frame.origin.y -= self.upperSelectItineraryView.bounds.size.height + 10
                self.rightDateLabel.alpha = 0
            }
            
            UIView.animateWithDuration(0.35, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.departureWeekDayLabel.frame.origin.y += self.bottomSelectItineraryView.bounds.size.height + 10
                self.returnWeekDayLabel.frame.origin.y += self.bottomSelectItineraryView.bounds.size.height + 10
                self.departureWeekDayLabel.alpha = 0.0
                self.returnWeekDayLabel.alpha = 0.0
            }) { (completed) in
               self.goUpStairAnimation(self.visibleBtnsInScrollView, startingPos: 0)
                for button in self.hiddenBtnsInScrollView as [UIButton] {
                    button.frame.origin.y -= self.monthSelectScrollView.bounds.size.height + 10
                    button.alpha = 1.0
                }
            }
            
            UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
                self.centerSelectItineraryView.frame.origin.x -= self.selectItineraryView.frame.size.width
                self.centerHiddenSelectItineraryView.frame.origin.x -= self.selectItineraryView.frame.size.width
                self.monthSelectScrollView.frame.origin.x -= self.selectItineraryView.frame.size.width
                self.bottomSelectItineraryView.frame.origin.x -= self.selectItineraryView.frame.size.width

                }, completion: { (completed) in
                    self.didChangeToSelectDate = true
            })
        }
    }
    
    
    func returnDatelblDidTapped(sender:UITapGestureRecognizer) {
        self.selectReturn = true
        self.departurePlaneImgViewDidTapped(sender)
    }
    
    func returnPlaneImgViewDidTapped(sender:UITapGestureRecognizer) {
        self.selectReturn = true
        self.departurePlaneImgViewDidTapped(sender)
    }
    
    func selectDatePlaneImgViewDidTapped(sender:UITapGestureRecognizer) {
        if didChangeToSelectDate == true && didStopScrollView == true {
            self.goDownStairAnimation(visibleBtnsInScrollView, startingPos: 0)
        }
    }
    
    func returnToSelectItineraryViewAnimation() {
        UIView.animateWithDuration(0.25, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.leftDateLabel.frame.origin.y -= self.upperSelectItineraryView.bounds.size.height
        }) { (completed) in
            if self.selectReturn == true {
                self.leftDateLabel.text = "DEPARTURE DATE"
            }
            UIView.animateWithDuration(0.25, animations: {
                self.leftDateLabel.frame.origin.y += self.upperSelectItineraryView.bounds.size.height
            })
            self.selectReturn = false
        }
        
        UIView.animateWithDuration(0.5) {
            self.rightDateLabel.frame.origin.y += self.upperSelectItineraryView.bounds.size.height + 10
            if self.isReturnTrip == true {
                self.rightDateLabel.alpha = 1.0
            }
        }
        
        UIView.animateWithDuration(0.5, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.centerSelectItineraryView.frame.origin.x += self.selectItineraryView.frame.size.width
            self.centerHiddenSelectItineraryView.frame.origin.x += self.selectItineraryView.frame.size.width
            self.monthSelectScrollView.frame.origin.x += self.selectItineraryView.frame.size.width
            self.bottomSelectItineraryView.frame.origin.x += self.selectItineraryView.frame.size.width
            }, completion: { (completed) in
                self.didChangeToSelectDate = false
        })
        
        UIView.animateWithDuration(0.35, delay: 0.0, options: UIViewAnimationOptions.CurveLinear, animations: {
            self.departureWeekDayLabel.frame.origin.y -= self.bottomSelectItineraryView.bounds.size.height + 10
            self.returnWeekDayLabel.frame.origin.y -= self.bottomSelectItineraryView.bounds.size.height + 10
            self.departureWeekDayLabel.alpha = 1.0
            if self.isReturnTrip == true {
                self.returnWeekDayLabel.alpha = 1.0
            }
        }) { (completed) in
            for button in self.hiddenBtnsInScrollView as [UIButton] {
                button.frame.origin.y += self.monthSelectScrollView.bounds.size.height + 10
                button.alpha = 0.0
            }
        }
    }
    
    func goUpStairAnimation(visibleBtns:[UIButton], startingPos:Int) {
        let button = visibleBtns[startingPos] as UIButton
        UIView.animateWithDuration(0.12, delay: 0.02, options: UIViewAnimationOptions.CurveLinear, animations: {
            button.frame.origin.y -= self.monthSelectScrollView.bounds.size.height + 10
            button.alpha = 1.0
        }) { (completed) in
            let nextPos = startingPos + 1
            if nextPos < visibleBtns.count {
                self.goUpStairAnimation(visibleBtns, startingPos: nextPos)
            }
        }
    }
    
    func goDownStairAnimation(visibleBtns:[UIButton], startingPos:Int) {
        let button = visibleBtns[startingPos] as UIButton
        var didStartReturnAnimation = false
        UIView.animateWithDuration(0.12, delay: 0.02, options: UIViewAnimationOptions.CurveLinear, animations: {
            if self.didChangeToSelectDate == true {
                button.frame.origin.y += self.monthSelectScrollView.bounds.size.height + 10
                button.alpha = 0.0
            }
        }) { (completed) in
            let nextPos = startingPos + 1
            if nextPos < visibleBtns.count {
                self.goDownStairAnimation(visibleBtns, startingPos: nextPos)
                if nextPos == visibleBtns.count - 1 {
                    didStartReturnAnimation = true
                    if didStartReturnAnimation == true {
                        self.returnToSelectItineraryViewAnimation()
                        didStartReturnAnimation = false
                    }
                }
            }
        }
    }

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension SearchViewController : UIScrollViewDelegate {
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.tag == 21 {
            didStopScrollView = false
        }
    }
    
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        if scrollView.tag == 21 {
            if didStopScrollView == false {
                visibleBtnsInScrollView.removeAll()
                hiddenBtnsInScrollView.removeAll()
                for view in scrollView.subviews {
                    guard let btn = view as? UIButton else { return }
                    let btnPosition = btn.frame
                    let container = CGRectMake(scrollView.contentOffset.x, scrollView.contentOffset.y, scrollView.frame.size.width, scrollView.frame.size.height)
                    if CGRectIntersectsRect(btnPosition, container) {
                        visibleBtnsInScrollView.append(btn)
                    } else {
                        hiddenBtnsInScrollView.append(btn)
                    }
                }
                didStopScrollView = true
            }
        }
    }
}

extension SearchViewController:UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    func numberOfSectionsInCollectionView(collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.numOfDaysInSelectedMonth != nil {
            return self.numOfDaysInSelectedMonth!
        } else {
            return 0
        }
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("reusableCell", forIndexPath: indexPath) as! DayCollectionViewCell
        
        let currentDate = NSDate().getCurrentYearMonthDay()

        cell.tag == indexPath.item
        cell.textLabel.text = String(indexPath.item+1)
        if selectedMonth! == currentDate.month {
            let day = currentDate.day + indexPath.item
            cell.textLabel.text = String(day)
            
        }
        cell.userInteractionEnabled = true
        
        if self.selectedDay != nil {
            if self.selectedDay! == indexPath.row
            {
                cell.imageView.hidden = false
                cell.textLabel.textColor = UIColor.whiteColor()
            }
            else
            {
                cell.textLabel.textColor = UIColor.blackColor()
                cell.imageView.hidden = true
                
            }
        } else {
            cell.textLabel.textColor = UIColor.blackColor()
            cell.imageView.hidden = true
        }

        return cell
    }
    
    func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("reusableCell", forIndexPath: indexPath) as! DayCollectionViewCell
        self.selectedDay = indexPath.row
        collectionView.reloadData()
        self.goDownStairAnimation(visibleBtnsInScrollView, startingPos: 0)
    }
}

