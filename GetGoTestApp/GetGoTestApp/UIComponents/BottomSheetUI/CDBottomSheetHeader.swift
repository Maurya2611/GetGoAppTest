import UIKit
/**
 `CDBottomSheetHeader` is subclass of the UIView  which represents Bottom Sheet Header
 
 ## Steps to use CDBottomSheetHeader
 
 Set a UIView in storyboard and change the class to CDBottomSheetHeader. Derive and IBOutlet to the required UIViewController.
 // Set constraints as per requirement.
 CDBottomListItem is UIView component with left image view and title.
 
 'CDBottomListItem' contains the list component which is a subclass of `UIView` with uob design system styles.
 
 Public API's
 ```
 /// Handler when cancel is tapped
 public var onCancelTap: (() -> Void)?
 /// Text for the title
 public var title
 /// Image for cancel button
 public var cancelButtonImage
   */
enum HeaderPosition {
    case top
    case bottom
}
protocol HeaderButtonDelegate: AnyObject {
    func touchedInside(position: HeaderPosition)
}
enum BottomSheetType {
    case logoutSummary
    case basic
}
public class CDBottomSheetHeader: UIView {
    @IBOutlet weak private(set) var dividerView: UIView!
    @IBOutlet weak private(set) var titleLabel: UILabel!
    @IBOutlet private(set) var contentView: UIView!
    @IBOutlet weak private(set) var overlayButton: UIButton!
    weak var delegate: HeaderButtonDelegate?
    var type: BottomSheetType = .basic {
        didSet {
            switch type {
            case .logoutSummary:
                overlayButton.isHidden = false
            default:
                overlayButton.isHidden = true
            }
        }
    }
    var position: HeaderPosition = .bottom
    private var tokens: Tokens
    /// Handler when cancel is tapped
    public var closeButtonEventHandler: (() -> Void)?
    /// Text for the title
    public var title: String? {
        didSet {
            //titleLabel.sizeToFit()
            titleLabel.text = title
            titleLabel.isHidden = (title ?? "").isEmpty
            titleLabel.textColor = .black
            titleLabel.numberOfLines = 2
        }
    }
   
    fileprivate struct Drawing {
        fileprivate var cornerRadius = 6
        fileprivate var headerleadingTrailingPadding = 24
        fileprivate var headerTopBottomPadding = 16
        fileprivate var dividerColor = UIColor(red: 0.90, green: 0.90, blue: 0.90, alpha: 1.00)
        fileprivate var titleLabelFont = UIFont(name:"SFProRounded-Semibold", size: 30) ?? UIFont.boldSystemFont(ofSize: 14)
    }
    fileprivate struct Preference {
        fileprivate var isMultiSelect = false
    }
    private struct Tokens {
        fileprivate var drawing = Drawing()
        fileprivate var preference = Preference()
        fileprivate init() {}
    }
    // :nodoc:
    override public init(frame: CGRect) {
        self.tokens = Tokens.init()
        super.init(frame: frame)
        commonInit()
    }
    // :nodoc:
    required init?(coder aDecoder: NSCoder) {
        self.tokens = Tokens.init()
        super.init(coder: aDecoder)
        commonInit()
    }
    private func commonInit() {
        _ = fromNib(nibName: "CDBottomSheetHeader")
        titleLabel.font = tokens.drawing.titleLabelFont
        self.layer.masksToBounds = true
        self.clipsToBounds = true
        self.roundCorners([.topRight, .topLeft],
                          radius: CGSize(width: tokens.drawing.cornerRadius, height: tokens.drawing.cornerRadius))
        dividerView.backgroundColor = tokens.drawing.dividerColor
        self.contentView.backgroundColor = .clear
        self.backgroundColor = .clear
        updateSpacing()
    }
    @IBAction func overlayButtonTapped(_ sender: Any) {
        delegate?.touchedInside(position: position)
    }
    /// Set the correct spacing for subviews
    private func updateSpacing() {
        for constraint in contentView.constraints {
            switch constraint.identifier {
            case "StackViewTrailing": constraint.constant = CGFloat(tokens.drawing.headerleadingTrailingPadding)
            case "StackViewLeading": constraint.constant = CGFloat(tokens.drawing.headerleadingTrailingPadding)
            default:
                break
            }
        }
    }
}
