//
//  ViewableType.swift
//  ThenUIKit
//
//  Created by ghost on 2023/3/12
//

import ThenFoundation
import UIKit

public protocol ViewableType: NSObjectProtocol {
    var view: UIView! { get }

    var viewController: UIViewController? { get }
}

public extension ViewableType {
    var isUserInteractionEnabled: Bool {
        get { view.isUserInteractionEnabled }
        set { view.isUserInteractionEnabled = newValue }
    }

    var tag: Int {
        get { view.tag }
        set { view.tag = newValue }
    }

    var layer: CALayer {
        return view.layer
    }

    @available(iOS 9.0, *)
    var canBecomeFocused: Bool {
        return view.canBecomeFocused
    }

    @available(iOS 9.0, *)
    var isFocused: Bool {
        return view.isFocused
    }

    @available(iOS 9.0, *)
    var semanticContentAttribute: UISemanticContentAttribute {
        get { view.semanticContentAttribute }
        set { view.semanticContentAttribute = newValue }
    }

    @available(iOS 10.0, *)
    var effectiveUserInterfaceLayoutDirection: UIUserInterfaceLayoutDirection {
        return view.effectiveUserInterfaceLayoutDirection
    }
}

public extension ViewableType {
    var frame: CGRect {
        get { view.frame }
        set { view.frame = newValue }
    }

    var bounds: CGRect {
        get { view.bounds }
        set { view.bounds = newValue }
    }

    var center: CGPoint {
        get { view.center }
        set { view.center = newValue }
    }

    var transform: CGAffineTransform {
        get { view.transform }
        set { view.transform = newValue }
    }

    @available(iOS 13.0, *)
    var transform3D: CATransform3D {
        get { view.transform3D }
        set { view.transform3D = newValue }
    }

    @available(iOS 4.0, *)
    var contentScaleFactor: CGFloat {
        get { view.contentScaleFactor }
        set { view.contentScaleFactor = newValue }
    }

    var isMultipleTouchEnabled: Bool {
        get { view.isMultipleTouchEnabled }
        set { view.isMultipleTouchEnabled = newValue }
    }

    var isExclusiveTouch: Bool {
        get { view.isExclusiveTouch }
        set { view.isExclusiveTouch = newValue }
    }

    func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        return view.hitTest(point, with: event)
    }

    func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
        return view.point(inside: point, with: event)
    }

    func convert(_ point: CGPoint, to view: UIView?) -> CGPoint {
        return self.view.convert(point, to: view)
    }

    func convert(_ point: CGPoint, from view: UIView?) -> CGPoint {
        return self.view.convert(point, from: view)
    }

    func convert(_ rect: CGRect, to view: UIView?) -> CGRect {
        return self.view.convert(rect, to: view)
    }

    func convert(_ rect: CGRect, from view: UIView?) -> CGRect {
        return self.view.convert(rect, from: view)
    }

    var autoresizesSubviews: Bool {
        get { view.autoresizesSubviews }
        set { view.autoresizesSubviews = newValue }
    }

    var autoresizingMask: UIView.AutoresizingMask {
        get { view.autoresizingMask }
        set { view.autoresizingMask = newValue }
    }

    func sizeThatFits(_ size: CGSize) -> CGSize {
        return view.sizeThatFits(size)
    }

    func sizeToFit() {
        view.sizeToFit()
    }
}

public extension ViewableType {
    var superview: UIView? {
        return view.superview
    }

    var subviews: [UIView] {
        return view.subviews
    }

    var window: UIWindow? {
        return view.window
    }

    func removeFromSuperview() {
        view.removeFromSuperview()
    }

    func insertSubview(_ view: UIView, at index: Int) {
        self.view.insertSubview(view, at: index)
    }

    func exchangeSubview(at index1: Int, withSubviewAt index2: Int) {
        view.exchangeSubview(at: index1, withSubviewAt: index2)
    }

    func addSubview(_ view: UIView) {
        view.removeFromSuperview()
        self.view.addSubview(view)
    }

    func insertSubview(_ view: UIView, belowSubview siblingSubview: UIView) {
        view.removeFromSuperview()
        self.view.insertSubview(view, belowSubview: siblingSubview)
    }

    func insertSubview(_ view: UIView, aboveSubview siblingSubview: UIView) {
        view.removeFromSuperview()
        self.view.insertSubview(view, aboveSubview: siblingSubview)
    }

