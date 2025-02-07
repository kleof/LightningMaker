## ✨ Instalation
[Download local package](https://github.com/kleof/LightningMaker/releases) \
[Download visualizer](https://github.com/kleof/LightningMaker/archive/refs/heads/main.zip) 

Import using menu: Tools ➜ Import Local Asset Package, or by dragging and dropping the `.yymps` file onto the workspace area of the GameMaker window.

https://github.com/user-attachments/assets/3da5580e-9dc7-4301-9916-bde346398a40


### ⚡ Basic Use:
```gml
// Lightning(start_point, end_point)

// CREATE EVENT
bolt = new Lightning({x:100, y:100}, {x:300, y:500});

// DRAW EVENT
bolt.update();
```
Start/end-point can be anything with `x` and `y` variables,  
like struct literal (above), your own struct, object instance:
```gml
// CREATE EVENT
start_point = instance_create_layer(0, 0, "Instances", obj_cloud);
bolt = new Lightning(start_point, obj_player);
```
When using anonymous struct literal, you can update lightning position with `update_start(x, y)` and `update_end(x, y)` methods

### _Run example project to customize lightning and generate code that will set all parameters_
\
![image](https://github.com/user-attachments/assets/ce5ea202-85ad-495c-8815-51ffafd199e6)
\
\
\
\
When drawing more than one lightning utilizing same glow effect use `draw`,`glow_set`,`glow_reset` methods:
```gml
// DRAW EVENT
bolt.glow_set();

bolt.draw();
bolt_2.draw();
bolt_3.draw();
// draw anything here that you want to apply glow to

bolt.glow_reset();
```
### 🌩️ Lightning Strikes:
Make a Lightning and provide it to LightningStrike constructor - it will be used as a template for strike effects
```gml
var template = new Lightning({x:0, y:0}, {x:0, y:0}).set_fade_in(true);
lightning = new LightningStrike(template);

// DRAW EVENT
lightning.update();
// or
lightning.glow_set();
lightning.draw();
lightning.glow_reset();
```
Now you can use `strike` method whenever you want:
```gml
/* strike
* @param {Real} _start_x Start point x coordinate
* @param {Real} _start_y Start point y coordinate
* @param {Real} _end_x End point x coordinate
* @param {Real} _end_y End point y coordinate
* @param {Real} [_duration] [Optional] How long will lightning be shown (in frames)
* @param {Real} [_fade_in_speed] [Optional] Speed of a fade in animation. By default speed set in template will be used
* @param {Array} [_collateral] [Optional] array of points (instances, structs, etc) that have a chance to be hit by child lightnings
*/

// STEP EVENT
if (mouse_check_button_pressed(mb_right)) {
  var _x = random(room_width);
  lightning.strike(_x, 0, _x, 800);
}
```

## Acknowledgements:
Perlin Noise by Nate Hunter - [functions](https://github.com/badwrongg/gm_camera_and_views/blob/main/scripts/perlin_noise_lib/perlin_noise_lib.gml), [shader](https://github.com/badwrongg/gm_camera_and_views/tree/main/shaders/shd_perlin_noise_glsl_es)  
Disk Glow by [Xor](https://github.com/XorDev)  
Neon Glow by [Jan Vorisek](https://github.com/odditica/NeonGlow)  
Electric discharge simulation idea from [Pierluigi Pesenti](https://web.archive.org/web/20110802053412/http://blog.oaxoa.com/2009/04/26/actionscript-3-lightning-class-step-2/)  

