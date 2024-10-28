import flixel.text.FlxTextBorderStyle;
import flixel.addons.display.FlxBackdrop;
import funkin.backend.MusicBeatState;
import flixel.util.FlxAxes;
import funkin.backend.utils.DiscordUtil;

static var initialized:Bool = false;
var pressedEnter:Bool = false;
var transitioning:Bool = false;

var logoBl:FlxSprite;
var textGroup:FlxGroup;
var logoBl:FlxSprite;
var titleText:FlxSprite;

var glowyThing:FlxSprite;
var gradient:FlxSprite;
var tilesThing:FlxBackdrop;

var starBG:FlxBackdrop;
var starFG:FlxBackdrop;

var bf:FlxSprite;
var fart:FlxSprite;

var curWacky:Array<String> = [];

var steps = 0;
function create() {
	if(!initialized)
		CoolUtil.playMenuSong(true);
	
	FlxG.mouse.visible = false;

	textGroup = new FlxGroup();

    
	back = new FlxSprite(0,-300).loadGraphic(Paths.image('menus/title/background'));
    back.screenCenter(FlxAxes.X);
	back.antialiasing = Options.antialiasing;
	add(back);
    back.visible = true;
    back.scale.set(0.54, 0.54);


    tilesThing = new FlxBackdrop(Paths.image('menus/title/checker'));
    tilesThing.antialiasing = Options.antialiasing;
    tilesThing.scrollFactor.set(0,0);
    tilesThing.velocity.set(100,100);
    tilesThing.alpha = 0.15;
    tilesThing.scale.set(0.7, 0.7);
    tilesThing.updateHitbox(); 
    add(tilesThing);

	logoBl = new FlxSprite(0,-870).loadGraphic(Paths.image('menus/title/logo'));
	add(logoBl);
	logoBl.visible = true;
	logoBl.screenCenter(FlxAxes.X);
	logoBl.antialiasing = true;
    logoBl.scale.set(0.6, 0.6);
    logoBl.blend = 0;


	titleText = new FlxSprite(100, 576);
	titleText.frames = Paths.getSparrowAtlas('menus/titlescreen/titleEnter');
	titleText.animation.addByPrefix('idle', "Press Enter to Begin", 24);
	titleText.animation.addByPrefix('press', "ENTER PRESSED", 24);
	titleText.antialiasing = true;
	titleText.animation.play('idle');
	titleText.updateHitbox();
	//add(titleText);

     gf = new FlxSprite(1400,170).loadGraphic(Paths.image('menus/title/GF'));
    add(gf);
    gf.scale.set(0.6, 0.6);
      n = new FlxSprite(-1000,170).loadGraphic(Paths.image('menus/title/N'));
    add(n);
    n.scale.set(0.6, 0.6);

    bf = new FlxSprite(1200,-100).loadGraphic(Paths.image('menus/title/BF'));
    add(bf);
    bf.scale.set(0.6, 0.6);

   


    uzi = new FlxSprite(-700,-100).loadGraphic(Paths.image('menus/title/Uzi'));
    add(uzi);
    uzi.scale.set(0.6, 0.6);

    

    var stupidArray:Array<String> = CoolUtil.coolTextFile(Paths.txt('title/introText'));
	if (stupidArray.contains('')) stupidArray.remove('');
	curWacky = stupidArray[FlxG.random.int(0, stupidArray.length-1)].split('--');

    if (initialized){
        skipIntro();
    }else{
        initialized = true;
    }

	add(textGroup);


    splash = new FlxSprite(0,500).loadGraphic(Paths.image('menus/title/splash'));
    splash.screenCenter(FlxAxes.X);
	splash.antialiasing = Options.antialiasing;
	add(splash);

    splash.visible = true;
    splash.scale.set(0.54, 0.54);
}

function postCreate() {
    addVirtualPad('NONE', 'A');
	addVirtualPadCamera();
}

function stepHit(curStep) {
    steps = curStep;
} 

