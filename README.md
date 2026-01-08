# 🎯 Universal Silent Aim (Optimized)

<img width="547" height="601" alt="image" src="https://github.com/user-attachments/assets/fc914a73-0b2a-4b95-baa1-a7852b3e08da" />


A high-performance, metamethod-based Silent Aim script for Roblox. This project utilizes **LinoriaLib** for a modern interface and **HookMetamethod** for engine-level redirection, ensuring compatibility with both modern Raycast and legacy FindPartOnRay systems.

---

## 🚀 Key Features

- **Dual Hooking**: Support for `__namecall` (Engine Raycasts) and `__index` (Mouse Property redirection).  
- **Performance Caching**: Throttled targeting logic (45Hz) to prevent CPU spikes and frame drops.  
- **Anti-Crash Logic**: Non-destructive hooking that allows character movement and reloading scripts to function normally.  
- **Customizable FOV**: Real-time adjustable Drawing API circle with visibility toggles.  
- **Sanity Checks**: Built-in Team Check, Visibility (Wall) Check, and Tool-Equipped verification.  

---

## 🛠 Installation & Usage

**Execution**: Run the provided `LocalScript` in your preferred environment.  

**Menu Toggle**: Press **RightAlt** (default) to show or hide the GUI.  

**Configuration**:

| Setting        | Options / Notes                                                                 |
|----------------|--------------------------------------------------------------------------------|
| Method         | `Raycast` – For modern games (ACS, CE, etc.)<br>`FindPartOnRay` – Legacy games (e.g., Prison Life)<br>`Mouse.Hit` – For basic "click-to-hit" tools |
| FOV Size       | Scale the detection radius to your preference                                   |

---

## ⚙️ Logic Workflow

The script follows a filtered decision tree to ensure target accuracy without wasting system resources:

1. **Throttled Search**: Instead of checking every frame, the script searches for the closest player at a set interval.  
2. **Validation**: Checks if the target is alive, on the opposite team, and (optionally) visible.  
3. **Metamethod Hijack**: Intercepts the game's intent to fire a bullet and replaces the coordinates with the validated target's position.  

---

## 📊 Technical Settings

| Feature       | Type      | Description                                                                 |
|---------------|----------|-----------------------------------------------------------------------------|
| SA_Enabled    | Toggle    | Master switch for all redirection logic                                     |
| Method        | Dropdown  | Switches engine hooks between Raycast, FindPartOnRay, and Mouse.Hit        |
| Visible Check | Toggle    | Uses `GetPartsObscuringTarget` to prevent shooting through walls            |
| Team Check    | Toggle    | Compares `Player.Team` to prevent friendly fire                             |
| FOV Radius    | Slider    | Sets the pixel-distance limit for the auto-aim                               |

---

## 🩹 Troubleshooting

- **The game is laggy**  
  *Solution*: Disable Visible Check. Wall-checking requires extra raycasts for every potential target, which is demanding in complex maps.

- **I can't move after respawning**  
  *Solution*: The script includes a `self == workspace` check to prevent hijacking the character's internal "floor detection" raycasts. Make sure you're using the latest version.

- **The gun doesn't shoot**  
  *Solution*: Switch the Method dropdown. Older games often rely on `FindPartOnRay` instead of modern Raycast.

---

## 📝 Changelog

- **v1.0.0**: Initial release.  
- **v1.0.1**: Added `checkcaller()` to prevent infinite hooking loops.  
- **v1.0.2**: Implemented Target Caching to fix FPS drops.  
- **v1.0.3**: Added Tool-Check to `__index` to allow UI interaction while unequipped.  

---
