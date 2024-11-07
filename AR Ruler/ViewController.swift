
import UIKit
import SceneKit
import ARKit

class ViewController: UIViewController, ARSCNViewDelegate {

    var doteNodes = [SCNNode]()
    var textNode = SCNNode()
    
    @IBOutlet var sceneView: ARSCNView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints]
        // Set the view's delegate
        sceneView.delegate = self
 
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        // Create a session configuration
        let configuration = ARWorldTrackingConfiguration()

        // Run the view's session
        sceneView.session.run(configuration)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        
        // Pause the view's session
        sceneView.session.pause()
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
    {
        if doteNodes.count >= 2
        {
            for dot in doteNodes
            {
                dot.removeFromParentNode()
            }
            doteNodes = [SCNNode]()
        }
        
        if let touch = touches.first?.location(in: sceneView)
        {
            let results = sceneView.hitTest(touch, types:.featurePoint)
            
                if let hitresults = results.first
                {
                    addpoint(result: hitresults)
                }
            
        }
    }
    
   func addpoint(result: ARHitTestResult)
    {
        let sphere = SCNSphere(radius: 0.005)
        
        let Material = SCNMaterial()
        
        Material.diffuse.contents = UIColor(.red)
        
        sphere.materials = [Material]
        
        let dotNode = SCNNode(geometry: sphere)
        
        dotNode.position = SCNVector3(result.worldTransform.columns.3.x, result.worldTransform.columns.3.y, result.worldTransform.columns.3.z)
        
        sceneView.scene.rootNode.addChildNode(dotNode)
        
        doteNodes.append(dotNode)
        
        if doteNodes.count >= 2
        {
            calculate()
        }
       
        
    }
    
    func calculate()
    {
        let start = doteNodes[0]
        let end = doteNodes[1]
        
        print(start)
        print(end)
        
        let a = end.position.x - start.position.x
        let b = end.position.y - start.position.y
        let c = end.position.z - start.position.z
        
        let distance = sqrt(pow(a,2) + pow(b,2) + pow(c,2))
        
        updateText( text: "\(abs(distance))" , at: end.position)
    }

    func updateText(text: String, at Position: SCNVector3)
    {
        textNode.removeFromParentNode()
        
        let textGeometry = SCNText(string: text, extrusionDepth: 1.0)
        
        textGeometry.firstMaterial?.diffuse.contents = UIColor(.red)
        
        let textNode = SCNNode(geometry: textGeometry)
        
        textNode.position = SCNVector3(Position.x, Position.y, Position.z)
        
        textNode.scale = SCNVector3(0.01, 0.01, 0.01)
        
        sceneView.scene.rootNode.addChildNode(textNode)
    }
 
}
