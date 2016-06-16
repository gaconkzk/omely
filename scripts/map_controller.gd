extends Control

export var show_blueprint = false
export var campaign_map = true
export var take_enemy_hq = true
export var control_all_towers = false
export var multiplayer_map = false

var terrain
var underground
var units
var map_layer_back
var map_layer_front
var action_layer
var bag

var mouse_dragging = false
var pos
var game_size
var scale
var root
var camera