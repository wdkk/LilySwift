import MetalKit
import LilySwift

class DevViewController : LLViewController
{
    lazy var cyan_view = LLMetalView().chain
    .setup.add( with:self ) { caller, me in
        me.chain
        .backgroundColor( .cyan )
    }
    .buildup.add( with:self ) { caller, me in
        CATransaction.stop {
            me.chain
            .rect( caller.safeArea )
        }
    }
    .unchain

    override func setup() {
        super.setup()
        self.view.addSubview( cyan_view )
    }
}
