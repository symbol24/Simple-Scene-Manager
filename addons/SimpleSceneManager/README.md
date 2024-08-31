# Simple Scene Manager

I developed Simple Scene Manager as a way to have access to a quick scene manager for game jams and then decided to release it as a plugin.

The plugin auto adds a Manager autoload.

To use the manager as intended, setup a LevelData resource with all the paths of levels/scenes you wish to load in the levels Array. The Manager uses int as the value to identify which level to load. -1 reloads the active level. -2 loads the next level without need to know which level is active.

LevelData contains:
 - Levels: array of paths to scenes as string
 - load_first_level_on_boot: bool to load the first in levels array on boot
 - use_own_loading_screen: bool to allow users to use their own loading screens and not rely on the built in loading screen
 - loading_delay: a float to add a delay at the end of loading to increase total load time (specifically if levels are very small)

The LevelData created by the user must be placed in the "level_data" Property of the scene_manager.tscn.

The Manager emits 2 signals for tghe loading screen:
 - ToggleLoadingScreen(_display:bool): used to toggle loading screens on and off
 - LoadingPercentUpdated(_percent:float): emits the percentage (between 0.0 and 1.0) during loading. Note: small scenes load VERY quickly.

Since the Manager is an autoload, the main scene used in project settings should be a "boot" scene that uses the manager to load the first scene users wish to load.

The included demo is a simple 2 scene setup with a button in each scene to load to the other scene.
