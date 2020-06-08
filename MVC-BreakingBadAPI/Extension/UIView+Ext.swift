//
//  UIView+Ext.swift
//  MVC-BreakingBadAPI
//
//  Created by Iury Popov on 21.04.2020.
//  Copyright © 2020 Iurii Popov. All rights reserved.
//

import UIKit

extension UIView {
    
    func pinToEdges(of superview: UIView) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            topAnchor.constraint(equalTo: superview.topAnchor),
            leadingAnchor.constraint(equalTo: superview.leadingAnchor),
            trailingAnchor.constraint(equalTo: superview.trailingAnchor),
            bottomAnchor.constraint(equalTo: superview.bottomAnchor)
        ])
    }
    
    func addSubviews(_ views: UIView...) {
        for view in views { addSubview(view) }
    }
}

extension UIView {

    /// Добавляет childView с активацией констреинтов
    /// 1. Добавляет childView
    /// 2. отключает translatesAutoresizingMaskIntoConstraints
    /// 3. активирует констраинты из массива [Constraint]
    ///
    /// - Parameters:
    ///   - child: child view
    ///   - constraints: массив функций Constraint
    public func addSubview(_ child: UIView, constraints: [Constraint]) {
        addSubview(child)
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.map { $0(child, self) })
    }

    /// Помещает childView в массив subviews по указанному индексу с активацией констреинтов
    /// 1. Помещает childView
    /// 2. отключает translatesAutoresizingMaskIntoConstraints
    /// 3. активирует констраинты из массива [Constraint]
    ///
    /// - Parameters:
    ///   - child: child view
    ///   - index: индекс в массиве subviews
    ///   - constraints: массив функций Constraint
    public func insertSubview(_ child: UIView, at index: Int, constraints: [Constraint]) {
        insertSubview(child, at: index)
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.map { $0(child, self) })
    }

    /// Помещает childView в массив subviews ниже указанной view с активацией констреинтов
    /// 1. Помещает childView
    /// 2. отключает translatesAutoresizingMaskIntoConstraints
    /// 3. активирует констраинты из массива [Constraint]
    ///
    /// - Parameters:
    ///   - child: child view
    ///   - siblingSubview: view которая будет выше child view
    ///   - constraints: массив функций Constraint
    public func insertSubview(_ child: UIView, belowSubview siblingSubview: UIView, constraints: [Constraint]) {
        insertSubview(child, belowSubview: siblingSubview)
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.map { $0(child, self) })
    }

    /// Помещает childView в массив subviews выше указанной view с активацией констреинтов
    /// 1. Помещает childView
    /// 2. отключает translatesAutoresizingMaskIntoConstraints
    /// 3. активирует констраинты из массива [Constraint]
    ///
    /// - Parameters:
    ///   - child: child view
    ///   - siblingSubview: view которая будет ниже child view
    ///   - constraints: массив функций Constraint
    public func insertSubview(_ child: UIView, aboveSubview siblingSubview: UIView, constraints: [Constraint]) {
        insertSubview(child, aboveSubview: siblingSubview)
        child.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.map { $0(child, self) })
    }

    public func add(_ constraints: [Constraint]) {
        translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate(constraints.map { $0(self, self) })
    }

    public func addConstraint(to view: UIView, _ constraint: Constraint) -> NSLayoutConstraint {
        return constraint(view, self)
    }
}


/// Базовый тип констреинта
public typealias Constraint = (_ child: UIView, _ parent: UIView) -> NSLayoutConstraint

extension Array where Element == Constraint {
    public static func allAnchors(top: CGFloat = 0,
                                  bottom: CGFloat = 0,
                                  leading: CGFloat = 0,
                                  trailing: CGFloat = 0) -> [Constraint] {
        return [
            equal(\.topAnchor, constant: top),
            equal(\.bottomAnchor, constant: bottom),
            equal(\.leadingAnchor, constant: leading),
            equal(\.trailingAnchor, constant: trailing)
        ]
    }

    public static func allAnchors(margin: CGFloat = 0) -> [Constraint] {
        return .allAnchors(top: margin, bottom: -margin, leading: margin, trailing: -margin)
    }

    public static var allAnchors: [Constraint] {
        return .allAnchors(margin: 0)
    }

