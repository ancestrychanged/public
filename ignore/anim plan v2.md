<a id="readme-top"></a>
<div align="center">
  <h3 align="center">project: scene 2 combat implementation</h3>

  <p align="center">
    technical execution plan for a 15-17s high-velocity combat sequence
    <br />
    <b>animator:</b> 2-13 (Dave)
    <br />
    <b>objective:</b> execute "scene 2" creative brief with high-fidelity physics interaction and script-based narrative elements
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
    <li><a href="#creative-direction">creative direction</a></li>
    <li><a href="#gears-used">gears used</a></li>
    <li><a href="#execution-roadmap">execution roadmap</a></li>
  </ol>
</details>

<!-- about the project -->
## about the project

short version of the doc;

mainly describes my visualization for "bot vs bAIcon" combat animation

animation will use gear interactions (bloxy cola, subspace tripmine, rainbow carpet) combined with script execution visualizations to bridge the gap between gameplay logic and cinematic animation

<p align="right">(<a href="#readme-top">back to top</a>)</p>

### built with

* [![blender][blender-shield]][blender-url]
* [![adobe after effects][ae-shield]][ae-url]
* [![roblox studio][roblox-shield]][roblox-url]
* [![visual studio code][vscode-shield]][vscode-url]

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- creative direction -->
## creative direction

*   **script-enhanced combat:** visualizing code execution as part of the environment without relying on generic "hacker" tropes; using custom console ui assets
*   **physics-based impact:** adobe AE for impact frames and small 2D vfx (e.g., carpet surfing, recoil)
*   **hud integration:** implementing custom health bars with gradient states to visualize damage values (100 -> 99.8 -> 20) in real-time
*   **lighting & vfx:** external assistance utilized for environmental lighting shifts (subspace detonation) and particle debris

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- gears used -->
## gears used

*   [Bloxy Cola](https://www.roblox.com/catalog/10472779/Bloxy-Cola) (max of 4-5 instances)
*   [Subspace Tripmine](https://www.roblox.com/catalog/11999247/Subspace-Tripmine) (max of 2 instances with only 1 being triggered)
*   [Rainbow Magic Carpet](https://www.roblox.com/catalog/225921000/Rainbow-Magic-Carpet) (total screen time will be 3-4 seconds)
*   [Sword](https://www.roblox.com/catalog/125013769/Linked-Sword)

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- execution roadmap -->
## execution roadmap

| timestamp (approx) | action / event | detailed breakdown |
| :--- | :--- | :--- |
| `[0:00-0:03]` | **bacon idle** | bacon is laying down on the baseplate. **action:** scratches head, performs small idle movements. stands up, looks into the distance, spots bot approaching. |
| `[0:03-0:11]` | **bot initialization** | bot summons holographic console. **action:** types code, executes `loadstring(game:HttpGet("https://ancestrychanged.fun/healthbar.lua"))()`. custom health gui appears (bot has gradient boss bar, both start at 100 hp). bot stomps on ground -> pillars spawn procedurally. camera cuts to bacon. |
| `[0:11-0:14]` | **gear prep** | bacon notices health bar. looks right to toolbox. grabs **bloxy cola** -> drinks -> gains "buff" (visible muscle expansion + speed particles). grabs **sword** & **subspace tripmine**. |
| `[0:14-0:16]` | **the trap** | bacon runs/jumps at bot. triggers tripmine, throws it. bot catches it (animation implies he thinks it's a baseball). mine detonates in hands. **vfx:** map flashes red/purple (blind/stun effect). |
| `[0:16-0:18]` | **the combo** | while bot is stunned, bacon lands 4 rapid sword strikes (speed buffed). **damage:** weak/chip damage only (bot hp: 100 -> 99.8). |
| `[0:18-0:19]` | **the counter** | bot recovers instantly. blocks final strike with arm. throws sword out of bacon's hand. lands heavy punch. **damage:** bacon hp drops 200 -> 130. bacon flies backwards towards a pillar. |
| `[0:19-0:24]` | **shadowstep** | bot engages "saitama vs boros" speed ([reference](https://youtu.be/54Td5wxNDpo?list=RD54Td5wxNDpo&t=51)). chases bacon mid-air. executes shadowstep sequence: 9 hits from alternating directions over ~5 seconds. |
| `[0:24-0:25]` | **the finisher** | 10th hit: bot grabs bacon, spins him around mid-air, throws him into the ground. **damage:** bacon hp critical (20/200). impact debris. |
| `[0:25-0:31]` | **escape & clutch** | bacon recovers (approx 6s sequence). grabs rainbow magic carpet. attempts to fly right. grabs bloxy cola #2. bot intercepts flight, punches down (hp 130 -> 90). bacon finishes drink frame-perfectly (full heal). **barely** dodges final impact (200 -> 195). lands in crouch, to the left of the bot |

<p align="right">(<a href="#readme-top">back to top</a>)</p>

<!-- markdown links & images -->
[blender-shield]: https://img.shields.io/badge/Blender-E87D0D?style=for-the-badge&logo=blender&logoColor=white
[blender-url]: https://www.blender.org/
[ae-shield]: https://img.shields.io/badge/Adobe%20After%20Effects-9999FF?style=for-the-badge&logo=adobe%20after%20effects&logoColor=white
[ae-url]: https://www.adobe.com/products/aftereffects.html
[roblox-shield]: https://img.shields.io/badge/Roblox%20Studio-00A2FF?style=for-the-badge&logo=roblox&logoColor=white
[roblox-url]: https://create.roblox.com/
[vscode-shield]: https://img.shields.io/badge/Visual%20Studio%20Code-007ACC?style=for-the-badge&logo=visualstudiocode&logoColor=white
[vscode-url]: https://code.visualstudio.com/
