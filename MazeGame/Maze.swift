//
//  Maze.swift
//  MazeGame
//
//  Created by Josh Ryan on 4/13/18.
//  Copyright © 2018 Bootleg Mobile. All rights reserved.
//

import UIKit
import QuartzCore
import SceneKit
import SpriteKit

let testMaze = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                [1,0,0,0,0,0,0,0,0,0,0,1,0,0,0,1],
                [1,0,1,1,1,1,1,1,0,1,0,1,0,1,0,1],
                [1,0,1,0,0,0,1,0,0,1,0,0,0,1,0,1],
                [1,0,1,0,1,0,1,0,1,1,1,1,1,1,0,1],
                [1,0,0,0,1,0,1,0,0,0,0,0,0,1,0,1],
                [1,1,1,1,1,0,1,1,1,1,1,1,0,1,0,1],
                [0,0,1,0,0,0,0,0,0,0,1,0,0,1,0,1],
                [1,0,1,1,1,1,1,1,1,0,1,0,0,0,0,1],
                [1,0,1,0,0,0,0,0,1,0,1,0,1,1,0,1],
                [1,0,1,0,1,1,1,0,1,0,1,0,1,1,0,1],
                [1,0,0,0,1,0,1,0,1,1,1,0,1,1,0,1],
                [1,1,1,1,1,0,1,0,1,1,1,0,1,1,0,1],
                [1,0,0,0,0,0,1,0,0,0,1,0,0,1,0,1],
                [1,0,1,1,1,1,1,1,1,0,1,1,0,1,0,1],
                [1,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0],
                [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]

//         8x8 array with walls
let mazeTemplate = [[1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1],
                [1,0,1,0,1,0,1,0,1,0,1,0,1,0,1,0,1],
                [1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1]]

//        8x8 array
let gridTemplate = [0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0,
                    0,0,0,0,0,0,0,0]

class Maze {
    
//    init wall/materials
    let materialRed = SCNMaterial()                 //set red material
    let materialCyan = SCNMaterial()                //set cyan material
    var walls = SCNNode()
    
    var mazeLocations: [Int] = []
    var randMaze: [[Int]] = [[]]
//    destination coordinates
    var destCoords: [Float] = []
    
    init(){
        materialRed.diffuse.contents = UIColor.red
        //        8x8 array
        mazeLocations = gridTemplate
        
        //        Load maze template
        randMaze = mazeTemplate
        
//        z coordinates
        destCoords.append(15.0)
        let chance = Int(arc4random_uniform(UInt32(10)))
        if chance > 5 {
            destCoords.append(1.0)
        }
        else {
            destCoords.append(15.0)
        }
    }
    
