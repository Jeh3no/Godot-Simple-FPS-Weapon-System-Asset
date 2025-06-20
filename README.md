### Important precision about the asset licence in the Credits section, please read it if you want/plan to make a commercial game/project with it !!


# Godot Simple FPS Weapon System Asset


 A simple yet complete FPS weapon system asset for Godot 4

 ![Asset logo](https://github.com/Jeh3no/Godot-Simple-FPS-Weapon-System-Asset/blob/main/addons/Arts/Images/Image5.png)

 
 # **General**

 
This asset provides a simple, fully commented, weapon system for FPS games.

A test map with a shooting range as well as a character controller are provided (the character controller is another asset i made some mounths ago : https://github.com/Jeh3no/Godot-Simple-State-Machine-First-Person-Controller)

The weapon system is resource based, designed to easely customize weapons.

The weapons are monitored by a weapon manager, designed to easely add/remove weapons to the game.

Each component of the weapon (shoot, reload, animation, ammunition) has his own script, neatly arranged in separate compartments.

The asset is 100% written in GDScript.

Of course, the code has been written in a way to be easely understandable and modifiable/editable, and he's as well fully commented.

He works perfectly on Godot 4.4, and should also works wells on the others 4.x versions (4.3, 4.2, 4.1, 4.0), but you will have to remove the uid files.

The video showcasing the asset features : https://youtu.be/B4cASUFbamU 

A precision about the showcase video : the doom-like sprites, and all the weapon sounds you heard in the video are not in the asset files, because they are under proprietary license.

### You can see this asset as some sort of demo, for a possible, much bigger (and better) asset, which will be may more advanced, and will have a ton of new features 


# **Features**

- Resource based weapons

- Weapon switching

- Weapon shooting

- Weapon reloading

- Weapon bobbing

- Weapon tilting

- Weapon swaying

- Hitscan and projectile types 

- Physics behaviour for both hitscan and projectile


- Shared ammo between weapons

- Ammo refilling


- Camera procedural recoil

- Camera bobbing

- Camera tilting


- Muzzle flash

- Bullet hole/decal


- Test map, with shooting range

- State machine based character controller (https://github.com/Jeh3no/Godot-Simple-State-Machine-First-Person-Controller)


# **Purpose**


I simply wanted to make it, and share it with the community.

Plus, it can be considered as some kind of demo for a possible big, really big asset.


# **How to use**


- It's an asset, which means you can add it to an existing project without any issue.

Simply download it, add it to your project, get the files you want to use.

- But you can also use it as a starter template if you want to.

If that's the case, you can simply drag and drop the folders under the "addon" one in a freshly created project.


You will need to create a input action in your project for each action, and then type the exact same name into the corresponding input action variable

(for example : name your move forward action "moveForward", and then type "moveForward" into the variable "moveForwardAction")


### How to create and add a new weapon to the weapon manager :
!  There is already 5 differents weapon examples in the asset, each of them representing a different type of weapon (pistol, assault rifle, shotgun, sniper rifle, rocket launcher), you can use them as examples, and/or to speed up the creation process.

- Create a new Node3D node, and add it to the "weapon container" node.
  
- Place your weapon model as a child of the Node3D node.
  
- Add a Marker3D node as a child of the weapon model, it will be the weapon attack point.
  
- Add a "WeaponSlotScript" script to the Node3D node, and assign the model (Node3D node) and attack point (Marker3D node) variables, as well as the weapon id variable.
  
- Create a new resource for your weapon, using the "WeaponResource" class reference.
  
- Fill the resource the way you want (the only mandatory variables are ("WeaponName", "WeaponId", a type (Hitscan or projectile), "Position"))
  
  ! The weapon id from the weapon resource and the weapon id from the weapon slot must be the same, otherwise it won't work !

- In the "WeaponManager" node, from the editor, add the weapon resources you want the game to load at the start of the scene, in the "Weapon Resources" variable.
  
- Then, add the weapons you want the player character to have at the start of the game, in the "Start weapons" variable.

  ! The order in which you place the weapon resources and start weapons doesn't matter, you just need to be sure that the weapon id is the same !

  ! You need to have at least one start weapon saved in the "Start weapons" variable, it can be a empty node with only the mandatory resource variables assigned, but you need at least one !

- If you have done everything correctly, your weapon should be usable and work in game !

! About the display of damage number, there are some tremendous errors with it, that i don't understand, and i didn't manage to resolve it, so i've put an option to disable it, so that you don't see theses errors (which don't affect gameplay  in any way, i might add, but i preferred to add an option to not trigger them).

  
# **Requets**


- For any bug request, please write on down in the "issues" section.

- For any new feature request, please write it down in the "discussions" section.

- For any bug resolution/improvement commit, please write it down in the "pull requests" section.


# **Credits**

Kenney Prototype Textures, made by Kenney, upload on the Godot asset library by Calinou : https://godotengine.org/asset-library/asset/781

Weapons models and textures by Aligned Games : https://opengameart.org/content/polygonal-modern-weapons-collection-1-asset-package

### Important precision : 

The "polygonal-modern-weapons-collection-1-asset-package" asset is licenced under GPL 3.0 and CC-BY-SA 3.0 licences, which mean that i have to licence the "Simple FPS weapon system" asset under the same licences.

If you want to get rid of theses licences once you have the "Simple FPS weapon system" asset (and so be able to make a commercial game/project with it) you'll need to geet rid of all the content coming from the "polygonal-modern-weapons-collection-1-asset-package" asset.

Here's the folders where the content is located : 

-Weapons/Models

-Weapons/Textures