    public static func allAnchors(to view: UIView) -> [Constraint] {
        return [
            equal(\.topAnchor, to: view),
            equal(\.bottomAnchor, to: view),
            equal(\.leadingAnchor, to: view),
            equal(\.trailingAnchor, to: view)
        ]
    }
}

// MARK: - Axis констрейнты

/// Функция создания констреинта типа
/// ````
/// childView.{axis}Anchor.constraint(equalTo: parentView.{axis}Anchor, constant: constant)
/// ````
/// где, childView anchor != parentView anchor
/// - Parameters:
///   - keyPath: child view anchor key path
///   - to: parent view anchor key path
///   - constant: конcтанта
///   - priority: приоритет
/// - Returns: функция Constraint
public func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                _ to: KeyPath<UIView, Anchor>,
                                constant: CGFloat = 0,
                                priority: UILayoutPriority = .required)
    -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { child, parent in
        child[keyPath: keyPath].constraint(equalTo: parent[keyPath: to], constant: constant)
            .with(priority: priority)
    }
}

/// Функция создания констреинта типа
/// ````
/// childView.{axis}Anchor.constraint(equalTo: parentView.{axis}Anchor, constant: constant)
/// ````
/// где, childView anchor == parentView anchor
///
/// - Parameters:
///   - keyPath: общий anchor key path
///   - constant: константа
///   - priority: приоритет
/// - Returns: функция Constraint
public func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                constant: CGFloat = 0,
                                priority: UILayoutPriority = .required)
    -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return equal(keyPath, keyPath, constant: constant, priority: priority)
}

/// Функция создания констреинта типа
/// ````
/// childView.{axis}Anchor.constraint(equalTo: toView.{axis}Anchor, constant: constant)
/// ````
/// где, childView anchor != toView anchor
///
/// - Parameters:
///   - keyPath: child view anchor key path
///   - toView: родительская view
///   - to: parent view anchor key path
///   - constant: константа
///   - priority: приоритет
/// - Returns: функция Constraint
public func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                to view: UIView,
                                _ to: KeyPath<UIView, Anchor>,
                                constant: CGFloat = 0,
                                priority: UILayoutPriority = .required)
    -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { child, _ in
        child[keyPath: keyPath].constraint(equalTo: view[keyPath: to], constant: constant)
            .with(priority: priority)
    }
}

/// Функция создания констреинта типа
/// ````
/// childView.{axis}Anchor.constraint(equalTo: toViewController.{axis}Anchor, constant: constant)
/// ````
/// где, childView anchor != toViewController anchor
///
/// - Parameters:
///   - keyPath: child view anchor key path
///   - toViewController: родительский viewController
///   - to: parent ViewContoller anchor key path
///   - constant: константа
///   - priority: приоритет
/// - Returns: функция Constraint
public func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                to viewController: UIViewController,
                                _ to: KeyPath<UIViewController, Anchor>,
                                constant: CGFloat = 0,
                                priority: UILayoutPriority = .required)
    -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return { child, _ in
        child[keyPath: keyPath].constraint(equalTo: viewController[keyPath: to], constant: constant)
            .with(priority: priority)
    }
}

/// Функция создания констреинта типа
/// ````
/// childView.{axis}Anchor.constraint(equalTo: toView.{axis}Anchor, constant: constant)
/// ````
/// где, childView anchor == toView anchor
///
/// - Parameters:
///   - keyPath: общий anchor key path
///   - toView: родительская view
///   - constant: константа
///   - priority: приоритет
/// - Returns: функция Constraint
public func equal<Axis, Anchor>(_ keyPath: KeyPath<UIView, Anchor>,
                                to view: UIView,
                                constant: CGFloat = 0,
                                priority: UILayoutPriority = .required)
    -> Constraint where Anchor: NSLayoutAnchor<Axis> {
    return equal(keyPath, to: view, keyPath, constant: constant, priority: priority)
}

// MARK: - Dimensions констрейнты

