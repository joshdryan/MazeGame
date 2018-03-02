//
//  GameViewController.swift
//  MazeGame
//
//  Created by Josh Ryan on 2/26/18.
//  Copyright © 2018 Bootleg Mobile. All rights reserved.
//

import UIKit
import SpriteKit
import GameplayKit
import SceneKit

class GameViewController: UIViewController {
    
    var gameView: SCNView!
    var gameScene:SCNScene!
    var cameraNode:SCNNode!
    
    var camX:Float = 0
    var camY:Float = 5
    var camZ:Float = 10
    
    var targetCreationTime:TimeInterval = 0
    
    func initView(){
        gameView = self.view as! SCNView
        gameView.allowsCameraControl = true
        gameView.autoenablesDefaultLighting = true
        gameView.showsStatistics = true
    }
    
    func initScene(){
        gameScene = SCNScene()
        gameView.scene = gameScene
        
        gameView.isPlaying = true
    }
    func initCamera(){
        cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        cameraNode.position = SCNVector3(x:camX, y:camY, z:camZ)
    }
    
    func createTarget(x: Float, y: Float, z: Float){
        let geometry:SCNGeometry = SCNPyramid(width: 1, height: 1, length: 1)
        
    
        geometry.materials.first?.diffuse.contents = UIColor.blue
        let geometryNode = SCNNode(geometry: geometry)
        gameScene.rootNode.addChildNode(geometryNode)
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initView()
        initScene()
        initCamera()
        
        var x:Float = 0
        var y:Float = 1
        var z:Float = 2
        
        createTarget(x:x, y:y, z:z)
    }
    
    override var shouldAutorotate: Bool {
        return true
    }

    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        if UIDevice.current.userInterfaceIdiom == .phone {
            return .allButUpsideDown
        } else {
            return .all
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Release any cached data, images, etc that aren't in use.
    }

    override var prefersStatusBarHidden: Bool {
        return true
    }
}
