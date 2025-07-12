<a id="readme-top"></a>
<div align="center">
  <a href="https://github.com/ancestrychanged/public/">
    <img src="https://i.ibb.co/pBqXB6nQ/deraxile-logo.png" alt="project logo" width="240" height="240">
  </a>

  <h3 align="center">fuckass proof-of-concept animation</h3>

  <p align="center">
    a project plan to recreate a 2d animation in a 3d roblox style using blender and adobe ae
    <br />
    actual goal is to prove my animation and vfx skills by.. replicating a 2d animation
    <br />
    quite literally, <b>what no pussy does to a mf</b>
    <br />
  </p>
</div>

<!-- table of contents -->
<details>
  <summary>table of contents</summary>
  <ol>
    <li>
      <a href="#about-the-project">about the project</a>
      <ul>
        <li><a href="#built-with">built with</a></li>
      </ul>
    </li>
    <li><a href="#project-goals--creative-direction">goals & creative direction</a></li>
    <li><a href="#animation-roadmap--shot-list">animation roadmap & shot list</a></li>
    <li><a href="#acknowledgments">acknowledgments</a></li>
  </ol>
</details>

<!-- about the project -->
## about the project

this repo documents the plan for recreating a 2d animated music video (originally animated by sashley) within blender, using a 3d roblox style

primary objective is to translate the high-energy, paper-cutout style of the original into a dynamic 3d animation

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### built with

this project will be created using the following software:

* [![blender][blender-shield]][blender-url]
* [![adobe after effects][ae-shield]][ae-url]
* [![audacity][audacity-shield]][audacity-url]
* [![aegisub][aegisub-shield]][aegisub-url]
* [![visual studio code][vscode-shield]][vscode-url]
* [![notepad++][notepad-shield]][notepad-url]
* [![obs studio][obs-shield]][obs-url]
* roblox studio (for asset/character importing)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- creative direction -->
## goals & creative direction

to make this recreation lowk cool and showcase skill growth, the following creative principles will be applied:

*   **3d "digital paper" aesthetic:** instead of flat 2d animation, will be making a 3d diorama; main character and key assets will have a subtle paper texture and a white "sticker" outline to blend the 2d feel with the 3d space
*   **kinetic typography in 3d space:** text will be modeled as physical 3d objects in the scene, the character will interact with them - jumping on, kicking, or dodging them to be more dynamic n shit
*   **vfx:** build upon the glitch and chromatic aberration effects from previous work; effects will be more purposeful, like world distortions synced to lyrics and paper-tear transitions between scenes
*   **expressive posing & "face decals":** overcome roblox character stiffness with exaggerated, dynamic posing; mesh deformation comin in play
    * will use a series of 2d face textures that can be swapped rapidly to mimic the expressive facial animation of the original ORRRRR use a face rig
*   **advanced camera work:** will make lots n lots of camera movements, including rapid zooms on key beats, impact frames (might wanna ask ilili about that to speed up the process), and orbiting shots to highlight the 3d environment and character interactions
*   **sophisticated lighting:** use blender's eevee render engine for professional lighting, including volumetric rays (god rays) and strong, colored rim lighting to make the characters pop from the background

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- roadmap & shot list -->
## animation roadmap & shot list

this table breaks down the original video shot-by-shot and outlines the plan for its 3d recreation