    func bringSubviewToFront(_ view: UIView) {
        self.view.bringSubviewToFront(view)
    }

    func sendSubviewToBack(_ view: UIView) {
        self.view.sendSubviewToBack(view)
    }

    func didAddSubview(_ subview: UIView) {
        view.didAddSubview(subview)
    }

    func willRemoveSubview(_ subview: UIView) {
        view.willRemoveSubview(subview)
    }

    func willMove(toSuperview newSuperview: UIView?) {
        view.willMove(toSuperview: newSuperview)
    }

    func didMoveToSuperview() {
        view.didMoveToSuperview()
    }

    func willMove(toWindow newWindow: UIWindow?) {
        view.willMove(toWindow: newWindow)
    }

    func didMoveToWindow() {
        view.didMoveToWindow()
    }

    func isDescendant(of view: UIView) -> Bool {
        return self.view.isDescendant(of: view)
    }

    func viewWithTag(_ tag: Int) -> UIView? {
        return view.viewWithTag(tag)
    }

    func setNeedsLayout() {
        view.setNeedsLayout()
    }

    func layoutIfNeeded() {
        view.layoutIfNeeded()
    }

    func layoutSubviews() {
        view.layoutSubviews()
    }

    @available(iOS 8.0, *)
    var layoutMargins: UIEdgeInsets {
        get { view.layoutMargins }
        set { view.layoutMargins = newValue }
    }

    @available(iOS 11.0, *)
    var directionalLayoutMargins: NSDirectionalEdgeInsets {
        get { view.directionalLayoutMargins }
        set { view.directionalLayoutMargins = newValue }
    }

    @available(iOS 8.0, *)
    var preservesSuperviewLayoutMargins: Bool {
        get { view.preservesSuperviewLayoutMargins }
        set { view.preservesSuperviewLayoutMargins = newValue }
    }

    @available(iOS 11.0, *)
    var insetsLayoutMarginsFromSafeArea: Bool {
        get { view.insetsLayoutMarginsFromSafeArea }
        set { view.insetsLayoutMarginsFromSafeArea = newValue }
    }

    @available(iOS 8.0, *)
    func layoutMarginsDidChange() {
        view.layoutMarginsDidChange()
    }

    @available(iOS 11.0, *)
    var safeAreaInsets: UIEdgeInsets {
        return view.safeAreaInsets
    }

    @available(iOS 11.0, *)
    func safeAreaInsetsDidChange() {
        view.safeAreaInsetsDidChange()
    }

    @available(iOS 9.0, *)
    var layoutMarginsGuide: UILayoutGuide {
        return view.layoutMarginsGuide
    }

    @available(iOS 9.0, *)
    var readableContentGuide: UILayoutGuide {
        return view.readableContentGuide
    }

    @available(iOS 11.0, *)
    var safeAreaLayoutGuide: UILayoutGuide {
        return view.safeAreaLayoutGuide
    }
}

public extension ViewableType {
    func draw(_ rect: CGRect) {
        view.draw(rect)
    }

    func setNeedsDisplay() {
        view.setNeedsDisplay()
    }

    func setNeedsDisplay(_ rect: CGRect) {
        view.setNeedsDisplay(rect)
    }

    var clipsToBounds: Bool {
        get { view.clipsToBounds }
        set { view.clipsToBounds = newValue }
    }

    var backgroundColor: UIColor? {
        get { view.backgroundColor }
        set { view.backgroundColor = newValue }
    }

    var alpha: CGFloat {
        get { view.alpha }
        set { view.alpha = newValue }
    }

    var isOpaque: Bool {
        get { view.isOpaque }
        set { view.isOpaque = newValue }
    }

    var clearsContextBeforeDrawing: Bool {
        get { view.clearsContextBeforeDrawing }
        set { view.clearsContextBeforeDrawing = newValue }
    }

    var isHidden: Bool {
        get { view.isHidden }
        set { view.isHidden = newValue }
    }

    var contentMode: UIView.ContentMode {
        get { view.contentMode }
        set { view.contentMode = newValue }
    }

    @available(iOS 8.0, *)
    var mask: UIView? {
        get { view.mask }
        set { view.mask = newValue }
    }

