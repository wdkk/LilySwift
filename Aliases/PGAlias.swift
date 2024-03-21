//
// LilySwift Library Project
//
// Copyright (c) Watanabe-Denki, Inc. and Kengo Watanabe.
//   https://wdkk.co.jp/
//
// This software is released under the MIT License.
//   https://opensource.org/licenses/mit-license.php
//

// LilySwift利用時のエイリアスサポートをする
// PlaygroundリポジトリではLilySwiftForPlayground置き換わる
// Booksではimportが消えて同一モジュールとなる
import LilySwift

public typealias PG = Lily.Stage.Playground
public typealias PGScreen = PG.PGScreen
public typealias PGScreenView = PG.PGScreenView
public typealias PGScene = PG.PGScene
#if os(visionOS)
public typealias PGVisionFullyScreen = PG.PGVisionFullyScreen
public typealias PGVisionScene = PG.PGVisionScene
#endif

public typealias PlaneStorage = PG.Plane.PlaneStorage
public typealias PGActor = PG.Plane.PGActor
public typealias PGEmpty = PG.Plane.PGEmpty
public typealias PGRectangle = PG.Plane.PGRectangle
public typealias PGAddRectangle = PG.Plane.PGAddRectangle
public typealias PGSubRectangle = PG.Plane.PGSubRectangle
public typealias PGTriangle = PG.Plane.PGTriangle
public typealias PGAddTriangle = PG.Plane.PGAddTriangle
public typealias PGSubTriangle = PG.Plane.PGSubTriangle
public typealias PGCircle = PG.Plane.PGCircle
public typealias PGAddCircle = PG.Plane.PGAddCircle
public typealias PGSubCircle = PG.Plane.PGSubCircle
public typealias PGBlurryCircle = PG.Plane.PGBlurryCircle
public typealias PGAddBlurryCircle = PG.Plane.PGAddBlurryCircle
public typealias PGSubBlurryCircle = PG.Plane.PGSubBlurryCircle
public typealias PGPicture = PG.Plane.PGPicture
public typealias PGAddPicture = PG.Plane.PGAddPicture
public typealias PGSubPicture = PG.Plane.PGSubPicture
public typealias PGMask = PG.Plane.PGMask
public typealias PGAddMask = PG.Plane.PGAddMask
public typealias PGSubMask = PG.Plane.PGSubMask

public typealias BBStorage = PG.Billboard.BBStorage
public typealias BBPool = PG.Billboard.BBPool
public typealias BBActor = PG.Billboard.BBActor
public typealias BBEmpty = PG.Billboard.BBEmpty
public typealias BBRectangle = PG.Billboard.BBRectangle
public typealias BBAddRectangle = PG.Billboard.BBAddRectangle
public typealias BBSubRectangle = PG.Billboard.BBSubRectangle
public typealias BBTriangle = PG.Billboard.BBTriangle
public typealias BBAddTriangle = PG.Billboard.BBAddTriangle
public typealias BBSubTriangle = PG.Billboard.BBSubTriangle
public typealias BBCircle = PG.Billboard.BBCircle
public typealias BBAddCircle = PG.Billboard.BBAddCircle
public typealias BBSubCircle = PG.Billboard.BBSubCircle
public typealias BBBlurryCircle = PG.Billboard.BBBlurryCircle
public typealias BBAddBlurryCircle = PG.Billboard.BBAddBlurryCircle
public typealias BBSubBlurryCircle = PG.Billboard.BBSubBlurryCircle
public typealias BBPicture = PG.Billboard.BBPicture
public typealias BBAddPicture = PG.Billboard.BBAddPicture
public typealias BBSubPicture = PG.Billboard.BBSubPicture
public typealias BBMask = PG.Billboard.BBMask
public typealias BBAddMask = PG.Billboard.BBAddMask
public typealias BBSubMask = PG.Billboard.BBSubMask

public typealias ModelStorage = PG.Model.ModelStorage
public typealias MDObj = PG.Model.MDObj
public typealias MDSphere = PG.Model.MDSphere

