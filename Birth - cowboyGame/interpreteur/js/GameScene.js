
class GameScene extends Phaser.Scene{
    constructor() {
        super("GameScene");
    }

    init(){
        this.path = "js/assets/";
        this.inputKeyboard  = this.input.keyboard.createCursorKeys();
        
    }

    preload(){
        this.load.image("background", this.path + "1.jpeg");
        this.load.spritesheet("hero", this.path + "atlas_hero.png", {
            frameWidth:32,
            frameHeight:32
        });
        this.loadObjects();
    }

    create(){
        this.background = this.add.image(0, 0, "background");
        this.background.setOrigin(0,0);



        this.heros = this.add.sprite(100, 100, "hero");
        this.heros.setDisplaySize(100, 100);
        this.anims.create({
            key:"hero_up",
            frames:this.anims.generateFrameNumbers("hero"),
            frameRate:15,
            repeat:-1
        });

        this.heros.play("hero_up");

    }

    update() {

        const vitesse = 3;
        if(this.inputKeyboard.left.isDown) {
            this.heros.x -=vitesse;
        }
        if(this.inputKeyboard.right.isDown) {
            this.heros.x +=vitesse;
        }
        if(this.inputKeyboard.up.isDown) {
            this.heros.y -=vitesse;
        }
        if(this.inputKeyboard.down.isDown) {
            this.heros.y +=vitesse;
        }
    }

    loadObjects() {
      let rawFile = "" ;

      fetch('js/Map/map/objects.objt')
            .then(response => response.text())
            .then((data) => {

                rawFile = data;
                //  console.log(rawFile);

                this.objectArray = new Array();
                var nbLigne = 0;
                let char=rawFile.charAt(0);
                let posCursor = 0;
                let nb = 0;
                while(char !=""){
                  if(char === "[") {
                      var ligne = rawFile.slice(posCursor+1, rawFile.indexOf("]", posCursor));
                      //console.log(ligne);
                      let texture = ligne.slice(0, ligne.indexOf("|"));
                      let id = ligne.slice(ligne.indexOf("|")+1, ligne.indexOf("%"));
                      let x = parseFloat(ligne.slice(ligne.indexOf("%")+1, ligne.indexOf("$")));
                      let y = parseFloat(ligne.slice(ligne.indexOf("$")+1));
                      this.objectArray[nb] = new pObjets (x, y, id, texture);
                      console.log(this.objectArray[nb]);
                      posCursor = rawFile.indexOf("[", rawFile.indexOf("]", posCursor));
                      char = rawFile.charAt(posCursor);
                  }
                  nb++;
                }
                console.log("Objets Chargés !")
      });
    }





}

//constructeur objets Objets
function pObjets (x, y, id, texture) {
  this.x = x;
  this.y = y;
  this.id = id;
  this.texture = texture;
}
