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
    }

    create(){
        this.background = this.add.image(0, 0, "background");
        this.background.setOrigin(0,0);



        this.heros = this.add.sprite(100, 100, "hero");
        this.anims.create({
            key:"hero_up",
            frames:this.anims.generateFrameNumbers("hero"),
            frameRate:20,
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

}