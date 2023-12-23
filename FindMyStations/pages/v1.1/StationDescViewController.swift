////
////  StationDescViewController.swift
////  MoviePlayer
////
////  Created by jack on 2023/9/22.
////
//
//import Foundation
//
//class StationDescViewController: UIViewController {
//    let station: Station
//    init(station: Station) {
//        self.station = station
//        super.init(nibName: nil, bundle: nil)
//    }
//    
//    required init?(coder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
//    }
//    
//    private lazy var segmentControl: UISegmentedControl = {
//        let segmentControl = UISegmentedControl(items: ["Json文件导入", "通过资源地址"])
//        return segmentControl
//    }()
//    
//    private lazy var pageVC = {
//        let pageVC = UIPageViewController()
//        return pageVC
//    }()
//    
//    private var viewControllers: [UIViewController] = []
//    private var currentIndex: Int = 0
//    
//    deinit {
//        debugPrint("StationDescViewController deinit")
//    }
//    
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        pageVC.delegate = self
//        pageVC.dataSource = self
//        
//        viewControllers = [StationJsonEditViewController(station: station), StationItemEditViewController(station: station)]
//        currentIndex = 0
//        pageVC.setViewControllers([viewControllers.first!], direction: .forward, animated: false)
//        
//        self.addChild(pageVC)
//        self.view.addSubview(pageVC.view)
//        pageVC.didMove(toParent: self)
//        pageVC.view.snp.makeConstraints { make in
//            make.left.bottom.right.top.equalToSuperview()
//        }
//        
//        self.navigationController?.navigationBar.addSubview(segmentControl)
//        segmentControl.snp.makeConstraints { make in
//            make.center.equalToSuperview()
//            make.width.equalTo(200)
//            make.height.equalToSuperview().offset(-20)
//        }
//        segmentControl.selectedSegmentIndex = 0
//        segmentControl.addTarget(self, action: #selector(onSegmentChanged), for: .valueChanged)
//    }
//    
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(animated)
//        segmentControl.isHidden = false
//    }
//    
//    override func viewWillDisappear(_ animated: Bool) {
//        super.viewWillDisappear(animated)
//        segmentControl.isHidden = true
//    }
//        
//    @objc func onSegmentChanged() {
//        let selectedIdx = segmentControl.selectedSegmentIndex
//        
//        pageVC.setViewControllers([viewControllers[selectedIdx]], direction: .forward, animated: false)
//    }
//}
//
//extension StationDescViewController: UIPageViewControllerDelegate, UIPageViewControllerDataSource {
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
//        currentIndex -= 1
//        if currentIndex < 0 {
//            currentIndex = viewControllers.count - 1
//        }
//        return viewControllers[currentIndex]
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
//        currentIndex += 1
//        if currentIndex > viewControllers.count - 1 {
//            currentIndex = 0
//        }
//        
//        return viewControllers[currentIndex]
//    }
//    
//    func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
//        segmentControl.selectedSegmentIndex = currentIndex
//    }
//    
//    func presentationCount(for pageViewController: UIPageViewController) -> Int {
//        return viewControllers.count
//    }
//    
//    func presentationIndex(for pageViewController: UIPageViewController) -> Int {
//        return currentIndex
//    }
//
//}