    @available(iOS 7.0, *)
    var tintColor: UIColor! {
        get { view.tintColor }
        set { view.tintColor = newValue }
    }

    @available(iOS 7.0, *)
    var tintAdjustmentMode: UIView.TintAdjustmentMode {
        get { view.tintAdjustmentMode }
        set { view.tintAdjustmentMode = newValue }
    }

    @available(iOS 7.0, *)
    func tintColorDidChange() {
        view.tintColorDidChange()
    }
}

public extension ViewableType {
    @available(iOS 3.2, *)
    var gestureRecognizers: [UIGestureRecognizer]? {
        get { view.gestureRecognizers }
        set { view.gestureRecognizers = newValue }
    }

    @available(iOS 3.2, *)
    func addGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        view.addGestureRecognizer(gestureRecognizer)
    }

    @available(iOS 3.2, *)
    func removeGestureRecognizer(_ gestureRecognizer: UIGestureRecognizer) {
        view.removeGestureRecognizer(gestureRecognizer)
    }

    @available(iOS 6.0, *)
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return view.gestureRecognizerShouldBegin(gestureRecognizer)
    }
}

public extension ViewableType {
    @available(iOS 7.0, *)
    func addMotionEffect(_ effect: UIMotionEffect) {
        view.addMotionEffect(effect)
    }

    @available(iOS 7.0, *)
    func removeMotionEffect(_ effect: UIMotionEffect) {
        view.removeMotionEffect(effect)
    }

    @available(iOS 7.0, *)
    var motionEffects: [UIMotionEffect] {
        get { view.motionEffects }
        set { view.motionEffects = newValue }
    }
}

public extension ViewableType {
    @available(iOS 6.0, *)
    var constraints: [NSLayoutConstraint] {
        return view.constraints
    }

    @available(iOS 6.0, *)
    func addConstraint(_ constraint: NSLayoutConstraint) {
        view.addConstraint(constraint)
    }

    @available(iOS 6.0, *)
    func addConstraints(_ constraints: [NSLayoutConstraint]) {
        view.addConstraints(constraints)
    }

    @available(iOS 6.0, *)
    func removeConstraint(_ constraint: NSLayoutConstraint) {
        view.removeConstraint(constraint)
    }

    @available(iOS 6.0, *)
    func removeConstraints(_ constraints: [NSLayoutConstraint]) {
        view.removeConstraints(constraints)
    }
}

public extension ViewableType {
    @available(iOS 6.0, *)
    func updateConstraintsIfNeeded() {
        view.updateConstraintsIfNeeded()
    }

    @available(iOS 6.0, *)
    func updateConstraints() {
        view.updateConstraints()
    }

    @available(iOS 6.0, *)
    func needsUpdateConstraints() -> Bool {
        return view.needsUpdateConstraints()
    }

    @available(iOS 6.0, *)
    func setNeedsUpdateConstraints() {
        view.setNeedsUpdateConstraints()
    }
}

public extension ViewableType {
    @available(iOS 6.0, *)
    var translatesAutoresizingMaskIntoConstraints: Bool {
        get { view.translatesAutoresizingMaskIntoConstraints }
        set { view.translatesAutoresizingMaskIntoConstraints = newValue }
    }
}

public extension ViewableType {
    @available(iOS 6.0, *)
    func alignmentRect(forFrame frame: CGRect) -> CGRect {
        return view.alignmentRect(forFrame: frame)
    }

    @available(iOS 6.0, *)
    func frame(forAlignmentRect alignmentRect: CGRect) -> CGRect {
        return view.frame(forAlignmentRect: alignmentRect)
    }

    @available(iOS 6.0, *)
    var alignmentRectInsets: UIEdgeInsets {
        return view.alignmentRectInsets
    }

    @available(iOS 9.0, *)
    var forFirstBaselineLayout: UIView {
        return view.forFirstBaselineLayout
    }

    @available(iOS 9.0, *)
    var forLastBaselineLayout: UIView {
        return view.forLastBaselineLayout
    }

    @available(iOS 6.0, *)
    var intrinsicContentSize: CGSize {
        return view.intrinsicContentSize
    }

    @available(iOS 6.0, *)
    func invalidateIntrinsicContentSize() {
        view.invalidateIntrinsicContentSize()
    }

    @available(iOS 6.0, *)
    func contentHuggingPriority(for axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
        return view.contentHuggingPriority(for: axis)
    }