| timestamp | on-screen text / lyrics | visuals & actions (from script) | new 3d implementation plan |
| :--- | :--- | :--- | :--- |
| `[0:00:00.00-0:00:00.30]` | `(i'm a-` | intro; text appears on a bubbly pink-purple-ish background | `[ ]` create the background; a procedural noise texture in blender with pink and purple colors; `[ ]` model 3d text object: 'animation poc'; `[ ]` at 0:00.00; keyframe this text to appear instantly; `[ ]` position the text at the top-center of the camera view; |
| `[0:00:00.30-0:00:00.78]` | `-psycho)` | another text appears beneath it 'because someone; apparently\ndoesn't trust my skills' | `[ ]` model 3d text object: 'because someone; apparently\ndoesn\'t trust my skills'; `[ ]` at 0:00.30; keyframe this second text object to appear instantly beneath the first one |
| `[0:00:00.58-0:00:01.30]` | `that's two!` | when lyrics catch up; text 'two!' appears with quart-in easing and overshadows the previous text | `[ ]` model 3d text object: 'that\'s two!'. `[ ]` at 0:00.58; begin the animation for this text; keyframe its scale and opacity to tween in; `[ ]` in the graph editor; set the keyframe interpolation to 'quartic' and 'easing in'; `[ ]` at 0:01.30; ensure this text is fully visible and large; keyframing the first two text objects to be fully transparent or scaled to zero |
| `[0:00:01.30-0:00:02.72]` | `commas in a million bucks` | character lipsyncing with semi-transparent clone; star pops out near the end | `[ ]` import character2 (my character) into the scene; `[ ]` model 3d text: 'commas in a million bucks'; `[ ]` create a particle system - its particle object will be a 3d robux symbol mesh; `[ ]` between 0:01.30 and 0:02.70; animate character2 performing a very exaggerated wind-up punch; `[ ]` at 0:02.72; keyframe the punch to connect with the word 'bucks'; `[ ]` on impact - trigger the particle system to make the 'bucks' text explode into robux symbols; `[ ]` use a 2d 'star pop' image plane as the impact flash; keyframe its scale and opacity to spike at this exact moment |
| `[0:00:02.45-0:00:03.08]` | `that's two!` | character's palm shows off a ':v:' peace sign | `[ ]` create a 2d image plane with a glowing neon 'v' or peace sign texture; give it an emissive material; `[ ]` pose character2 in a confident static pose for the shot, for example one hand on the hip and leaning back; `[ ]` at 0:02.45; keyframe the neon vfx plane to flash into existence behind character2; `[ ]` the vfx should be very brief; keyframe its opacity to be 100% on its first frame then fade out entirely by 0:03.08 |
| `[0:00:03.07-0:00:04.46]` | `more that i'm givin' in fucks` | character2 on chair with legs on character1; character1 shrugs; background is a chroma key or clone scene; '\|\|' effect appears | `[ ]` set up the scene: character2 sits on a chair with feet up on a slightly frowning character1; `[ ]` animate character2 performing a shrug; `[ ]` for the background; create a scene clone and place it behind the main scene; set its transparency; `[ ]` model the '||' effect as two 3d planes or curves; animate their transparency to fade in and out during this shot |
| `[0:00:04.46-0:00:06.46]` | `that's two!` | same thing as [0:00:02.45-0:00:03.08] | `[ ]` this is a repeat of the vfx gesture; pose character2 in a different confident stance; `[ ]` at 0:04.46; trigger the same neon peace sign vfx to flash behind the character again |
| `[0:00:04.91-0:00:06.24]` | `shawties with them big ol' butts` | character bobs head; background is a semi-transparent clone scene with stars | `[ ]` animate character2 (foreground) bobbing their head and torso to the beat of the music; `[ ]` for the background; place a semi-transparent version of character1; pose them with arms crossed and a skeptical expression; `[ ]` have character1 slowly shake their head 'no'; `[ ]` to fill space; add a slow rain of 2d question mark particles behind the characters; |
| `[0:00:06.18-0:00:06.83]` | `that's two!` | almost same as [0:00:02.45-0:00:03.08]; but character is upside down and smiling | `[ ]` this is a transition shot, do not cut `[ ]` animate the main camera rig to perform a full 180-degree roll; flipping the view upside down; `[ ]` simultaneously; tween character2 from their head-bobbing pose into a new upside-down smiling pose; `[ ]` at the peak of the upside-down pose; trigger the neon peace sign vfx to flash behind them |
| `[0:00:06.78-0:00:07.67]` | `forgiato sets` | scene doesn't cut; character tweens to normal orientation with a smug face; background has fillers | `[ ]` continue the animation without cutting; `[ ]` animate the camera rig rolling back 180 degrees to an upright orientation; `[ ]` ensure motion blur is enabled in eevee's render settings to make this rotation look fluid; `[ ]` as character2 lands in the upright pose; swap their face decal to a smug expression |
| `[0:00:07.67-0:00:08.28]` | `on a truck` | character looks left and smiles showing cash; screen shakes with chromatic aberration | `[ ]` model a small stack of 3d cash; `[ ]` at 0:07.67; on the beat of 'truck'; keyframe a quick head turn for character2 to their left; `[ ]` pop the 3d cash model into their hand for a quick 'show off' motion; `[ ]` for the transition; keyframe a short sharp camera shake to occur for about 150ms after the lyric ends; `[ ]` in the compositor; keyframe a chromatic aberration node's value to spike at this exact moment; creating a visual glitch for the scene change |
| `[0:00:08.20-0:00:08.52]` | `one-` | beat drops; character poses with right leg up like reversed 'L'; scene transitions with shake and motion blur which dies off; camera moves up slowly with quad-in easing | `[ ]` pose character2 in the 'reversed L' leg pose; `[ ]` ensure motion blur is enabled for this pose change and camera movement. `[ ]` at 0:08.20; begin keyframing the camera's y position to move up; `[ ]` in the graph editor; set this keyframe's interpolation to 'quartic' and 'easing in' |
| `[0:00:08.56-0:00:08.77]` | `to the -` | scene doesn't change; camera keeps moving and the easing style is now visible | `[ ]` this is a hold shot for the character animation. `[ ]` do not add new keyframes here; let the camera continue its upward movement based on the previously set keyframes |
| `[0:00:08.83-0:00:09.24]` | `kidney;` | camera shakes slightly+chromatic aberration+motion blur and goes up to reveal waist; background lines pointing outwards animate their speed | `[ ]` add a quick camera shake effect using a noise modifier on the camera's location channels. `[ ]` keyframe a chromatic aberration node in the compositor to spike here. `[ ]` continue the camera's upward movement to frame the character's waist. `[ ]` create the background lines using curve objects parented to a central empty. `[ ]` animate the rotation speed of the central empty for the lines; keyframe it to speed up then slow down to match the lyric timing |
| `[0:00:09.23-0:00:09.48]` | `two- -` | camera shakes slightly+chromatic aberration+motion blur and goes up to reveal shoulders; torso visible but legs are not; same line effect and camera easing | `[ ]` repeat the camera shake and chromatic aberration spike from the previous step. `[ ]` continue the camera's upward movement to frame the character's torso. `[ ]` the background lines continue their animated rotation from the last keyframe |
| `[0:00:09.48-0:00:09.75]` | `to the- -` | same as [0:00:08.56-0:00:08.77] | `[ ]` this is another hold shot for character animation; let the camera continue its established upward movement |
| `[0:00:09.71-0:00:10.24]` | `dome!` | lots of vfx; character fully revealed; tilted left ~10 degrees; specific arm pose; semi-transparent pastel ghost rig fades in from bottom to up | `[ ]` this is the final keyframe for the camera's upward movement; the full character is now in frame. `[ ]` animate character2 into the final described pose and tilt (roll) them. `[ ]` duplicate character2 to create the 'ghost rig'. `[ ]` give the ghost rig a pastel-colored emissive material. `[ ]` use a gradient texture in the shader editor to control the ghost rig's transparency; animate the gradient's position to create the fade from bottom to top; max transparency should be around 0.4. `[ ]` spike the vfx here for impact. |
| `[0:00:09.96-0:00:10.23]` | `that's- -` | character tweens to the right center; text 'that's' appears on the left; scene gets a dotted out effect with a linear tween | `[ ]` animate character2's x position to move from the center to the right side of the screen. `[ ]` model the 3d text 'that\'s' and place it on the left. `[ ]` create a dotting effect using a compositor node setup with a dot pattern texture; keyframe its mix factor to tween from 0 to 1 as the transition |
| `[0:00:10.20-0:00:10.47]` | `left;` | character on left; specific arm pose; text 'left' + arrow pointing right appears with dotted texture; sine-inout tween to the right with overshoot; background letterbox | `[ ]` new scene cut; character is on the left; pose them with the described arm position. `[ ]` apply attitude face-swap: instantly swap the character's face decal to a smug grin. `[ ]` model 3d text 'left' and an arrow mesh pointing right; apply a dotted texture to them. `[ ]` parent character; text; and arrow to an empty; animate this parent empty moving to the right with sine-inout easing. `[ ]` add two extra keyframes to the empty's animation to create a slight overshoot. `[ ]` add two black planes for the letterbox effect at the top and bottom of the frame |
| `[0:00:10.44-0:00:10.68]` | `right;` | character on right; yaw-ed with gun-like pose; text 'right' + arrow pointing left appears; same tween; overshoot; and letterbox effects | `[ ]` new scene cut; character is on the right; pose them with the yaw offset and 'gun-like' hand. `[ ]` apply attitude face-swap: instantly swap the face decal to a different expression like ':p'. `[ ]` model 3d text 'right' and an arrow pointing left; apply dotted texture. `[ ]` parent character; text; and arrow to an empty; animate this parent empty moving to the left with sine-inout easing and an overshoot. `[ ]` the letterbox effect remains visible |
| `[0:00:10.69-0:00:10.92]` | `left;` | same as [0:00:10.20-0:00:10.47] | `[ ]` repeat the exact animation from the 'left;' scene at 0:00:10.20; copy and paste the keyframes for all relevant objects `[ ]` consider swapping the face decal to a new expression to keep it fresh. |
| `[0:00:10.91-0:00:11.12]` | `right;` | same as [0:00:10.44-0:00:10.68] | `[ ]` repeat the exact animation from the 'right;' scene at 0:00:10.44; copy and paste keyframes. `[ ]` swap the face decal again |
| `[0:00:11.11-0:00:11.37]` | `left` | same as [0:00:10.20-0:00:10.47] | `[ ]` repeat the exact animation from the 'left;' scene at 0:00:10.20; copy and paste keyframes. `[ ]` swap the face decal again |
| `[0:00:11.36-0:00:11.58]` | `right;` | same as [0:00:10.44-0:00:10.68] | `[ ]` repeat the exact animation from the 'right;' scene at 0:00:10.44; copy and paste keyframes. `[ ]` swap the face decal again |
| `[0:00:11.62-0:00:11.89]` | `go!` | letterbox goes out; chibi character pops up from bottom; background dims; camera zooms in/out; text becomes 'go!'; arrow scales down; scene dots out for transition | `[ ]` animate the letterbox planes moving up and down off-screen. `[ ]` create a simplified 'chibi' version of character2; animate it popping up from the bottom of the frame with index fingers up. `[ ]` animate a dimming effect on the background scene. `[ ]` keyframe the camera's distance to zoom in then out quickly for a pulse effect. `[ ]` swap the 'right' text object for a 'go!' text object; animate the arrow mesh's y-scale to shrink to zero; `[ ]` animate the dotting transition effect to 100% influence. `[ ]` as the dots appear; animate the background scene sliding slightly to the left |
| `[0:00:11.89-0:00:12.84]` | `got a rollie for the brunch` | character on left; lipsyncing; paper-like background with doodles and chibi on right bobbing; doodles are animated | `[ ]` pose character2 on the left side of the screen; `[ ]` create a notebook paper texture for the background; `[ ]` create 2d doodle assets like hearts; `[ ]` animate the hearts to do a 'popping out' animation by keyframing their scale; `[ ]` place the chibi version of character2 on the right; `[ ]` animate the chibi's y-scale up and down to the beat twice during this shot |
| `[0:00:12.84-0:00:13.72]` | `and a patek for the show` | same thing but chibi is reversed on x axis; bobbing twice | `[ ]` keep all scene elements from the previous shot; `[ ]` set the chibi character's x-scale to -1 to reverse it; `[ ]` animate the chibi's y-scale to bob up and down to the beat twice again; `[ ]` character2 can have a slight pose change to keep it dynamic |
| `[0:00:13.74-0:00:13.97]` | `that's-` | scene stays; after lyric ends; transitions by dotting and slightly flashing | `[ ]` hold the current scene and poses until the lyric ends; `[ ]` keyframe the compositor dotting effect to transition from 0 to 1; `[ ]` add a quick flash using a brightness node in the compositor during the dotting transition |
| `[0:00:13.96-0:00:14.21]` | `left;` | same as [0:00:10.20-0:00:10.47] | `[ ]` copy all objects and keyframes from the 'left;' scene at 0:00:10.20; `[ ]` change the face decal on character2 for this instance |
| `[0:00:14.18-0:00:14.41]` | `right;` | same as [0:00:10.44-0:00:10.68] | `[ ]` copy all objects and keyframes from the 'right;' scene at 0:00:10.44; `[ ]` change the face decal on character2 |
| `[0:00:14.41-0:00:14.63]` | `left;` | same as [0:00:10.20-0:00:10.47] | `[ ]` repeat the copy-paste process for the 'left;' scene; use a new face decal |
| `[0:00:14.65-0:00:14.88]` | `right;` | same as [0:00:10.44-0:00:10.68] | `[ ]` repeat the copy-paste process for the 'right;' scene; use a new face decal |
| `[0:00:14.88-0:00:15.12]` | `left;` | same as [0:00:10.20-0:00:10.47] | `[ ]` repeat the copy-paste process for the 'left;' scene; use a new face decal |
| `[0:00:15.12-0:00:15.34]` | `right;` | same as [0:00:10.44-0:00:10.68] | `[ ]` repeat the copy-paste process for the 'right;' scene; use a new face decal |
| `[0:00:15.34-0:00:15.64]` | `go!` | same as [0:00:11.62-0:00:11.89]; but face expression changed from ':o' to '>:D' | `[ ]` copy all objects and keyframes from the 'go!' scene at 0:00:11.62; `[ ]` replace the chibi's face decal texture with a '>:D' expression |
| `[0:00:15.64-0:00:16.55]` | `got a big new body` | character on right with yaw offset; bobbing; paper background with dotted clone; menacing chibi; crayon font typewriter | `[ ]` position character2 on the right; keyframe the yaw offset and head/torso bobbing; `[ ]` set up the paper background with a dotted; semi-transparent clone of character2; `[ ]` pose the chibi on the left 'menacingly'; `[ ]` create a text object with a crayon-like font; keyframe the 'characters' property to type out 'got a big new body' |
| `[0:00:16.55-0:00:17.50]` | `and i whip it like a pro` | chibi is reversed on x axis; typewriter continues; character head now looks directly at viewer on 'pro' | `[ ]` set the chibi character's x-scale to -1 to reverse it; `[ ]` continue the typewriter animation to add '\nand i whip it like a pro!'; `[ ]` at the exact frame the lyric 'pro' hits; keyframe character2's head rotation to look directly at the camera |
| `[0:00:17.45-0:00:17.65]` | `that's-` | no changes; scene dots out and then quickly removes dots with a subtle flash | `[ ]` hold the scene animation; `[ ]` create the transition by keyframing the dotting compositor node to 100% and then immediately back to 0%; `[ ]` add a quick brightness flash in the compositor during the dot transition |
| `[0:00:17.66-0:00:17.92]` | `left;` | same as [0:00:10.20-0:00:10.47] | `[ ]` copy and paste the keyframes for the 'left;' scene; use a different face decal |
| `[0:00:17.96-0:00:18.15]` | `right;` | same as [0:00:10.44-0:00:10.68] | `[ ]` copy and paste the keyframes for the 'right;' scene; use a different face decal |
| `[0:00:18.15-0:00:18.38]` | `left;` | same as [0:00:10.20-0:00:10.47] | `[ ]` copy and paste the keyframes for the 'left;' scene; use a different face decal |
| `[0:00:18.38-0:00:18.61]` | `right;` | same as [0:00:10.44-0:00:10.68] | `[ ]` copy and paste the keyframes for the 'right;' scene; use a different face decal |
| `[0:00:18.62-0:00:18.88]` | `left;` | same as [0:00:10.20-0:00:10.47] | `[ ]` copy and paste the keyframes for the 'left;' scene; use a different face decal |
| `[0:00:18.88-0:00:19.08]` | `right;` | same as [0:00:10.44-0:00:10.68] | `[ ]` copy and paste the keyframes for the 'right;' scene; use a different face decal |
| `[0:00:19.08-0:00:19.37]` | `go!` | same as [0:00:11.62-0:00:11.89]; but face expression changed from '>:d' to ':P' | `[ ]` copy all objects and keyframes from the 'go!' scene; `[ ]` replace the chibi's face decal texture with a ':P' expression |
| `[0:00:19.32-0:00:20.30]` | `got a great main chick` | scene wobbles on x axis; character posed; embarrassed chibi in paper-cutout; text '#single4eva' animates to beat; typewriter at bottom | `[ ]` use a compositor node setup (wave/noise distortion) to create the x-axis wobble transition; `[ ]` pose character2 with the specified yaw offset; `[ ]` create the embarrassed chibi inside a paper-cutout shape using a mask; `[ ]` animate the '#single4eva' text by swapping font styles or animating its properties to the beat; `[ ]` create the typewriter effect at the bottom using 'special elite' font |
| `[0:00:20.30-0:00:21.23]` | `and a real bad hoe` | comic text keeps changing; character blinks; chibi bobs on y axis; typewriter finishes; character on left gives 'ugh' face and rolls eyes | `[ ]` continue the '#single4eva' text animation; `[ ]` animate a blink for character2; `[ ]` animate the chibi's y-scale to bob to the beat; `[ ]` ensure the typewriter animation finishes and the cursor fades; `[ ]` at the end of the line; animate character2's face decal to an 'ugh' face and keyframe their eye bones or textures to roll |
| `[0:00:21.21-0:00:21.43]` | `that's-` | scene flashes; camera tweens rolling right and zooming in with fov change (90 to 75); brightness filter applied to next sequence | `[ ]` create a bright flash with a compositor node; `[ ]` keyframe the camera's rotation (roll); z-position (zoom); and fov properties; `[ ]` add a brightness/contrast node to the compositor and keyframe its influence to 1 for this entire next sequence |
| `[0:00:21.46-0:00:21.71]` | `left;` | same as [0:00:10.20-0:00:10.47] | `[ ]` copy and paste the 'left;' scene animation; it will inherit the new camera/brightness effects |
| `[0:00:21.70-0:00:21.92]` | `right;` | same as [0:00:10.44-0:00:10.68] | `[ ]` copy and paste the 'right;' scene animation |
| `[0:00:21.92-0:00:22.16]` | `left;` | same as [0:00:10.20-0:00:10.47] | `[ ]` copy and paste the 'left;' scene animation |
| `[0:00:22.16-0:00:22.40]` | `right;` | same as [0:00:10.44-0:00:10.68] | `[ ]` copy and paste the 'right;' scene animation |
| `[0:00:22.40-0:00:22.64]` | `left;` | same as [0:00:10.20-0:00:10.47] | `[ ]` copy and paste the 'left;' scene animation |
| `[0:00:22.64-0:00:22.87]` | `right;` | same as [0:00:10.44-0:00:10.68] | `[ ]` copy and paste the 'right;' scene animation |
| `[0:00:22.84-0:00:23.32]` | `go!` | same as [0:00:11.62-0:00:11.89]; but face from ':p' to ':O'; after lyric; camera flashes/shakes with chromatic aberration for audio fade-in | `[ ]` copy the 'go!' scene animation; `[ ]` swap the chibi face decal to an ':O' expression; `[ ]` after the main 'go!' animation concludes; add a new extended camera shake effect; `[ ]` keyframe a flash and a chromatic aberration spike in the compositor to match the duration of the audio fade-in effect |
| `[0:00:23.31-0:00:23.80]` | `two,` | character on left showing 2 fingers; semi-transparent clone on right; text '2' pops out; palm moves slightly | `[ ]` pose character2 on the left doing a vfx peace sign; `[ ]` place a semi-transparent pastel-colored clone of character2 on the right; `[ ]` model a 3d text '2'; animate it popping into view via scale keyframes; `[ ]` add a subtle rotation keyframe to character2's hand to make it feel alive |
| `[0:00:23.80-0:00:24.30]` | `four,` | character palm shows 4; text '4' pops out | `[ ]` change character2's pose to show '4' (may need to get creative with a vfx counter for this); `[ ]` model a 3d text '4'; animate it popping into view |
| `[0:00:24.30-0:00:24.76]` | `six,` | worried expression; left hand shows 5; right hand shows 1; text '6' pops out | `[ ]` swap character2's face decal to a 'worried' expression; `[ ]` pose both hands to represent '6'; `[ ]` model a 3d text '6'; animate it popping into view |
| `[0:00:24.75-0:00:25.24]` | `eight,` | expression intensifies; left hand 5; right hand 3; text '8' pops out | `[ ]` swap face decal to a more intense worried look; `[ ]` pose hands to represent '8'; `[ ]` model a 3d text '8'; animate it popping into view |
| `[0:00:25.17-0:00:25.90]` | `who do we-` | number tweens left and vanishes; text 'who\ndo\nwe' pops out from right | `[ ]` animate the '8' text tweening to the left and scaling down to zero; `[ ]` model 3d text 'who\ndo\nwe'; animate it entering from off-screen right |
| `[0:00:25.92-0:00:26.16]` | `a-` | new text 'a' appears on bottom; tweening right to left; bobbing to beat | `[ ]` model 3d text 'a'; position at bottom; `[ ]` animate its x-position from right to left; `[ ]` add a noise modifier to its location to create a bobbing effect |
| `[0:00:26.16-0:00:26.40]` | `-ppre-` | face changes to smug; text on bottom is now 'appre' | `[ ]` swap character2's face decal to 'smug'; `[ ]` swap the bottom text object to 'appre' |
| `[0:00:26.30-0:00:26.64]` | `-ci-` | text on bottom is now 'appreci' | `[ ]` swap the bottom text object to 'appreci' |
| `[0:00:26.60-0:00:26.87]` | `-ate?` | text on bottom is now 'appreciate' | `[ ]` swap the bottom text object to 'appreciate' |
| `[0:00:26.86-0:00:27.11]` | `that's-` | all text goes off right; new text 'that's' appears on right center; face changes to ':d' | `[ ]` animate all visible text moving off-screen right; `[ ]` swap character2's face decal to ':D'; `[ ]` animate new text 'that\'s' appearing in the right-center |
| `[0:00:27.11-0:00:27.57]` | `ba-` | new text 'b' appears under 'that's' | `[ ]` animate new text 'b' appearing under 'that\'s' |
| `[0:00:27.54-0:00:27.83]` | `-by-` | 2nd text addition is now 'bb' | `[ ]` swap the bottom text object to 'bb' |
| `[0:00:27.80-0:00:28.05]` | `no-` | 2nd text addition is now 'bbno'; texts roll left | `[ ]` swap the bottom text to 'bbno'; `[ ]` animate the rotation of both text objects to roll to the left |
| `[0:00:28.04-0:00:28.51]` | `mo-` | 2nd text addition is now 'bbno$'; texts roll right | `[ ]` swap the bottom text to 'bbno$'; `[ ]` animate the rotation of both text objects to roll to the right |
| `[0:00:28.51-0:00:28.84]` | `-ney` | texts roll to original orientation | `[ ]` animate the rotation of both text objects back to zero |
| `[0:00:28.84-0:00:29.44]` | `he's always-` | scene changes; character at center clapping; jojo-like fast-paced outlines | `[ ]` cut to a new scene with character2 at the center; `[ ]` animate them clapping to the audio beat; `[ ]` create the 'jojo lines' effect using 2d planes with line textures that animate scaling inwards quickly |
| `[0:00:29.43-0:00:30.86]` | `up to something` | character keeps clapping; camera zooms out; camera shakes for transition | `[ ]` continue the clapping animation; `[ ]` keyframe the camera's position to zoom out; `[ ]` add a camera shake effect at the end of the shot |
| `[0:00:30.84-0:00:31.31]` | `two,` | same as [0:00:23.31-0:00:23.80]; but reversed on x axis | `[ ]` copy the entire scene from 0:00:23.31; `[ ]` set the parent empty's x-scale to -1 to reverse everything except the text |
| `[0:00:31.31-0:00:31.78]` | `four,` | same as [0:00:23.80-0:00:24.30]; but reversed on x axis | `[ ]` copy the entire scene from 0:00:23.80; reverse it via the parent empty's x-scale |
| `[0:00:31.78-0:00:32.25]` | `six,` | same as [0:00:24.30-0:00:24.76]; but reversed on x axis | `[ ]` copy the entire scene from 0:00:24.30; reverse it |
| `[0:00:32.25-0:00:32.74]` | `eight,` | same as [0:00:24.75-0:00:25.24]; but reversed on x axis | `[ ]` copy the entire scene from 0:00:24.75; reverse it |
| `[0:00:32.73-0:00:33.43]` | `who's that guy` | (reversed) text 'who's\nthat\nguy' pops out; animated as standalone objects | `[ ]` inside the reversed scene; model and animate the 'who\'s\nthat\nguy' text popping in; each word a separate object bobbing to the beat |
| `[0:00:33.43-0:00:34.32]` | `who really ate?` | (reversed) same as appreciate scene but text is 'who really ate' at bottom; face changes to smug | `[ ]` inside the reversed scene; create the 'who really ate' text at the bottom; `[ ]` on the word 'really'; swap character2's face decal to 'smug' |
| `[0:00:34.31-0:00:34.62]` | `that's-` | (reversed) same as [0:00:26.86-0:00:27.11] but reversed; text not reversed | `[ ]` copy the reversed scene setup and text animation; ensure the text object itself is not reversed |
| `[0:00:34.62-0:00:35.08]` | `ba-` | (reversed) same as [0:00:27.11-0:00:27.57] but reversed; text not reversed | `[ ]` continue the copied animation |
| `[0:00:35.08-0:00:35.31]` | `-by-` | (reversed) same as [0:00:27.54-0:00:27.83] but reversed; text not reversed | `[ ]` continue the copied animation |
| `[0:00:35.31-0:00:35.56]` | `no-` | (reversed) same as [0:00:27.80-0:00:28.05] but reversed; text not reversed | `[ ]` continue the copied animation |
| `[0:00:35.56-0:00:36.00]` | `mo-` | (reversed) same as [0:00:28.04-0:00:28.51] but reversed; text not reversed | `[ ]` continue the copied animation |
| `[0:00:36.00-0:00:36.28]` | `-ney` | (reversed) same as [0:00:28.51-0:00:28.84] but reversed; text not reversed | `[ ]` continue the copied animation |
| `[0:00:36.23-0:00:38.32]` | `he never leave 'em hungry` | scene changes to a sketch drawing of the character signaling outro | `[ ]` create a final scene with a 2d sketch texture of character2 on a plane; this is a simple static shot |
| `[0:00:38.33-0:00:46.46]` | `[outro]` | credits; merch ad; thanks to patreons | `[ ]` create the final credits screen; this can be done in blender with text objects or in after effects and rendered as a final clip |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- acknowledgments -->
## acknowledgments

