import Combine
import SwiftUI
import SwiftUIIntrospect
import UIKit

final class UISBWARootController: UIHostingController<UISBWARootView> {

    private let primaryScrollViewSubject = CurrentValueSubject<UIScrollView?, Never>(nil)
    private var cancellables = Set<AnyCancellable>()

    init() {
        super.init(rootView: UISBWARootView(scrollViewSubject: primaryScrollViewSubject))

        primaryScrollViewSubject
            .compactMap { $0 }
            .sink { scrollView in
                NSLog("[UISBWA] Primary scroll view: \(scrollView)")
            }
            .store(in: &cancellables)
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    @objc var contentScrollView: UIScrollView? {
        primaryScrollViewSubject.value
    }
}

@objc(UISBWARootListController)
final class UISBWARootListController: PSListController {

    override func viewDidLoad() {
        super.viewDidLoad()
        addNavigationBarImage()

        navigationItem.title = ""
        navigationItem.largeTitleDisplayMode = .never

        let controller = UISBWARootController()
        addChild(controller)

        controller.view.frame = view.bounds
        controller.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        controller.view.translatesAutoresizingMaskIntoConstraints = true
        view.addSubview(controller.view)

        controller.didMove(toParent: self)
    }

    private func addNavigationBarImage() {
        let image = UIImage(named: "icon", in: Bundle.uisbwa_support, with: nil)!
        let imageView = UIImageView(image: image)
        let bannerWidth: CGFloat = 32
        let bannerHeight: CGFloat = 32
        let bannerX = bannerWidth / 2 - image.size.width / 2
        let bannerY = bannerHeight / 2 - image.size.height / 2
        imageView.frame = CGRect(x: bannerX, y: bannerY, width: bannerWidth, height: bannerHeight)
        imageView.contentMode = .scaleAspectFit
        navigationItem.titleView = imageView
    }

    @objc var contentScrollView: UIScrollView? {
        (children.first as? UISBWARootController)?.contentScrollView
    }
}