    func generateMaze() {
        print("Generating Maze")
        //        https://en.wikipedia.org/wiki/Maze_generation_algorithm
        
        
        let mazeSize = mazeLocations.count
        var currentPos = 0
        var newPos = 0
        
        //        random starting position, change int to UInt32 for compatibility
        let startingPos = Int(arc4random_uniform(UInt32(mazeSize)))
        currentPos = startingPos
        mazeLocations[startingPos] = 1

        while mazeLocations.contains(0) {
            var neighbors = [Int]()
            var neighborPos = 0
            
            
            //            Test for neighbors
            
            //            Left neighbor
            neighborPos = currentPos % 8
            if (neighborPos - 1) >= 0{
                neighborPos = currentPos-1
                if mazeLocations[neighborPos] == 0 {
                    neighbors.append(neighborPos)
                }
                else {
                    let visitChance = Int(arc4random_uniform(UInt32(100)))
                    if visitChance < 50 {
                        neighbors.append(neighborPos)
                    }
                }
                
            }
            
            //            Right neighbor
            neighborPos = currentPos % 8
            if (neighborPos + 1) != 8{
                neighborPos = currentPos+1
                if mazeLocations[neighborPos] == 0 {
                    neighbors.append(neighborPos)
                }
                else {
                    let visitChance = Int(arc4random_uniform(UInt32(100)))
                    if visitChance < 50 {
                        neighbors.append(neighborPos)
                    }
                }
            }
            
            //            Top neighbor
            neighborPos = currentPos-8
            if neighborPos >= 0{
                if mazeLocations[neighborPos] == 0 {
                    neighbors.append(neighborPos)
                }
                else {
                    let visitChance = Int(arc4random_uniform(UInt32(100)))
                    if visitChance < 50 {
                        neighbors.append(neighborPos)
                    }
                }
            }
            
            //            Bottom neighbor
            neighborPos = currentPos+8
            if neighborPos <= 63{
                if mazeLocations[neighborPos] == 0 {
                    neighbors.append(neighborPos)
                }
                else {
                    let visitChance = Int(arc4random_uniform(UInt32(100)))
                    if visitChance < 50 {
                        neighbors.append(neighborPos)
                    }
                }
            }
            
            if neighbors.count > 0 {
                let randNeighbor = Int(arc4random_uniform(UInt32(neighbors.count-1)))
                
                mazeLocations[neighbors[randNeighbor]] = 1
                newPos = neighbors[randNeighbor]
                
            }
            else {
                
                newPos = 0
                
                while newPos == 0 {
                    let tempPos = Int(arc4random_uniform(UInt32(mazeSize)))
                    print (mazeLocations)
                    if mazeLocations[tempPos] == 0 {
                        newPos = tempPos
                        mazeLocations[newPos] = 1
                        currentPos = newPos
                    }
                }
            }
            
            if abs(currentPos-newPos) == 1 {
                var col = currentPos % 8
                var row = ((currentPos-col) / 8) + 1
                
                col = (((col+1)*2) - 1) + (newPos-currentPos)
                row = (row*2) - 1
                
                
                randMaze[row][col] = 0
            }
            else if abs(currentPos-newPos) == 8{
                var col = currentPos % 8
                var row = ((currentPos-col) / 8) + 1
                
                let newCol = newPos % 8
                let newRow = ((newPos-newCol)/8) + 1
                
                col = ((col+1)*2) - 1
                row = ((row*2) - 1) + (newRow - row)
                
                randMaze[row][col] = 0
            }
            currentPos = newPos
        }
        print("Generated Maze")
    }
    
//    func unloadMaze(){
//        print(wall.count)
//        let cont = wall.count
//        var i = 0
//        while(i<cont){
//            wall[i].removeFromParentNode()
//            i=i+1;
//        }
//        wall.removeAll()
//        print(wall.count)
//    }
    
    func loadMaze(maze: [[Int]]) {
        print("loading Maze")
        let wallGeometry = SCNBox(width: 5, height: 8, length: 5, chamferRadius: 0)
        wallGeometry.materials = [materialRed]
        
        var xpos = 0.0
        var zpos = 0.0
        var ypos = 4
        var i = 0
        var xcont = -1
        
        walls = SCNNode(geometry: wallGeometry)
        
        while(i < maze.count){
            for item in maze[i]{
                switch (item){
                case 0:
                    xpos=xpos+5
                case 1:
                    if (xcont == (-1)) {
                        walls.position = SCNVector3(x: Float(xpos), y: Float(ypos), z: Float(zpos))
                        xcont += 1
                        xpos = xpos + 5;
                        ypos = 0
                    }
                    else {
                        walls.addChildNode(SCNNode(geometry: wallGeometry))
                        walls.childNodes[xcont].position = SCNVector3(x: Float(xpos), y: Float(ypos), z: Float(zpos))
                        xcont = xcont + 1;
                        xpos = xpos + 5;
                    }
                default:
                    print("this shouldn't happen")
                }
            }
            //print("Array",i)
            xpos = 0
            zpos = zpos+5
            i = i+1;
        }
        print("finished maze")
        print(randMaze)
    }
}