function update(elapsed:Float) {
	if (controls.ACCEPT && !skippedIntro) skipIntro();
	else if (controls.ACCEPT && skippedIntro && !pressedEnter){
        if (Options.flashingMenu)
            FlxG.camera.flash(FlxColor.WHITE, 1);

		pressedEnter = transitioning = true;

        titleText.animation.play('press');
		CoolUtil.playMenuSFX(1);

        FlxTween.tween(logoBl, {y: logoBl.y + 800}, 1, {ease: FlxEase.expoIn, startDelay: 0.8});
        FlxTween.tween(titleText, {y: titleText.y + 800}, 1, {ease: FlxEase.expoIn, startDelay: 0.2});
        FlxTween.tween(bf, {y: bf.y + 800}, 1, {ease: FlxEase.expoIn, startDelay: 0.4});
        FlxTween.tween(gf, {y: gf.y + 800}, 1, {ease: FlxEase.expoIn, startDelay: 0.65});
        FlxTween.tween(n, {y: n.y + 800}, 1, {ease: FlxEase.expoIn, startDelay: 0.6});
        FlxTween.tween(uzi, {y: uzi.y + 800}, 1, {ease: FlxEase.expoIn, startDelay: 0.45});

		new FlxTimer().start(2, function() {
			FlxG.switchState(new MainMenuState());
		});
	} else if (controls.ACCEPT && transitioning){
		FlxG.camera.stopFX();
		FlxG.switchState(new MainMenuState());
	}


}

function goToMainMenu() {
    FlxG.switchState(new MainMenuState());
}

function createCoolText(textArray:Array<String>) {
	for (i => text in textArray) {
		if (text == "" || text == null) continue;
        var money:Alphabet = new Alphabet(0, (i * 60) + 200, text, true, false);
        money.screenCenter(FlxAxes.X);
        textGroup.add(money);
	}
}

function addMoreText(text:String) {
    var coolText:Alphabet = new Alphabet(0, (textGroup.length * 60) + 200, text, true, false);
    coolText.screenCenter(FlxAxes.X);
    textGroup.add(coolText);
}

function deleteCoolText() {
	while (textGroup.members.length > 0) {
		textGroup.members[0].destroy();
		textGroup.remove(textGroup.members[0], true);
	}
}

function beatHit(curBeat:Int) {
	FlxTween.tween(FlxG.camera, {zoom: 1.02}, 1, {ease: FlxEase.expoOut, type: FlxTween.BACKWARD});

	if(skippedIntro) return;
	switch (curBeat)
	{
        case 1:		createCoolText(['The sky is']);
        case 3:		addMoreText('falling down');
        case 4:		deleteCoolText();
        case 5:		createCoolText(['Wipe them out']);
        case 6:		addMoreText(['All of them']);
        case 7:		
        case 8:		deleteCoolText();
        case 9:		createCoolText(['Blood in the air']);
        case 11:	addMoreText(['Drones everywhere']);
        case 12:	deleteCoolText();
        case 13:	addMoreText(['Murder Drones']);
        case 14:	addMoreText(['On the hunt']);
        case 15:	
            addMoreText('For revenge');
            FlxTween.tween(FlxG.camera, {zoom: 0.9}, 0.5, {ease: FlxEase.expoOut, type: FlxTween.BACKWARD});
        case 16:	
            skipIntro();
            FlxTween.tween(FlxG.camera, {zoom: 0.4}, 0.5, {ease: FlxEase.expoOut, type: FlxTween.BACKWARD});
	}
}


var skippedIntro:Bool = false;

function skipIntro() {
	if (!skippedIntro) {
        FlxG.camera.flash(FlxColor.WHITE, 1);
        remove(textGroup);
        add(titleText);
        FlxTween.tween(bf, {x: bf.x - 460}, 2, {ease: FlxEase.expoOut});
        FlxTween.tween(gf, {x: gf.x - 940}, 2, {ease: FlxEase.expoOut});
         FlxTween.tween(n, {x: n.x + 1050}, 2, {ease: FlxEase.expoOut});
        FlxTween.tween(uzi, {x: uzi.x + 550}, 2, {ease: FlxEase.expoOut});
        FlxTween.tween(logoBl, {y: logoBl.y + 800}, 2, {ease: FlxEase.expoOut});
        skippedIntro = true;
        back.visible = true;
        gradient.visible = true;
        glowyThing.visible = true;
    }
}