*   **song:** two by bbno$
*   **original animation / inspiration:** [sashley](https://www.youtube.com/@Sashley)
*   **song:** two by 

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- markdown links & images -->
<!-- markdown links & images -->
[blender-shield]: https://img.shields.io/badge/Blender-E87D0D?style=for-the-badge&logo=blender&logoColor=white
[blender-url]: https://www.blender.org/
[ae-shield]: https://img.shields.io/badge/Adobe%20After%20Effects-9999FF?style=for-the-badge&logo=adobe%20after%20effects&logoColor=white
[ae-url]: https://www.adobe.com/products/aftereffects.html
[audacity-shield]: https://img.shields.io/badge/Audacity-0000CC?style=for-the-badge&logo=audacity&logoColor=white
[audacity-url]: https://www.audacityteam.org/
[aegisub-shield]: https://img.shields.io/badge/Aegisub-333399?style=for-the-badge
[aegisub-url]: https://aegisub.org/
[vscode-shield]: https://img.shields.io/badge/Visual%20Studio%20Code-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white
[vscode-url]: https://code.visualstudio.com/
[notepad-shield]: https://img.shields.io/badge/Notepad++-91B359?style=for-the-badge&logo=notepadplusplus&logoColor=white
[notepad-url]: https://notepad-plus-plus.org/
[obs-shield]: https://img.shields.io/badge/OBS%20Studio-302E31?style=for-the-badge&logo=obsstudio&logoColor=white
[obs-url]: https://obsproject.com/
