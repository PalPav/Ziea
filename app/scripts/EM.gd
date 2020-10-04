extends Node

var player_entity:Player = null

func setPlayer(player):
	player_entity = player
	
func getPlayer()->Player:
	return player_entity
