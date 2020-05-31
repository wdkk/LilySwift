//
// LilySwift Library Project
//
// Copyright (c) Watanabe-DENKI Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)

import CoreVideo

public class LLDisplayLink
{
    var dlink:CVDisplayLink?
    public var loopFunc:(() -> ())?
     
    public init() {
        var dlink:CVDisplayLink?
        CVDisplayLinkCreateWithActiveCGDisplays( &dlink )
        guard let nonnull_dlink = dlink else { return }
        
        let result = CVDisplayLinkSetOutputCallback( nonnull_dlink,
            { ( _, _, _, _, _, context ) -> CVReturn in
                if let context = context {
                    let lldlink = Unmanaged<LLDisplayLink>.fromOpaque( context )
                    lldlink.takeUnretainedValue().loopFunc?()
                }
                return kCVReturnSuccess
            }, 
            Unmanaged.passUnretained( self ).toOpaque() )
        
        if result != kCVReturnSuccess {
            return
        }
        
        if CVDisplayLinkSetCurrentCGDisplay( nonnull_dlink, CGMainDisplayID() ) != kCVReturnSuccess { 
            return
        }
        
        self.dlink = nonnull_dlink
    }

    deinit {
        stop()
    }    
    
    public var isRunning:Bool { 
        guard let dlink = self.dlink else { return false }
        return CVDisplayLinkIsRunning( dlink )
    }
    
    public func start() {
        if isRunning { return }
        guard let dlink = self.dlink else { return }
        CVDisplayLinkStart( dlink )
    }
    
    public func stop() {
        if !isRunning { return }
        guard let dlink = self.dlink else { return }
        CVDisplayLinkStop( dlink )
    }
}

#endif
