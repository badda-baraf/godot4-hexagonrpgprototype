extends Node



func move_towards_position(unitMoving:CharacterUnit,targetPosition:Vector2i):
	var astar = AStar2D.new()
	var astarGrid = AStarGrid2D.new()
	astarGrid.size = Game.currentTilemap.get_used_rect().size
	astarGrid.cell_size = Vector2(500, 500)
	astarGrid.update()

	pass
