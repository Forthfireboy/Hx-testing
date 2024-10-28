import flixel.addons.display.FlxBackdrop;
import funkin.menus.ModSwitchMenu;
import funkin.editors.EditorPicker;
import flixel.text.FlxTextBorderStyle;
import funkin.options.OptionsMenu;
import openfl.ui.Mouse;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.tweens.FlxEase;
import flixel.tweens.FlxTween;
import flixel.util.FlxTimer;
import flixel.effects.FlxFlicker;
import hxvlc.flixel.FlxVideoSprite;


var codenameVersion = Application.current.meta.get('version');
var snow = new FlxVideoSprite(-100);
var optionShit:Array<String> = ["Freeplay","Option","credits"];// seperate the story mode cuz Idk how to make it behind the ground without broking the option item - Notbeep
var menuItems:FlxTypedGroup<FlxSprite> = new FlxTypedGroup();
var menuItem:FunkinSprite;
var stroy:FunkinSprite;

var camZoom:FlxTween;
var usingMouse:Bool = true;



var confirm:FlxSound;
var locked:FlxSound;
var cancel:FlxSound;
var hover:FlxSound;

var curSelected:Int = 0;

function create() {
    CoolUtil.playMenuSong();
    FlxG.mouse.visible = true;

    confirm = FlxG.sound.load(Paths.sound('menu/confirm'));
    cancel = FlxG.sound.load(Paths.sound('menu/cancel'));
    hover = FlxG.sound.load(Paths.sound('menu/scroll'));

    sky = new FlxSprite(-1100, -500).loadGraphic(Paths.image('menus/main/sky'));
    sky.antialiasing = Options.antialiasing;
    add(sky);
    sky.scale.set(0.5, 0.5);
    sky.scrollFactor.set(0, 0);

    planete = new FlxSprite(-400, -100).loadGraphic(Paths.image('menus/main/planete'));
    planete.antialiasing = Options.antialiasing;
    add(planete);
    planete.scale.set(0.35, 0.35);
    planete.scrollFactor.set(0.1, 0.1);

    buildingbehind = new FlxSprite(250, -300).loadGraphic(Paths.image('menus/main/buildingbehind'));
    buildingbehind.antialiasing = Options.antialiasing;
    add(buildingbehind);
    buildingbehind.scale.set(0.35, 0.35);
    buildingbehind.scrollFactor.set(0.3, 0.3);

    building = new FlxSprite(-200, -485).loadGraphic(Paths.image('menus/main/building'));
    building.antialiasing = Options.antialiasing;
    add(building);
    building.scale.set(0.35, 0.35);
    building.scrollFactor.set(0.5, 0.5);

    grille = new FlxSprite(490, -240).loadGraphic(Paths.image('menus/main/grille'));
    grille.antialiasing = Options.antialiasing;
    add(grille);
    grille.scale.set(0.35, 0.35);
    grille.scrollFactor.set(0.6, 0.6);

    buildingfront = new FlxSprite(150, -660).loadGraphic(Paths.image('menus/main/buildingfront'));
    buildingfront.antialiasing = Options.antialiasing;
    add(buildingfront);
    buildingfront.scale.set(0.35, 0.35);
    buildingfront.scrollFactor.set(0.7, 0.7);

    ground = new FlxSprite(-1400, 330).loadGraphic(Paths.image('menus/main/ground'));
    ground.antialiasing = Options.antialiasing;
    add(ground);
    ground.scale.set(0.33, 0.33);

    lantern = new FlxSprite(850, -340).loadGraphic(Paths.image('menus/main/lantern'));
    lantern.antialiasing = Options.antialiasing;
    add(lantern);
    lantern.scale.set(0.5, 0.5);

    stroy = new FunkinSprite(0, -100);
    stroy.frames = Paths.getSparrowAtlas('menus/main/menuButtons');
    stroy.animation.addByPrefix('idle', 'StorymodeButton', 8, true);
    stroy.animation.addByPrefix('hover', 'StorymodeSelect', 8, true);
    stroy.scale.set(0.4,0.4);
    stroy.scrollFactor.set(0.35, 0.35);
    insert(members.indexOf(ground), stroy);

    for (i in 0...optionShit.length) {
        menuItem = new FunkinSprite(0, 0);
        menuItem.frames = Paths.getSparrowAtlas('menus/main/menuButtons');
        menuItem.animation.addByPrefix('idle', optionShit[i] + 'Button', 8, true);
        menuItem.animation.addByPrefix('hover', optionShit[i] + 'Select', 8, true);
        menuItem.ID = i;
        menuItems.add(menuItem);
        menuItem.scale.set(0.4, 0.4);
        menuItem.antialiasing = true;

        switch(optionShit[i]) {
            case "Freeplay":
                menuItem.setPosition(780, 300);
                menuItem.updateHitbox();
            case "Option":
                menuItem.setPosition(400, 450);
                menuItem.scale.set(0.35, 0.35);
                menuItem.updateHitbox();
            case "credits":
                menuItem.setPosition(550, -180);
                menuItem.blend = 0;
                menuItem.scale.set(0.45, 0.45);
        }
    }

    add(menuItems);
	overlay2 = new FlxSprite(-450, -450).loadGraphic(Paths.image('menus/main/overlay2'));
    overlay2.blend = 0;
    overlay2.antialiasing = Options.antialiasing;
    add(overlay2);
	overlay2.scale.set(0.3, 0.3);
	overlay2.scrollFactor.set(0.4, 0.4);
	overlay2.alpha = 0.5;

	star = new FlxSprite(-250, -300).loadGraphic(Paths.image('menus/main/star'));
    star.blend = 0;
    star.antialiasing = Options.antialiasing;
    add(star);
	star.scale.set(0.3, 0.3);
	star.scrollFactor.set(0.5, 0.5);
	star.alpha = 0.3;


    tabText = new FunkinText(1055, FlxG.height, 0, 'Open the Mods Menu [TAB]');
    tabText.y -= tabText.height + 50;
    add(tabText);

    versionShit = new FunkinText(1040, FlxG.height, 0, 'Codename Engine - v.' + codenameVersion);
    versionShit.y -= versionShit.height + 70;
    add(versionShit);

    dronesVersion = new FunkinText(1055, FlxG.height, 0, 'Funkin-Drones - Release');
    dronesVersion.y -= dronesVersion.height + 90;
    add(dronesVersion);

    hint = new FunkinText(5, FlxG.height +80, 400, "Hint: Hitboxes aren’t perfect. Press F for Freeplay, C for Credits, O for Options.");
    hint.y -= hint.height + 90;
    add(hint);
    hint.scrollFactor.set(1.1, 1.1);

    gradient = new FlxSprite(-100, -100).loadGraphic(Paths.image('menus/main/overlay'));
    gradient.blend = 0;
    gradient.antialiasing = Options.antialiasing;
    add(gradient);
    gradient.alpha = 0.05;

	 

    snow.bitmap.onFormatSetup.add(function()
    {
        snow.blend = 0;
        snow.scale.set(1, 1);
        snow.alpha = 0.5;
    });
    snow.load(Assets.getPath(Paths.video("snow")), [':input-repeat=65535', ':no-audio']);
    add(snow);
    snow.play();
    

	 darkoverlay = new FlxSprite(00, 0).loadGraphic(Paths.image('menus/main/darkoverlay'));
	darkoverlay.scrollFactor.set(0.1, 0.1);
	darkoverlay.scale.set(1.05, 1.05);
    darkoverlay.antialiasing = Options.antialiasing;
    add(darkoverlay);
    darkoverlay.alpha = 0.2;
	darkoverlay.blend = 1;

    updateItems();
}

