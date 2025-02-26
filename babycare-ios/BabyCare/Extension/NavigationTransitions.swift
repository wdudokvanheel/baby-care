import SwiftUI
import NavigationTransitions

extension AnyNavigationTransition {
    static func flip(axis: Axis) -> Self {
        .init(Flip(axis: axis))
    }

    static var flip: Self {
        .flip(axis: .horizontal)
    }

    static var swing: Self {
        .init(Swing())
    }

    static var zoom: Self {
        .init(Zoom())
    }
}

struct Flip: NavigationTransitionProtocol {
    var axis: Axis

    var body: some NavigationTransitionProtocol {
        MirrorPush {
            Rotate3D(.degrees(180), axis: axis == .horizontal ? (x: 1, y: 0, z: 0) : (x: 0, y: 1, z: 0))
        }
    }
}

struct Swing: NavigationTransitionProtocol {
    var body: some NavigationTransitionProtocol {
        Slide(axis: .horizontal)
        MirrorPush {
            let angle = 70.0
            let offset = 150.0
            OnInsertion {
                ZPosition(1)
                Rotate(.degrees(-angle))
                Offset(x: offset)
                Opacity()
                Scale(0.5)
            }
            OnRemoval {
                Rotate(.degrees(angle))
                Offset(x: -offset)
            }
        }
    }
}

struct Zoom: NavigationTransitionProtocol {
    var body: some NavigationTransitionProtocol {
        MirrorPush {
            Scale(0.5)
            OnInsertion {
                ZPosition(1)
                Opacity()
            }
        }
    }
}
