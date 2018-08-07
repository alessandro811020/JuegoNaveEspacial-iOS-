//
//  GameScene.swift
//  juegoEspacial
//
//  Created by AlejandroMacEstudio on 10/05/2017.
//  Copyright © 2017 AlejandroMacEstudio. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    
    //declarar los tipos de colisiones
    enum Colisiones: UInt32{
        case Nave = 1
        case Espada = 2
        case Espacio = 4
    }
    
    //los nodos que son objetos dentro del juego, que llevan animación como colisiones y demás
    var nave = SKSpriteNode()
    var fondo = SKSpriteNode()
    var espada1 = SKSpriteNode()
    var espada2 = SKSpriteNode()
    
    //los campos referidos a la puntuación del juego
    var puntuacionLabel = SKLabelNode()
    var puntuacion = 0
    
    //variable Bool que hace referencia a si el juego está andando o no
    var gameOver = false
    
    //Labels del juego que brinda información sobre continuar el juego en caso de terminar
    var gameOverLabel = SKLabelNode()
    var gameOverLabel2 = SKLabelNode()
    var gameContinue = SKLabelNode()
    
    //temporizador
    var timer = Timer()
    
    //variable Bool que habla si se juega o no
    var play = false
    
    //campos referidos a las vidas del juego, donde se informaará y la variable que las va contando.
    var vidasLabel = SKLabelNode()
    var vidas = 3
    
    //método que cargará el juego y las características
    override func didMove(to view: SKView) {
        
        //para activar el delegate al haber contacto
        self.physicsWorld.contactDelegate = self
        
        //método que desarrolla el juego, los recursos y caracteristicas
        configuracionJuego()
        
    }
    
    //método que carga os nodos y objetos que se utilizan en el juego
    func configuracionJuego(){
        
        //VAMOS A CONFIGURAR EL FONDO DEL JUEGO
        //textura del fondo
        let texturaFondo = SKTexture(imageNamed: "fondo")
        //establecer el vector de movimiento de la imagen y el temporizador
        let animacionFondo1 = SKAction.move(by: CGVector(dx: -texturaFondo.size().width, dy: 0), duration: 7)
        let animacionFondo2 = SKAction.move(by: CGVector(dx: texturaFondo.size().width, dy: 0), duration: 0)
        //hacer la animación constante.
        let moverFondo = SKAction.repeatForever(SKAction.sequence([animacionFondo1, animacionFondo2]))
        
        //variable que se usará en el bucle while, dode repite lo siguiente constantemente
        var i: CGFloat = 0
        
        while i<3{
            //declaración de la textura al fondo
            fondo = SKSpriteNode(texture: texturaFondo)
            //ubicación de la imagen
            fondo.position = CGPoint(x: texturaFondo.size().width*i, y: self.frame.midY)
            //el tamaño del fondo, de la imagen de fondo al tamaño de la pantalla
            fondo.size.height = self.frame.height
            //animar el fondo
            fondo.run(moverFondo)
            //ponerlo dos unidades hacia abajo en el eje z
            fondo.zPosition = -2
            //agregarlo a la pantalla
            self.addChild(fondo)
            //restar 1 a i
            i+=1
        }
        
        //AÑADIMOS LA NAVE ESPACIAL
        //las tres texturas de la nave
        let naveTextura1 = SKTexture(imageNamed: "nave1")
        let naveTextura2 = SKTexture(imageNamed: "nave2")
        let naveTextura3 = SKTexture(imageNamed: "nave3")
        
        //hacer la animacion de la nave
        let animacion = SKAction.animate(with: [naveTextura1, naveTextura2, naveTextura3, naveTextura2, naveTextura1], timePerFrame: 0.3)
        //hacer constante la animación de la nave
        let movimientoNave = SKAction.repeatForever(animacion)
        
        //para establecer las coordenadas de la nave, primero la textura del nodo, luego las coordenadas del centro de la pantalla
        nave = SKSpriteNode(texture: naveTextura1)
        nave.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
        
        //asignarle la animación de movimiento a la nave
        nave.run(movimientoNave)
        //declarar el circulo de la nave como el cuerpo físico
        nave.physicsBody = SKPhysicsBody(circleOfRadius: naveTextura1.size().height/2)
        nave.physicsBody!.isDynamic = false
        //declarar las diferentes colisiones posibles de la nave
        nave.physicsBody!.collisionBitMask = Colisiones.Nave.rawValue
        nave.physicsBody!.contactTestBitMask = Colisiones.Espada.rawValue
        nave.physicsBody!.categoryBitMask = Colisiones.Nave.rawValue
        //agregar la nave a la pantalla
        self.addChild(nave)
        
        
        
        //AGREGAMOS UNA SUPERFICIE
        //primero la declaracion del nodo pra inicializarlo a la superficie
        let superficie = SKNode()
        //especificar la posición de la superficie y a la vez declararlo como cuerpo físico
        superficie.position = CGPoint(x: self.frame.midX, y: -self.frame.height/2)
        superficie.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: self.frame.width, height: 1))
        superficie.physicsBody?.isDynamic = false
        
        //las diferentes colisiones que puede hacer la superficie
        superficie.physicsBody!.collisionBitMask = Colisiones.Espada.rawValue
        superficie.physicsBody!.contactTestBitMask = Colisiones.Espada.rawValue
        superficie.physicsBody!.categoryBitMask = Colisiones.Espada.rawValue
        //agregarlo a la pantalla
        self.addChild(superficie)
        
        
        //AGREGAREMOS UNA BARRA DONDE COLOCAREMOS LA PUNTUACION Y LAS VIDAS DE LA NAVE
        //establecer las caracteristicas del rectangulo
        let barra = SKShapeNode(rectOf: CGSize(width: self.frame.width, height: 80))
        //rellenar el rectangulo con el color
        barra.fillColor = SKColor(colorLiteralRed: 28/255, green: 57/255, blue: 136/255, alpha: 1)
        //establecer la posicion de la barra dentro del eje z
        barra.zPosition = 2
        //posición de la barra dentro de la pantalla en las dos dimensiones
        barra.position = CGPoint(x: 0, y: (self.size.height/2)-40)
        //agregar la barra a la pantalla
        self.addChild(barra)
        
        
        //AGREGAMOS EL TEXTO PARA LA PUNTUACION
        //especificar el tipo de letra del texto a escribir
        puntuacionLabel.fontName = "Helvetica"
        //tamaño de la letra que se escribirá la puntuación
        puntuacionLabel.fontSize = 60
        //imprimir la puntuación
        puntuacionLabel.text = "\(puntuacion)"
        //especificar la posicion de la puntuación, y queremos colocarla encima de la barra creada en la parte superior de la pantalla
        puntuacionLabel.position = CGPoint(x: (-self.size.width/2)+40, y: (self.size.height/2)-60)
        //posición en el eje z
        puntuacionLabel.zPosition = 3
        //color del texto
        puntuacionLabel.color = SKColor(colorLiteralRed: 179/255, green: 180/255, blue: 182/255, alpha: 1)
        //agregar la etiqueta de la puntuación en la barra
        self.addChild(puntuacionLabel)
        
        
        //AGREGAMOS EL TEXTO DE LAS VIDAS DENTRO DE JUEGO
        //aclarar el tipo de letra del Label
        vidasLabel.fontName = "Helvetica"
        //especificar el tamaño del texto
        vidasLabel.fontSize = 60
        //especificar la variable que plantea la cantidad de vidas dentro del juego
        vidasLabel.text = "\(vidas)"
        //especificar la posicion del texto donde expresará la cantidad de vidas que se tiene
        vidasLabel.position = CGPoint(x: (self.size.width/2)-40, y: (self.size.height/2)-60)
        //posición dentro del eje z
        vidasLabel.zPosition = 3
        //posición del label dentro de la pantalla, que estara dentro del abarra superior.
        vidasLabel.color = SKColor(colorLiteralRed: 179/255, green: 180/255, blue: 182/255, alpha: 1)
        //agregarlo a la pantalla
        self.addChild(vidasLabel)

        //AGREGAMOS SIMBOLO DE LAS VIDAS EN LA BARRA
        //crear la textura de la nave para las vidas dentro de la barra
        let naveVidasTextura = SKTexture(imageNamed: "navevidas")
        //crear el nodo de la nave con la textura de la nave
        let naveVidaNodo = SKSpriteNode(texture: naveVidasTextura)
        //posicionarlo dentro de la barra, a un costado de la labdel de las vidas
        naveVidaNodo.position = CGPoint(x: (self.size.width/2)-120, y: (self.size.height/2)-42)
        //posición dentro del eje z
        naveVidaNodo.zPosition = 3
        //agregarlo dentro de la pantalla
        self.addChild(naveVidaNodo)
    }
    
    //método donde se crean las espadas dentro del programa
    func crearEspadas(){
        //especificar el espacio entre las espadas
        let espacioIntermedio = nave.size.height*3
        //movimiento aleatorio de las espadas dentro del juego hacia arriba o abajo
        let movimiento = arc4random() % UInt32(self.frame.height/2)
        //llevar el movimiento dentro de las espadas
        let espadaFuera = CGFloat(movimiento)-self.frame.height/4
        //crear la animación de las espadas moviéndose hacia la izquierda
        let moverEspadas = SKAction.move(by: CGVector(dx: -2*self.frame.width, dy: 0), duration: TimeInterval(self.frame.width/100))
        
        //CREAMOS LA PRIMERA ESPADA
        //textura de la primera espada
        let espadaTextura1 = SKTexture(imageNamed: "espada1")
        //asignarle a la espada, la textura pertinente
        espada1 = SKSpriteNode(texture: espadaTextura1)
        //especificar la posición de la espada como nodo
        espada1.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + espadaTextura1.size().height/2 + espacioIntermedio/2 + espadaFuera)
        //asignarle la animación de movimiento de las espadas
        espada1.run(moverEspadas)
        //darle cuerpo físico a la espada, en forma de rectángulo y del tamaño de la espada
        espada1.physicsBody = SKPhysicsBody(rectangleOf: espada1.size)
        espada1.physicsBody!.isDynamic = false
        //declarar los tipos de colisiones que tendrá la espada
        espada1.physicsBody!.collisionBitMask = Colisiones.Espada.rawValue
        espada1.physicsBody!.contactTestBitMask = Colisiones.Espada.rawValue
        espada1.physicsBody!.categoryBitMask = Colisiones.Espada.rawValue
        //especificar la posicion en el eje Z
        espada1.zPosition = -1
        //agregar el nodo a la pantalla
        self.addChild(espada1)
        
        
        //CREAMOS LA SEGUNDA ESPADA
        //crear la textura de la segunda espada
        let espadaTextura2 = SKTexture(imageNamed: "espada2")
        //el segundo nodo se le asigna la textura creada.
        espada2 = SKSpriteNode(texture: espadaTextura2)
        //colocar la posicion de las segundas espadas
        espada2.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY - espadaTextura1.size().height/2 - espacioIntermedio/2 + espadaFuera)
        //asignarle el movimiento a la espada
        espada2.run(moverEspadas)
        //declarar la espada como cuerpo físico del tamaño de la espada
        espada2.physicsBody = SKPhysicsBody(rectangleOf: espada2.size)
        espada2.physicsBody!.isDynamic = false
        //declarar los tipos de colisiones que tendrá la espada
        espada2.physicsBody!.collisionBitMask = Colisiones.Espada.rawValue
        espada2.physicsBody!.contactTestBitMask = Colisiones.Espada.rawValue
        espada2.physicsBody!.categoryBitMask = Colisiones.Espada.rawValue
        //declarar la posición en el eje z
        espada2.zPosition = -1
        //agregar el nodo a la pantalla
        self.addChild(espada2)
        
        //EL ESPACIO ENTRE ESPADAS
        //crear el nodo del espacio entre las espadas
        let pasaje = SKNode()
        //especificar la posición de el espacio entre las espadas.
        pasaje.position = CGPoint(x: self.frame.midX + self.frame.width, y: self.frame.midY + espadaFuera)
        //declarar el espacio comofísico porque es necesario para sabr que la nave lo atraviesa.
        pasaje.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: espadaTextura1.size().width, height: espacioIntermedio))
        pasaje.physicsBody!.isDynamic = false
        //asignarle el movimiento al espacio entre las espadas
        pasaje.run(moverEspadas)
        //declarar los tipos de colisiones que tendrá el espacio dentro del juego
        pasaje.physicsBody?.collisionBitMask = Colisiones.Espacio.rawValue
        pasaje.physicsBody?.contactTestBitMask = Colisiones.Nave.rawValue
        pasaje.physicsBody?.categoryBitMask = Colisiones.Espacio.rawValue
        //agregar el nodo a la pantalla
        self.addChild(pasaje)
    }
    
    //método que refiere al juego cuando ya ha comenzado, lo que realiza cuando este ya ha sido cargado
    func didBegin(_ contact: SKPhysicsContact) {
        //el bucle condicional, si el juego no ha terminado que realice lo siguiente
        if !gameOver{
            //en caso de que colisione con el centro, el espacio central
            if contact.bodyA.categoryBitMask == Colisiones.Espacio.rawValue || contact.bodyB.categoryBitMask == Colisiones.Espacio.rawValue{
                //continuar el juego e ir sumando puntos y reflejarlo en el Label de puntuación
                puntuacion+=1
                puntuacionLabel.text = String(puntuacion)
                //si no colisionó
            }else{
                //al chocar la espada restamos la vida
                vidas-=1
                //en caso de hayamos llegado a no tener vidas declarar que se acaba el juego
                if vidas==0{
                    //tipo de letra del mensaje en el label
                    gameOverLabel.fontName = "Helvetica"
                    //tamaño del texto del cartel
                    gameOverLabel.fontSize = 50
                    //texto del cartel
                    gameOverLabel.text = "GAME OVER!"
                    //posicion del cartel
                    gameOverLabel.position = CGPoint(x: self.frame.midX, y: self.frame.midY)
                    //agregar el nodo a la pantalla
                    self.addChild(gameOverLabel)
                    //ipo de letra del segundo cartel
                    gameOverLabel2.fontName = "Helvetica"
                    //tamaño de la letra del Label
                    gameOverLabel2.fontSize = 50
                    //texto a mostrar en el Label
                    gameOverLabel2.text = "Click para volver a empezar"
                    //posicion del Label que se mostrará
                    gameOverLabel2.position = CGPoint(x: self.frame.midX, y: self.frame.midY-60)
                    //agregar el nodo a la pantalla
                    self.addChild(gameOverLabel2)
                    //si hay mas de cero entonces simplemente darle click para continuar
                }else{
                    //declarar el tipo de letra del mensaje
                    gameContinue.fontName = "Helvetica"
                    //tamaño de la letra
                    gameContinue.fontSize = 50
                    //mensaje que se ha de mostrar
                    gameContinue.text = "Click para Continuar"
                    //posición del mensaje que se mostrará para continuar
                    gameContinue.position = CGPoint(x: self.frame.midX, y: self.frame.midY-50)
                    //posicion del cartel en el eje z
                    gameContinue.zPosition = 4
                    //agregar el nodo a la pantalla
                    self.addChild(gameContinue)
                }
                //al haber chocado con la espada detener la velocidad
                self.speed = 0
                //parar el juego
                gameOver = true
                //pausarlo
                play = false
                timer.invalidate()
                
            }
        }
    }
    //método que indica el inicio del juego, al darle click, según las situaciones, el inicio, sea al comenzar o ya comenzado el juego
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        //si no es false el fin del juego y la cantidad de vidas no es cero
        if !gameOver && vidas>0{
            //si no se ha pausado
            if !play{
                //cree tubos moviendose dentro de la pantalla
                timer = Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(GameScene.crearEspadas), userInfo: nil, repeats: true)
                play = true
            }
            //a la nave darle impulso por cada click, vaya subiendo
            nave.physicsBody?.velocity = CGVector(dx: 0, dy:0)
            nave.physicsBody?.applyImpulse(CGVector(dx: 0, dy: 170))
            nave.physicsBody?.isDynamic = true
            //en caso de que no sea mayor que o las vidas y el juego sea true el final gameOver
        }else{
            //si las vidas son cero, reiniciar la puntuacion y las vidas
            if vidas == 0{
                puntuacion = 0
                vidas = 3
            }
            //la velocidad reconfigurarla y reiniciar todo
            self.speed = 1
            gameOver = false
            self.removeAllChildren()
            configuracionJuego()
        }
    }
    
    override func updateFocusIfNeeded() {
        //Called before each frame is rendered
    }
}
    
    