var selectedSomethin:Bool = false;
function update(elapsed) {

         if (FlxG.keys.justPressed.C)
            {
                FlxG.switchState(new ModState("FD/CreditsScreen"));
                
            }

             if (FlxG.keys.justPressed.F)
            {
                FlxG.switchState(new ModState("FD/FreeplayCustomState"));
                
            }

            if (FlxG.keys.justPressed.O)
            {
                 FlxG.switchState(new OptionsMenu());
                
            }
            if (FlxG.keys.justPressed.E)
            {
                  FlxG.switchState(new ModState("FD/EndSongs"));
                
            }

            if (FlxG.keys.justPressed.S)
            { PlayState.loadSong("clinic sorrow", "hard");
                    trace("Loading Clinic Chill");
                    PlayState.chartingMode = false;
                    FlxG.switchState(new PlayState());}
                    PlayState.isStoryMode = true;
        
        

    FlxG.sound.music.volume = 0.5;

    if (FlxG.keys.justPressed.SEVEN) {
        persistentUpdate = !(persistentDraw = true);
        openSubState(new EditorPicker());
    }

    if (controls.SWITCHMOD) {
        openSubState(new ModSwitchMenu());
        persistentUpdate = !(persistentDraw = true);
    }

    if (controls.BACK || FlxG.mouse.justPressedRight) {
        cancel.play();

        FlxTween.tween(FlxG.camera, {zoom: 1.2}, 2, {ease: FlxEase.expoOut});

        FlxG.camera.fade(FlxColor.BLACK, 0.5, false);
        new FlxTimer().start(.75, function(tmr:FlxTimer) {
            FlxG.switchState(new TitleState());
        });
    }

    if (FlxG.mouse.justMoved) {
        usingMouse = true;
    }

    if (!selectedSomethin) {
        if (usingMouse) {
            for (i in menuItems.members) {
                if (FlxG.mouse.overlaps(i)) {

                    curSelected = menuItems.members.indexOf(i);
                    updateItems();

                    if (FlxG.mouse.justPressed) {
                        selectItem();
                    }        
                } else {
                    i.animation.play("idle", true);
                }
            }
            if (FlxG.mouse.overlaps(stroy)) {
                stroy.animation.play('hover');

                if (FlxG.mouse.justPressed) {
                    PlayState.loadSong("clinic sorrow", "hard");
                    trace("Loading Clinic Chill");
                    PlayState.isStoryMode = PlayState.chartingMode = false;
                    FlxG.switchState(new PlayState());
                }        
            } else {
                stroy.animation.play('idle');
            }
        }
    }

    FlxG.camera.scroll.x = FlxMath.lerp(FlxG.camera.scroll.x, (FlxG.mouse.screenX - (FlxG.width / 2)) * 0.02, 1);    
    FlxG.camera.scroll.y = FlxMath.lerp(FlxG.camera.scroll.y, (FlxG.mouse.screenY - (FlxG.height / 2)) * 0.02, 1);
}