/// Функция создания констреинта типа
/// ````
/// childView.{dimension}Anchor.constraint(equalToConstant: constant)
/// ````
///
/// - Parameters:
///   - keyPath: dimension anchor key path
///   - constant: константа
///   - priority: приоритет
/// - Returns: функция Constraint
public func equal<Dimension>(_ keyPath: KeyPath<UIView, Dimension>,
                             constant: CGFloat = 0,
                             priority: UILayoutPriority = .required) -> Constraint where Dimension: NSLayoutDimension {
    return { child, _ in
        child[keyPath: keyPath].constraint(equalToConstant: constant)
            .with(priority: priority)
    }
}

/// Функция создания констреинта типа
/// ````
/// childView.{dimension}Anchor.constraint(equalTo: parentView.{dimension}Anchor,
/// multiplier: multiplier, constant: constant)
/// ````
/// где, childView anchor != parentView anchor
///
/// - Parameters:
///   - keyPath: child view anchor key path
///   - to: parent view anchor key path
///   - multiplier: множитель
///   - constant: константа
///   - priority: приоритет
/// - Returns: функция Constraint
public func equal<Dimension>(_ keyPath: KeyPath<UIView, Dimension>,
                             _ to: KeyPath<UIView, Dimension>,
                             multiplier: CGFloat = 1,
                             constant: CGFloat = 0,
                             priority: UILayoutPriority = .required) -> Constraint where Dimension: NSLayoutDimension {
    return { child, parent in
        child[keyPath: keyPath].constraint(equalTo: parent[keyPath: to], multiplier: multiplier, constant: constant)
            .with(priority: priority)
    }
}

/// Функция создания констреинта типа
/// ````
/// childView.{dimension}Anchor.constraint(equalTo: parentView.{dimension}Anchor,
/// multiplier: multiplier, constant: constant)
/// ````
/// где, childView anchor == parentView anchor
///
/// - Parameters:
///   - keyPath: общий anchor key path
///   - multiplier: множитель
///   - constant: константа
///   - priority: приоритет
/// - Returns: функция Constraint
public func equal<Dimension>(_ keyPath: KeyPath<UIView, Dimension>,
                             multiplier: CGFloat = 1,
                             constant: CGFloat = 0,
                             priority: UILayoutPriority = .required) -> Constraint where Dimension: NSLayoutDimension {
    return equal(keyPath, keyPath, multiplier: multiplier, constant: constant, priority: priority)
}

/// Функция создания констреинта типа
/// ````
/// childView.{dimension}Anchor.constraint(equalTo: toView.{dimension}Anchor,
/// multiplier: multiplier, constant: constant)
/// ````
/// где, childView anchor != toView anchor
///
/// - Parameters:
///   - keyPath: child view anchor key path
///   - toView: родительская view
///   - to: parent view anchor key path
///   - multiplier: множитель
///   - constant: константа
///   - priority: приоритет
/// - Returns: функция Constraint
public func equal<Dimension>(_ keyPath: KeyPath<UIView, Dimension>,
                             to view: UIView,
                             _ to: KeyPath<UIView, Dimension>,
                             multiplier: CGFloat = 1,
                             constant: CGFloat = 0,
                             priority: UILayoutPriority = .required) -> Constraint where Dimension: NSLayoutDimension {
    return { child, _ in
        child[keyPath: keyPath].constraint(equalTo: view[keyPath: to], multiplier: multiplier, constant: constant)
            .with(priority: priority)
    }
}

/// Функция создания констреинта типа
/// ````
/// childView.{dimension}Anchor.constraint(equalTo: toView.{dimension}Anchor,
/// multiplier: multiplier, constant: constant)
/// ````
/// где, childView anchor == toView anchor
///
/// - Parameters:
///   - keyPath: общий anchor key path
///   - toView: родительская view
///   - multiplier: множитель
///   - constant: константа
///   - priority: приоритет
/// - Returns: функция Constraint
public func equal<Dimension>(_ keyPath: KeyPath<UIView, Dimension>,
                             to view: UIView,
                             multiplier: CGFloat = 1,
                             constant: CGFloat = 0,
                             priority: UILayoutPriority = .required) -> Constraint where Dimension: NSLayoutDimension {
    return equal(keyPath, to: view, keyPath, multiplier: multiplier, constant: constant, priority: priority)
}

extension NSLayoutConstraint {
    func with(priority: UILayoutPriority) -> NSLayoutConstraint {
        self.priority = priority

        return self
    }
}
