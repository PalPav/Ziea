extends Node

# Уроваень враги и игрок
# warning-ignore:unused_signal
signal enemy_spawned
# warning-ignore:unused_signal
signal enemy_died
# warning-ignore:unused_signal
signal player_dead
# warning-ignore:unused_signal
signal stage_cleared
# warning-ignore:unused_signal
signal level_ready

# эвенты оружия
# warning-ignore:unused_signal
signal shot_fired(weapon_state)
# warning-ignore:unused_signal
signal weapon_reloaded(weapon_state)
# warning-ignore:unused_signal
signal weapon_changed(weapon_state)