function selectItem() {
    var option = optionShit[curSelected];
    selectedSomethin = true;
    confirm.play();

    if (Options.flashingMenu) { 
        FlxG.camera.fade(FlxColor.WHITE, 0.5, true);
    }

    FlxG.camera.zoom = 1.1;
    FlxTween.tween(FlxG.camera, {zoom: 1}, 2, {ease: FlxEase.expoOut});

    new FlxTimer().start(0.6, function(tmr:FlxTimer) {
        switchState();
    });
}

function updateItems() {
    menuItems.forEach(function(spr:FunkinSprite) {
        if (spr.ID == curSelected) {
            spr.animation.play('hover');
        }
    });
}

function switchState() {
    var daChoice:String = optionShit[curSelected];

    switch (daChoice) {
        case 'Freeplay':
            FlxG.switchState(new ModState('FD/FreeplayCustomState'));
        case 'Option':
            FlxG.switchState(new OptionsMenu());
        case 'credits':
                FlxG.switchState(new ModState("FD/CreditsScreen"));
    }
}

function changeSelection(change:Int = 0, force:Bool = false) {
    if (change == 0 && !force) return;

    hover.play();

    usingMouse = false;
    trace(curSelected);
    trace(change);

    curSelected = FlxMath.wrap(curSelected + change, 0, optionShit.length - 1);

    menuItems.forEach(function(spr:FunkinSprite) {
        if (spr.ID == curSelected && spr.ID != 3) {
            spr.animation.play('hover');
        } else {
            spr.animation.play('idle');
        }
    });
}