    @available(iOS 6.0, *)
    func setContentHuggingPriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        return view.setContentHuggingPriority(priority, for: axis)
    }

    @available(iOS 6.0, *)
    func contentCompressionResistancePriority(for axis: NSLayoutConstraint.Axis) -> UILayoutPriority {
        return view.contentCompressionResistancePriority(for: axis)
    }

    @available(iOS 6.0, *)
    func setContentCompressionResistancePriority(_ priority: UILayoutPriority, for axis: NSLayoutConstraint.Axis) {
        view.setContentCompressionResistancePriority(priority, for: axis)
    }
}

public extension ViewableType {
    @available(iOS 6.0, *)
    func systemLayoutSizeFitting(_ targetSize: CGSize) -> CGSize {
        return view.systemLayoutSizeFitting(targetSize)
    }

    @available(iOS 8.0, *)
    func systemLayoutSizeFitting(
        _ targetSize: CGSize,
        withHorizontalFittingPriority horizontalFittingPriority: UILayoutPriority,
        verticalFittingPriority: UILayoutPriority
    ) -> CGSize {
        return view.systemLayoutSizeFitting(
            targetSize,
            withHorizontalFittingPriority: horizontalFittingPriority,
            verticalFittingPriority: verticalFittingPriority
        )
    }
}

public extension ViewableType {
    @available(iOS 9.0, *)
    var layoutGuides: [UILayoutGuide] {
        return view.layoutGuides
    }

    @available(iOS 9.0, *)
    func addLayoutGuide(_ layoutGuide: UILayoutGuide) {
        view.addLayoutGuide(layoutGuide)
    }

    @available(iOS 9.0, *)
    func removeLayoutGuide(_ layoutGuide: UILayoutGuide) {
        view.removeLayoutGuide(layoutGuide)
    }
}

public extension ViewableType {
    @available(iOS 9.0, *)
    var leadingAnchor: NSLayoutXAxisAnchor {
        return view.leadingAnchor
    }

    @available(iOS 9.0, *)
    var trailingAnchor: NSLayoutXAxisAnchor {
        return view.trailingAnchor
    }

    @available(iOS 9.0, *)
    var leftAnchor: NSLayoutXAxisAnchor {
        return view.leftAnchor
    }

    @available(iOS 9.0, *)
    var rightAnchor: NSLayoutXAxisAnchor {
        return view.rightAnchor
    }

    @available(iOS 9.0, *)
    var topAnchor: NSLayoutYAxisAnchor {
        return view.topAnchor
    }

    @available(iOS 9.0, *)
    var bottomAnchor: NSLayoutYAxisAnchor {
        return view.bottomAnchor
    }

    @available(iOS 9.0, *)
    var widthAnchor: NSLayoutDimension {
        return view.widthAnchor
    }

    @available(iOS 9.0, *)
    var heightAnchor: NSLayoutDimension {
        return view.heightAnchor
    }

    @available(iOS 9.0, *)
    var centerXAnchor: NSLayoutXAxisAnchor {
        return view.centerXAnchor
    }

    @available(iOS 9.0, *)
    var centerYAnchor: NSLayoutYAxisAnchor {
        return view.centerYAnchor
    }

    @available(iOS 9.0, *)
    var firstBaselineAnchor: NSLayoutYAxisAnchor {
        return view.firstBaselineAnchor
    }

    @available(iOS 9.0, *)
    var lastBaselineAnchor: NSLayoutYAxisAnchor {
        return view.lastBaselineAnchor
    }
}

public extension ViewableType {
    @available(iOS 6.0, *)
    func exerciseAmbiguityInLayout() {
        view.exerciseAmbiguityInLayout()
    }
}

public extension ViewableType {
    @available(iOS 10.0, *)
    func constraintsAffectingLayout(for axis: NSLayoutConstraint.Axis) -> [NSLayoutConstraint] {
        return view.constraintsAffectingLayout(for: axis)
    }

    @available(iOS 10.0, *)
    var hasAmbiguousLayout: Bool {
        return view.hasAmbiguousLayout
    }
}

public extension ViewableType {
    @available(iOS 6.0, *)
    var restorationIdentifier: String? {
        get { view.restorationIdentifier }
        set { view.restorationIdentifier = newValue }
    }

