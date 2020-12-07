//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

import Foundation
import Metal

open class LBPanel : LBShape<
    LBPanelDecoration,
    LBPanelStorage
    >
{
    public var vertice:LLQuad<LBActorVertex> {
        get { return decoration!.storage.metalVertex.vertice[index] }
        set { withUnsafeMutablePointer(to: &(decoration!.storage.metalVertex.vertice[index]) ) { 
                $0.pointee = newValue
            } 
        }
    }
    
    // MARK: - 基本パラメータオーバーライド
    public override var p1:LLPointFloat { 
        get { return LLPointFloat( vertice.p1.xy.x, vertice.p1.xy.y ) }
        set { vertice.p1.xy = LLFloatv2( newValue.x, newValue.y ) }
    }

    public override var p2:LLPointFloat { 
        get { return LLPointFloat( vertice.p2.xy.x, vertice.p2.xy.y ) }
        set { vertice.p2.xy = LLFloatv2( newValue.x, newValue.y ) }
    }
    
    public override var p3:LLPointFloat { 
        get { return LLPointFloat( vertice.p3.xy.x, vertice.p3.xy.y ) }
        set { vertice.p3.xy = LLFloatv2( newValue.x, newValue.y ) }
    }

    public override var p4:LLPointFloat { 
        get { return LLPointFloat( vertice.p4.xy.x, vertice.p4.xy.y ) }
        set { vertice.p4.xy = LLFloatv2( newValue.x, newValue.y ) }
    }

    public override var uv1:LLPointFloat { 
        get { return LLPointFloat( vertice.p1.tex_uv.u, vertice.p1.tex_uv.v ) }
        set { vertice.p1.tex_uv = LLFloatv2( newValue.x, newValue.y ) }
    }

    public override var uv2:LLPointFloat { 
        get { return LLPointFloat( vertice.p2.tex_uv.u, vertice.p2.tex_uv.v ) }
        set { vertice.p2.tex_uv = LLFloatv2( newValue.x, newValue.y ) }
    }

    public override var uv3:LLPointFloat { 
        get { return LLPointFloat( vertice.p3.tex_uv.u, vertice.p3.tex_uv.v ) }
        set { vertice.p3.tex_uv = LLFloatv2( newValue.x, newValue.y ) }
    }

    public override var uv4:LLPointFloat { 
        get { return LLPointFloat( vertice.p4.tex_uv.u, vertice.p4.tex_uv.v ) }
        set { vertice.p4.tex_uv = LLFloatv2( newValue.x, newValue.y ) }
    }

    
    @discardableResult
    public override func atlasParts( of key:String ) -> Self {
        guard let parts = decoration?.storage.atlas?.parts( key ),
              let reg = parts.region 
        else {
            LLLog( "アトラスが設定されていないか,指定が正しくないため無効です:\(key)" )
            params.atlasUV = LLFloatv4( 0.0, 0.0, 1.0, 1.0 )
            vertice.p1.tex_uv = .zero
            vertice.p2.tex_uv = .zero
            vertice.p3.tex_uv = .zero
            vertice.p4.tex_uv = .zero
            return self
        }
        
        params.atlasUV = LLFloatv4( reg.left.f, reg.top.f, reg.right.f, reg.bottom.f )
        vertice.p1.tex_uv = LLFloatv2( 0.0, 0.0 ) 
        vertice.p2.tex_uv = LLFloatv2( 1.0, 0.0 ) 
        vertice.p3.tex_uv = LLFloatv2( 0.0, 1.0 ) 
        vertice.p4.tex_uv = LLFloatv2( 1.0, 1.0 ) 
            
        return self
    }    

    @discardableResult
    public override func texture( _ tex:MTLTexture? ) -> Self {
        guard let tex = tex else {
            self.decoration?.storage.texture = nil
            params.atlasUV = LLFloatv4( 0.0, 0.0, 1.0, 1.0 );
            vertice.p1.tex_uv = .zero
            vertice.p2.tex_uv = .zero
            vertice.p3.tex_uv = .zero
            vertice.p4.tex_uv = .zero
            return self
        }
        
        self.decoration?.storage.texture = tex
        params.atlasUV = LLFloatv4( 0.0, 0.0, 1.0, 1.0 );
        vertice.p1.tex_uv = LLFloatv2( 0.0, 0.0 ) 
        vertice.p2.tex_uv = LLFloatv2( 1.0, 0.0 ) 
        vertice.p3.tex_uv = LLFloatv2( 0.0, 1.0 ) 
        vertice.p4.tex_uv = LLFloatv2( 1.0, 1.0 ) 
        
        return self
    } 

    @discardableResult
    public override func texture( _ tex:LLMetalTexture? ) -> Self {
        return texture( tex?.metalTexture )
    }
}
