//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

#if os(macOS)
import AppKit
#else
import UIKit
#endif
import Metal
import LilySwift
import LilySwiftAlias

var device = MTLCreateSystemDefaultDevice()!

class DevViewController 
: Lily.View.ViewController
{
    var pgScreen:PGScreen?
        
    lazy var planeStorage:PlaneStorage = .init(
        device: device,
        capacity: 2000, 
        textures: ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star", "star" ]
    )

    lazy var bbStorage:BBStorage = .init(
        device: device,
        capacity: 2000,
        textures: ["lily", "mask-sparkle", "mask-snow", "mask-smoke", "mask-star"]
    )

    lazy var modelStorage:ModelStorage = .init(
        device: device,
        modelCapacity: 500,
        modelAssets: [ "cottonwood1", "acacia1", "plane", "yukidaruma" ] 
    )
    
    lazy var planeStorage2:PlaneStorage = .init(
        device: device,
        capacity: 2000, 
        textures: [ "mask-smoke" ]
    )
    
    lazy var audioStorage:PGAudioStorage = .init(
        assetNames:[ "amenokoibitotachi", "mag!c number" ]
    )
    
    override func setup() {
        super.setup()
        
        pgScreen = PGScreen(
            device:device,
            environment:.string,
            planeStorage:planeStorage,
            bbStorage:bbStorage,
            modelStorage:modelStorage,
            audioStorage:audioStorage
        )
        
        pgScreen?.pgReadyHandler = ready
        pgScreen?.pgDesignHandler = design
        pgScreen?.pgUpdateHandler = update
        
        self.addSubview( pgScreen!.view )
    }
    
    override func buildup() {
        super.buildup()
        pgScreen?.rect = self.rect
    }
        
    #if os(macOS)
    #else
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        //PGSound( name:"sound2", assetName:"mag!c number" )
        //.play()
    }
    
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded( touches, with:event )
        
        planeStorage2.clear()
        
        pgScreen?.changeStorages(
            planeStorage:planeStorage2,
            bbStorage:nil,
            modelStorage:nil,
            audioStorage:audioStorage,
            ready:nil,
            design:design2,
            update:update,
            resize:nil
        )
    }
    #endif
}

func ready( screen:PGScreen ) {

    PGSound( name:"sound1", assetName:"mag!c number" )
    .play()

    PGShader.shared.make(
        device:device,
        name:"f1",
        code:"""
            float4 c = p.color * (1.0 - p.uv[0]) + p.color2 * p.uv[0];
            return float4( c.xyz, p.alpha );
        """
    )
    
    PGShader.shared.make(
        device:device,
        name:"f2",
        code:"""
            float4 c = saturate( p.color + p.color2 );
            return float4( c.xyz, p.alpha );
        """
    )
    
    BBShader.shared.make(
        device:device,
        name:"f3",
        code:"""
            float4 c = p.color * (1.0 - p.uv[0]) + p.color2 * p.uv[0];
            return float4( c.xyz, p.alpha );
        """
    )
}

func design( screen:PGScreen ) {
    //screen.clearColor = .clear
    screen.cubeMap = "skyCubeMap"
    
    screen.camera.position = .init( 0, 450, 400 )
    screen.camera.direction = .init( 0.0, -0.5, -0.8 )
    
    // Playground 3D
    MDObj( assetName:"cottonwood1" )
    .position( cx:-50.0, cy:0.0, cz:0.0 )
    .scale( x: 40, y: 40, z: 40 )
    
    MDObj( assetName:"cottonwood1" )
    .position( cx:50.0, cy:0.0, cz:0.0 )
    .scale( x: 80, y: 80, z: 80 )
    
    MDObj( assetName:"acacia1" )
    .position( cx:0.0, cy:0.0, cz:100.0 )
    .scale( x: 30, y: 30, z:30 )
    
    MDSphere()
    .position( cx:0.0, cy:50.0, cz:0.0 )
    .scale( x: 30, y: 30, z:30 )
    .rotation( rx:0, ry:LLAngle(degrees:-45.0).radians.f, rz:0 )
    
    MDObj( assetName:"plane" ) 
    .position( cx:0.0, cy:0.0, cz:0.0 )
    .scale( equal:1000.0 )
    
    let p = BBEmpty()
    .scale( scx:2.0, scy:2.0, scz:2.0 )
    .deltaRotation(rx: 0, ry: -0.005, rz:0 )
    .deltaAngle( degrees:1.0 )

    for _ in 0 ..< 160 {
        //BBAddBlurryCircle()
        BBShaderRectangle( shaderName:"f3" )
        .parent( p )
        .color( LLColor( 0.5, 0.8, 1.0, 1.0 ) )
        .color2( LLColor( 1.0, 0.8, 0.5, 1.0 ) )
        .position(
            cx:(-100.0 ... 100.0).randomize,
            cy:(0.0 ... 0.0).randomize,
            cz:(-100.0 ... 100.0).randomize
        )
        .deltaPosition( 
            dx:(-0.1...0.1).randomize,
            dy:(0.5...1.0).randomize,
            dz:(-0.1...0.1).randomize
        )
        .angle( .random )
        .scale( square:5.0 )
        .life( .random )
        .deltaLife( -0.005 )
        .iterate { _ in
            /*
            if $0.life < 0.5 {
               $0.alpha( $0.life )
            }
            else {
               $0.alpha( (1.0 - $0.life) )
            }
            */
        }
        .completion {
            $0
            .position(
                cx:(-100.0 ... 100.0).randomize,
                cy:(0.0 ... 0.0).randomize,
                cz:(-100.0 ... 100.0).randomize
            )
            .scale( square: 5.0 )
            .life( 1.0 )
        }
    }
}
 
func update( screen:PGScreen ) {
    LLClock.fps()
}

func design2( screen:PGScreen ) {    
    screen.clearColor = .darkGray 
    
    let p = PGEmpty()
    .deltaAngle( degrees:1.0 )
    
    for _ in 0 ..< 160 {
       //PGAddMask( "mask-smoke" )
       PGShaderRectangle( shaderName:"f1" )
       .parent( p )
       .color( LLColor( 0.62, 0.32, 0.22, 1.0 ) )
       .color2( .yellow )
       .position(
           cx:(-50 ... 50).randomize,
           cy:(-120 ... -110).randomize
       )
       .deltaPosition( 
           dx:(-1.0...1.0).randomize,
           dy:(0.5...4.5).randomize 
       )
       .scale( square: 80.0 )
       .deltaScale( dw: 0.5, dh: 0.5 )
       .angle( .random )
       .deltaAngle( degrees:(-2.0...2.0).randomize )
       .life( .random )
       .deltaLife( -0.01 )
       .iterate {
           if $0.life < 0.5 {
              $0.alpha( $0.life )
           }
           else {
              $0.alpha( (1.0 - $0.life) )
           }
       }
       .completion {
           $0
           .position( 
               cx:(-50 ... 50).randomize,
               cy:(-120 ... -110).randomize 
           )
           .scale( square: 80.0 )
           .life( 1.0 )
       }
    }
}

func update2( screen:PGScreen ) {

}