    @available(iOS 6.0, *)
    func encodeRestorableState(with coder: NSCoder) {
        view.encodeRestorableState(with: coder)
    }

    @available(iOS 6.0, *)
    func decodeRestorableState(with coder: NSCoder) {
        view.decodeRestorableState(with: coder)
    }
}

public extension ViewableType {
    @available(iOS 7.0, *)
    func snapshotView(afterScreenUpdates afterUpdates: Bool) -> UIView? {
        view.snapshotView(afterScreenUpdates: afterUpdates)
    }

    @available(iOS 7.0, *)
    func resizableSnapshotView(from rect: CGRect, afterScreenUpdates afterUpdates: Bool, withCapInsets capInsets: UIEdgeInsets) -> UIView? {
        return view.resizableSnapshotView(from: rect, afterScreenUpdates: afterUpdates, withCapInsets: capInsets)
    }

    @available(iOS 7.0, *)
    func drawHierarchy(in rect: CGRect, afterScreenUpdates afterUpdates: Bool) -> Bool {
        return view.drawHierarchy(in: rect, afterScreenUpdates: afterUpdates)
    }
}

public extension ViewableType {
    @available(iOS 13.0, *)
    var overrideUserInterfaceStyle: UIUserInterfaceStyle {
        get { view.overrideUserInterfaceStyle }
        set { view.overrideUserInterfaceStyle = newValue }
    }
}

public extension ViewableType {
    var viewController: UIViewController? {
        return nil
    }

    func addSub(_ sub: ViewableType) {
        if let _ = sub.superview {
            sub.removeFromSuper()
        }
        view.addSubview(sub.view)
    }

    func removeFromSuper() {
        view.removeFromSuperview()
    }

    func insertSubview(_ sub: ViewableType, at index: Int) {
        view.insertSubview(sub.view, at: index)
    }

    func insertSubview(_ aview: ViewableType, belowSubview siblingSubview: ViewableType) {
        view.insertSubview(aview.view, belowSubview: siblingSubview.view)
    }

    func insertSubview(_ aview: ViewableType, aboveSubview siblingSubview: ViewableType) {
        view.insertSubview(aview.view, aboveSubview: siblingSubview.view)
    }

    func bringSubviewToFront(_ aview: ViewableType) {
        view.bringSubviewToFront(aview.view)
    }

    func bringToFront() {
        view.superview?.bringSubviewToFront(view)
    }

    func sendSubviewToBack(_ aview: ViewableType) {
        view.sendSubviewToBack(aview.view)
    }

    func sendToBack() {
        view.superview?.sendSubviewToBack(view)
    }

    func isDescendant(of aview: ViewableType) -> Bool {
        return view.isDescendant(of: aview.view)
    }
}

extension UIView: ViewableType {
    public var view: UIView! {
        return self
    }
}

extension UIView {
    func isSub<T: ViewableType>(of type: T.Type) -> Bool {
        if self is T {
            return true
        }
        return superview?.isSub(of: type) ?? false
    }
}

extension UIViewController: ViewableType {
    public var viewController: UIViewController? {
        return self
    }
}

public extension ThenExtension where T: ViewableType {
    func isSub<T: ViewableType>(of type: T.Type) -> Bool {
        return value.view.isSub(of: type)
    }
}

public extension ThenExtension where T: ViewableType {
    func debugBorder() {
        if value.layer.borderWidth > 0 {
            return
        }

        let rc = UIColor(hex: Int.random(in: 0 ... 0xFFFFFF))
        value.layer.borderColor = rc.cgColor
        value.layer.borderWidth = 1

        value.subviews.forEach { $0.then.debugBorder() }
    }
}

public protocol TableType: ViewableType {
    var table: UITableView { get }
}

public protocol CollectionType: ViewableType {
    var collection: UICollectionView { get }
}

public protocol TableCellType: ViewableType {
    var cell: UITableViewCell { get }
}

public protocol CollectionCellType: ViewableType {
    var cell: UICollectionViewCell { get }
}

extension UITableViewCell: TableCellType {
    public var cell: UITableViewCell { return self }
}

extension UICollectionViewCell: CollectionCellType {
    public var cell: UICollectionViewCell { return self }
}

extension UITableView: TableType {
    public var table: UITableView { return self }
}

extension UICollectionView: CollectionType {
    public var collection: UICollectionView { return self }
}
