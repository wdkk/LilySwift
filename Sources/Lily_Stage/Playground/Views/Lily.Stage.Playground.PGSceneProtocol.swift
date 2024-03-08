//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

/// コメント未済

import Foundation
import Metal

public protocol Lily_Stage_Playground_PGSceneProtocol
{
    typealias PG = Lily.Stage.Playground
    
    // MARK: 描画テクスチャ
    var modelRenderTextures:PG.Model.RenderTextures { get set }
    var mediumTexture:PG.MediumTexture { get set }
    
    // MARK: ストレージ
    var planeStorage:PG.Plane.Storage? { get set }
    var modelStorage:PG.Model.Storage? { get set }
    var bbStorage:PG.Billboard.Storage? { get set }
    
    // MARK: レンダーフロー
    var clearRenderFlow:PG.ClearRenderFlow? { get set }
    var planeRenderFlow:PG.Plane.PlaneRenderFlow? { get set }
    var modelRenderFlow:PG.Model.RenderFlow? { get set }
    var bbRenderFlow:PG.Billboard.RenderFlow? { get set }
    var sRGBRenderFlow:PG.sRGB.RenderFlow? { get set }
    
    // MARK: - 背景色情報
    var clearColor:LLColor { get set }
    // MARK: - 2Dパーティクル情報
    var shapes:Set<PG.Plane.PGActor> { get }
    // MARK: - 3Dビルボード情報
    var billboards:Set<PG.Billboard.BBActor> { get }
    // MARK: - 3Dモデル情報
    var models:Set<PG.Model.ModelActor> { get }
    
    var pgDesignHandler:(( Self )->Void)? { get set }
    var pgUpdateHandler:(( Self )->Void)? { get set }
    var pgResizeHandler:(( Self )->Void)? { get set }
    
    func setCurrentStorage()
            
    func checkPlanesStatus()
    
    func checkBillboardsStatus() 
    
    func checkModelsStatus()
    
    func removeAllShapes()

    var _design_mutex:Lily.View.RecursiveMutex { get set }

    func alreadySetupDesignOnce() -> Bool
    func designOnce( _ torf:Bool )
    
    func redesign()
    func designProc( vc:Self, force:Bool ) 
    func updateProc( vc:Self )    
}

extension Lily_Stage_Playground_PGSceneProtocol
{
    // MARK: - 2Dパーティクル情報
    public var shapes:Set<PG.Plane.PGActor> { 
        if let storage = planeStorage { return PG.Plane.PGPool.shared.shapes( on:storage ) }
        return []
    }
    
    // MARK: - 3Dビルボード情報
    public var billboards:Set<PG.Billboard.BBActor> { 
        if let storage = bbStorage { return PG.Billboard.BBPool.shared.shapes( on:storage ) }
        return []
    }
    
    // MARK: - 3Dモデル情報
    public var models:Set<PG.Model.ModelActor> { 
        if let storage = modelStorage { return PG.Model.ModelPool.shared.shapes( on:storage ) }
        return []
    }
        
    public func setCurrentStorage() {
        PG.Plane.Storage.current = self.planeStorage
        PG.Billboard.Storage.current = self.bbStorage
        PG.Model.Storage.current = self.modelStorage
    }
            
    public func checkPlanesStatus() {
        self.shapes.forEach {
            $0.appearIterate()       // イテレート処理
            $0.appearInterval()      // インターバル処理
            
            if $0.life > 0.0 { return }
            
            $0.appearCompletion()    // 完了前処理
            $0.checkRemove()         // 削除処理
        }
    }
    
    public func checkBillboardsStatus() {
        self.billboards.forEach {
            $0.appearIterate()       // イテレート処理
            $0.appearInterval()      // インターバル処理
            
            if $0.life > 0.0 { return }
            
            $0.appearCompletion()    // 完了前処理
            $0.checkRemove()         // 削除処理
        }
    }
    
    public func checkModelsStatus() {
        self.models.forEach {
            $0.appearIterate()       // イテレート処理
            $0.appearInterval()      // インターバル処理
            
            if $0.life > 0.0 { return }
            
            $0.appearCompletion()    // 完了前処理
            $0.checkRemove()         // 削除処理
        }
    }
    
    public func removeAllShapes() {
        PG.Plane.PGPool.shared.removeAllShapes( on:planeStorage )
        PG.Billboard.BBPool.shared.removeAllShapes( on:bbStorage )
        PG.Model.ModelPool.shared.removeAllShapes( on:modelStorage )
    }
    
    public func redesign() {
        self.designProc( vc:self, force:true )
    }

    // MARK: - 更新時関数群
    public func designProc( vc:Self, force:Bool = false ) {
        // 強制描画でなくかつonceが効いているときはスキップ
        if !force && vc.alreadySetupDesignOnce() { return }

        // redesignの繰り返し呼び出しの防止をしつつ処理を実行
        _design_mutex.lock {
            PG.Serial.shared.serialize {
                vc.setCurrentStorage()
                
                vc.removeAllShapes()
                
                vc.pgDesignHandler?( self )
                
                vc.modelStorage?.statuses.commit()
                vc.bbStorage?.statuses.commit()
                vc.planeStorage?.statuses.commit()
                
                vc.designOnce( true )
            }
        }
    }
    
    public func updateProc( vc:Self ) {
        PG.Serial.shared.serialize {
            vc.setCurrentStorage()
            
            // TODO: ActorTimerも1つにしたい. 時間の更新
            PG.Plane.PGActor.ActorTimer.shared.update()
            PG.Billboard.BBActor.ActorTimer.shared.update()
            PG.Model.ModelActor.ActorTimer.shared.update()
            
            // ハンドラのコール
            vc.pgUpdateHandler?( self )
            // 変更の確定
            vc.modelStorage?.statuses.commit()
            vc.bbStorage?.statuses.commit()
            vc.planeStorage?.statuses.commit()
            
            // 背景色の更新
            vc.clearRenderFlow?.clearColor = self.clearColor
            vc.modelStorage?.clearColor = self.clearColor
            
            // Shapeの更新/終了処理を行う
            vc.checkPlanesStatus()
            vc.checkBillboardsStatus()
            vc.checkModelsStatus()
        }
    }
    
    public mutating func changeStorages(
        planeStorage:PG.Plane.Storage?,
        bbStorage:PG.Billboard.Storage?,
        modelStorage:PG.Model.Storage?,
        design:(( Self )->Void)?,
        update:(( Self )->Void)?,
        resize:(( Self )->Void)?
    )
    {
        self.planeStorage = planeStorage
        self.bbStorage = bbStorage
        self.modelStorage = modelStorage
        
        self.planeRenderFlow?.storage = self.planeStorage
        self.bbRenderFlow?.storage = self.bbStorage
        self.modelRenderFlow?.storage = self.modelStorage
        
        self.pgDesignHandler = design
        self.pgUpdateHandler = update
        self.pgResizeHandler = resize
        
        self.designProc( vc:self, force:true )
    }
}
