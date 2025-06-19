### Important precision about the asset licence, please read it if you want/plan to make a commercial game/project with it !!


# Godot Simple FPS Weapon System Asset


 A simple yet complete FPS weapon system for Godot 4.4


 # **General**


This asset provides a simple, fully commented, weapon system for FPS games.

A test map as well as a character controller are provided (the character controller is another asset i made some mounths ago : https://github.com/Jeh3no/Godot-Simple-State-Machine-First-Person-Controller)

The controller use a finite state machine, designed to be easely editable, allowing to easily add, remove and modify behaviours and actions.

Each state has his own script, allowing to easly filter and manage the communication between each state.

He is also very customizable, with a whole set of open variables for every state and for more general stuff. This is the same for the camera.

The asset is 100% written in GDScript.

He works perfectly on Godot 4.4, and should also works wells on the others 4.x versions (4.3, 4.2, 4.1, 4.0), but you will have to remove the uid files.

The video showcasing the asset features : 


# **Features**

- Ressource based weapons

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


I simply wanted to make it.
Plus, it can be considered as some kind of demo for a possible big, really big asset.


# **How to use**


It's an asset, which means you can add it to an existing project without any issue.

Simply download it, add it to your project, get the files you want to use.

But you can also use it as a starter template if you want to.

If that's the case, you can simply drag and drop the folders under the "addon" one in a freshly created project.




you need to create a input action in your project for each action, and then type the exact same name into the corresponding input action variable

(for example : name your move forward action "moveForward", and then type "moveForward" into the variable "moveForwardAction").


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

